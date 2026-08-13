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
      # shared {Conditional::RELATION} predicate. Decodes the opaque mnemonics once:
      # +hs+/+cs+ and +lo+/+cc+ are aliases; +mi+/+pl+ (sign bit) act as signed
      # +</+>=+. +vs+/+vc+ (overflow) have no constraint form and are absent, so a
      # branch on them maps to +nil+ and aborts the path. (x86 uses {X86::JCC}.)
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

      # +add+/+sub+, shared by both families. Each allows the 2-operand shorthand,
      # and each may carry a modifier on +op2+ -- a shift, or (aarch64) a
      # sign-extension of its low half.
      # @param [String] dst The destination register.
      # @param [String] src The value added to, or the only operand given.
      # @param [String, nil] op2 The value to add, or nil in the 2-operand form.
      # @param [String, nil] mode A modifier applied to +op2+ (see {#modified_operand}).
      # @return [void]
      def inst_add(dst, src, op2 = nil, mode = nil) = arith(:+, dst, src, op2, mode)

      # +sub dst, src, op2+. See {#inst_add} for the operands.
      # @return [void]
      def inst_sub(dst, src, op2 = nil, mode = nil) = arith(:-, dst, src, op2, mode)

      # Add or subtract, and store the result.
      #
      # A sum of two values neither of which is known folds into no base+offset,
      # so it is named as the operation it is -- a candidate deriving a pointer
      # that way still says what the caller has to arrange. That is the only
      # fallback: an offset from a known base stays a base+offset, which the rest
      # of the emulator can resolve against tracked memory.
      # @param [Symbol] op +:++ or +:-+.
      # @return [void]
      # @raise [OneGadget::Error::UnsupportedInstructionArgumentError]
      #   When the modifier, or the result, is not one this emulator can name.
      def arith(op, dst, src, op2, mode)
        check_register!(dst)
        src, op2 = shorthand(dst, src, op2)
        lhs = value_of(src)
        rhs = modified_operand(value_of(op2), mode) { raise_unsupported(op, dst, src, op2, mode) }

        result = offset_result(op, lhs, rhs)
        # The stack pointer has to stay an offset from itself: every tracked
        # stack slot is keyed on it, and a candidate that reads one back after
        # allocating a variable-size frame would be answered from the wrong
        # place. Such a frame also puts the array a gadget builds at an address
        # only a register the caller supplies decides, which no constraint this
        # emulator emits states.
        result ||= operation_result(op, lhs, rhs) unless dst == sp
        raise_unsupported(op, dst, src, op2) if result.nil?

        registers[dst] = result
      end

      # +lhs op rhs+ when the result is an offset from +lhs+'s base, which
      # {Lambda} expresses directly. +nil+ when it is not, leaving the caller to
      # name the operation instead.
      # @return [Lambda, Integer, nil]
      def offset_result(op, lhs, rhs)
        return lhs.send(op, rhs) if rhs.is_a?(Integer)
        # Adding a known offset to an unknown value is the same value shifted;
        # subtracting from one is not, so only addition commutes here.
        return rhs + lhs if op == :+ && lhs.is_a?(Integer)

        nil
      end

      # +value+ with an operand modifier applied. +nil+ +mode+ is the bare
      # operand. Yields, rather than returning, for a modifier this emulator does
      # not model, so an unmodelled one aborts instead of being silently dropped.
      # @example (aarch64) +add x0, x1, w2, sxtw+ -- +mode+ is +"sxtw"+
      # @example (arm) +add r0, r1, r2, lsl 3+ -- +mode+ is +"lsl 3"+
      # @return [Lambda, Integer]
      def modified_operand(value, mode)
        return value if mode.nil? || mode == 'sxtw' # a sign-extension we take whole

        shifted = shifted_operand(value_str(value), mode)
        return yield if shifted.nil?

        Integer(shifted)
      end

      # Apply a data-processing instruction and store its result. Both families
      # allow the 2-operand shorthand, so +src+ may be the only operand given.
      # @param [String] name The mnemonic, and the {DATA_OPS} key naming its operator.
      # @param [String] dst The destination register.
      # @param [String] src The left operand, or the only one given (see {#shorthand}).
      # @param [String, nil] op2 The right operand, or nil in the 2-operand form.
      # @return [void]
      # @raise [OneGadget::Error::UnsupportedInstructionArgumentError]
      #   When the result is nothing this emulator can name.
      def data_op(name, dst, src, op2)
        check_register!(dst)
        src, op2 = shorthand(dst, src, op2)
        result = operation_result(DATA_OPS.fetch(name), value_of(src), value_of(op2))
        raise_unsupported(name, dst, src, op2) if result.nil?

        # A shift can push bits past the register width, which the arbitrary-
        # precision fold above would otherwise keep.
        registers[dst] = result.is_a?(Integer) ? result & width_mask : result
      end

      # Each {DATA_OPS} mnemonic handled the one way, since they differ only in the
      # operator applied (see {#data_op} for the operands).
      %w[and orr eor lsl lsr].each do |name|
        define_method(:"inst_#{name}") { |dst, src, op2 = nil| data_op(name, dst, src, op2) }
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
        data_op('and', dst, src, OneGadget::Helper.hex(complement('bic', op2, dst, src, op2)))
      end

      # +mvn dst, op2+ is that complement on its own.
      # @param [String] dst The destination register.
      # @param [String] op2 The value to complement.
      # @return [void]
      def inst_mvn(dst, op2)
        check_register!(dst)

        registers[dst] = complement('mvn', op2, dst, op2)
      end

      # +op2+ with every bit flipped. Only a concrete value has a complement this
      # emulator can name; a symbolic one aborts rather than being recorded as a
      # mask it isn't.
      # @param [String] name The mnemonic to report an abort against.
      # @param [String] op2 The operand to complement.
      # @param [Array<String>] reported The operands to name in that abort.
      # @return [Integer] +op2+ complemented, within the register width.
      def complement(name, op2, *reported)
        value = value_of(op2)
        raise_unsupported(name, *reported) unless value.is_a?(Integer)

        ~value & width_mask
      end

      # Every bit of a register, for masking a result back to its width.
      # @return [Integer]
      def width_mask = (1 << self.class.bits) - 1

      # The value of an operand. {Arm} overrides it for +pc+, whose value depends
      # on the address of the instruction reading it.
      # @param [String] arg The operand, as written.
      # @return [OneGadget::Emulators::Lambda, Integer] Its current value.
      def value_of(arg) = arg_to_lambda(arg)

      # Expand a 2-operand data-processing form into its (src, op2) operands:
      # +add dst, op2+ is shorthand for +add dst, dst, op2+, while an explicit
      # 3-operand form is passed through unchanged.
      # @param [String] dst The destination register, which the 2-operand form
      #   also reads as its left operand.
      # @param [String] src The left operand, or the right one in the 2-operand form.
      # @param [String, nil] op2 The right operand, or nil in the 2-operand form.
      # @return [(String, String)] The left and right operands.
      # @example
      #   shorthand('r0', 'r4', nil) # 2-operand: add r0, r4
      #   #=> ['r0', 'r4']
      #   shorthand('r0', 'r4', '8') # 3-operand: add r0, r4, 8
      #   #=> ['r4', '8']
      def shorthand(dst, src, op2)
        op2.nil? ? [dst, src] : [src, op2]
      end

      # An instruction with no effect this emulator models anything of.
      # @return [void]
      def inst_nop(*); end

      # A +bl+/+blx+ call: record the terminal +exec*+ target, accept a known-safe
      # syscall wrapper, or +:fail+ to abort the candidate.
      def inst_bl(addr)
        return reach_terminal_call(addr) if terminal_call?(addr)

        dispatch_safe_call(addr)
      end

      # Track a store: write +values+ (one per word from +dst_l+) into the stack
      # {#resolve_address} resolves +dst_l+ to, and require +dst_l+
      # writable -- unless it is a pure +sp+ store. +sp+ is invariantly the
      # writable stack; the frame pointer only conventionally is, so a store
      # through it stays a real precondition (like amd64's +writable: rbp+imm+).
      # Shared by +str+ (one value) and +stp+ (two).
      # @param [OneGadget::Emulators::Lambda] dst_l The destination, zero-deref.
      # @param [Array<OneGadget::Emulators::Lambda, Integer>] values One per word.
      # @return [void]
      def track_write(dst_l, *values)
        stack, offset = resolve_address(dst_l)
        values.each_with_index { |v, i| stack[offset + size_t * i] = v } if stack
        add_writable(dst_l) unless stack.equal?(sp_based_stack)
      end

      # +cbz+/+cbnz+ (compare-and-branch-on-zero): identical decoding in ARM and
      # AArch64. +ops+ is +[register, target-address-hex]+, as {#operands} splits it.
      # @param [Array<String>] ops The branch's operands.
      # @param [Boolean] negate +false+ for +cbz+, +true+ for +cbnz+.
      def handle_cbz(ops, negate:)
        branch_on_zero(ops[1].to_i(16), ops[0], negate:)
      end

      # Replace register tokens that currently hold a concrete integer with that
      # integer, so a register-indexed memory operand becomes an offset one the
      # Lambda parser handles.
      # @example
      #   # with the index register currently holding 0xd8
      #   resolve_int_regs('[r8, r2]')  #=> '[r8, 0xd8]'
      #   resolve_int_regs('[x8, x2]')  #=> '[x8, 0xd8]'
      def resolve_int_regs(str)
        str.gsub(/[a-z]+\d*/) do |tok|
          v = registers[tok] if register?(tok)
          v.is_a?(Integer) ? OneGadget::Helper.hex(v) : tok
        end
      end
    end
  end
end
