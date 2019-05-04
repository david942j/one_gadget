# frozen_string_literal: true

require 'one_gadget/emulators/amd64'
require 'one_gadget/fetchers/x86'

module OneGadget
  module Fetcher
    # Fetcher for amd64.
    class Amd64 < OneGadget::Fetcher::X86
      private

      def emulator
        OneGadget::Emulators::Amd64.new
      end

      def candidates
        # one basic block case
        cands = super do |candidate|
          next false unless candidate.include?(bin_sh_hex) # works in x86-64
          next false unless candidate.lines.last.include?('execve') # only care execve

          true
        end
        cands + jmp_case_candidates
      end

      # find gadgets in form:
      #   lea rdi, '/bin/sh'
      #   ...
      #   jmp xxx
      # xxx:
      #   ...
      #   call execve
      def jmp_case_candidates
        `#{objdump_cmd}|egrep 'rdi.*# #{bin_sh_hex}' -A 3`.split('--').map do |cand|
          cand = cand.lines.map(&:strip).reject(&:empty?)
          jmp_at = cand.index { |c| c.include?('jmp') }
          next nil if jmp_at.nil?

          cand = cand[0..jmp_at]
          next if cand.any? { |c| c.include?(call_str) }

          jmp_addr = cand.last.scan(/jmp\s+([\da-f]+)\s/)[0][0].to_i(16)
          dump = `#{objdump_cmd(start: jmp_addr, stop: jmp_addr + 100)}|egrep '[0-9a-f]+:'`
          remain = dump.lines.map(&:strip).reject(&:empty?)
          remain = remain[0..remain.index { |r| r.match(/call.*<execve[^+]*>/) }]
          [cand + remain].join("\n")
        end.compact
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
