# frozen_string_literal: true

require 'one_gadget/emulators/riscv64'
require 'one_gadget/fetchers/base'

module OneGadget
  module Fetchers
    # Fetcher for RISC-V (RV64).
    class Riscv64 < Base
      private

      # +jal+ is the only direct call and is four bytes wide, carrying its target as
      # a signed offset from itself. Instructions are two-byte aligned, since a
      # compressed one is half a word, so every two-byte position is read as a
      # possible +jal+ rather than every fourth: a false positive only adds a
      # window nothing is found in, while a missed call costs the gadgets around it.
      def scan_calls(base, data, targets)
        halves = data.unpack('v*')
        sites = []
        halves.each_with_index do |low, i|
          next unless (low & 0x7f) == JAL_OPCODE

          high = halves[i + 1]
          break if high.nil?

          addr = base + (i * 2)
          sites << addr if targets.key?(addr + jal_offset(low | (high << 16)))
        end
        sites
      end

      # The J-type opcode, which lives in the low half of the instruction word.
      JAL_OPCODE = 0x6f
      private_constant :JAL_OPCODE

      # The signed offset a +jal+ carries. The encoding scatters its bits --
      # +[20|10:1|11|19:12]+, with bit 0 always zero since a target is two-byte
      # aligned -- so they are put back in order before the sign is applied.
      # @param [Integer] word The instruction word.
      # @return [Integer]
      def jal_offset(word)
        imm = (((word >> 31) & 0x1) << 20) |
              (((word >> 12) & 0xff) << 12) |
              (((word >> 20) & 0x1) << 11) |
              (((word >> 21) & 0x3ff) << 1)
        imm.anybits?(1 << 20) ? imm - (1 << 21) : imm
      end

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
