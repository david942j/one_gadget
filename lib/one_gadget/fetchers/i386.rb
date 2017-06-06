require 'elftools'

require 'one_gadget/emulators/i386'
require 'one_gadget/fetchers/base'

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
            options = resolve(processor, bin_sh: rw_off - bin_sh)
            next if options.nil?
            offset = offset_of(lines[i])
            gadgets << OneGadget::Gadget::Gadget.new(offset, options)
          end
          gadgets
        end.flatten.compact
      end

      private

      def emulate(cmds)
        cmds.each_with_object(OneGadget::Emulators::I386.new) { |cmd, obj| obj.process(cmd) }
      end

      # Generating constraints to be a valid gadget.
      # @param [OneGadget::Emulators::I386] processor The processor after executing the gadget.
      # @param [Integer] bin_sh The related offset refer to /bin/sh.
      # @return [Hash{Symbol => Array<String>, String}, NilClass]
      #   The options to create a {OneGadget::Gadget::Gadget} object.
      #   Keys might be:
      #   1. constraints: Array<String> List of constraints.
      #   2. effect: String Result function call of this gadget.
      #   If the constraints can never be satisfied, +nil+ is returned.
      def resolve(processor, bin_sh: 0)
        call = processor.registers['eip'].to_s
        cur_top = processor.registers['esp'].evaluate('esp' => 0)
        arg = processor.stack[cur_top]
        # arg0 must be /bin/sh
        return nil unless arg.to_s.include?(bin_sh.to_s(16))
        rw_base = arg.deref.obj.to_s # this should be esi or ebx..
        arg1 = processor.stack[cur_top + 4]
        arg2 = processor.stack[cur_top + 8]
        options = if call.include?('execve')
                    resolve_execve(arg1, arg2, rw_base: rw_base)
                  elsif call.include?('execl')
                    resolve_execl(arg1, arg2, rw_base: rw_base, sh: bin_sh - 5)
                  end
        return nil if options.nil?
        options[:constraints].unshift("#{rw_base} is the address of `rw-p` area of libc")
        options
      end

      # Resolve +call execl+ case.
      # @param [OneGadget::Emulators::Lambda] arg1
      #   The second argument.
      # @param [OneGadget::Emulators::Lambda] arg2
      #   The third argument.
      # @param [String] rw_base Usually +ebx+ or +esi+.
      # @param [Integer] sh The relative offset of string 'sh' appears.
      # @return [Hash{Symbol => Array<String>, String}]
      #   Same format as {#resolve}.
      def resolve_execl(arg1, arg2, rw_base: nil, sh: 0)
        args = []
        arg = arg1.to_s
        if arg.include?(sh.to_s(16))
          arg = arg2.to_s
          args << '"sh"'
        end
        args << arg
        return nil if arg.include?(rw_base) || arg.include?('eip') # we don't want base-related constraints
        # now arg is the constraint.
        { constraints: ["#{arg} == NULL"], effect: %(execl("/bin/sh", #{args.join(', ')})) }
      end

      # Resolve +call execve+ case.
      # @param [OneGadget::Emulators::Lambda] arg1
      #   The second argument.
      # @param [OneGadget::Emulators::Lambda] arg2
      #   The third argument.
      # @param [String] rw_base Usually +ebx+ or +esi+.
      # @return [Hash{Symbol => Array<String>, String}]
      #   Same format as {#resolve}.
      def resolve_execve(arg1, arg2, rw_base: nil)
        # arg1 == NULL || [arg1] == NULL
        # arg2 == NULL or arg2 is environ
        cons = [should_null(arg1.to_s)]
        envp = arg2.to_s
        use_env = true
        unless envp.include?('[[') && envp.include?(rw_base) # hope this is environ_ptr_0
          return nil if envp.include?('[') # we don't like this :(
          cons << should_null(envp)
          use_env = false
        end
        { constraints: cons, effect: %(execve("/bin/sh", #{arg1}, #{use_env ? 'environ' : envp})) }
      end

      def rw_offset
        File.open(file) do |f|
          elf = ELFTools::ELFFile.new(f)
          elf.segment_by_type(:dynamic).tag_by_type(:pltgot).value
        end
      end

      def should_null(str)
        ret = "[#{str}] == NULL"
        ret += " || #{str} == NULL" unless str.include?('esp')
        ret
      end
    end
  end
end
