# frozen_string_literal: true

require 'one_gadget/emulators/amd64'
require 'one_gadget/fetchers/x86'

module OneGadget
  module Fetchers
    # Fetcher for amd64.
    class Amd64 < OneGadget::Fetchers::X86
      private

      def emulator
        OneGadget::Emulators::Amd64.new
      end

      # The branch-aware walker (see {Base#branch_aware_candidates}) already
      # stitches +jmp+ targets, so only the filter remains.
      def candidates
        super do |candidate|
          next true if candidate.include?('posix_spawn@')
          next false unless candidate.include?(bin_sh_hex) # works in x86-64
          next false unless candidate.lines.last.include?('execve') # only care execve

          true
        end
      end

      def bin_sh_hex
        @bin_sh_hex ||= str_offset('/bin/sh').to_s(16)
      end

      def str_bin_sh?(str)
        str.include?('rip+0x') # && str.include?(bin_sh_hex)
      end

      def global_var?(str)
        str.include?('rip')
      end
    end
  end
end
