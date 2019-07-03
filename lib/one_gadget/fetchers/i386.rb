# frozen_string_literal: true

require 'elftools'

require 'one_gadget/emulators/i386'
require 'one_gadget/fetchers/x86'

module OneGadget
  module Fetcher
    # Fetcher for i386.
    class I386 < OneGadget::Fetcher::X86
      private

      def candidates
        rel_sh_hex = rel_sh.to_s(16)
        super do |candidate|
          next false unless candidate.include?(rel_sh_hex)

          true
        end
      end

      def emulator
        OneGadget::Emulators::I386.new
      end

      def resolve(processor)
        # use arg(0) to fetch the got base register
        # first check if argument 0 is '/bin/sh' to prevent error
        arg0 = processor.argument(0)
        return nil unless str_bin_sh?(arg0.to_s)

        @base_reg = arg0.deref.obj.to_s # this should be esi or ebx..
        # now we can let parent to invoke global_var?
        res = super
        return if res.nil?

        # unshift GOT constraint into cons
        res[:constraints].unshift("#{@base_reg} is the GOT address of libc")
        res
      end

      def str_bin_sh?(str)
        str.include?(rel_sh.to_s(16))
      end

      def str_sh?(str)
        str.include?((rel_sh - 5).to_s(16))
      end

      # +@base_reg+ should always be set in resolve()
      def global_var?(str)
        str.include?(@base_reg)
      end

      def got_offset
        File.open(file) do |f|
          elf = ELFTools::ELFFile.new(f)
          elf.segment_by_type(:dynamic).tag_by_type(:pltgot).value
        end
      end

      def rel_sh
        @rel_sh ||= got_offset - str_offset('/bin/sh')
      end
    end
  end
end
