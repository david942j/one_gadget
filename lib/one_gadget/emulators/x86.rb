# frozen_string_literal: true

require 'one_gadget/emulators/instruction'
require 'one_gadget/emulators/lambda'
require 'one_gadget/emulators/processor'
require 'one_gadget/error'

module OneGadget
  module Emulators
    # Super class for amd64 and i386 processor.
    class X86 < Processor
      # Constructor for a x86 processor.
      # @param [Array<String>] registers All the register names this architecture accepts.
      # @param [String] sp The stack pointer's name.
      # @param [String] bp The frame pointer's name.
      # @param [String] pc The program counter's name.
      def initialize(registers, sp, bp, pc)
        super(registers, sp)
        @pc = pc
        setup_frame_pointer(bp)
      end

      # Process one command.
      # Will raise exceptions when encounter unhandled instruction.
      # @param [String] cmd
      #   One line from result of objdump.
      # @return [Boolean]
      #   If successfully processed.
      def process!(cmd)
        cmd = concretize_rip(cmd)
        resolve_pending_branch(cmd)
        mnem = mnemonic(cmd)
        return handle_compare(COMPARES[mnem], cmd) if COMPARES.key?(mnem)
        return handle_branch(mnem, cmd) != :fail if branch_mnem?(mnem)

        inst, args = parse(cmd)
        __send__(inst.handler, *args) != :fail
      end

      # x86 conditional-jump mnemonics mapped to shared {Conditional::RELATION}
      # predicates (x86's adapter table, as {AArch64::COND} is for arm/aarch64).
      JCC = {
        'je' => :eq, 'jz' => :eq, 'jne' => :ne, 'jnz' => :ne,
        'jb' => :ult, 'jc' => :ult, 'jnae' => :ult, 'jae' => :uge, 'jnb' => :uge, 'jnc' => :uge,
        'ja' => :ugt, 'jnbe' => :ugt, 'jbe' => :ule, 'jna' => :ule,
        'jl' => :slt, 'jnge' => :slt, 'jge' => :sge, 'jnl' => :sge,
        'jg' => :sgt, 'jnle' => :sgt, 'jle' => :sle, 'jng' => :sle,
        'js' => :slt, 'jns' => :sge
      }.freeze

      # x86 flag-setting compare mnemonics mapped to the ALU op whose result their
      # flags reflect (see {Conditional::COMPARE_OPS}). +test+ is a bitwise AND, +cmp+
      # a subtraction.
      COMPARES = { 'cmp' => :sub, 'test' => :and }.freeze

      # A segment-prefixed operand reads thread-local storage, which isn't modelled
      # (the other arches reach it by instructions that are unsupported anyway).
      # Every gadget observed behind one tests +errno == ENOEXEC+, which the caller
      # would have had to arrange before entering, so modelling it would produce
      # gadgets that all but never apply. Worth revisiting for a libc found
      # reaching a terminal call under a condition that commonly holds.
      # @example +cmp DWORD PTR fs:[r14], 0x8+ -- errno == ENOEXEC
      SEGMENT_OPERAND = /\b(?:fs|gs|ds|es|ss|cs):/

      # Supported instruction set.
      # @return [Array<Instruction>] The supported instructions.
      def instructions
        [
          Instruction.new('add', 2),
          Instruction.new('and', 2),
          Instruction.new('call', 1),
          Instruction.new('endbr32', -1),
          Instruction.new('endbr64', -1),
          Instruction.new('jmp', 1),
          Instruction.new('lea', 2),
          Instruction.new('mov', 2),
          Instruction.new('movsxd', 2),
          Instruction.new('nop', -1),
          Instruction.new('push', 1),
          Instruction.new('sub', 2),
          Instruction.new('xchg', 2),
          Instruction.new('xor', 2),
          Instruction.new('movq', 2),
          Instruction.new('movaps', 2),
          Instruction.new('movhps', 2),
          Instruction.new('punpcklqdq', 2)
        ]
      end

      private

      # Whether a whole register's worth of value is what this operand names.
      def swappable?(operand)
        register?(operand) && !OneGadget::ABI::NARROW_VIEWS.fetch(arch_name, {}).key?(operand)
      end

      def branch_mnem?(mnem)
        mnem == 'jmp' || JCC.key?(mnem) || %w[jcxz jecxz jrcxz].include?(mnem)
      end

      # Operands of +cmd+ (mnemonic dropped), size hints removed, each stripped of
      # a trailing +<symbol>+.
      def operands(cmd)
        raise Error::UnsupportedInstructionArgumentError, cmd if SEGMENT_OPERAND.match?(cmd)

        cmd.sub(/\A[0-9a-f]+:\s*\S+\s*/, '').split(',').map do |o|
          o.gsub(/\b(XMMWORD|QWORD|DWORD|WORD|BYTE|PTR)\b/, '').strip.sub(/\s*<.*>\z/, '')
        end
      end

      # Arch-specific hook to rewrite a line's operands before it is processed. A
      # no-op here; amd64 overrides it to resolve rip-relative operands (i386 has
      # no rip-relative addressing, so it keeps the no-op). See {Amd64#concretize_rip}.
      def concretize_rip(cmd) = cmd

      # The (direct) target address of a jump line.
      def jump_target(cmd)
        cmd[/\A[0-9a-f]+:\s*\S+\s+([0-9a-f]+)/, 1].to_i(16)
      end

      def handle_branch(mnem, cmd)
        return true if mnem == 'jmp' # unconditional: control handled by the stitched path
        return branch_on_zero(jump_target(cmd), cx_reg(mnem), negate: false) if mnem.end_with?('cxz')

        branch_on_compare(JCC[mnem], jump_target(cmd))
      end

      # The counter register a +jcxz+-family branch tests, at the width its
      # mnemonic names.
      def cx_reg(mnem)
        { 'jcxz' => 'cx', 'jecxz' => 'ecx', 'jrcxz' => 'rcx' }[mnem]
      end

      def inst_mov(dst, src)
        src = arg_to_lambda(src)
        if register?(dst)
          registers[dst] = read_value(src)
          return
        end
        dst = arg_to_lambda(dst)
        # dup: add_writable ref!s its argument, and dst is reused below.
        add_writable(dst.dup.ref!)
        # resolve_address takes the address the store writes to, i.e. the operand
        # with the store's own dereference peeled off.
        stack, offset = resolve_address(dst.ref!)
        stack&.store(offset, src)
      end

      # +movsxd dst, src+: +src+'s low 32 bits, sign-extended into the 64-bit +dst+.
      # A destination that isn't a register would be a store the emulator doesn't
      # model, so the candidate is abandoned rather than tracked wrongly.
      def inst_movsxd(dst, src)
        check_register!(dst)

        registers[dst] = sign_extend32(read_value(arg_to_lambda(src)))
      end

      # What a 32-bit +val+ sign-extends to. Only a concrete value can be extended;
      # a symbolic one is taken whole, since no expression names its low half --
      # the same over-approximation a narrow register read makes (see
      # {RegisterFile#narrowed}).
      # @example
      #   sign_extend32(0x1)        #=> 0x1
      #   sign_extend32(0xffffffff) #=> -0x1
      def sign_extend32(val)
        return val unless val.is_a?(Integer)

        low = val & 0xffffffff
        low < 0x80000000 ? low : low - 0x100000000
      end

      # This instruction moves 128bits.
      def inst_movaps(dst, src)
        # XXX: here we only support `movaps [sp+*], xmm*`
        src, dst = check_xmm_sp(src, dst) { raise_unsupported('movaps', dst, src) }
        raise_unsupported('movaps', dst, src) unless src.is_a?(Array)

        off = dst.evaluate(eval_dict)
        @constraints << [:raw, "#{sp} & 0xf == #{OneGadget::Helper.hex(0x10 - off & 0xf)}"]
        (128 / self.class.bits).times do |i|
          sp_based_stack[off + i * size_t] = src[i]
        end
      end

      # Move src to dst[:64]
      # Supported forms:
      #   movq xmm*, [sp+*]
      #   movq xmm*, reg64
      def inst_movq(dst, src)
        if self.class.bits == 64 && xmm_reg?(dst) && src.start_with?('r') && register?(src)
          dst = arg_to_lambda(dst)
          src = arg_to_lambda(src)
          raise_unsupported('movq', dst, src) unless dst.is_a?(Array)

          dst[0] = src
          return
        end
        dst, src = check_xmm_sp(dst, src) { raise_unsupported('movq', dst, src) }
        raise_unsupported('movq', dst, src) unless dst.is_a?(Array)

        off = src.evaluate(eval_dict)
        (64 / self.class.bits).times do |i|
          dst[i] = sp_based_stack[off + i * size_t]
        end
      end

      # Move src to dst[64:128]
      def inst_movhps(dst, src)
        # XXX: here we only support `movhps xmm*, [sp+*]`
        dst, src = check_xmm_sp(dst, src) { raise_unsupported('movhps', dst, src) }
        raise_unsupported('movhps', dst, src) unless dst.is_a?(Array)

        off = src.evaluate(eval_dict)
        (64 / self.class.bits).times do |i|
          dst[i + 64 / self.class.bits] = sp_based_stack[off + i * size_t]
        end
      end

      # check whether (dst, src) is in form (xmm*, [sp+*])
      def check_xmm_sp(dst, src)
        return yield unless xmm_reg?(dst) && src.include?(sp)

        dst_lm = arg_to_lambda(dst)
        src_lm = arg_to_lambda(src)
        return yield if src_lm.deref_count != 1

        src_lm.ref!
        [dst_lm, src_lm]
      end

      def xmm_reg?(reg)
        reg.start_with?('xmm') && register?(reg)
      end

      # dst[64:128] = src[0:64]
      def inst_punpcklqdq(dst, src)
        raise_unsupported('punpcklqdq', dst, src) unless xmm_reg?(dst) && xmm_reg?(src)

        dst = arg_to_lambda(dst)
        src = arg_to_lambda(src)
        raise_unsupported('punpcklqdq', dst, src) unless dst.is_a?(Array) && src.is_a?(Array)

        (64 / self.class.bits).times do |i|
          dst[i + 64 / self.class.bits] = src[i]
        end
      end

      def inst_lea(dst, src)
        check_register!(dst)

        registers[dst] = arg_to_lambda(src).ref!
      end

      def inst_push(val)
        val = arg_to_lambda(val)
        registers[sp] -= size_t
        cur_top = registers[sp].evaluate(eval_dict)
        raise Error::InstructionArgumentError, "Corrupted stack pointer: #{cur_top}" unless cur_top.is_a?(Integer)

        sp_based_stack[cur_top] = val
      end

      def inst_xor(dst, src)
        check_register!(dst)

        # only supports dst == src
        raise Error::UnsupportedInstructionArgumentError, 'xor operator only supports dst = src' unless dst == src

        registers[dst] = 0
      end

      # A {Lambda} knows how to add a number to itself, not the other way round,
      # and addition commutes -- adding an unknown value to a known one is the
      # same unknown value shifted (see {DataProcessing#offset_result}, which
      # states the same rule for the architectures that go through it).
      def inst_add(dst, src)
        check_register!(dst)

        lhs = registers[dst]
        rhs = read_value(arg_to_lambda(src))
        lhs, rhs = rhs, lhs if lhs.is_a?(Integer)
        registers[dst] = lhs + rhs
      end

      # +and dst, src+ both writes +dst+ and sets the flags a following branch
      # reads, so it does both: model the result, then record the compare the
      # +test+ of the same operands would have (see {Conditional::COMPARE_OPS}).
      # Modelling only the flags would leave +dst+ holding a value the gadget has
      # already replaced.
      def inst_and(dst, src)
        check_register!(dst)

        src = read_value(arg_to_lambda(src))
        result = mask_result(registers[dst], src)
        record_compare(:and, value_str(registers[dst]), value_str(src))
        registers[dst] = result
      end

      # +lhs & rhs+, or an abort when the result is nothing this emulator can name.
      # @param [Lambda, Integer] lhs The value being masked.
      # @param [Lambda, Integer] rhs The mask.
      # @return [Lambda, Integer] The masked value.
      def mask_result(lhs, rhs)
        operation_result(:&, lhs, rhs) || raise_unsupported('and', lhs, rhs)
      end

      def inst_sub(dst, src)
        check_register!(dst)
        src = arg_to_lambda(src)
        raise Error::UnsupportedInstructionArgumentError, "Unhandled -= of type #{src.class}" unless src.is_a?(Integer)

        registers[dst] -= src
      end

      # A marker for the branch predictor: it says a jump may land here and leaves
      # every value alone.
      def inst_endbr64(*); end
      alias inst_endbr32 inst_endbr64

      # Swap what two registers hold. Naming one place twice is nothing at all,
      # whatever it names -- the multi-byte nop a compiler pads with.
      # @raise [OneGadget::Error::UnsupportedInstructionArgumentError]
      #   For a memory operand, which is an exchange with memory and an atomic one,
      #   or a narrower view, which names part of a register where swapping whole
      #   values cannot reach.
      # @example (amd64) A swap, then the padding.
      #   inst_xchg('rbx', 'rdi') #=> [rdi, rbx]
      #   inst_xchg('rax', 'rax') #=> nil
      def inst_xchg(dst, src)
        return if dst == src
        raise Error::UnsupportedInstructionArgumentError, "xchg #{dst},#{src}" unless
          swappable?(dst) && swappable?(src)

        registers[dst], registers[src] = registers[src], registers[dst]
      end

      # TODO: handle some registers would be fucked after call
      def inst_call(addr)
        return reach_terminal_call(addr) if terminal_call?(addr)

        dispatch_safe_call(addr)
      end

      # A vector register holds one value per lane, so it becomes an array of
      # them -- each lane named by the shift that reaches it -- where an ordinary
      # register becomes a single {Lambda}.
      def to_lambda(reg)
        return super unless reg =~ /^xmm\d+$/

        Array.new(128 / self.class.bits) do |i|
          cast = "(u#{self.class.bits})"
          OneGadget::Emulators::Lambda.new(i.zero? ? "#{cast}#{reg}" : "#{cast}(#{reg} >> #{self.class.bits * i})")
        end
      end
    end
  end
end
