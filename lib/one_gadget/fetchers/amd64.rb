require 'one_gadget/fetchers/base'
require 'one_gadget/emulators/amd64'
module OneGadget
  module Fetcher
    # Fetcher for amd64.
    class Amd64 < OneGadget::Fetcher::Base
      # Gadgets for amd64 glibc.
      # @return [Array<OneGadget::Gadget::Gadget>] Gadgets found.
      def find
        bin_sh_hex = str_offset('/bin/sh').to_s(16)
        cands = candidates do |candidate|
          next false unless candidate.include?(bin_sh_hex) # works in x86-64
          next false unless candidate.lines.last.include?('execve') # only care execve
          true
        end
        cands.map do |candidate|
          processor = OneGadget::Emulators::Amd64.new
          candidate.lines.each { |l| processor.process(l) }
          offset = offset_of(candidate)
          options = gen_constraints(processor)
          next nil if options.nil? # impossible be a gadget
          OneGadget::Gadget::Gadget.new(offset, options)
        end.compact
      end

      private

      def gen_constraints(processor)
        # check rdi should always related to rip
        return unless processor.registers['rdi'].to_s.include?('rip')
        # rsi or [rsi] should be zero
        rsi = processor.registers['rsi'].to_s
        cons = [should_null(rsi)]
        rdx = processor.registers['rdx'].to_s
        use_env = true
        if should_null(rdx, allow_global: true)
          cons << should_null(rdx, allow_global: true)
          use_env = false
        end
        { constraints: cons, effect: %(execve("/bin/sh", #{rsi}, #{use_env ? 'environ' : rdx})) }
      end

      def should_null(str, allow_global: false)
        return nil if allow_global && str.include?('rip')
        ret = "[#{str}] == NULL"
        ret += " || #{str} == NULL" unless str.include?('rsp')
        ret
      end
    end
  end
end
