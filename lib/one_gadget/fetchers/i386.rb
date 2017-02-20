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
        cands.map do |cand|
          lines = cand.lines
          # use processor to find which can lead to a valid one-gadget call.
          gadgets = []
          (lines.size - 2).downto(0) do |i|
            processor = emulate(lines[i..-1])
            constraints = gen_constraints(processor, bin_sh: rw_off - bin_sh)
            next if constraints.nil?
            offset = offset_of(lines[i..-1].join)
            gadgets << OneGadget::Gadget::Gadget.new(offset, constraints: constraints)
          end
          gadgets
        end.flatten.compact
      end

      private

      def emulate(cmds)
        cmds.each_with_object(OneGadget::Emulators::I386.new) { |cmd, obj| obj.process(cmd) }
      end

      def valid_execl(arg1, arg2, rw_base: nil, sh: 0)
        arg = arg1.to_s
        arg = arg2.to_s if arg.include?(sh.to_s(16))
        return nil if arg.include?(rw_base) || arg.include?('eip') # we don't want base-related constraints
        # now arg is the constraint.
        ["#{arg} == NULL"]
      end

      def valid_execve(arg1, arg2, rw_base: nil)
        # arg1 == NULL || [arg1] == NULL
        # arg2 == NULL or arg2 is environ
        cons = [should_null(arg1.to_s)]
        envp = arg2.to_s
        unless envp.include?('[[') && envp.include?(rw_base) # hope this is environ_ptr_0
          return nil if envp.include?('[') # we don't like this :(
          cons << should_null(envp)
        end
        cons
      end

      # Generating constraints to be a valid gadget.
      # @param [OneGadget::Emulators::I386] processor The processor after executing the gadget.
      # @param [Integer] bin_sh The related offset refer to /bin/sh.
      # @return [Array<String>, NilClass]
      #   List of constraints.
      #   If constraints can never be statified, +nil+ is returned.
      def gen_constraints(processor, bin_sh: 0)
        call = processor.registers['eip'].to_s
        cur_top = processor.registers['esp'].evaluate('esp' => 0)
        arg = processor.stack[cur_top]
        # arg0 must be /bin/sh
        return nil unless arg.to_s.include?(bin_sh.to_s(16))
        rw_base = arg.deref.obj.to_s # this should be esi or ebx..
        arg1 = processor.stack[cur_top + 4]
        arg2 = processor.stack[cur_top + 8]
        cons = if call.include?('execve')
                 valid_execve(arg1, arg2, rw_base: rw_base)
               elsif call.include?('execl')
                 valid_execl(arg1, arg2, rw_base: rw_base, sh: bin_sh - 5)
               end
        return nil if cons.nil?
        ["#{rw_base} is the address of `rw-p` area of libc"] + cons
      end

      def rw_offset
        # How to find this offset correctly..?
        line = `readelf -d #{file}|grep PLTGOT`
        line.scan(/0x[\da-f]+/).last.to_i(16) & -0x1000
      end

      def should_null(str)
        ret = "[#{str}] == NULL"
        ret += " || #{str} == NULL" unless str.include?('esp')
        ret
      end
    end
  end
end
