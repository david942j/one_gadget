# frozen_string_literal: true

require 'one_gadget/emulators/x86'
require 'one_gadget/fetchers/base'

module OneGadget
  module Fetcher
    # Define common methods for gadget fetchers.
    class X86 < Base
      # Conditional-jump mnemonics (shared with the emulator).
      JCC = OneGadget::Emulators::X86::JCC

      private

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
