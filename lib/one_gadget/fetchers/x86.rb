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

      def branch_lead_regex
        /\A[0-9a-f]+:\s+j/
      end

      def conditional_branch?(line)
        m = mnemonic(line)
        JCC.key?(m) || %w[jcxz jecxz jrcxz].include?(m)
      end

      def unconditional_branch?(line)
        mnemonic(line) == 'jmp' && !branch_target(line).nil?
      end

      # +ret+/+leave+ and indirect jumps (+jmp rax+, +jmp QWORD PTR [..]+) end the path.
      def path_ends?(line)
        m = mnemonic(line)
        m.start_with?('ret') || m == 'leave' || (m == 'jmp' && branch_target(line).nil?)
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
