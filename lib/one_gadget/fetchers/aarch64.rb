# frozen_string_literal: true

require 'one_gadget/emulators/aarch64'
require 'one_gadget/fetchers/base'

module OneGadget
  module Fetchers
    # Define common methods for gadget fetchers.
    class AArch64 < Base
      # aarch64 condition codes (used to recognise +b.<cond>+ branches).
      CONDS = %w[eq ne cs hs cc lo mi pl vs vc hi ls ge lt gt le].freeze

      private

      # +BL imm26+ is AArch64's only direct call, one word wide and word-aligned,
      # so the whole scan is a masked compare per word.
      def scan_calls(base, data, targets)
        sites = []
        data.unpack('V*').each_with_index do |word, i|
          next unless (word & 0xfc000000) == 0x94000000

          imm = word & 0x03ffffff
          imm -= 1 << 26 if imm.anybits?(1 << 25)
          addr = base + (i * 4)
          sites << addr if targets.key?(addr + (imm * 4))
        end
        sites
      end

      def emulator
        OneGadget::Emulators::AArch64.new
      end

      def branch_lead_chars
        'bct'
      end

      def branch_kind(line)
        m = mnemonic(line)
        return :conditional if %w[cbz cbnz tbz tbnz].include?(m) || (m.start_with?('b.') && CONDS.include?(m[2..]))
        return :unconditional if %w[b b.al].include?(m)

        :terminator if %w[ret br braa brab braaz brabz].include?(m)
      end

      def call_str
        'bl'
      end
    end
  end
end
