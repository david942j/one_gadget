# frozen_string_literal: true

require 'one_gadget/emulators/lambda'
require 'one_gadget/emulators/safe_calls'

module OneGadget
  module Emulators
    # Behaviour shared by the two ARM-architecture emulators, {Arm} (AArch32) and
    # {AArch64}: the condition-code table plus the parts of the calling convention
    # and memory model that are identical in 32- and 64-bit mode. Included into
    # each; everything that genuinely differs (instruction set, register width,
    # +pc+ handling) stays in the individual classes.
    module ArmFamily
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

      # Frame-pointer register whose relative stores are tracked, or +nil+ when this
      # arch tracks none. Enabled via {#setup_frame_pointer} (mirrors x86's +bp+).
      attr_reader :bp

      # @return [Hash{Integer => Lambda}, nil] Stack content based on {#bp}, or nil.
      attr_reader :bp_based_stack

      # Enable frame-pointer stack tracking with +bp+ as the frame register (so a
      # gadget that stages data at +[bp+imm]+ -- e.g. an argv array off +x29+ -- is
      # recovered instead of collapsing to a bare +writable:+). Nil disables it,
      # leaving the arch +sp+-only. Call from the arch initializer after +super+.
      def setup_frame_pointer(bp)
        @bp = bp
        return if bp.nil?

        @bp_based_stack = Hash.new do |h, k|
          h[k] = OneGadget::Emulators::Lambda.new(bp).tap do |lmda|
            lmda.immi = k
            lmda.deref!
          end
        end
      end

      # The stack that +obj+ addresses -- +sp+-based, {#bp}-based, or a
      # per-register write history (see {Processor#reg_based_stack}) for any
      # other register the candidate has written through.
      # @param [String, Lambda] obj A lambda object or its string.
      # @return [Hash{Integer => Lambda}, nil]
      # @example
      #   get_corresponding_stack('sp+0x10') #=> sp_based_stack
      #   get_corresponding_stack('x29+0x40') #=> bp_based_stack (aarch64)
      #   get_corresponding_stack('x21') #=> nil, or a write history if x21 was written through
      def get_corresponding_stack(obj)
        # A compound base (a nested Lambda, e.g. the address is itself "[reg]+imm"
        # -- one more indirection than a simple register+offset) isn't something
        # any of sp/bp/reg_based_stack model correctly: their imm is always "an
        # offset from a *named register*", not "an offset from a dereferenced
        # value". Matching it via a substring check on its rendered form (e.g.
        # "[rbp-0x78]" contains "rbp") would silently mistrack it as bp-relative.
        return nil if obj.is_a?(OneGadget::Emulators::Lambda)

        s = obj.to_s
        return sp_based_stack if s.include?(sp)
        return bp_based_stack if bp && s.include?(bp)

        reg_based_stack(s)
      end

      # Resolve +sp+- and (when tracked) {#bp}-relative operands to their offset;
      # the base {Processor#eval_dict} covers only +sp+ (cf. x86).
      def eval_dict
        bp ? { sp => 0, bp => 0 } : { sp => 0 }
      end

      # The ARM emulators accept exactly {SafeCalls::COMMON} -- no arch-specific
      # syscall wrappers beyond the shared set. See {Processor#dispatch_safe_call}.
      SAFE_CALLS = SafeCalls::COMMON

      private

      # A +bl+/+blx+ call: record the terminal +exec*+ target, accept a known-safe
      # syscall wrapper, or +:fail+ to abort the candidate.
      def inst_bl(addr)
        return reach_terminal_call(addr) if terminal_call?(addr)

        dispatch_safe_call(addr, SAFE_CALLS)
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
        branch_on_zero(ops[1].to_i(16), operand_str(ops[0]), negate:)
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

      # Libc-relative addresses are known-mapped too; they carry the +$base+ marker
      # rather than a +pc+-relative one.
      def mapped_pointer?(obj)
        super || obj == libc_base.obj.to_s
      end

      # The libc load base as a symbolic +$base+ lambda.
      def libc_base
        @libc_base ||= OneGadget::Emulators::Lambda.new('$base')
      end

      # +$base+-relative addresses are treated as read-only; any other store
      # target must be writable, so record it as a constraint.
      def add_writable(lmda)
        # XXX: a tighter check would consult the libc's writable LOAD segments.
        return if lmda.obj == libc_base.obj
        # The stack is invariantly writable, so a pure sp-relative target needs no
        # constraint (cf. x86's needs_writable?, and the sp-skip in #track_write).
        return if lmda.obj == sp

        @constraints << [:writable, lmda]
      end
    end
  end
end
