# frozen_string_literal: true

require 'one_gadget/emulators/riscv64'
require 'one_gadget/fetchers/base'

module OneGadget
  module Fetchers
    # Fetcher for RISC-V (RV64).
    class Riscv64 < Base
      private

      def emulator
        OneGadget::Emulators::Riscv64.new
      end

      def branch_lead_chars
        'bj'
      end

      # Every conditional branch compares two registers directly -- there is no
      # flag register and no compare instruction -- so the whole family, including
      # the pseudo-instructions the assembler spells against +zero+, starts with
      # +b+. +jalr+ ends a path: it is an indirect jump, and where it goes is not
      # something the disassembly says.
      def branch_kind(line)
        m = mnemonic(line)
        return :conditional if m.start_with?('b')
        return :unconditional if m == 'j'

        :terminator if %w[ret jr jalr].include?(m)
      end

      # +jal+ is the direct call. A tail +j+ into an +exec*+ entry reaches one too,
      # but it is a jump, not a call, and is left out for the same reason x86 counts
      # only +call+: the walker stitches such a jump into the window it targets.
      def call_str
        'jal'
      end
    end
  end
end
