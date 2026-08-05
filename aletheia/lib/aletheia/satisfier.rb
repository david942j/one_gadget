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
    # @!attribute mem
    #   [Hash{Integer => Integer, Hash}] scratch-relative memory writes the driver
    #   applies before jumping (a pointer value, keyed by the scratch offset to
    #   write it at) -- e.g. so a chained dereference like +[[sp]]+ finds a real
    #   pointer at +[sp]+ instead of the zero-fill a single dereference relies on.
    Plan = Struct.new(:offset, :effect, :constraints, :regs, :mem, :base_mem, :scratch_size, :sp_offset,
                      :benign_default, :poison_default, :null_default, :branches, :status,
                      :reason, :writable_count, keyword_init: true)

    SCRATCH_SIZE    = 0x20000
    # Headroom below sp: some gadgets land inside a function whose own prologue
    # allocates its stack frame *after* we've jumped in (e.g. aarch64 execl's
    # `sub sp, sp, #0x2000; sub sp, sp, #0xd0`, ~8.4KB) -- too little headroom lets
    # that write run off the start of the scratch mmap. Found via Aletheia itself:
    # a too-tight sp_offset (0x2000) let exactly this happen, silently absorbed by
    # an adjacent mapping under native ASLR but faulting reliably under qemu-user's
    # stricter layout -- a harness bug, not a one_gadget one. 64KB comfortably
    # covers any observed gadget's local stack usage.
    SP_OFFSET       = 0x10000
    STRING_POOL     = 0x100    # readable+writable zeroed bytes: a valid "" / [NULL] array
    COMMAND_POOL    = 0x200    # the "ls /" L2 command the driver seeds here
    COMMAND_RESERVED = 0x40    # generous window at COMMAND_POOL treated as non-zero
    WRITABLE_BASE   = 0x12000  # write-areas live above the stack region (sp is at SP_OFFSET)
    WRITABLE_STRIDE = 0x800
    WORD            = 8        # conservative pointer width for a "reads zero" check
    MASK64          = (1 << 64) - 1
    IMM             = /-?(?:0x[0-9a-fA-F]+|\d+)/
    # A literal zero, in whichever form one_gadget renders it for that context:
    # decimal +0+ (a bare register's "== NULL" branch) or hex +0x0+ (a sized value
    # comparison, e.g. +(s32)[..] <= 0x0+). Use in place of a hardcoded +0+ so a
    # rendering choice on the one_gadget side can't silently stop the satisfier
    # from recognising a branch it already knows how to solve.
    ZERO            = /(?:0|0x0+)/
    # Bare +reg & mask == want+ (no parens): a low-bits/alignment constraint. The
    # parenthesised +(reg & mask) == want+ is a settable-register relation instead
    # (see {#parse_relation}).
    ALIGN           = /\A(\w+) & (#{IMM}) == (#{IMM})\z/

    # +<reg> is the GOT address of libc+ (i386 PIC): the register must hold the
    # libc GOT base, i.e. +base + PLTGOT offset+.
    GOT = /\A(\w+) is the GOT address of libc\z/

    # +writable: [base]+imm+ (a compound base -- offset from a *dereferenced*
    # value, not a bare register, e.g. a store through a pointer read off the
    # stack). +base+'s own content is only pinned by a *later* argv/envp
    # constraint, so this is handled by deferring it (see {#satisfy}) rather
    # than by {#writable_cost}/{#apply_writable}, which assume a bare register.
    WRITABLE_COMPOUND = /\Awritable: (\[.+\])[+-]#{IMM}\z/

    # @param arch an arch backend (e.g. {Arch::AArch64})
    # @param [Integer, nil] got_offset the libc PLTGOT file offset, for i386's
    #   "+<reg> is the GOT address of libc+" constraint (see {GOT}).
    # @param [Boolean] strict when true, uncontrolled registers are poisoned
    #   (unmapped) so any unlisted dependency faults -- a completeness test for
    #   the constraint list. When false, they point at readable scratch.
    def initialize(arch, got_offset: nil, strict: false)
      @arch = arch
      @got_offset = got_offset
      @strict = strict
    end

    # @param [OneGadget::Gadget::Gadget] gadget
    # @return [Aletheia::Plan]
    def satisfy(gadget)
      plan = Plan.new(
        offset: format('%#x', gadget.offset), effect: gadget.effect,
        constraints: gadget.constraints.dup, regs: {}, mem: {}, base_mem: {}, scratch_size: SCRATCH_SIZE,
        sp_offset: SP_OFFSET, benign_default: !@strict, poison_default: @strict,
        branches: {}, status: 'ok', reason: nil, writable_count: 0
      )
      # A `writable: [base]+imm` constraint can only be checked once `base`'s own
      # content is pinned by its own (argv/envp) constraint -- deferred to run
      # last. That constraint must not pick its NULL branch for `base`: with
      # base == NULL, `[base]+imm` is a fixed low address (e.g. 0x10), an
      # unmapped-page write in reality, not a merely-untracked one.
      ordered = order_constraints(gadget.constraints)
      @null_unsafe_bases = ordered.grep(WRITABLE_COMPOUND) { Regexp.last_match(1) }
      ordered.each_with_index do |constraint, i|
        chosen = satisfy_constraint(plan, constraint)
        return skip(plan, "unsupported-or-unsat: #{constraint}") unless chosen

        plan.branches["c#{i}"] = chosen
      end
      plan
    end

    private

    # Try each disjunct of +constraint+ cheapest-first; accept the first that is
    # already satisfied by the current plan or that applies without conflict. The
    # register map and memory-write map are snapshot/restored around a failed
    # apply so a partial assignment can't leak into the next attempt.
    # @return [String, nil] the chosen disjunct, or nil if none worked.
    def satisfy_constraint(plan, constraint)
      ordered = constraint.split(' || ').map(&:strip)
                          .map { |b| [evaluate(b), b] }.select { |c, _| c }
                          .sort_by { |c, _| c }
      ordered.each do |_, branch|
        return branch if satisfied?(plan, branch)

        regs_snapshot = plan.regs.dup
        mem_snapshot = plan.mem.dup
        return branch if apply(plan, branch)

        plan.regs = regs_snapshot
        plan.mem = mem_snapshot
      end
      nil
    end

    def skip(plan, reason)
      plan.status = 'skip'
      plan.reason = reason
      plan
    end

    # Order constraints so each runs once its inputs are settled and so a
    # register-pinning constraint wins over a mere bound on the same register:
    # * a plain `writable: reg+imm` runs FIRST -- it pins `reg` to a (nonzero,
    #   mapped) scratch pointer, which then already satisfies a co-occurring bound
    #   like `reg != 0` (see {#scratch_satisfies_relation?}); applying the bound
    #   first would pin `reg` to a bare literal and block the writable.
    # * a compound `writable: [base]+imm` (see {WRITABLE_COMPOUND}) runs LAST, once
    #   `base`'s own constraint has picked and applied its resolution.
    def order_constraints(constraints)
      compound, rest = constraints.partition { |c| c.match?(WRITABLE_COMPOUND) }
      writable, others = rest.partition { |c| c.start_with?('writable: ') }
      # A nested readable (readable: [base+imm]) resolves its base through
      # mem_addr_off, which needs base already pointed at scratch -- done by a
      # shallower readable/writable on that base. Apply readables shallowest
      # first, keeping every other constraint's relative order (stable sort via
      # the original index).
      others = others.each_with_index.sort_by { |c, i| [readable_depth(c), i] }.map(&:first)
      writable + others + compound
    end

    # The dereference depth of a +readable:+ constraint's pointer (0 for a bare
    # +readable: reg+imm+, 1 for +readable: [base+imm]+); 0 for any non-readable
    # constraint, so {#order_constraints} leaves those in place.
    def readable_depth(constraint)
      m = constraint.match(/\Areadable: (.+)\z/) or return 0
      (op = safe_parse(m[1])) ? op.deref : 0
    end

    # Cost of satisfying a single disjunct (lower = easier); nil = unsatisfiable
    # or a category this satisfier doesn't handle.
    # @return [Float, nil]
    def evaluate(disjunct)
      case disjunct
      when WRITABLE_COMPOUND then 0.9 # deferred; see #order_compound_writable_last
      when /\Awritable: (.+)\z/
        (op = safe_parse(Regexp.last_match(1))) && writable_cost(op)
      when /\Areadable: (.+)\z/
        (op = safe_parse(Regexp.last_match(1))) && op.reg && 0.4 # point it at scratch
      when /\A(.+?) == NULL\z/, /\A(.+?) <= #{ZERO}\z/
        base = Regexp.last_match(1)
        return nil if @null_unsafe_bases&.include?(base)

        (op = safe_parse(base)) && null_cost(op)
      when /\A\{.*\} is a valid (?:argv|envp)\z/ then 0.5 # array literal: element builder
      when /is a valid (?:argv|envp)\z/         then 0.4 # pointer form: point it at scratch
      when ALIGN                                then alignment_cost(disjunct)
      when GOT                                  then got_cost(disjunct)
      else
        if (op = deref_zero(disjunct)) then null_cost(op)
        elsif (parsed = deref_relation(disjunct)) then literal_cost(parsed[0])
        elsif reg_relation(disjunct) then 0.45 # pin both registers
        elsif reg_mem_relation(disjunct) then 0.5 # pin the register, store a matching value
        else relational_cost(disjunct)
        end
      end
    end

    # A dereferenced value required to be zero (+[X] == 0+) -- equivalent to
    # +[X] == NULL+. A bare +reg == 0+ is a settable relation handled elsewhere,
    # so only the dereferenced form is returned here.
    def deref_zero(disjunct)
      m = disjunct.match(/\A(.+?) == #{ZERO}\z/) or return nil
      op = safe_parse(m[1])
      op if op&.reg && op.deref.positive?
    end

    # A dereferenced value compared against a literal, e.g. +[rbp-0x50] == 0x1+ or
    # +[$base+0x1c2430] != 0x0+ -- a value read from tracked memory that a later
    # comparison in the *same* candidate constrains. Returns the operand together
    # with the value to store so the comparison holds (see {#relation_witness}),
    # which the register-side relation machinery can't express: {#parse_relation}
    # matches a bare register name, never a memory operand. The zero-equality case
    # is claimed by {#deref_zero} first. Only a single dereference is modeled -- a
    # chained +[[X]+imm]+ would need the same deep-pointer machinery as
    # {#apply_deep_null}.
    # @return [(Aletheia::Operand, Integer), nil]
    def deref_relation(disjunct)
      m = disjunct.match(/\A(?:\([su]\d+\))?(.+?) (==|!=|<=|>=|<|>) (#{IMM})\z/) or return nil
      op = safe_parse(m[1])
      return nil unless op&.reg && op.deref == 1

      relop = m[2]
      imm = Integer(m[3])
      witness = relation_witness(relop, imm)
      # "must be nonzero" admits any value, so record that a pointer will do:
      # storing one keeps the location usable as a pointer by another constraint
      # (+[$base+off] != 0+ alongside +[[$base+off]+0xe8] == 0+), which pinning
      # the bare literal 1 would block.
      witness && [op, witness & MASK64, relop == '!=' && imm.zero?]
    end

    # +<reg> is the GOT address of libc+: settable when we know the PLTGOT offset
    # and the register is assignable (see {GOT}).
    # @return [Float, nil]
    def got_cost(disjunct)
      reg = disjunct[GOT, 1]
      @got_offset && settable?(reg) ? 0.3 : nil
    end

    # +reg & mask == want+: the stack pointer is aligned by construction (the
    # driver sets +sp+ to an aligned scratch address); a GPR can be pointed at an
    # aligned scratch slot. Only +want == 0+ (the alignment case) is handled.
    # @return [Float, nil]
    def alignment_cost(disjunct)
      reg, _mask, want = parse_alignment(disjunct)
      return 0.05 if stack_reg?(reg) && want.zero?

      settable?(reg) && want.zero? ? 0.3 : nil
    end

    def parse_alignment(disjunct)
      m = disjunct.match(ALIGN)
      [xreg(m[1]), Integer(m[2]), Integer(m[3])]
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
      elsif op.deref == 1
        # A single dereferenced value must be zero in memory. If it hangs off the
        # stack it lands in our zeroed scratch for free; off a register, that
        # register can be pointed at scratch.
        return 0.05 if stack_reg?(op.reg)

        op.reg ? 0.2 : nil
      else
        deep_null_cost(op)
      end
    end

    # +[[X]] == NULL+ (or deeper): X's OWN first-level target isn't guaranteed
    # zero (only what it points AT, at the next level, needs to be) -- so unlike a
    # single deref this needs a real pointer written into scratch at each level of
    # the chain, terminating in the always-zero {STRING_POOL}. See {#apply_deep_null}.
    # Costed above a single deref (one extra scratch write per extra level), and
    # requires a settable register when X isn't the stack pointer.
    # @return [Float, nil]
    def deep_null_cost(op)
      return nil unless stack_reg?(op.reg) || base_reg?(op) || (op.reg && settable?(op.reg))

      base = stack_reg?(op.reg) ? 0.15 : 0.25
      base + (0.05 * (op.deref - 2))
    end

    # Unlike a zero target ({#null_cost}), a nonzero literal is never already
    # sitting in zeroed scratch for free -- it always needs a real write, so
    # this costs above the zero case at each tier.
    # @return [Float, nil]
    def literal_cost(op)
      return 0.15 if stack_reg?(op.reg)
      return 0.2 if base_reg?(op) # a libc global the driver writes directly

      op.reg && settable?(op.reg) ? 0.3 : nil
    end

    # @return [Float, nil]
    def relational_cost(disjunct)
      parse_relation(disjunct) ? 0.4 : nil
    end

    # Whether +branch+ already holds under the current register assignment.
    def satisfied?(plan, branch)
      case branch
      when WRITABLE_COMPOUND
        compound_writable_satisfied?(plan, Regexp.last_match(1))
      when /\Awritable: (.+)\z/
        op = Operand_.parse(Regexp.last_match(1))
        op.deref.zero? && op.reg && (stack_reg?(op.reg) || scratch?(plan, op.reg))
      when /\Areadable: (.+)\z/
        (op = safe_parse(Regexp.last_match(1))) && pointer_resolved?(plan, op)
      when /is a valid (?:argv|envp)\z/
        (op = pointer_form(branch)) && pointer_resolved?(plan, op)
      when ALIGN
        reg, _mask, want = parse_alignment(branch)
        (stack_reg?(reg) && want.zero?) || (want.zero? && scratch?(plan, reg))
      when /\A(.+?) == NULL\z/, /\A(.+?) <= #{ZERO}\z/
        (op = safe_parse(Regexp.last_match(1))) && deref_reads_zero?(plan, op)
      when GOT
        base_relative?(plan.regs[branch[GOT, 1]])
      else
        if (op = deref_zero(branch))
          deref_reads_zero?(plan, op)
        elsif (parsed = deref_relation(branch))
          literal_satisfied?(plan, parsed[0], parsed[1], any_nonzero: parsed[2])
        elsif (pair = reg_relation(branch))
          reg_relation_satisfied?(plan, *pair)
        elsif (trio = reg_mem_relation(branch))
          reg_mem_satisfied?(plan, *trio)
        else
          reg, value = parse_relation(branch)
          current = reg && plan.regs[reg]
          if current.is_a?(Hash) then scratch_satisfies_relation?(branch)
          else reg && !current.nil? && current == (value & MASK64)
          end
        end
      end
    end

    # Whether a memory-relation operand's tracked memory already holds +literal+
    # (see {#deref_relation}).
    def literal_satisfied?(plan, op, literal, any_nonzero: false)
      value = mem_value(plan, op)
      return pointer_value?(value) || (value.is_a?(Integer) && !value.zero?) if any_nonzero

      value == literal
    end

    # A stored scratch pointer: a mapped, nonzero address the driver resolves.
    def pointer_value?(value)
      value.is_a?(Hash) && value.key?('scratch_off')
    end

    # Whether a +== NULL+ / +<= 0+ operand already reads zero under the current
    # plan: a bare register pinned to 0, or a single deref off a scratch-pointing
    # register whose target lands in the zero-filled region. This lets one register
    # assignment (e.g. a +writable: reg+imm+) also satisfy a +[reg+imm] == NULL+ on
    # the same slot, instead of the two conflicting.
    def deref_reads_zero?(plan, op)
      return plan.regs[op.reg] == 0 if op.deref.zero? && op.reg
      return mem_value(plan, op)&.zero? || false if op.deref >= 2
      return false unless op.inner_imm.zero?
      return plan.base_mem[op.imm] == 0 if op.deref == 1 && base_reg?(op) # zeroed libc global
      return false unless op.deref == 1 && op.reg && scratch?(plan, op.reg)

      zeroed_scratch?(plan.regs[op.reg]['scratch_off'] + op.imm)
    end

    # A +$base+<off>+ operand: a fixed libc-global address (the load base plus an
    # offset), which the driver writes directly rather than the satisfier pinning
    # a register.
    def base_reg?(op)
      op&.reg == '$base'
    end

    # Whether a word read at scratch offset +off+ is zero: in-bounds, and clear of
    # the L2 command the driver seeds at COMMAND_POOL (the only non-zero region).
    def zeroed_scratch?(off)
      return false unless off >= 0 && off + WORD <= SCRATCH_SIZE

      off + WORD <= COMMAND_POOL || off >= COMMAND_POOL + COMMAND_RESERVED
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
      when WRITABLE_COMPOUND
        compound_writable_satisfied?(plan, Regexp.last_match(1))
      when /\Awritable: (.+)\z/
        (op = safe_parse(Regexp.last_match(1))) ? apply_writable(plan, op) : false
      when /\Areadable: (.+)\z/
        (op = safe_parse(Regexp.last_match(1))) ? apply_pointer(plan, op) : false
      when /\A(.+?) == NULL\z/, /\A(.+?) <= #{ZERO}\z/
        op = safe_parse(Regexp.last_match(1))
        if op.nil? then false
        elsif op.deref.zero? then set_reg(plan, op.reg, (-op.imm) & MASK64)
        elsif op.deref == 1 && base_reg?(op) then set_base_mem(plan, op.imm, 0) # zero the libc global
        elsif op.deref == 1 && stack_reg?(op.reg) then true # sp-relative slot is already zeroed scratch
        elsif op.deref == 1 && op.reg then set_reg(plan, op.reg, { 'scratch_off' => STRING_POOL - op.imm })
        elsif op.deref >= 2 then apply_deep_null(plan, op)
        else false
        end
      when /\A\{(.*)\} is a valid (?:argv|envp)\z/ then apply_argv_list(plan, Regexp.last_match(1))
      when /is a valid (?:argv|envp)\z/            then apply_pointer(plan, pointer_form(disjunct))
      when ALIGN                                   then apply_alignment(plan, disjunct)
      when GOT                                     then apply_got(plan, disjunct)
      else
        if (op = deref_zero(disjunct)) then apply_deref_null(plan, op)
        elsif (parsed = deref_relation(disjunct)) then apply_literal(plan, parsed[0], parsed[1], any_nonzero: parsed[2])
        elsif (pair = reg_relation(disjunct)) then apply_reg_relation(plan, *pair)
        elsif (trio = reg_mem_relation(disjunct)) then apply_reg_mem_relation(plan, *trio)
        else apply_relation(plan, disjunct)
        end
      end
    end

    # Satisfy a dereferenced +== <imm>+ (nonzero) by pinning +op.reg+ to a fresh
    # scratch slot (unless it's already resolvable -- sp, or a register some
    # other constraint in this candidate already pinned) and writing +literal+
    # there. Unlike a zero target, there's no already-correct region to point
    # at, so this always needs a real write.
    def apply_literal(plan, op, literal, any_nonzero: false)
      # "Nonzero" is satisfied by a scratch pointer, which -- unlike a bare 1 --
      # another constraint can still dereference (see {#deref_relation}).
      literal = scratch_slot(plan, 0) if any_nonzero
      if op.deref >= 2
        target = deep_target_off(plan, op, allocate: true)
        return target ? set_mem(plan, target, literal) : false
      end
      return false unless op.inner_imm.zero? # a displaced pointer value, not memory contents
      return set_base_mem(plan, op.imm, literal) if base_reg?(op)

      addr_off = mem_addr_off(plan, op)
      if addr_off.nil?
        return false unless op.reg && settable?(op.reg)

        slot = scratch_slot(plan, op.imm)
        return false unless set_reg(plan, xreg(op.reg), slot)

        addr_off = slot['scratch_off'] + op.imm
      end
      set_mem(plan, addr_off, literal)
    end

    # Satisfy a dereferenced +== 0+ by pointing the register at zeroed scratch
    # (an sp-relative slot is already zero); cf. the +== NULL+ deref handling.
    def apply_deref_null(plan, op)
      return true if op.deref == 1 && stack_reg?(op.reg)
      return set_base_mem(plan, op.imm, 0) if op.deref == 1 && base_reg?(op) # zero the libc global
      return apply_deep_null(plan, op) if op.deref >= 2

      op.reg ? set_reg(plan, op.reg, { 'scratch_off' => STRING_POOL - op.imm }) : false
    end

    # Build a chain of scratch pointers so a chained dereference (+[[X]] == NULL+,
    # or deeper) is genuinely valid at every level, not just the last: unlike a
    # single dereference, +[X]+ (the first level) is NOT already guaranteed zero,
    # so it must hold a real pointer for the next level to read -- terminating in
    # the always-zero {STRING_POOL} so the final read is 0.
    # @param [Aletheia::Operand] op A parsed operand with +op.deref >= 2+.
    # @example +[[sp]] == NULL+ (deref 2): one write, sp's own scratch slot -> STRING_POOL
    # @example +[[r5+8]] == NULL+ (deref 2, register): r5 is pointed at a fresh
    #   slot, and that slot -> STRING_POOL
    # @example deref 3: X -> slot_1 -> STRING_POOL (two writes, one extra slot)
    def apply_deep_null(plan, op)
      # A field read off a pointer ([[base+imm]+inner]): point that pointer at a
      # fresh scratch area so the field lands in the zero fill.
      unless op.inner_imm.zero?
        target = deep_target_off(plan, op, allocate: true)
        return target ? set_mem(plan, target, 0) : false
      end

      addr_off =
        if stack_reg?(op.reg)
          SP_OFFSET + op.imm
        elsif op.reg && settable?(op.reg)
          slot = scratch_slot(plan, op.imm)
          return false unless set_reg(plan, xreg(op.reg), slot)

          slot['scratch_off'] + op.imm
        end
      return false unless addr_off

      (op.deref - 1).times do |i|
        target_off = i == op.deref - 2 ? STRING_POOL : scratch_slot(plan, 0)['scratch_off']
        return false unless set_mem(plan, addr_off, { 'scratch_off' => target_off })

        addr_off = target_off
      end
      true
    end

    # Set the base register to the libc GOT, +base + PLTGOT offset+; the driver
    # resolves the +base_off+ against the runtime load base (cf. +scratch_off+).
    def apply_got(plan, disjunct)
      return false unless @got_offset

      set_reg(plan, xreg(disjunct[GOT, 1]), { 'base_off' => @got_offset })
    end

    # A register value the driver resolves against the libc load base.
    def base_relative?(value)
      value.is_a?(Hash) && value.key?('base_off')
    end

    def apply_alignment(plan, disjunct)
      reg, _mask, want = parse_alignment(disjunct)
      return want.zero? if stack_reg?(reg) # sp is aligned by construction; nothing to set
      return false unless want.zero? && settable?(reg)

      set_reg(plan, reg, { 'scratch_off' => STRING_POOL }) # a 16-aligned readable slot
    end

    def apply_writable(plan, op)
      return false unless op.deref.zero? && op.reg
      return true if stack_reg?(op.reg)

      set_reg(plan, op.reg, scratch_slot(plan, op.imm))
    end

    # +writable: [base]+imm+ (see {WRITABLE_COMPOUND}): satisfied once +base+'s
    # own content -- pinned by its own constraint, which {#order_compound_writable_last}
    # guarantees ran first -- is a scratch pointer. Nothing further to write:
    # +imm+ always lands comfortably inside that region (an argv/envp element
    # offset, never close to {STRING_POOL}/{WRITABLE_STRIDE}'s size).
    def compound_writable_satisfied?(plan, base_text)
      op = safe_parse(base_text)
      return false unless op && op.deref == 1 && op.reg

      addr_off = mem_addr_off(plan, op)
      return false unless addr_off

      target = plan.mem[addr_off]
      target.is_a?(Hash) && target.key?('scratch_off')
    end

    # The scratch-relative offset a single-deref operand's memory lives at (an
    # +sp+-relative slot, or off a register the plan already points at scratch),
    # or +nil+ when neither -- +base+ isn't resolved (yet).
    def mem_addr_off(plan, op)
      return SP_OFFSET + op.imm if stack_reg?(op.reg)
      return plan.regs[op.reg]['scratch_off'] + op.imm if scratch?(plan, op.reg)

      nil
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
    def apply_pointer(plan, op)
      return false unless op
      return set_reg(plan, op.reg, { 'scratch_off' => STRING_POOL }) if op.deref.zero?

      addr_off = mem_addr_off(plan, op)
      addr_off && set_mem(plan, addr_off, { 'scratch_off' => STRING_POOL })
    end

    # Whether a pointer-form +X is a valid argv/envp+ operand already resolves to
    # scratch: +X+ itself (deref 0), or the memory +X+ dereferences (deref 1).
    def pointer_resolved?(plan, op)
      return scratch?(plan, op.reg) if op.deref.zero?

      addr_off = mem_addr_off(plan, op)
      addr_off && plan.mem[addr_off].is_a?(Hash) && plan.mem[addr_off].key?('scratch_off')
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

    # A comparison between two registers, e.g. +x3 == x0+ or +r3 != r1+: neither
    # side is a literal, so {#parse_relation} (a register against an immediate)
    # can't express it. Only equality is modeled -- an ordering between two
    # uncontrolled registers hasn't been needed, and picking witnesses for it
    # would constrain both sides more than the branch actually requires.
    # @return [(String, String, String), nil] normalised lhs, operator, rhs.
    def reg_relation(disjunct)
      m = disjunct.match(/\A(?:\([su]\d+\))?(\w+) (==|!=) (?:\([su]\d+\))?(\w+)\z/) or return nil
      lhs, op, rhs = m.captures
      # \w+ also matches a hex literal, which is {#parse_relation}'s business.
      return nil if [lhs, rhs].any? { |r| r.match?(/\A#{IMM}\z/) }
      return nil unless settable?(lhs) && settable?(rhs)

      [xreg(lhs), op, xreg(rhs)]
    end

    # Whether both registers already hold values meeting +op+.
    def reg_relation_satisfied?(plan, lhs, op, rhs)
      return op == '==' if lhs == rhs # the same register, after normalisation

      a, b = plan.regs.values_at(lhs, rhs)
      return false if a.nil? || b.nil?

      values_equal?(a, b) == (op == '==')
    end

    # Pin whichever side isn't pinned yet so +op+ holds. A register already set by
    # an earlier constraint is never overwritten -- the other side is matched to
    # it, and a genuine conflict falls through to {#set_reg}'s refusal.
    def apply_reg_relation(plan, lhs, op, rhs)
      return op == '==' if lhs == rhs

      a, b = plan.regs.values_at(lhs, rhs)
      return reg_relation_satisfied?(plan, lhs, op, rhs) unless a.nil? || b.nil?
      return set_reg(plan, lhs, counterpart(b, op)) if a.nil? && !b.nil?
      return set_reg(plan, rhs, counterpart(a, op)) if b.nil? && !a.nil?

      set_reg(plan, lhs, 0) && set_reg(plan, rhs, op == '==' ? 0 : 1)
    end

    # A value for the unpinned side of a register equality, given the pinned
    # side's value +val+ (an integer, or a scratch-pointer Hash).
    def counterpart(val, op)
      return val if op == '=='
      return 0 if val.is_a?(Hash) # a scratch pointer is a large nonzero address

      (val + 1) & MASK64
    end

    # A comparison between a register and a value read from memory, e.g.
    # +x3 == [x1+0x8]+ or +r13d == [r14+0x70]+: neither {#parse_relation}
    # (register against an immediate) nor {#deref_relation} (memory against an
    # immediate) covers it, since neither side is a literal. Returns the register
    # operand, the operator, and the memory operand, in whichever order they were
    # written.
    # @return [(Aletheia::Operand, String, Aletheia::Operand), nil]
    def reg_mem_relation(disjunct)
      m = disjunct.match(/\A(?:\([su]\d+\))?(\S+) (==|!=) (?:\([su]\d+\))?(\S+)\z/) or return nil
      lhs, op, rhs = m.captures
      return nil if [lhs, rhs].any? { |s| s.match?(/\A#{IMM}\z/) }

      a, b = [lhs, rhs].map { |s| safe_parse(s) }
      reg, mem = a&.deref&.zero? ? [a, b] : [b, a]
      return nil unless reg&.deref&.zero? && reg.reg && settable?(reg.reg)
      return nil unless (1..2).cover?(mem&.deref.to_i) && mem.reg

      [reg, op, mem]
    end

    # The value tracked memory holds at run time, or +nil+ when unknown. An
    # address inside our scratch reads zero unless the plan writes it; a libc
    # global keeps whatever libc left there, so it counts as known only once the
    # plan has written it.
    def mem_value(plan, op)
      if op.deref >= 2
        target = deep_target_off(plan, op)
        return target && (plan.mem[target] || (zeroed_scratch?(target) ? 0 : nil))
      end
      return nil unless op.inner_imm.zero? # a displaced pointer value, not memory contents
      return plan.base_mem[op.imm] if base_reg?(op)

      addr_off = mem_addr_off(plan, op)
      return nil unless addr_off

      plan.mem[addr_off] || (zeroed_scratch?(addr_off) ? 0 : nil)
    end

    # The scratch offset of the level-1 slot +[reg+imm]+, allocating a scratch
    # pointer for a settable base register when +allocate+ is set.
    def level1_addr_off(plan, op, allocate: false)
      off = mem_addr_off(plan, op)
      return off if off
      return nil unless allocate && op.reg && settable?(op.reg)

      slot = scratch_slot(plan, op.imm)
      set_reg(plan, xreg(op.reg), slot) ? slot['scratch_off'] + op.imm : nil
    end

    # The scratch offset a two-level operand +[[reg+imm]+inner]+ addresses: the
    # pointer stored at +[reg+imm]+, displaced by +inner_imm+. With +allocate+,
    # an unset pointer is made to reference a fresh scratch area, so the field it
    # addresses lands in the zero fill.
    def deep_target_off(plan, op, allocate: false)
      via_base = base_reg?(op)
      slot_off = via_base ? nil : level1_addr_off(plan, op, allocate:)
      return nil unless via_base || slot_off

      current = via_base ? plan.base_mem[op.imm] : plan.mem[slot_off]
      return current['scratch_off'] + op.inner_imm if current.is_a?(Hash) && current.key?('scratch_off')
      return nil unless allocate && current.nil?

      target = scratch_slot(plan, 0)['scratch_off']
      pointer = { 'scratch_off' => target }
      stored = via_base ? set_base_mem(plan, op.imm, pointer) : set_mem(plan, slot_off, pointer)
      stored ? target + op.inner_imm : nil
    end

    # Whether the register and the memory value already meet +op+.
    def reg_mem_satisfied?(plan, reg, op, mem)
      current = plan.regs[xreg(reg.reg)]
      value = mem_value(plan, mem)
      return false if current.nil? || value.nil? || current.is_a?(Hash) || value.is_a?(Hash)

      (((current + reg.imm) & MASK64) == value) == (op == '==')
    end

    # Match the register and the memory it is compared against. Whichever side is
    # already settled drives the other: when the memory's contents are known (a
    # zero-filled scratch slot, or a value an earlier constraint stored) the
    # register is pinned to match it, rather than overwriting memory that another
    # constraint depends on -- e.g. +[$base+off] != 0+ pins the global first, and
    # +x3 == [$base+off]+ must then take its value, not reset it. A register
    # already pinned to a scratch pointer is left alone: its run-time address
    # isn't known here, so no stored literal can be shown to equal it.
    def apply_reg_mem_relation(plan, reg, op, mem)
      current = plan.regs[xreg(reg.reg)]
      return false if current.is_a?(Hash)

      # The comparison is on `reg + imm`, so the register itself carries the
      # displacement: it holds the matched value less `imm`.
      known = mem_value(plan, mem)
      return set_reg(plan, xreg(reg.reg), (counterpart(known, op) - reg.imm) & MASK64) if known && !known.is_a?(Hash)

      value = current || 0
      lhs = (value + reg.imm) & MASK64
      set_reg(plan, xreg(reg.reg), value) && apply_literal(plan, mem, counterpart(lhs, op))
    end

    # Whether two plan values denote the same runtime value: two scratch pointers
    # at the same offset, or two equal integers. A scratch pointer and an integer
    # are never treated as equal -- the pointer's address isn't known until the
    # driver resolves it.
    def values_equal?(a, b)
      return a['scratch_off'] == b['scratch_off'] if a.is_a?(Hash) && b.is_a?(Hash)
      return false if a.is_a?(Hash) || b.is_a?(Hash)

      a == b
    end

    # A value satisfying +<reg> op imm+. An upper bound admits a whole range, so
    # pick the smallest benign member (zero) rather than the bound itself: a
    # register pinned to the extreme needlessly conflicts with a co-occurring
    # constraint on the same register, e.g. +(u64)rax <= 0xfffffffffffff000+
    # alongside +eax == 0x0+, which zero satisfies at once.
    def relation_witness(op, imm)
      case op
      when '==', '>=' then imm
      when '!=' then imm.zero? ? 1 : 0
      when '>'  then imm + 1
      when '<=' then imm.negative? ? imm : 0
      when '<'  then imm.positive? ? 0 : imm - 1
      end
    end

    # A distinct scratch write-area for a +writable: reg+imm+ target.
    def scratch_slot(plan, imm)
      slot = plan.writable_count
      plan.writable_count += 1
      { 'scratch_off' => WRITABLE_BASE + slot * WRITABLE_STRIDE - imm }
    end

    # +X+ in +X is a valid argv/envp+ (the bare-pointer form, not an array
    # literal): either +X+ itself is the pointer (deref 0 -- point the register
    # at scratch), or +X+ is +[base]+ (deref 1 -- a store through a pointer read
    # off the stack, e.g. Finding 6's shape; write the scratch pointer into
    # +base+'s own memory instead, via {#mem_addr_off}). A bare +readable: <reg>+
    # is handled directly in {#apply} via {#apply_pointer}, not here.
    # @return [Aletheia::Operand, nil]
    def pointer_form(branch)
      ptr = branch[/\A(\S+) is a valid (?:argv|envp)\z/, 1]
      return nil unless ptr && !ptr.start_with?('{')

      op = safe_parse(ptr)
      op if op&.reg && op.deref <= 1
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

    # Normalise a sub-register view to its full-width register; the mapping is
    # arch-specific (+w21+ -> +x21+ on aarch64, +eax+ -> +rax+ on amd64).
    def xreg(reg)
      @arch.normalize_reg(reg)
    end

    def set_reg(plan, reg, value)
      return false if reg.nil?

      existing = plan.regs[reg]
      return false if existing && existing != value

      plan.regs[reg] = value
      true
    end

    # As {#set_reg}, but for a scratch-relative memory write (+plan.mem+): false
    # on a conflicting write to an already-assigned offset.
    def set_mem(plan, off, value)
      existing = plan.mem[off]
      return false if existing && existing != value

      plan.mem[off] = value
      true
    end

    # As {#set_mem}, but for a libc global (+plan.base_mem+), which the driver
    # writes at +base + off+ once the runtime load base is known.
    def set_base_mem(plan, off, value)
      existing = plan.base_mem[off]
      return false if existing && existing != value

      plan.base_mem[off] = value
      true
    end

    def stack_reg?(reg)
      @arch.stack_regs.include?(reg)
    end
  end
end
