require 'one_gadget/abi'
require 'one_gadget/emulators/instruction'
require 'one_gadget/emulators/processor'

module OneGadget
  module Emulators
    # Emulator of aarch64.
    class AArch64 < Processor
      attr_reader :pc # @return [String] Program counter.

      # Instantiate a {AArch64} object.
      def initialize
        super(OneGadget::ABI.aarch64, 'sp')
        # Constant registers
        %w[xzr wzr].each { |r| @registers[r] = 0 }
        @pc = 'pc'
      end

      # @see {OneGadget::Emulators::X86#process!}
      def process!(cmd)
        inst, args = parse(cmd.gsub(/#-?(0x)?[0-9a-f]+/) { |v| v[1..-1] })
        sym = "inst_#{inst.inst}".to_sym
        __send__(sym, *args) != :fail
      end

      # Supported instruction set.
      # @return [Array<Instruction>] The supported instructions.
      def instructions
        [
          Instruction.new('add', 3),
          Instruction.new('adrp', 2),
          Instruction.new('bl', 1),
          Instruction.new('ldr', 2),
          Instruction.new('mov', 2),
          Instruction.new('stp', 3),
          Instruction.new('str', 2)
        ]
      end

      # Return the argument value of calling a function.
      # @param [Integer] idx
      # @return [Lambda, Integer]
      def argument(idx)
        registers["x#{idx}"]
      end

      private

      def inst_add(dst, src, op2)
        src = OneGadget::Emulators::Lambda.parse(src, predefined: registers)
        op2 = OneGadget::Emulators::Lambda.parse(op2, predefined: registers)
        registers[dst] = src + op2
      end

      def inst_adrp(dst, imm)
        registers[dst] = libc_base + imm.to_i(16)
      end

      def inst_bl(target)
        registers[pc] = target
      end

      def inst_ldr(dst, src)
        src = OneGadget::Emulators::Lambda.parse(src, predefined: registers)
        registers[dst] = src
      end

      def inst_mov(dst, src)
        src = OneGadget::Emulators::Lambda.parse(src, predefined: registers)
        registers[dst] = src
      end

      def inst_stp(reg1, reg2, dst); end

      def inst_str(src, dst); end

      def libc_base
        @libc_base ||= OneGadget::Emulators::Lambda.new('$base')
      end
    end
  end
end
