require 'one_gadget/fetchers/base'
module OneGadget
  module Fetcher
    # Fetcher for amd64.
    class Amd64 < OneGadget::Fetcher::Base
      def find
        bin_sh_hex = str_offset('/bin/sh').to_s(16)
        cands = candidates do |candidate|
          next false unless candidate.include?(bin_sh_hex) # works in x86-64
          next false unless candidate.lines.last.include?('execve') # only care execve
          true
        end
        cands.map do |candidate|
          convert_to_gadget(candidate) do |line|
            ['rsi'].any? { |r| line.include?(r) }
          end
        end
      end
    end
  end
end
