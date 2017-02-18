require 'one_gadget/fetchers/base'
require 'one_gadget/emulators/i386'

module OneGadget
  module Fetcher
    # Fetcher for i386.
    class I386 < OneGadget::Fetcher::Base
      # Gadgets for i386 glibc.
      # @return [Array<OneGadget::Gadget::Gadget>] Gadgets found.
      def find
        rw_off = rw_offset
        bin_sh = str_offset('/bin/sh')
        rel_sh_hex = (rw_off - bin_sh).to_s(16)
        cands = candidates do |candidate|
          next false unless candidate.include?(rel_sh_hex)
          true
        end
        gadgets = cands.map do |cand|
          lines = cand.lines
          # handle execve later
          next convert_to_gadget(cand) { true } unless lines.last.include?('execl')
          # special handle for execl call
          # use processor to find which can lead to a valid execl call.
          gadgets = []
          (lines.size - 2).downto(0) do |i|
            processor = emulate(lines[i..-1])
            constraints = valid_execl(processor, bin_sh: rw_off - bin_sh)
            next if constraints.nil?
            offset = offset_of(lines[i..-1].join)
            gadgets << OneGadget::Gadget::Gadget.new(offset, constraints: constraints)
          end
          gadgets
        end.flatten.compact
        gadgets.uniq(&:constraints).sort_by(&:offset)
      end

      private

      def emulate(cmds)
        cmds.each_with_object(OneGadget::Emulators::I386.new) { |cmd, obj| obj.process(cmd) }
      end

      # @param [Integer] sh The related offset refer to /bin/sh.
      # @return [Array<String>, NilClass] The constraints to be a valid +execl+ call.
      def valid_execl(processor, bin_sh: 0)
        cur_top = processor.registers['esp'].evaluate('esp' => 0)
        arg = processor.stack[cur_top]
        # arg0 must be /bin/sh
        return nil unless arg.to_s.include?(bin_sh.to_s(16))
        rw_base = arg.deref.obj.to_s # this should be esi or ebx..
        arg = processor.stack[cur_top + 4]
        # arg1 can be a lambda or sh
        sh = bin_sh - 5 # /bin/ sh
        arg = processor.stack[cur_top + 8] if arg.to_s.include?(sh.to_s(16))
        return nil if arg.to_s.include?(rw_base) # we don't want base-related constraints
        # now arg is the constraint.
        ["#{rw_base} is the address of `rw-p` area of libc", "#{arg} == NULL"]
      end

      def rw_offset
        # How to find this offset correctly..?
        line = `readelf -d #{file}|grep PLTGOT`
        line.scan(/0x[\da-f]+/).last.to_i(16) & -0x1000
      end
    end
  end
end
