require 'one_gadget/emulators/processor'
require 'one_gadget/emulators/instruction'

module OneGadget
  module Emulators
    # Super class for amd64 and i386 processor.
    class X86 < Processor
      attr_reader :sp # @return [String] Stack pointer.
      attr_reader :pc # @return [String] Program counter.
      # Constructor for a x86 processor.
      def initialize(registers, sp, pc)
        super(registers)
        @sp = sp
        @pc = pc
        @stack = Hash.new do |h, k|
          lmda = OneGadget::Emulators::Lambda.new(sp)
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
        return registers[pc] = args[0] if inst.inst == 'call'
        return if inst.inst == 'jmp' # believe the fetcher has handled jmp.
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
          Instruction.new('call', 1),
          Instruction.new('jmp', 1)
        ]
      end

      class << self
        # 32 or 64.
        # @return [Integer] 32 or 64.
        def bits; raise NotImplementedError
        end
      end

      private

      def register?(reg)
        registers.include?(reg)
      end

      def inst_mov(tar, src)
        src = OneGadget::Emulators::Lambda.parse(src, predefined: registers)
        if register?(tar)
          registers[tar] = src
        else
          # Just ignore strange case...
          return unless tar.include?(sp)
          tar = OneGadget::Emulators::Lambda.parse(tar, predefined: registers)
          return if tar.deref_count != 1 # should not happened
          tar.ref!
          stack[tar.evaluate(eval_dict)] = src
        end
      end

      def inst_lea(tar, src)
        src = OneGadget::Emulators::Lambda.parse(src, predefined: registers)
        src.ref!
        registers[tar] = src
      end

      def inst_push(val)
        val = OneGadget::Emulators::Lambda.parse(val, predefined: registers)
        registers[sp] -= bytes
        cur_top = registers[sp].evaluate(eval_dict)
        raise ArgumentError, "Corrupted stack pointer: #{cur_top}" unless cur_top.is_a?(Integer)
        stack[cur_top] = val
      end

      def inst_add(tar, src)
        src = OneGadget::Emulators::Lambda.parse(src, predefined: registers)
        registers[tar] += src
      end

      def inst_sub(tar, src)
        src = OneGadget::Emulators::Lambda.parse(src, predefined: registers)
        registers[tar] -= src
      end

      def bytes
        self.class.bits / 8
      end

      def eval_dict
        dict = {}
        dict[sp] = 0
        dict
      end
    end
  end
end
