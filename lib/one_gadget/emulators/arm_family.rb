# frozen_string_literal: true

require 'one_gadget/emulators/lambda'
require 'one_gadget/emulators/processor'

module OneGadget
  module Emulators
    # Behaviour shared by the two ARM-architecture emulators, {Arm} (AArch32) and
    # {AArch64}: the condition-code table plus the parts of the calling convention
    # and memory model that are identical in 32- and 64-bit mode. The common base
    # each inherits (the ARM counterpart of {X86}); everything that genuinely
    # differs (instruction set, register width, +pc+ handling) stays in the
    # individual classes.
    class ArmFamily < Processor
      # ARM condition-code suffix (the +<cc>+ in +b<cc>+ / +b.<cc>+) mapped to a
      # shared {Conditional::RELATION} predicate. Decodes the opaque mnemonics once:
      # +hs+/+cs+ and +lo+/+cc+ are aliases; +mi+/+pl+ (sign bit) act as signed
      # +</+>=+. +vs+/+vc+ (overflow) have no constraint form and are absent, so a
      # branch on them maps to +nil+ and aborts the path. (x86 uses {X86::JCC}.)
      COND = {
        'eq' => :eq, 'ne' => :ne,
        'hs' => :uge, 'cs' => :uge, 'lo' => :ult, 'cc' => :ult,
        'hi' => :ugt, 'ls' => :ule,
        'ge' => :sge, 'lt' => :slt, 'gt' => :sgt, 'le' => :sle,
        'mi' => :slt, 'pl' => :sge
      }.freeze

      # This arch family's flag-setting compare mnemonics, mapped to the ALU op
      # whose result their flags reflect (see {Conditional::COMPARE_OPS}). x86 has
      # its own {X86::COMPARES}.
      COMPARES = { 'cmp' => :sub, 'cmn' => :add, 'tst' => :and }.freeze

      private

      # A compare whose second operand may carry a shift modifier, e.g.
      # +cmn x0, 0x1, lsl 12+ (the immediate is 0x1000, not 0x1). Fold a constant
      # shift into the operand; abort on any modifier not modelled, since dropping
      # it would silently understate the constraint.
      # @return [Boolean] false aborts the candidate.
      def handle_compare(op, cmd)
        ops = operands(cmd)
        return false if ops.size > 3

        rhs = operand_str(ops[1])
        if ops.size == 3
          rhs = shifted_operand(rhs, ops[2])
          return false if rhs.nil?
        end
        record_compare(op, operand_str(ops[0]), rhs)
      end

      # Apply a constant shift modifier to an already-rendered operand.
      # @return [String, nil] nil when the shift isn't a constant amount applied to
      #   a known integer, which the caller treats as unmodelled.
      # @example
      #   shifted_operand('0x1', 'lsl 12') #=> '0x1000'
      def shifted_operand(rhs, modifier)
        m = modifier.match(/\A(lsl|lsr|asr)\s+(\d+)\z/)
        return nil unless m && OneGadget::Helper.integer?(rhs)

        value = Integer(rhs)
        OneGadget::Helper.hex(m[1] == 'lsl' ? value << Integer(m[2]) : value >> Integer(m[2]))
      end

      # A +bl+/+blx+ call: record the terminal +exec*+ target, accept a known-safe
      # syscall wrapper, or +:fail+ to abort the candidate.
      def inst_bl(addr)
        return reach_terminal_call(addr) if terminal_call?(addr)

        dispatch_safe_call(addr)
      end

      # Track a store: write +values+ (one per word from +dst_l+) into the stack
      # {#get_corresponding_stack} resolves +dst_l+ to, and require +dst_l+
      # writable -- unless it is a pure +sp+ store. +sp+ is invariantly the
      # writable stack; the frame pointer only conventionally is, so a store
      # through it stays a real precondition (like amd64's +writable: rbp+imm+).
      # Shared by +str+ (one value) and +stp+ (two).
      # @param [OneGadget::Emulators::Lambda] dst_l The destination, zero-deref.
      # @param [Array<OneGadget::Emulators::Lambda, Integer>] values One per word.
      # @return [void]
      def track_write(dst_l, *values)
        stack = dst_l.deref_count.zero? ? get_corresponding_stack(dst_l.obj) : nil
        values.each_with_index { |v, i| stack[dst_l.immi + size_t * i] = v } if stack
        add_writable(dst_l) unless stack.equal?(sp_based_stack)
      end

      # +cbz+/+cbnz+ (compare-and-branch-on-zero): identical decoding in ARM and
      # AArch64. +ops+ is +[register, target-address-hex]+, as {#operands} splits it.
      # @param [Array<String>] ops The branch's operands.
      # @param [Boolean] negate +false+ for +cbz+, +true+ for +cbnz+.
      def handle_cbz(ops, negate:)
        branch_on_zero(ops[1].to_i(16), ops[0], negate:)
      end

      # Replace register tokens that currently hold a concrete integer with that
      # integer, so a register-indexed memory operand becomes an offset one the
      # Lambda parser handles.
      # @example
      #   # with the index register currently holding 0xd8
      #   resolve_int_regs('[r8, r2]')  #=> '[r8, 0xd8]'
      #   resolve_int_regs('[x8, x2]')  #=> '[x8, 0xd8]'
      def resolve_int_regs(str)
        str.gsub(/[a-z]+\d*/) do |tok|
          v = registers[tok] if register?(tok)
          v.is_a?(Integer) ? OneGadget::Helper.hex(v) : tok
        end
      end
    end
  end
end
