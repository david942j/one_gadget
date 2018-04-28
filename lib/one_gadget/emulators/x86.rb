require 'one_gadget/emulators/instruction'
require 'one_gadget/emulators/lambda'
require 'one_gadget/emulators/processor'
require 'one_gadget/error'

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
          h[k] = OneGadget::Emulators::Lambda.new(sp).tap do |lmda|
            lmda.immi = k
            lmda.deref!
          end
        end
      end

      # Process one command.
      # Will raise exceptions when encounter unhandled instruction.
      # @param [String] cmd
      #   One line from result of objdump.
      # @return [Boolean]
      def process!(cmd)
        inst, args = parse(cmd)
        # return registers[pc] = args[0] if inst.inst == 'call'
        return true if inst.inst == 'jmp' # believe the fetcher has handled jmp.
        sym = "inst_#{inst.inst}".to_sym
        __send__(sym, *args) != :fail
      end

      # Process one command, without raising any exceptions.
      # @param [String] cmd
      #   See {#process!} for more information.
      # @return [Boolean]
      def process(cmd)
        process!(cmd)
      rescue ArgumentError, OneGadget::Error::Error
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
          Instruction.new('xor', 2),
          Instruction.new('movq', 2),
          Instruction.new('movaps', 2),
          Instruction.new('movhps', 2)
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
          return if tar.deref_count != 1 # should not happen
          tar.ref!
          stack[tar.evaluate(eval_dict)] = src
        end
      end

      # This instruction moves 128bits.
      def inst_movaps(tar, src)
        # XXX: here we only support `movaps [sp+*], xmm*`
        # TODO: This need an extra constraint: sp & 0xf == 0
        src, tar = check_xmm_sp(src, tar) { raise_unsupported('movaps', tar, src) }
        off = tar.evaluate(eval_dict)
        (128 / self.class.bits).times do |i|
          stack[off + i * size_t] = src[i]
        end
      end

      # Mov *src to tar[:64]
      def inst_movq(tar, src)
        # XXX: here we only support `movq xmm*, [sp+*]`
        tar, src = check_xmm_sp(tar, src) { raise_unsupported('movq', tar, src) }
        off = src.evaluate(eval_dict)
        (64 / self.class.bits).times do |i|
          tar[i] = stack[off + i * size_t]
        end
      end

      # Move *src to tar[64:128]
      def inst_movhps(tar, src)
        # XXX: here we only support `movhps xmm*, [sp+*]`
        tar, src = check_xmm_sp(tar, src) { raise_unsupported('movhps', tar, src) }
        off = src.evaluate(eval_dict)
        (64 / self.class.bits).times do |i|
          tar[i + 64 / self.class.bits] = stack[off + i * size_t]
        end
      end

      # check if (tar, src) in form (xmm*, [sp+*])
      def check_xmm_sp(tar, src)
        return yield unless tar.start_with?('xmm') && register?(tar) && src.include?(sp)
        tar_lm = OneGadget::Emulators::Lambda.parse(tar, predefined: registers)
        src_lm = OneGadget::Emulators::Lambda.parse(src, predefined: registers)
        return yield if src_lm.deref_count != 1
        src_lm.ref!
        [tar_lm, src_lm]
      end

      def inst_lea(tar, src)
        src = OneGadget::Emulators::Lambda.parse(src, predefined: registers)
        src.ref!
        registers[tar] = src
      end

      def inst_push(val)
        val = OneGadget::Emulators::Lambda.parse(val, predefined: registers)
        registers[sp] -= size_t
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

      def size_t
        self.class.bits / 8
      end

      def eval_dict
        { sp => 0 }
      end

      def raise_unsupported(inst, *args)
        raise OneGadget::Error::UnsupportedInstructionArguments, "#{inst} #{args.join(', ')}"
      end

      def to_lambda(reg)
        return super unless reg =~ /^xmm\d+$/
        Array.new(128 / self.class.bits) do |i|
          OneGadget::Emulators::Lambda.new("#{reg}__#{i}")
        end
      end
    end
  end
end
