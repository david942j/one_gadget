# frozen_string_literal: true

require 'one_gadget/emulators/amd64'
require 'one_gadget/fetchers/x86'

module OneGadget
  module Fetchers
    # Fetcher for amd64.
    class Amd64 < OneGadget::Fetchers::X86
      # +posix_spawn+ itself, not one of the setup helpers that share its prefix.
      # The name ends at the version marker, or at the closing bracket when there
      # is none -- glibc's symbols are versioned, musl's are not, and neither is
      # one recovered from a file with no symbol table (see {DynamicSymbols}).
      TERMINAL_SPAWN = /posix_spawn[@>]/

      private

      def emulator
        OneGadget::Emulators::Amd64.new
      end

      # The branch-aware walker (see {Base#branch_aware_candidates}) already
      # stitches +jmp+ targets, so only the filter remains.
      def candidates
        super do |candidate|
          next true if candidate.match?(TERMINAL_SPAWN)
          next false unless candidate.include?(bin_sh_offset.to_s(16)) # works in x86-64
          next false unless candidate.lines.last.include?('execve') # only care execve

          true
        end
      end
    end
  end
end
