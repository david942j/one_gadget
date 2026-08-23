# frozen_string_literal: true

require 'one_gadget/abi'
require 'one_gadget/emulators/arm_family'
require 'one_gadget/emulators/instruction'
require 'one_gadget/emulators/processor'

module OneGadget
  module Emulators
    # Emulator of aarch64.
    class AArch64 < ArmFamily
      # Instantiate a {AArch64} object.
      def initialize
        super(OneGadget::ABI.aarch64, 'sp')
        # Constant registers
        %w[xzr wzr].each { |r| @registers[r] = 0 }
        @pc = 'pc'
        setup_frame_pointer('x29') # track argv/data staged off the frame pointer
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
          Instruction.new('and', 3),
          Instruction.new('bic', 3),
          Instruction.new('bl', 1),
          Instruction.new('bti', 0..1),
          Instruction.new('dmb', 0..1),
          Instruction.new('dsb', 0..1),
          Instruction.new('eor', 3),
          Instruction.new('isb', 0..1),
          Instruction.new('ldr', 2..3),
          Instruction.new('ldrb', 2..3),
          Instruction.new('lsl', 3),
          Instruction.new('lsr', 3),
          Instruction.new('mov', 2),
          Instruction.new('mvn', 2),
          Instruction.new('nop', 0..1),
          Instruction.new('orr', 3),
          Instruction.new('stp', 3),
          Instruction.new('str', 2..3),
          Instruction.new('sub', 3..4)
        ]
      end

      # A landing pad marks where an indirect branch may arrive; nothing about the
      # state changes at one.
      alias inst_bti inst_nop

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
        when 'cbz' then handle_cbz(ops, negate: false)
        when 'cbnz' then handle_cbz(ops, negate: true)
        when 'tbz' then branch_on_bit(ops[2].to_i(16), ops[0], Integer(ops[1]), negate: false)
        when 'tbnz' then branch_on_bit(ops[2].to_i(16), ops[0], Integer(ops[1]), negate: true)
        else branch_on_compare(COND[mnem[2..]], ops[0].to_i(16))
        end
      end

      def inst_adrp(dst, imm)
        check_register!(dst)

        registers[dst] = libc_base + imm.to_i(16)
      end

      def inst_ldr(dst, src, index = 0)
        check_register!(dst)

        src = resolve_int_regs(src)
        val = read_value(arg_to_lambda(src))
        registers[dst] = val
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

        dst = resolve_int_regs(dst)
        dst_l = arg_to_lambda(dst).ref!
        track_write(dst_l, registers[reg1], registers[reg2])

        registers[sp] += arg_to_lambda(dst).immi if dst.end_with?('!')
      end

      def inst_str(src, dst, index = 0)
        check_register!(src)
        raise_unsupported('str', src, dst, index) unless OneGadget::Helper.integer?(index)

        dst = resolve_int_regs(dst)
        dst_l = arg_to_lambda(dst).ref!
        track_write(dst_l, registers[src])

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
