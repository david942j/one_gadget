# frozen_string_literal: true

require 'one_gadget/abi'
require 'one_gadget/emulators/arm_family'
require 'one_gadget/emulators/instruction'
require 'one_gadget/emulators/lambda'
require 'one_gadget/emulators/processor'
require 'one_gadget/helper'

module OneGadget
  module Emulators
    # Emulator of 32-bit ARM (both A32 and Thumb-2 encodings).
    class Arm < ArmFamily
      # Instantiate an {Arm} object.
      # @param [String, nil] file
      #   Path to the target libc. Used to read words from the literal pool when
      #   resolving PC-relative +ldr+ loads. May be +nil+ in unit tests that don't
      #   exercise literal loads.
      def initialize(file = nil)
        super(OneGadget::ABI.arm, 'sp')
        @pc = 'pc'
        # find() builds a fresh emulator per candidate; cache the file's bytes so
        # the literal pool isn't re-read from disk thousands of times.
        @data = file && self.class.file_data(file)
        @prev_addr = nil
        # A32 until proven Thumb by a +.w+/+.n+ suffix or a 2-byte instruction stride.
        @thumb = false
      end

      # Memoized bytes of +file+ (the target libc), shared across emulator instances.
      def self.file_data(file)
        (@file_data ||= {})[file] ||= File.binread(file)
      end

      # @see OneGadget::Emulators::AArch64#process!
      def process!(cmd)
        resolve_pending_branch(cmd)
        line = cmd.strip
        track_mode(line)
        body, @literal = split_line(line)
        body = normalize(body)
        mnem, rest = body.split(/\s+/, 2)
        return handle_compare(COMPARES[mnem], rest) if COMPARES.key?(mnem)
        return handle_branch(mnem, rest) != :fail if branch_mnem?(mnem)
        # push/pop take a {reg-list} whose commas would confuse the generic parser.
        return __send__(:"inst_#{mnem}", rest) != :fail if %w[push pop].include?(mnem)

        inst, args = parse(body)
        __send__(:"inst_#{inst.inst}", *args) != :fail
      end

      # The flag-setting spelling of an instruction we model, which differs from
      # the base mnemonic only by a trailing +s+ (+movs+, +ands+, ...). The flags
      # it sets are not modelled, so a branch reading them aborts the path anyway;
      # what matters here is the value it also writes. Conditional variants
      # (+moveq+, +addne+, ...) are deliberately absent and stay unsupported.
      FLAG_SETTING = /\A(mov|add|sub|and|orr|eor|bic|mvn|lsl|lsr)s\z/

      # Supported instruction set. Any instruction not listed here aborts the
      # current gadget candidate (mirrors the conservative aarch64 emulator).
      # @return [Array<Instruction>] The supported instructions.
      def instructions
        [
          Instruction.new('push', 1),
          Instruction.new('pop', 1),
          Instruction.new('add', 2..3),
          Instruction.new('sub', 2..3),
          Instruction.new('mov', 2),
          Instruction.new('ldr', 2..3),
          Instruction.new('str', 2..3),
          Instruction.new('bl', 1),
          Instruction.new('blx', 1),
          Instruction.new('nop', 0..1),
          Instruction.new('and', 2..3),
          Instruction.new('orr', 2..3),
          Instruction.new('eor', 2..3),
          Instruction.new('bic', 2..3),
          Instruction.new('mvn', 2),
          Instruction.new('lsl', 2..3),
          Instruction.new('lsr', 2..3),
          Instruction.new('cmp', 2..3),
          Instruction.new('cmn', 2..3),
          Instruction.new('tst', 2..3),
          Instruction.new('svc', 1)
        ]
      end

      # Return the argument value of calling a function.
      # @param [Integer] idx The 0-based index of the argument.
      # @return [Lambda, Integer]
      #   AAPCS passes the first four arguments in +r0+-+r3+; any further
      #   arguments are on the stack at +[sp]+, +[sp+4]+, ... (needed for
      #   6-argument calls such as +posix_spawn+).
      def argument(idx)
        return registers["r#{idx}"] if idx < 4

        sp_based_stack[(idx - 4) * size_t]
      end

      # Settle Thumb vs A32 from a whole candidate, before any of it is emulated.
      # {#track_mode} can only learn from lines already seen, so the FIRST
      # instruction is judged on no evidence at all -- and when that instruction
      # reads +pc+, the bias it picks decides an address the constraints go on to
      # name. Applying the same evidence up front removes that dependence on
      # whatever happened to be processed first.
      #
      # A32 is left alone: it shows neither a width suffix nor a 2-byte stride, so
      # a genuinely A32 candidate keeps the whole-word bias. A single-instruction
      # Thumb candidate offers no evidence either and is no better served than
      # before.
      # @param [Array<String>] lines The candidate's objdump lines.
      def note_instruction_set(lines)
        return if @thumb

        addrs = lines.filter_map { |l| l[/\A\s*([0-9a-f]+):/, 1]&.to_i(16) }
        @thumb = lines.any? { |l| l.match?(/\.[wn]\b/) } ||
                 addrs.each_cons(2).any? { |a, b| b - a == 2 }
      end

      private

      # Update {@thumb}/{@cur_addr} from the leading +ADDR:+ of an objdump line.
      # A 2-byte stride proves Thumb; A32 keeps the whole-word stride.
      def track_mode(line)
        @thumb = true if line.match?(/\.[wn]\b/) # Thumb-2 wide/narrow suffix
        @cur_addr = line[/\A([0-9a-f]+):/, 1]&.to_i(16)
        return if @cur_addr.nil?

        @thumb = true if @prev_addr && (@cur_addr - @prev_addr) == 2
        @prev_addr = @cur_addr
      end

      # Split an objdump line into its instruction body and the literal-pool address
      # embedded in the trailing +@+ comment (used by PC-relative +ldr+).
      # @return [(String, Integer?)] The instruction body, and the literal address (or +nil+).
      # @example
      #   split_line('2c626: ldr r2, [pc, #128] @ (2c6a8 <x>)')
      #   #=> ['ldr r2, [pc, #128]', 0x2c6a8]
      def split_line(line)
        body = line.sub(/\A[0-9a-f]+:\s*/, '')
        literal = body[/@\s*\(?([0-9a-f]+)\s/, 1]&.to_i(16)
        # Strip a trailing comment. The marker is whitespace-prefixed, which avoids
        # eating the +@@+ inside symbol names such as +<execve@@GLIBC_2.4>+.
        [body.sub(/\s+[@;].*\z/, '').strip, literal]
      end

      # Rewrite one instruction into the plain form the generic parser expects:
      # drop the +.w+/+.n+ width suffix, map the flag-setting aliases we support
      # (+movs+/+adds+/+subs+) back to their base mnemonic, and strip the +#+ that
      # prefixes ARM immediates. Other conditional/flag variants (+moveq+, +addne+, ...) are
      # left intact so they fall through to "unsupported".
      # @example
      #   normalize('movs r0, #0')
      #   #=> 'mov r0, 0'
      #   normalize('add.w r0, r4, #8')
      #   #=> 'add r0, r4, 8'
      def normalize(body)
        mnem, rest = body.split(/\s+/, 2)
        mnem = mnem.sub(/\.(w|n)\z/, '')
        mnem = mnem.sub(FLAG_SETTING, '\\1')
        [mnem, rest].compact.join(' ').gsub(/#(-?(?:0x)?[0-9a-f]+)/i, '\1')
      end

      # The value of +pc+ when used as an operand: +$base + (addr + bias)+,
      # bias +4+ in Thumb and +8+ in A32.
      def pc_value
        libc_base + @cur_addr + (@thumb ? 4 : 8)
      end

      def inst_mov(dst, src)
        check_register!(dst)

        registers[dst] = value_of(src)
      end

      def inst_ldr(dst, src, index = 0)
        check_register!(dst)
        raise_unsupported('ldr', dst, src, index) unless OneGadget::Helper.integer?(index)

        val = src.include?(pc) ? literal_value : read_value(arg_to_lambda(resolve_int_regs(src)))
        registers[dst] = val

        index = Integer(index)
        return unless src.end_with?('!') || index.nonzero?

        # pre-index ([reg, imm]!) or post-index ([reg], imm) write-back.
        writeback(src, index)
      end

      def inst_str(src, dst, index = 0)
        check_register!(src)
        raise_unsupported('str', src, dst, index) unless OneGadget::Helper.integer?(index)

        dst_l = arg_to_lambda(resolve_int_regs(dst)).ref!
        track_write(dst_l, registers[src])

        index = Integer(index)
        return unless dst.end_with?('!') || index.nonzero?

        writeback(dst, index)
      end

      # Pre-/post-index write-back of a +[reg, imm]+ memory operand to +reg+.
      def writeback(mem, index)
        lmda = OneGadget::Emulators::Lambda.parse(resolve_int_regs(mem.delete('!')))
        registers[lmda.obj] += lmda.immi + index if register?(lmda.obj)
      end

      # push {r4, r5, lr}: registers are stored with the lowest-numbered at the
      # lowest address; sp ends decremented by 4 * count.
      def inst_push(list)
        regs = reglist(list)
        registers[sp] -= size_t * regs.size
        base = registers[sp].evaluate(eval_dict)
        regs.each_with_index { |r, i| sp_based_stack[base + size_t * i] = registers[r] }
      end

      # pop {r4, r5, pc}: inverse of push. A pop into pc/lr does not affect the
      # constraint search, so only sp and the popped GPRs are updated.
      def inst_pop(list)
        regs = reglist(list)
        base = registers[sp].evaluate(eval_dict)
        regs.each_with_index { |r, i| registers[r] = sp_based_stack[base + size_t * i] if register?(r) }
        registers[sp] += size_t * regs.size
      end

      # +blx+ (interworking call) is modelled exactly like +bl+ (see {ArmFamily#inst_bl}).
      alias inst_blx inst_bl

      # Flag-only / no-effect instructions: keep emulating without changing state.
      # A raw syscall: not modelled, but it does not touch anything the emulator
      # tracks either, so the candidate continues (see {ArmFamily#inst_nop}).
      alias inst_svc inst_nop

      def branch_mnem?(mnem)
        return true if mnem == 'b' || %w[cbz cbnz].include?(mnem)

        # +vs+/+vc+ aren't in COND but are still branches (they just abort the path).
        mnem.start_with?('b') && (COND.key?(mnem[1..]) || %w[vs vc].include?(mnem[1..]))
      end

      def operands(rest)
        rest.to_s.split(',').map { |o| o.strip.sub(/\s*<.*>\z/, '') }
      end

      def handle_branch(mnem, rest)
        ops = operands(rest)
        case mnem
        when 'b' then true # unconditional: control handled by the stitched path
        when 'cbz' then handle_cbz(ops, negate: false)
        when 'cbnz' then handle_cbz(ops, negate: true)
        else branch_on_compare(COND[mnem[1..]], ops[0].to_i(16))
        end
      end

      # Read the little-endian word the current PC-relative +ldr+ points at.
      def literal_value
        raise_unsupported('ldr', 'pc') if @literal.nil? || @data.nil?

        @data[@literal, size_t].unpack1('V')
      end

      # Resolve an operand to its current value, modelling +pc+ symbolically.
      # +pc+ reads as its own address plus the pipeline bias; everything else is
      # an ordinary operand (see {ArmFamily#value_of}).
      # @param [String] arg The operand, as written.
      # @return [OneGadget::Emulators::Lambda, Integer] Its current value.
      def value_of(arg)
        return pc_value if arg == pc

        super
      end

      # Parse an ARM register-list operand (as written by +push+/+pop+/+ldm+/+stm+)
      # into the individual register names.
      # @example
      #   reglist('{r4, r5, lr}')
      #   #=> ['r4', 'r5', 'lr']
      def reglist(list)
        list.tr('{}', '').split(',').map(&:strip)
      end

      class << self
        # ARM (32-bit) is 32-bit.
        def bits
          32
        end
      end
    end
  end
end
