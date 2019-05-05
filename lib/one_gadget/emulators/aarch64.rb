# frozen_string_literal: true

require 'one_gadget/abi'
require 'one_gadget/emulators/instruction'
require 'one_gadget/emulators/processor'

module OneGadget
  module Emulators
    # Emulator of aarch64.
    class AArch64 < Processor
      # Instantiate a {AArch64} object.
      def initialize
        super(OneGadget::ABI.aarch64, 'sp')
        # Constant registers
        %w[xzr wzr].each { |r| @registers[r] = 0 }
        @pc = 'pc'
      end

      # @see OneGadget::Emulators::X86#process!
      def process!(cmd)
        inst, args = parse(cmd.gsub(/#-?(0x)?[0-9a-f]+/) { |v| v[1..-1] })
        sym = "inst_#{inst.inst}".to_sym
        __send__(sym, *args) != :fail
      end

      # Supported instruction set.
      # @return [Array<Instruction>] The supported instructions.
      def instructions
        [
          Instruction.new('add', 3..4),
          Instruction.new('adrp', 2),
          Instruction.new('bl', 1),
          Instruction.new('ldr', 2..3),
          Instruction.new('mov', 2),
          Instruction.new('stp', 3),
          Instruction.new('str', 2..3)
        ]
      end

      # Return the argument value of calling a function.
      # @param [Integer] idx
      # @return [Lambda, Integer]
      def argument(idx)
        registers["x#{idx}"]
      end

      private

      def inst_add(dst, src, op2, mode = 'sxtw')
        check_register!(dst)

        src = OneGadget::Emulators::Lambda.parse(src, predefined: registers)
        op2 = OneGadget::Emulators::Lambda.parse(op2, predefined: registers)
        raise_unsupported('add', dst, src, op2) unless op2.is_a?(Integer) && mode == 'sxtw'

        registers[dst] = src + op2
      end

      def inst_adrp(dst, imm)
        check_register!(dst)

        registers[dst] = libc_base + imm.to_i(16)
      end

      # Handle some valid calls.
      # For example, +sigprocmask+ will always be a valid call
      # because it just invokes syscall.
      def inst_bl(addr)
        # This is the last call
        return registers[pc] = addr if %w[execve execl].any? { |n| addr.include?(n) }

        # TODO: handle some registers would be fucked after call
        checker = {
          'sigprocmask' => {},
          '__sigaction' => { 2 => :zero? }
        }
        func = checker.keys.find { |n| addr.include?(n) }
        return if func && checker[func].all? { |idx, sym| check_argument(idx, sym) }

        # unhandled case or checker's condition fails
        :fail
      end

      def inst_ldr(dst, src, index = 0)
        check_register!(dst)

        src_l = OneGadget::Emulators::Lambda.parse(src, predefined: registers)
        registers[dst] = src_l
        raise_unsupported('ldr', dst, src, index) unless OneGadget::Helper.integer?(index)

        index = Integer(index)
        return unless src.end_with?('!') || index.nonzero?

        # Two cases:
        # 1. pre-index mode, +src+ is [reg, imm]!
        # 2. post-index mode, +src+ is [reg]
        lmda = OneGadget::Emulators::Lambda.parse(src)
        registers[lmda.obj] += lmda.immi + index
      end

      def inst_mov(dst, src)
        check_register!(dst)

        src = OneGadget::Emulators::Lambda.parse(src, predefined: registers)
        registers[dst] = src
      end

      def inst_stp(reg1, reg2, dst)
        raise_unsupported('stp', reg1, reg2, dst) unless reg64?(reg1) && reg64?(reg2)

        dst_l = OneGadget::Emulators::Lambda.parse(dst, predefined: registers).ref!
        raise_unsupported('stp', reg1, reg2, dst) unless dst_l.obj == sp && dst_l.deref_count.zero?

        cur_top = dst_l.evaluate(eval_dict)
        stack[cur_top] = registers[reg1]
        stack[cur_top + size_t] = registers[reg2]

        registers[sp] += OneGadget::Emulators::Lambda.parse(dst).immi if dst.end_with?('!')
      end

      def inst_str(src, dst, index = 0)
        check_register!(src)
        raise_unsupported('str', src, dst, index) unless OneGadget::Helper.integer?(index)

        dst_l = OneGadget::Emulators::Lambda.parse(dst, predefined: registers).ref!
        # Only stores on stack.
        if dst_l.obj == sp && dst_l.deref_count.zero?
          cur_top = dst_l.evaluate(eval_dict)
          stack[cur_top] = registers[src]
        else
          # Unlike the stack case, don't know where to save the value.
          # Simply add a constraint.
          add_writable(dst_l)
        end

        index = Integer(index)
        return unless dst.end_with?('!') || index.nonzero?

        # Two cases:
        # 1. pre-index mode, +dst+ is [reg, imm]!
        # 2. post-index mode, +dst+ is [reg]
        lmda = OneGadget::Emulators::Lambda.parse(dst)
        registers[lmda.obj] += lmda.immi + index
      end

      def libc_base
        @libc_base ||= OneGadget::Emulators::Lambda.new('$base')
      end

      # Checks if +reg+ is a 64-bit register.
      def reg64?(reg)
        register?(reg) && reg.start_with?('x')
      end

      def add_writable(lmda)
        # XXX: Better way is check LOAD segment of the libc ELF.
        # XXX: Should also checks deref_count, but sometimes [[$base+xx]] is also writable..
        return if lmda.obj == libc_base.obj

        @constraints << [:writable, lmda]
      end

      class << self
        # AArch64 is 64-bit.
        def bits
          64
        end
      end
    end
  end
end
