# frozen_string_literal: true

require 'one_gadget/emulators/lambda'
require 'one_gadget/emulators/processor'

module OneGadget
  module Emulators
    # Behaviour shared by the two ARM-architecture emulators, {Arm} (AArch32) and
    # {AArch64}: the condition-code table plus the parts of the calling convention
    # and memory model that are identical in 32- and 64-bit mode. The common base
    # each inherits (the ARM counterpart of {X86}); everything that genuinely
    # differs (instruction set, register width, +pc+ handling) stays in the
    # individual classes.
    class ArmFamily < Processor
      # ARM condition-code suffix (the +<cc>+ in +b<cc>+ / +b.<cc>+) mapped to a
      # shared {Conditional::RELATION} predicate. (x86 uses {X86::JCC}.)
      # @example Aliases decode alike, the sign bit reads as a signed comparison,
      #   and overflow has no constraint form -- a branch on it aborts the path.
      #   COND['hs'] #=> :uge
      #   COND['cs'] #=> :uge
      #   COND['mi'] #=> :slt
      #   COND['vs'] #=> nil
      COND = {
        'eq' => :eq, 'ne' => :ne,
        'hs' => :uge, 'cs' => :uge, 'lo' => :ult, 'cc' => :ult,
        'hi' => :ugt, 'ls' => :ule,
        'ge' => :sge, 'lt' => :slt, 'gt' => :sgt, 'le' => :sle,
        'mi' => :slt, 'pl' => :sge
      }.freeze

      # This arch family's flag-setting compare mnemonics, mapped to the ALU op
      # whose result their flags reflect (see {Conditional::COMPARE_OPS}). x86 has
      # its own {X86::COMPARES}.
      COMPARES = { 'cmp' => :sub, 'cmn' => :add, 'tst' => :and }.freeze

      # The data-processing instructions both ARM families spell the same way,
      # mapped to the Ruby operator that folds them and renders them alike.
      # +bic+ and +mvn+ are absent: they complement their operand first, which
      # {#complement} turns back into one of these (see {#inst_bic}).
      DATA_OPS = { 'and' => :&, 'orr' => :|, 'eor' => :^, 'lsl' => :<<, 'lsr' => :>> }.freeze
      private_constant :DATA_OPS

      private

      # A compare whose second operand may carry a shift modifier, e.g.
      # +cmn x0, 0x1, lsl 12+ (the immediate is 0x1000, not 0x1). Fold a constant
      # shift into the operand; abort on any modifier not modelled, since dropping
      # it would silently understate the constraint.
      # @return [Boolean] false aborts the candidate.
      def handle_compare(op, cmd)
        ops = operands(cmd)
        return false if ops.size > 3

        rhs = operand_str(ops[1])
        if ops.size == 3
          rhs = shifted_operand(rhs, ops[2])
          return false if rhs.nil?
        end
        record_compare(op, operand_str(ops[0]), rhs)
      end

      # Apply a constant shift modifier to an already-rendered operand.
      # @return [String, nil] nil when the shift isn't a constant amount applied to
      #   a known integer, which the caller treats as unmodelled.
      # @example
      #   shifted_operand('0x1', 'lsl 12') #=> '0x1000'
      def shifted_operand(rhs, modifier)
        m = modifier.match(/\A(lsl|lsr|asr)\s+(\d+)\z/)
        return nil unless m && OneGadget::Helper.integer?(rhs)

        value = Integer(rhs)
        OneGadget::Helper.hex(m[1] == 'lsl' ? value << Integer(m[2]) : value >> Integer(m[2]))
      end

      # +op2+ with the modifier this family may spell on it folded in. Yields for a
      # modifier it does not model, so an unmodelled one aborts the candidate
      # instead of being silently dropped.
      # @param [String] op2 The operand the modifier applies to.
      # @param [String, nil] mode The modifier, as written -- +nil+ for none.
      # @return [String] The operand {Processor#arith} then reads.
      # @example (aarch64, +x2+ holding +0x1+) A constant shift folds in, a
      #   sign-extension is taken whole, and a rotate is not modelled.
      #   modified_operand('x2', 'lsl 3')            #=> '0x8'
      #   modified_operand('x2', 'sxtw')             #=> 'x2'
      #   modified_operand('x2', 'ror 3') { :abort } #=> :abort
      def modified_operand(op2, mode)
        return op2 if mode.nil? || mode == 'sxtw'

        shifted_operand(value_str(value_of(op2)), mode) || yield
      end

      # +add+/+sub+, shared by both families. Each allows the 2-operand shorthand,
      # and each may carry a modifier on +op2+ -- a shift, or (aarch64) a
      # sign-extension of its low half.
      # @param [String] dst The destination register.
      # @param [String] src The value added to, or the only operand given.
      # @param [String, nil] op2 The value to add, or nil in the 2-operand form.
      # @param [String, nil] mode A modifier applied to +op2+ (see {#modified_operand}).
      # @return [void]
      def inst_add(dst, src, op2 = nil, mode = nil)
        arith(:+, dst, src, modified_operand(op2, mode) { raise_unsupported(:+, dst, src, op2, mode) })
      end

      # +sub dst, src, op2+. See {#inst_add} for the operands.
      # @return [void]
      def inst_sub(dst, src, op2 = nil, mode = nil)
        arith(:-, dst, src, modified_operand(op2, mode) { raise_unsupported(:-, dst, src, op2, mode) })
      end

      # Each {DATA_OPS} mnemonic handled the one way, since they differ only in the
      # operator applied (see {Processor#data_op} for the operands).
      %w[and orr eor lsl lsr].each do |name|
        define_method(:"inst_#{name}") do |dst, src, op2 = nil|
          data_op(DATA_OPS.fetch(name), dst, src, op2, name:)
        end
      end

      # +bic dst, src, op2+ clears the bits +op2+ sets, which is +and+ against its
      # complement -- the form a constraint should read as, since that complement
      # is the mask the caller has to arrange.
      # @param [String] dst The destination register.
      # @param [String] src The value to clear bits of, or the only operand given.
      # @param [String, nil] op2 The bits to clear, or nil in the 2-operand form.
      # @return [void]
      def inst_bic(dst, src, op2 = nil)
        src, op2 = shorthand(dst, src, op2)
        data_op(DATA_OPS.fetch('and'), dst, src,
                OneGadget::Helper.hex(complement('bic', op2, dst, src, op2)), name: 'and')
      end

      # +mvn dst, op2+ is that complement on its own.
      # @param [String] dst The destination register.
      # @param [String] op2 The value to complement.
      # @return [void]
      def inst_mvn(dst, op2)
        check_register!(dst)

        registers[dst] = complement('mvn', op2, dst, op2)
      end

      # A memory barrier orders accesses without changing any value, so a path
      # crossing one carries on unchanged. The operand naming its scope (+dmb ish+)
      # says which accesses, not what they hold.
      alias inst_dmb inst_nop
      alias inst_dsb inst_nop
      alias inst_isb inst_nop

      # A +bl+/+blx+ call: record the terminal +exec*+ target, accept a known-safe
      # syscall wrapper, or +:fail+ to abort the candidate.
      def inst_bl(addr)
        return reach_terminal_call(addr) if terminal_call?(addr)

        dispatch_safe_call(addr)
      end

      # A byte load. The address is read like any other, so what the caller has to
      # arrange about it is recorded the same way -- but one byte of a word is not
      # a value this emulator can name, so the register holds what a call would
      # have left: a path that goes on to depend on it is abandoned rather than
      # described wrongly.
      def inst_ldrb(dst, src, index = 0)
        inst_ldr(dst, src, index)
        registers[dst] = clobbered_value
      end

      # +cbz+/+cbnz+ (compare-and-branch-on-zero): identical decoding in ARM and
      # AArch64. +ops+ is +[register, target-address-hex]+, as {#operands} splits it.
      # @param [Array<String>] ops The branch's operands.
      # @param [Boolean] negate +false+ for +cbz+, +true+ for +cbnz+.
      def handle_cbz(ops, negate:)
        branch_on_zero(ops[1].to_i(16), ops[0], negate:)
      end
    end
  end
end
