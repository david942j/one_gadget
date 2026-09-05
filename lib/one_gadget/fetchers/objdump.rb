# frozen_string_literal: true

require 'shellwords'

require 'one_gadget/error'
require 'one_gadget/helper'

module OneGadget
  module Fetchers
    # Utilities for fetching instructions from libc using objdump.
    class Objdump
      # Instantiate an {Objdump} object.
      # @param [String] file Absolute path of target libc.
      # @param [Symbol] arch
      #   The architecture that objdump should support, usually same as the architecture of the target file.
      def initialize(file, arch)
        @file = file
        @arch = arch
        @options = []
      end

      # Read the file as a raw blob at +vma+ instead of as an ELF, for one whose
      # section headers are gone: objdump disassembles sections, and a file with
      # none disassembles to nothing at all.
      # @param [String] machine The objdump architecture name, as {OneGadget::Helper.objdump_arch} gives it.
      # @param [Symbol] endian +:little+ or +:big+.
      # @param [Integer] vma What the first byte of the file is loaded at.
      # @return [void]
      def read_raw(machine:, endian:, vma:)
        @raw = { machine:, endian:, vma: }
      end

      # Set the extra options to be passed to objdump.
      # @param [Array<String>] options The options.
      # @example
      #   objdump.extra_options = %w[-M intel]
      # @return [void]
      def extra_options=(options)
        @options = options
      end

      # @param [Integer] start The start address to be dumped from.
      # @param [Integer] stop The end address.
      # @param [Array<String>] extra Options for this range alone, on top of {#extra_options=}.
      # @return [String] The CLI command to be executed.
      def command(start: nil, stop: nil, extra: [])
        # --dwarf-start=0 is to make sure `suppress_bfd_header` is true to eliminate the file path in the output, see
        # issue #204 for more details.
        # Note: We might need to update this when the objdump act differently in the future.
        cmd = [bin, '--dwarf-start=0', '--no-show-raw-insn', '-w', *disassemble_options, *@options, *extra, @file]
        cmd.push('--start-address', start) if start
        cmd.push('--stop-address', stop) if stop
        ::Shellwords.join(cmd)
      end

      private

      # +-d+ walks the sections; a file read as a blob has none, so everything in
      # it is disassembled (+-D+) and told what it is and where it lives.
      def disassemble_options
        return ['-d'] if @raw.nil?

        ['-D', '-b', 'binary', '-m', @raw[:machine], @raw[:endian] == :big ? '-EB' : '-EL',
         "--adjust-vma=#{@raw[:vma]}"]
      end

      def bin
        OneGadget::Helper.find_objdump(@arch).tap do |bin|
          install_objdump_guide! if bin.nil?
        end
      end

      def install_objdump_guide!
        raise Error::UnsupportedArchitectureError, <<-EOS
Objdump that supports architecture #{@arch.to_s.inspect} is not found!
Please install the package 'binutils-multiarch' and try one_gadget again!

For Ubuntu users:
  $ [sudo] apt install binutils-multiarch
        EOS
      end
    end
  end
end
