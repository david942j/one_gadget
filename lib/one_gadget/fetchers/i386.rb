# frozen_string_literal: true

require 'elftools'

require 'one_gadget/emulators/i386'
require 'one_gadget/fetchers/x86'

module OneGadget
  module Fetchers
    # Fetcher for i386.
    class I386 < OneGadget::Fetchers::X86
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
        # use arg(0) to fetch the GOT base register
        # first check if argument 0 is '/bin/sh' to prevent error
        arg0 = processor.argument(0)
        return nil unless str_bin_sh?(arg0.to_s)

        @base_reg = arg0.deref.obj.to_s # this should be esi or ebx..
        # now we can let parent invoke "global_var?"
        res = super
        return if res.nil?

        # The GOT base is a fixed, mapped libc address, surfaced as its own
        # constraint; a writable:/readable: precondition rooted at it (a store or
        # load through the GOT base) is therefore not an attacker precondition and
        # is dropped. Unlike arm, i386 doesn't seed this register to +$base+ before
        # emulating, so the emulator can't recognise it as mapped -- it is pruned
        # here once +@base_reg+ is known.
        res[:constraints].unshift("#{@base_reg} is the GOT address of libc")
        res[:constraints].reject! { |c| c.match?(/\A(?:writable|readable): \[*#{Regexp.escape(@base_reg)}\b/) }
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
