require 'one_gadget/emulators/processor'
require 'one_gadget/emulators/instruction'

module OneGadget
  module Emulators
    # Emulator of amd64 instruction set.
    class Amd64 < Processor
      REGISTERS = %w(rax rbx rcx rdx rdi rsi rbp rsp rip) + 7.upto(15).map { |i| "r#{i}" }
      def initialize
        super(REGISTERS)
      end

      def process(cmd)
        inst, args = parse(cmd)
        # where should this be defined..?
        return if inst.inst == 'call' # later
        case inst.inst
        when 'mov', 'lea'
          tar = args[0]
          src = OneGadget::Emulators::Lambda.parse(args[1], predefined: @registers)
        end
        src.ref! if inst.inst == 'lea'

        @registers[tar] = src
      end

      def instructions
        [
          Instruction.new('mov', 2),
          Instruction.new('lea', 2),
          Instruction.new('call', 1)
        ]
      end
    end
  end
end
