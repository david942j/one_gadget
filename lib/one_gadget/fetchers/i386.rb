require 'one_gadget/fetchers/base'
module OneGadget
  module Fetcher
    # Fetcher for i386.
    class I386 < OneGadget::Fetcher::Base
      def find
        rw_off = rw_offset
        bin_sh = str_offset('/bin/sh')
        minus_c = str_offset('-c')
        rel_sh_hex = (rw_off - bin_sh).to_s(16)
        rel_minus_c = (rw_off - minus_c).to_s(16)
        cands = candidates do |candidate|
          next false unless candidate.include?(rel_sh_hex)
          true
        end
        # remove lines before and with -c appears
        cands = slice_prefix(cands) do |line|
          line.include?(rel_minus_c)
        end
        # special handle for execl call
        cands.map! do |cand|
          lines = cand.lines
          next cand unless lines.last.include?('execl')
          # Find the last three +push+, or mov [esp+0x8], .*
          # Make it call +execl("/bin/sh", "sh", NULL)+.
          if cand.include?('esp+0x8')
            to_rm = lines.index { |c| c.include?('esp+0x8') }
          else
            push_cnt = 0
            to_rm = lines.rindex do |c|
              push_cnt += 1 if c.include?('push')
              push_cnt >= 3
            end
          end
          lines = lines[to_rm..-1] unless to_rm.nil?
          lines.join
        end
        cands.map do |candidate|
          convert_to_gadget(candidate) do |_|
            true
          end
        end
      end

      private

      def rw_offset
        # How to find this offset correctly..?
        line = `readelf -d #{file}|grep PLTGOT`
        line.scan(/0x[\da-f]+/).last.to_i(16) & -0x1000
      end
    end
  end
end
