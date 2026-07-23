# frozen_string_literal: true

require 'one_gadget/abi'
require 'one_gadget/emulators/arm_family'
require 'one_gadget/emulators/instruction'
require 'one_gadget/emulators/processor'

module OneGadget
  module Emulators
    # Emulator of aarch64.
    class AArch64 < Processor
      include ArmFamily

      # Instantiate a {AArch64} object.
      def initialize
        super(OneGadget::ABI.aarch64, 'sp')
        # Constant registers
        %w[xzr wzr].each { |r| @registers[r] = 0 }
        @pc = 'pc'
      end

      # @see OneGadget::Emulators::X86#process!
      def process!(cmd)
        resolve_pending_branch(cmd)
        cmd = cmd.gsub(/#-?(0x)?[0-9a-f]+/) { |v| v[1..] }
        mnem = mnemonic(cmd)
        return handle_compare(COMPARES[mnem], cmd) if COMPARES.key?(mnem)
        return handle_branch(mnem, cmd) != :fail if branch_mnem?(mnem)

        inst, args = parse(cmd)
        sym = :"inst_#{inst.inst}"
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
      # @param [Integer] idx The 0-based index of the argument.
      # @return [Lambda, Integer] The value held in register +x<idx>+, used for the +idx+-th argument.
      def argument(idx)
        registers["x#{idx}"]
      end

      private

      def branch_mnem?(mnem)
        mnem == 'b' || mnem.start_with?('b.') || %w[cbz cbnz tbz tbnz].include?(mnem)
      end

      # Operands of +cmd+ (mnemonic dropped), each stripped of a trailing +<symbol>+.
      def operands(cmd)
        cmd.sub(/\A[0-9a-f]+:\s*\S+\s*/, '').split(',').map { |o| o.strip.sub(/\s*<.*>\z/, '') }
      end

      def handle_branch(mnem, cmd)
        ops = operands(cmd)
        case mnem
        when 'b', 'b.al' then true # unconditional: control handled by the stitched path
        when 'cbz' then queue_cbz(ops[1].to_i(16), operand_str(ops[0]), negate: false)
        when 'cbnz' then queue_cbz(ops[1].to_i(16), operand_str(ops[0]), negate: true)
        when 'tbz' then queue_tbz(ops[2].to_i(16), operand_str(ops[0]), Integer(ops[1]), negate: false)
        when 'tbnz' then queue_tbz(ops[2].to_i(16), operand_str(ops[0]), Integer(ops[1]), negate: true)
        else queue_cond_branch(COND[mnem[2..]], ops[0].to_i(16))
        end
      end

      def inst_add(dst, src, op2, mode = 'sxtw')
        check_register!(dst)

        src = arg_to_lambda(src)
        op2 = arg_to_lambda(op2)
        raise_unsupported('add', dst, src, op2) unless op2.is_a?(Integer) && mode == 'sxtw'

        registers[dst] = src + op2
      end

      def inst_adrp(dst, imm)
        check_register!(dst)

        registers[dst] = libc_base + imm.to_i(16)
      end

      def inst_ldr(dst, src, index = 0)
        check_register!(dst)

        src_l = arg_to_lambda(src)
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

        registers[dst] = arg_to_lambda(src)
      end

      def inst_stp(reg1, reg2, dst)
        raise_unsupported('stp', reg1, reg2, dst) unless reg64?(reg1) && reg64?(reg2)

        dst_l = arg_to_lambda(dst).ref!
        if dst_l.obj == sp && dst_l.deref_count.zero?
          cur_top = dst_l.evaluate(eval_dict)
          sp_based_stack[cur_top] = registers[reg1]
          sp_based_stack[cur_top + size_t] = registers[reg2]
        else
          # Don't know where it points; just require it be writable (as inst_str does).
          add_writable(dst_l)
        end

        registers[sp] += arg_to_lambda(dst).immi if dst.end_with?('!')
      end

      def inst_str(src, dst, index = 0)
        check_register!(src)
        raise_unsupported('str', src, dst, index) unless OneGadget::Helper.integer?(index)

        dst_l = arg_to_lambda(dst).ref!
        # Only stores on stack.
        if dst_l.obj == sp && dst_l.deref_count.zero?
          cur_top = dst_l.evaluate(eval_dict)
          sp_based_stack[cur_top] = registers[src]
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

      # Checks if +reg+ is a 64-bit register.
      def reg64?(reg)
        register?(reg) && reg.start_with?('x')
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
