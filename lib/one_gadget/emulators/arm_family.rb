# frozen_string_literal: true

require 'one_gadget/emulators/lambda'

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
      # whose result their flags reflect (see {Conditional::COMPARE}). x86 has its
      # own {X86::COMPARES}.
      COMPARES = { 'cmp' => :sub, 'cmn' => :add, 'tst' => :and }.freeze

      # The sp-based stack that +obj+ addresses, or +nil+ when +obj+ isn't sp-relative.
      # @param [String, Lambda] obj A lambda object or its string.
      # @return [Hash{Integer => Lambda}, nil]
      # @example
      #   get_corresponding_stack('sp+0x10') #=> sp_based_stack
      #   get_corresponding_stack('x21')     #=> nil
      def get_corresponding_stack(obj)
        return nil unless obj.to_s.include?(sp)

        sp_based_stack
      end

      private

      # A +bl+/+blx+ call: record the terminal +exec*+ target, silently accept a
      # known-safe syscall wrapper, or +:fail+ to abort the candidate.
      def inst_bl(addr)
        # This is the last call.
        return registers[pc] = addr if %w[execve execl posix_spawn].any? { |n| addr.include?(n) }

        # Calls that are always safe because they merely wrap a syscall.
        checker = {
          'sigprocmask' => {},
          '__sigaction' => { 2 => :zero? }
        }
        func = checker.keys.find { |n| addr.include?(n) }
        return if func && checker[func].all? { |idx, sym| check_argument(idx, sym) }

        # unhandled case or checker's condition fails
        :fail
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

        @constraints << [:writable, lmda]
      end
    end
  end
end
