# frozen_string_literal: true

require 'one_gadget/emulators/x86'
require 'one_gadget/fetchers/base'

module OneGadget
  module Fetchers
    # Define common methods for gadget fetchers.
    class X86 < Base
      # Conditional-jump mnemonics (shared with the emulator).
      JCC = OneGadget::Emulators::X86::JCC

      private

      # A direct near call, +E8+ then a 32-bit displacement from the instruction
      # after it.
      CALL_REL32 = "\xe8".b.freeze
      private_constant :CALL_REL32
      CALL_REL32_SIZE = 5
      private_constant :CALL_REL32_SIZE

      # x86 instructions are variable length, so a byte in the middle of one can
      # read as a call; that costs a window nothing is found in, where missing a
      # real call would cost the gadgets around it.
      def scan_calls(base, data, targets)
        sites = []
        pos = 0
        while (pos = data.index(CALL_REL32, pos))
          displacement = data.byteslice(pos + 1, 4)
          break if displacement.nil? || displacement.bytesize < 4

          addr = base + pos
          sites << addr if targets.key?(addr + CALL_REL32_SIZE + displacement.unpack1('l<'))
          pos += 1
        end
        sites
      end

      def branch_lead_chars
        'j'
      end

      # +jcc+/+jcxz+ are conditional; a direct +jmp+ is unconditional while an
      # indirect one (+jmp rax+, +jmp QWORD PTR [..]+) and +ret+/+leave+ terminate.
      def branch_kind(line)
        m = mnemonic(line)
        return :conditional if JCC.key?(m) || %w[jcxz jecxz jrcxz].include?(m)
        return branch_target(line).nil? ? :terminator : :unconditional if m == 'jmp'

        :terminator if m.start_with?('ret') || m == 'leave'
      end

      def objdump_options
        %w[-M intel]
      end

      def call_str
        'call'
      end
    end
  end
end
