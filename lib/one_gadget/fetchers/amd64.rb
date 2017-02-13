require 'one_gadget/fetchers/base'
module OneGadget
  module Fetcher
    # Fetcher for x86-64.
    class Amd64 < OneGadget::Fetcher::Base
      def find
        bin_sh_hex = str_offset('/bin/sh').to_s(16)
        cands = candidates.select do |candidate|
          next false unless candidate.include?(bin_sh_hex) # works in x86-64
          true
        end
        cands.map do |candidate|
          # remove other calls
          lines = candidate.lines
          to_rm = lines[0...-1].rindex { |c| c.include?('call') }
          lines = lines[to_rm + 1..-1] unless to_rm.nil?
          convert_to_gadget(lines.join) do |line|
            ['rsi'].any? { |r| line.include?(r) }
          end
        end
      end
    end
  end
end
