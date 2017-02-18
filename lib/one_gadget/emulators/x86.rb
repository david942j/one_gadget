require 'one_gadget/emulators/processor'
require 'one_gadget/emulators/instruction'

module OneGadget
  module Emulators
    # Super class for amd64 and i386 processor.
    class X86 < Processor
      # Constructor for a x86 processor.
      def initialize(*)
        super
        @stack = Hash.new do |h, k|
          lmda = OneGadget::Emulators::Lambda.new(self.class.stack_pointer)
          lmda.immi = k
          lmda.deref!
          h[k] = lmda
        end
      end

      # Process one command.
      # @param [String] cmd
      #   One line from result of objdump.
      # @return [void]
      def process(cmd)
        inst, args = parse(cmd)
        return if inst.inst == 'call' # later
        sym = "inst_#{inst.inst}".to_sym
        send(sym, *args)
      end

      # Support instruction set.
      # @return [Array<Instruction>] The support instructions.
      def instructions
        [
          Instruction.new('mov', 2),
          Instruction.new('lea', 2),
          Instruction.new('add', 2),
          Instruction.new('sub', 2),
          Instruction.new('push', 1),
          Instruction.new('call', 1)
        ]
      end

      class << self
        def bits; raise NotImplementedError
        end

        def stack_pointer; raise NotImplementedError
        end
      end

      private

      def inst_mov(tar, src)
        src = OneGadget::Emulators::Lambda.parse(src, predefined: @registers)
        @registers[tar] = src
      end

      def inst_lea(tar, src)
        src = OneGadget::Emulators::Lambda.parse(src, predefined: @registers)
        src.ref!
        @registers[tar] = src
      end

      def inst_push(val)
        val = OneGadget::Emulators::Lambda.parse(val, predefined: @registers)
        @registers[self.class.stack_pointer] -= bytes
        dict = {}
        dict[self.class.stack_pointer] = 0
        cur_top = @registers[self.class.stack_pointer].evaluate(dict)
        raise ArgumentError, "Corrupted stack pointer: #{cur_top}" unless cur_top.is_a?(Integer)
        @stack[cur_top] = val
      end

      def inst_add(tar, src)
        src = OneGadget::Emulators::Lambda.parse(src, predefined: @registers)
        @registers[tar] += src
      end

      def inst_sub(tar, src)
        src = OneGadget::Emulators::Lambda.parse(src, predefined: @registers)
        @registers[tar] -= src
      end

      def bytes
        self.class.bits / 8
      end
    end
  end
end
