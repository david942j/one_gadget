# frozen_string_literal: true

require_relative 'operand'

module Aletheia
  # Turns a gadget's constraint list into a concrete injection plan: which
  # registers to set, and how scratch memory is laid out. This is the inverse of
  # one_gadget's +calculate_score+ dispatch, but it *produces assignments* and
  # its constraint semantics are written independently (see {Operand_}).
  #
  # Memory model assumed by the plan: the driver allocates one zeroed, RW scratch
  # region and sets +sp+ to +scratch + sp_offset+. So any +sp+-relative
  # dereference the constraints need NULL is satisfied by the zero-fill, any
  # +sp+imm+ effect argument points into scratch, and a register pointed at
  # scratch is a readable+writable pointer (and, being zero-filled, a valid empty
  # string / a NULL-terminated empty argv|envp).
  class Satisfier
    # @return [Aletheia::Plan]
    Plan = Struct.new(:offset, :effect, :constraints, :regs, :scratch_size, :sp_offset,
                      :benign_default, :poison_default, :null_default, :branches, :status,
                      :reason, :writable_count, keyword_init: true)

    SCRATCH_SIZE    = 0x10000
    SP_OFFSET       = 0x2000
    STRING_POOL     = 0x100    # readable+writable zeroed bytes: a valid "" / [NULL] array
    COMMAND_POOL    = 0x200    # the "ls /" L2 command the driver seeds here
    WRITABLE_BASE   = 0x4000   # write-areas live above the stack region (sp is at SP_OFFSET)
    WRITABLE_STRIDE = 0x800
    MASK64          = (1 << 64) - 1
    IMM             = /-?(?:0x[0-9a-fA-F]+|\d+)/

    # @param arch an arch backend (e.g. {Arch::AArch64})
    # @param [Boolean] strict when true, uncontrolled registers are poisoned
    #   (unmapped) so any unlisted dependency faults -- a completeness test for
    #   the constraint list. When false, they point at readable scratch.
    def initialize(arch, strict: false)
      @arch = arch
      @strict = strict
    end

    # @param [OneGadget::Gadget::Gadget] gadget
    # @return [Aletheia::Plan]
    def satisfy(gadget)
      plan = Plan.new(
        offset: format('%#x', gadget.offset), effect: gadget.effect,
        constraints: gadget.constraints.dup, regs: {}, scratch_size: SCRATCH_SIZE,
        sp_offset: SP_OFFSET, benign_default: !@strict, poison_default: @strict,
        branches: {}, status: 'ok', reason: nil, writable_count: 0
      )
      gadget.constraints.each_with_index do |constraint, i|
        chosen = satisfy_constraint(plan, constraint)
        return skip(plan, "unsupported-or-unsat: #{constraint}") unless chosen

        plan.branches["c#{i}"] = chosen
      end
      plan
    end

    private

    # Try each disjunct of +constraint+ cheapest-first; accept the first that is
    # already satisfied by the current plan or that applies without conflict. The
    # register map is snapshot/restored around a failed apply so a partial
    # assignment can't leak into the next attempt.
    # @return [String, nil] the chosen disjunct, or nil if none worked.
    def satisfy_constraint(plan, constraint)
      ordered = constraint.split(' || ').map(&:strip)
                          .map { |b| [evaluate(b), b] }.select { |c, _| c }
                          .sort_by { |c, _| c }
      ordered.each do |_, branch|
        return branch if satisfied?(plan, branch)

        snapshot = plan.regs.dup
        return branch if apply(plan, branch)

        plan.regs = snapshot
      end
      nil
    end

    def skip(plan, reason)
      plan.status = 'skip'
      plan.reason = reason
      plan
    end

    # Cost of satisfying a single disjunct (lower = easier); nil = unsatisfiable
    # or a category this satisfier doesn't handle.
    # @return [Float, nil]
    def evaluate(disjunct)
      case disjunct
      when /\Awritable: (.+)\z/
        (op = safe_parse(Regexp.last_match(1))) && writable_cost(op)
      when /\A(.+?) == NULL\z/, /\A(.+?) <= 0\z/
        (op = safe_parse(Regexp.last_match(1))) && null_cost(op)
      when /\A\{.*\} is a valid (?:argv|envp)\z/ then 0.5 # array literal: element builder
      when /is a valid (?:argv|envp)\z/         then 0.4 # pointer form: point it at scratch
      else relational_cost(disjunct)
      end
    end

    # @return [Float, nil]
    def writable_cost(op)
      return 0.05 if op.deref.zero? && op.reg && stack_reg?(op.reg) # already in scratch via sp

      op.deref.zero? && op.reg ? 0.2 : nil
    end

    # @return [Float, nil]
    def null_cost(op)
      if op.deref.zero?
        return nil if op.reg && stack_reg?(op.reg) # sp/x29 (+imm) is a live address, never NULL
        return nil if op.reg.nil?                  # a bare literal == NULL is fixed, not ours to set

        op.imm.zero? ? 0.1 : 0.3 # set reg = -imm
      else
        # A dereferenced value must be zero in memory. If it hangs off the stack it
        # lands in our zeroed scratch for free; a single deref off a register can be
        # zeroed by pointing that register at scratch; deeper derefs aren't handled.
        return 0.05 if stack_reg?(op.reg)

        op.deref == 1 && op.reg ? 0.2 : nil
      end
    end

    # @return [Float, nil]
    def relational_cost(disjunct)
      parse_relation(disjunct) ? 0.4 : nil
    end

    # Whether +branch+ already holds under the current register assignment.
    def satisfied?(plan, branch)
      case branch
      when /\Awritable: (.+)\z/
        op = Operand_.parse(Regexp.last_match(1))
        op.deref.zero? && op.reg && (stack_reg?(op.reg) || scratch?(plan, op.reg))
      when /is a valid (?:argv|envp)\z/
        (ptr = pointer_form(branch)) && scratch?(plan, ptr)
      else
        reg, value = parse_relation(branch)
        current = reg && plan.regs[reg]
        if current.is_a?(Hash) then scratch_satisfies_relation?(branch)
        else reg && !current.nil? && current == (value & MASK64)
        end
      end
    end

    # A register pointed at scratch holds a large, nonzero, mapped address, so it
    # already satisfies +!= <imm>+ and +>|>= <small imm>+ (but not an equality or a
    # low bound).
    def scratch_satisfies_relation?(branch)
      m = branch.match(/\A(?:\([su]\d+\))?\w+ (==|!=|<=|>=|<|>) (#{IMM})\z/)
      return false unless m

      op, imm = m[1], Integer(m[2])
      op == '!=' || ((op == '>' || op == '>=') && imm <= 0x1000)
    end

    # Mutate +plan+ to satisfy +disjunct+; false on an irreconcilable conflict.
    def apply(plan, disjunct)
      case disjunct
      when /\Awritable: (.+)\z/
        (op = safe_parse(Regexp.last_match(1))) ? apply_writable(plan, op) : false
      when /\A(.+?) == NULL\z/, /\A(.+?) <= 0\z/
        op = safe_parse(Regexp.last_match(1))
        if op.nil? then false
        elsif op.deref.zero? then set_reg(plan, op.reg, (-op.imm) & MASK64)
        elsif stack_reg?(op.reg) then true # sp-relative slot is already zeroed scratch
        elsif op.deref == 1 && op.reg then set_reg(plan, op.reg, { 'scratch_off' => STRING_POOL - op.imm })
        else false
        end
      when /\A\{(.*)\} is a valid (?:argv|envp)\z/ then apply_argv_list(plan, Regexp.last_match(1))
      when /is a valid (?:argv|envp)\z/            then apply_pointer(plan, pointer_form(disjunct))
      else apply_relation(plan, disjunct)
      end
    end

    def apply_writable(plan, op)
      return false unless op.deref.zero? && op.reg
      return true if stack_reg?(op.reg)

      set_reg(plan, op.reg, scratch_slot(plan, op.imm))
    end

    # +{e0, e1, ...}+ argv/envp contents: point every controllable register
    # element at a readable scratch string so the array is fully valid. Literals,
    # NULL, libc globals and stack slots are handled by the code or zero-fill.
    def apply_argv_list(plan, inner)
      elements = inner.split(',').map(&:strip).reject { |e| e == '...' }
      seen_c = false
      command_set = false
      elements.each do |e|
        seen_c ||= (e == '"-c"')
        next if e.start_with?('"') || e == 'NULL'

        op = safe_parse(e) or next
        next if op.deref.positive? || op.reg.nil? || stack_reg?(op.reg) || global?(op.reg)

        # For `sh -c … <cmd>`, the first operand register after -c is the shell
        # command (`--`, a libc constant, just ends option parsing) -- point it at
        # "ls /". Every other element gets an empty readable string.
        pool = seen_c && !command_set ? COMMAND_POOL : STRING_POOL
        command_set ||= (pool == COMMAND_POOL)
        return false unless set_reg(plan, op.reg, { 'scratch_off' => pool - op.imm })
      end
      true
    end

    # +<ptr> is a valid argv/envp+: point the pointer at scratch (a zero-filled,
    # hence NULL-terminated empty array).
    def apply_pointer(plan, ptr)
      return false unless ptr

      set_reg(plan, ptr, { 'scratch_off' => STRING_POOL })
    end

    def apply_relation(plan, disjunct)
      reg, value = parse_relation(disjunct)
      return false unless reg

      set_reg(plan, reg, value & MASK64)
    end

    # Parse a branch-condition disjunct into the [register, value] that satisfies
    # it, or [nil, nil] when it isn't a settable single-register relation.
    # @return [(String, Integer), (nil, nil)]
    def parse_relation(disjunct)
      if (m = disjunct.match(/\A\((\w+) & (#{IMM})\) (==|!=) (#{IMM})\z/))
        reg, mask, op, rhs = m[1], Integer(m[2]), m[3], Integer(m[4])
        return [nil, nil] unless rhs.zero? && settable?(reg)

        return [xreg(reg), op == '==' ? 0 : mask] # (reg & mask)==0 -> 0; !=0 -> mask
      end
      if (m = disjunct.match(/\A(?:\([su]\d+\))?(\w+) (==|!=|<=|>=|<|>) (#{IMM})\z/))
        reg, op, imm = m[1], m[2], Integer(m[3])
        return [nil, nil] unless settable?(reg)

        return [xreg(reg), relation_witness(op, imm)]
      end
      [nil, nil]
    end

    def relation_witness(op, imm)
      case op
      when '==', '>=', '<=' then imm
      when '!=' then imm.zero? ? 1 : 0
      when '>'  then imm + 1
      when '<'  then imm - 1
      end
    end

    # A distinct scratch write-area for a +writable: reg+imm+ target.
    def scratch_slot(plan, imm)
      slot = plan.writable_count
      plan.writable_count += 1
      { 'scratch_off' => WRITABLE_BASE + slot * WRITABLE_STRIDE - imm }
    end

    def pointer_form(branch)
      ptr = branch[/\A(\S+) is a valid (?:argv|envp)\z/, 1]
      ptr && !ptr.start_with?('{') ? (op = safe_parse(ptr)) && op.reg && op.deref.zero? && op.reg : nil
    end

    def safe_parse(str)
      Operand_.parse(str)
    rescue ArgumentError
      nil
    end

    # A register the plan points at scratch (a readable+writable, zero-filled ptr).
    def scratch?(plan, reg)
      plan.regs[reg].is_a?(Hash)
    end

    def global?(reg)
      reg.start_with?('$')
    end

    def settable?(reg)
      @arch.gprs.include?(xreg(reg))
    end

    # Normalise a 32-bit view (+w21+) to its 64-bit register (+x21+); others as-is.
    def xreg(reg)
      reg.sub(/\Aw(\d+|zr)\z/, 'x\1')
    end

    def set_reg(plan, reg, value)
      return false if reg.nil?

      existing = plan.regs[reg]
      return false if existing && existing != value

      plan.regs[reg] = value
      true
    end

    def stack_reg?(reg)
      @arch.stack_regs.include?(reg)
    end
  end
end
