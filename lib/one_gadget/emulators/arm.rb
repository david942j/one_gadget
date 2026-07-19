# frozen_string_literal: true

require 'one_gadget/abi'
require 'one_gadget/emulators/instruction'
require 'one_gadget/emulators/lambda'
require 'one_gadget/emulators/processor'
require 'one_gadget/helper'

module OneGadget
  module Emulators
    # Emulator of 32-bit ARM (both A32 and Thumb-2 encodings).
    class Arm < Processor
      # Instantiate an {Arm} object.
      # @param [String, nil] file
      #   Path to the target libc. Used to read words from the literal pool when
      #   resolving PC-relative +ldr+ loads. May be +nil+ in unit tests that don't
      #   exercise literal loads.
      def initialize(file = nil)
        super(OneGadget::ABI.arm, 'sp')
        @pc = 'pc'
        @data = file && File.binread(file)
        @prev_addr = nil
        # A32 until proven Thumb by a +.w+/+.n+ suffix or a 2-byte instruction stride.
        @thumb = false
      end

      # @see OneGadget::Emulators::AArch64#process!
      def process!(cmd)
        line = cmd.strip
        track_mode(line)
        body, @literal = split_line(line)
        body = normalize(body)
        # push/pop take a {reg-list} whose commas would confuse the generic parser.
        mnem, rest = body.split(/\s+/, 2)
        return __send__(:"inst_#{mnem}", rest) != :fail if %w[push pop].include?(mnem)

        inst, args = parse(body)
        __send__(:"inst_#{inst.inst}", *args) != :fail
      end

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

      # @param [String, Lambda] obj A lambda object or its string.
      # @return [Hash{Integer => Lambda}, nil]
      #   The sp-based stack that +obj+ uses, or +nil+ if +obj+ is not sp-relative.
      def get_corresponding_stack(obj)
        return nil unless obj.to_s.include?(sp)

        sp_based_stack
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
      # prefixes ARM immediates. Other conditional/flag variants (e.g. +moveq+) are
      # left intact so they fall through to "unsupported".
      # @example
      #   normalize('movs r0, #0')
      #   #=> 'mov r0, 0'
      #   normalize('add.w r0, r4, #8')
      #   #=> 'add r0, r4, 8'
      def normalize(body)
        mnem, rest = body.split(/\s+/, 2)
        mnem = mnem.sub(/\.(w|n)\z/, '')
        mnem = { 'movs' => 'mov', 'adds' => 'add', 'subs' => 'sub' }.fetch(mnem, mnem)
        [mnem, rest].compact.join(' ').gsub(/#(-?(?:0x)?[0-9a-f]+)/i, '\1')
      end

      # The value of +pc+ when used as an operand: +$base + (addr + bias)+,
      # bias +4+ in Thumb and +8+ in A32.
      def pc_value
        libc_base + @cur_addr + (@thumb ? 4 : 8)
      end

      def libc_base
        @libc_base ||= OneGadget::Emulators::Lambda.new('$base')
      end

      def inst_mov(dst, src)
        check_register!(dst)

        registers[dst] = value_of(src)
      end

      # 2-operand form (+add dst, op2+) is shorthand for +add dst, dst, op2+.
      def inst_add(dst, src, op2 = nil)
        check_register!(dst)
        src, op2 = shorthand(dst, src, op2)

        registers[dst] = combine(value_of(src), value_of(op2))
      end

      def inst_sub(dst, src, op2 = nil)
        check_register!(dst)
        src, op2 = shorthand(dst, src, op2)

        op2 = value_of(op2)
        raise_unsupported('sub', dst, src, op2) unless op2.is_a?(Integer)

        registers[dst] = combine(value_of(src), -op2)
      end

      def inst_ldr(dst, src, index = 0)
        check_register!(dst)
        raise_unsupported('ldr', dst, src, index) unless OneGadget::Helper.integer?(index)

        registers[dst] = src.include?(pc) ? literal_value : arg_to_lambda(resolve_int_regs(src))

        index = Integer(index)
        return unless src.end_with?('!') || index.nonzero?

        # pre-index ([reg, imm]!) or post-index ([reg], imm) write-back.
        lmda = OneGadget::Emulators::Lambda.parse(resolve_int_regs(src.delete('!')))
        registers[lmda.obj] += lmda.immi + index
      end

      def inst_str(src, dst, index = 0)
        check_register!(src)
        raise_unsupported('str', src, dst, index) unless OneGadget::Helper.integer?(index)

        dst_l = arg_to_lambda(resolve_int_regs(dst)).ref!
        if dst_l.obj == sp && dst_l.deref_count.zero?
          sp_based_stack[dst_l.evaluate(eval_dict)] = registers[src]
        else
          add_writable(dst_l)
        end

        index = Integer(index)
        return unless dst.end_with?('!') || index.nonzero?

        lmda = OneGadget::Emulators::Lambda.parse(resolve_int_regs(dst.delete('!')))
        registers[lmda.obj] += lmda.immi + index
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

      def inst_bl(addr)
        return registers[pc] = addr if %w[execve execl posix_spawn].any? { |n| addr.include?(n) }

        # Calls that are always safe because they merely wrap a syscall.
        checker = {
          'sigprocmask' => {},
          '__sigaction' => { 2 => :zero? }
        }
        func = checker.keys.find { |n| addr.include?(n) }
        return if func && checker[func].all? { |idx, sym| check_argument(idx, sym) }

        :fail
      end
      alias inst_blx inst_bl

      # Flag-only / no-effect instructions: keep emulating without changing state.
      def inst_nop(*); end
      alias inst_cmp inst_nop
      alias inst_cmn inst_nop
      alias inst_tst inst_nop
      alias inst_svc inst_nop

      # Read the little-endian word the current PC-relative +ldr+ points at.
      def literal_value
        raise_unsupported('ldr', 'pc') if @literal.nil? || @data.nil?

        @data[@literal, size_t].unpack1('V')
      end

      # Resolve an operand to its current value, modelling +pc+ symbolically.
      def value_of(arg)
        return pc_value if arg == pc

        arg_to_lambda(arg)
      end

      # Add two operand values, keeping any {Lambda} on the left of the sum.
      def combine(a, b)
        a.is_a?(Integer) ? b + a : a + b
      end

      # Expand a 2-operand data-processing form into its (src, op2) operands:
      # +add dst, op2+ is shorthand for +add dst, dst, op2+, while an explicit
      # 3-operand form is passed through unchanged.
      # @example
      #   shorthand('r0', 'r4', nil) # 2-operand: add r0, r4
      #   #=> ['r0', 'r4']
      #   shorthand('r0', 'r4', '8') # 3-operand: add r0, r4, 8
      #   #=> ['r4', '8']
      def shorthand(dst, src, op2)
        op2.nil? ? [dst, src] : [src, op2]
      end

      # Parse an ARM register-list operand (as written by +push+/+pop+/+ldm+/+stm+)
      # into the individual register names.
      # @example
      #   reglist('{r4, r5, lr}')
      #   #=> ['r4', 'r5', 'lr']
      def reglist(list)
        list.tr('{}', '').split(',').map(&:strip)
      end

      # Replace register tokens that currently hold a concrete integer with that
      # integer, so memory operands like +[r8, r2]+ (r2 == 0xd8) become +[r8, 0xd8]+.
      # @example
      #   # with r2 currently holding 0xd8
      #   resolve_int_regs('[r8, r2]')
      #   #=> '[r8, 0xd8]'
      def resolve_int_regs(str)
        str.gsub(/[a-z]+\d*/) do |tok|
          v = registers[tok] if register?(tok)
          v.is_a?(Integer) ? OneGadget::Helper.hex(v) : tok
        end
      end

      def add_writable(lmda)
        return if lmda.obj == libc_base.obj

        @constraints << [:writable, lmda]
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
