# frozen_string_literal: true

require 'one_gadget/emulators/lambda'

module OneGadget
  module Emulators
    # What an instruction leaves in a register: the architecture-independent half of
    # an +inst_*+ handler. A result that stays an offset from a known base keeps that
    # form, so the rest of the emulator can resolve it against tracked memory; one
    # that does not is named as the operation it is, since a caller deriving a value
    # that way still has to arrange its operands. Anything neither of those aborts
    # the candidate rather than being recorded as a value it is not. Mixed into
    # {Processor}.
    module DataProcessing
      private

      # The value +op+ produces from +lhs+ and +rhs+: folded when both are
      # concrete, and otherwise named as the operation itself, since no
      # base+offset expresses it (see {Lambda.operation}). +nil+ when it is
      # neither -- an operation on something this emulator cannot name, which the
      # caller reports against its own mnemonic.
      # @param [Symbol] op A Ruby operator that doubles as how the operation renders.
      # @param [Lambda, Integer] lhs The value operated on.
      # @param [Lambda, Integer] rhs The value it is operated on with.
      # @return [Lambda, Integer, nil] The result, or nil when it is not one this
      #   emulator can name.
      # @example (amd64) +and rax, 0xf+ with rax unknown leaves +(rax & 0xf)+
      #   operation_result(:&, registers['rax'], 0xf)
      def operation_result(op, lhs, rhs)
        return lhs.send(op, rhs) if lhs.is_a?(Integer) && rhs.is_a?(Integer)
        return nil unless lhs.is_a?(OneGadget::Emulators::Lambda)

        # Exclusive-or of a value with itself is zero whether or not the value is
        # known -- how every arch spells "zero this register".
        return 0 if op == :^ && lhs.to_s == rhs.to_s

        OneGadget::Emulators::Lambda.operation(lhs, op.to_s, rhs)
      end

      # Add or subtract, and store the result.
      # @example An offset from a known base stays one, which the rest of the
      #   emulator resolves against tracked memory; a sum of two unknowns is named
      #   as the operation it is, so a pointer derived that way still says what the
      #   caller has to arrange.
      #   arith(:+, 'rax', 'rsp', '0x10') ; registers['rax'] #=> rsp+0x10
      #   arith(:+, 'rax', 'rdi', 'rsi')  ; registers['rax'] #=> (rdi + rsi)
      # @param [Symbol] op +:++ or +:-+.
      # @param [String] dst The destination register.
      # @param [String] src The value added to, or the only operand given.
      # @param [String, nil] op2 The value to add, or nil in the 2-operand form.
      # @return [void]
      # @raise [OneGadget::Error::UnsupportedInstructionArgumentError]
      #   When the result is not one this emulator can name.
      def arith(op, dst, src, op2)
        check_register!(dst)
        src, op2 = shorthand(dst, src, op2)
        lhs = value_of(src)
        rhs = value_of(op2)

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

      # Apply a data-processing instruction and store its result. An arch that
      # allows the 2-operand shorthand may pass +src+ as the only operand.
      # @param [Symbol] op A Ruby operator that doubles as how the operation renders.
      # @param [String] dst The destination register.
      # @param [String] src The left operand, or the only one given (see {#shorthand}).
      # @param [String, nil] op2 The right operand, or nil in the 2-operand form.
      # @param [String] name The mnemonic, named in an abort.
      # @return [void]
      # @raise [OneGadget::Error::UnsupportedInstructionArgumentError]
      #   When the result is nothing this emulator can name.
      def data_op(op, dst, src, op2, name:)
        check_register!(dst)
        src, op2 = shorthand(dst, src, op2)
        result = operation_result(op, value_of(src), value_of(op2))
        raise_unsupported(name, dst, src, op2) if result.nil?

        # A shift can push bits past the register width, which the arbitrary-
        # precision fold above would otherwise keep.
        registers[dst] = result.is_a?(Integer) ? result & width_mask : result
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
