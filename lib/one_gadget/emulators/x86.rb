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
      # Will raise exceptions when encounter unhandled instruction.
      # @param [String] cmd
      #   One line from result of objdump.
      # @return [void]
      def process!(cmd)
        inst, args = parse(cmd)
        # return registers[pc] = args[0] if inst.inst == 'call'
        return true if inst.inst == 'jmp' # believe the fetcher has handled jmp.
        sym = "inst_#{inst.inst}".to_sym
        send(sym, *args) != :fail
      end

      # Process one command, without raising any exceptions.
      # @param [String] cmd
      #   See {#process!} for more information.
      # @return [void]
      def process(cmd)
        process!(cmd)
      rescue ArgumentError
        false
      end

      # Support instruction set.
      # @return [Array<Instruction>] The support instructions.
      def instructions
        [
          Instruction.new('add', 2),
          Instruction.new('call', 1),
          Instruction.new('jmp', 1),
          Instruction.new('lea', 2),
          Instruction.new('mov', 2),
          Instruction.new('nop', -1),
          Instruction.new('push', 1),
          Instruction.new('sub', 2),
          Instruction.new('xor', 2)
        ]
      end

      class << self
        # 32 or 64.
        # @return [Integer] 32 or 64.
        def bits; raise NotImplementedError
        end
      end

      def argument(_idx); raise NotImplementedError
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

      def inst_xor(dst, src)
        # only supports dst == src
        raise ArgumentError, 'xor operator only supports dst = src' unless dst == src
        dst[0] = 'r' if self.class.bits == 64 && dst.start_with?('e')
        registers[dst] = 0
      end

      def inst_add(tar, src)
        src = OneGadget::Emulators::Lambda.parse(src, predefined: registers)
        registers[tar] += src
      end

      def inst_sub(tar, src)
        src = OneGadget::Emulators::Lambda.parse(src, predefined: registers)
        raise ArgumentError, "Can't handle -= of type #{src.class}" unless src.is_a?(Integer)
        registers[tar] -= src
      end

      # yap, nop
      def inst_nop(*); end

      def check_argument(idx, expect)
        case expect
        when :global then argument(idx).to_s.include?(pc) # easy check
        when :zero? then argument(idx).is_a?(Integer) && argument(idx).zero?
        end
      end

      # Handle some valid calls.
      # For example, +sigprocmask+ will always be a valid call
      # because it just invokes syscall.
      def inst_call(addr)
        # This is the last call
        return registers[pc] = addr if %w[execve execl].any? { |n| addr.include?(n) }
        # TODO: handle some registers would be fucked after call
        checker = {
          'sigprocmask' => {},
          '__close' => {},
          'unsetenv' => { 0 => :global },
          '__sigaction' => { 1 => :global, 2 => :zero? }
        }
        func = checker.keys.find { |n| addr.include?(n) }
        return if func && checker[func].all? { |idx, sym| check_argument(idx, sym) }
        # unhandled case or checker's condition fails
        :fail
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
