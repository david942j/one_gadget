# frozen_string_literal: true

require_relative 'operand'

module Aletheia
  # Turns a gadget's constraint list into a concrete injection plan: which
  # registers to set, and how scratch memory is laid out. This is the inverse of
  # one_gadget's +calculate_score+ dispatch, but it *produces assignments* and
  # its constraint semantics are written independently (see {Operand_}).
  #
  # Memory model assumed by the plan: the driver allocates one zeroed scratch
  # region and sets +sp+ to +scratch + sp_offset+. Any +sp+-relative dereference
  # the constraints require to be NULL is therefore already satisfied by the
  # zero-fill; any effect argument of the form +sp+imm+ points into scratch.
  class Satisfier
    # @return [Aletheia::Plan]
    Plan = Struct.new(:offset, :effect, :constraints, :regs, :scratch_size, :sp_offset,
                      :benign_default, :poison_default, :branches, :status, :reason,
                      :writable_count, keyword_init: true)

    SCRATCH_SIZE    = 0x10000
    SP_OFFSET       = 0x2000
    WRITABLE_BASE   = 0x4000  # write-areas live above the stack region (sp is at SP_OFFSET)
    WRITABLE_STRIDE = 0x800
    MASK64          = (1 << 64) - 1

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
        options = constraint.split(' || ').map { |d| [evaluate(d.strip), d.strip] }
                            .select { |cost, _| cost }
        if options.empty?
          return skip(plan, "unsupported-or-unsat: #{constraint}")
        end

        cost, chosen = options.min_by { |c, _| c }.then { |c, d| [c, d] }
        unless apply(plan, chosen)
          return skip(plan, "conflict while satisfying: #{chosen}")
        end

        plan.branches["c#{i}"] = chosen
      end
      plan
    end

    private

    def skip(plan, reason)
      plan.status = 'skip'
      plan.reason = reason
      plan
    end

    # Cost of satisfying a single disjunct (lower = easier). nil = not
    # satisfiable, or a category this satisfier does not yet handle.
    # @return [Float, nil]
    def evaluate(disjunct)
      case disjunct
      when /\Awritable: (.+)\z/         then writable_cost(Operand_.parse(Regexp.last_match(1)))
      when /\A(.+?) == NULL\z/          then null_cost(Operand_.parse(Regexp.last_match(1)))
      when /\A(.+?) <= 0\z/             then null_cost(Operand_.parse(Regexp.last_match(1)))
      when /is a valid argv\z/          then 0.9  # requires the argv builder (see #apply)
      when /is a valid envp\z/          then 0.9
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
        # A dereferenced value must be zero in memory. If it hangs off the stack
        # it lands in our zeroed scratch for free; otherwise we would have to
        # point a register at zeroed scratch (handled in a later milestone).
        stack_reg?(op.reg) ? 0.05 : nil
      end
    end

    # Mutates +plan+ to satisfy +disjunct+. Returns false on an irreconcilable
    # register conflict.
    def apply(plan, disjunct)
      case disjunct
      when /\Awritable: (.+)\z/
        op = Operand_.parse(Regexp.last_match(1))
        return true if stack_reg?(op.reg) # sp/x29-relative already lands in writable scratch

        slot = plan.writable_count
        plan.writable_count += 1
        set_reg(plan, op.reg, { 'scratch_off' => WRITABLE_BASE + slot * WRITABLE_STRIDE - op.imm })
      when /\A(.+?) == NULL\z/, /\A(.+?) <= 0\z/
        op = Operand_.parse(Regexp.last_match(1))
        return true if op.deref.positive? # satisfied by zeroed scratch

        set_reg(plan, op.reg, (-op.imm) & MASK64)
      when /is a valid argv\z/, /is a valid envp\z/
        # Not reached for the native-2.43 set (a NULL branch is always cheaper).
        # The argv/envp builder lands with the older-libc milestone.
        false
      else
        false
      end
    end

    def set_reg(plan, reg, value)
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
