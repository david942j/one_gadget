# frozen_string_literal: true

require 'shellwords'

require 'one_gadget/error'
require 'one_gadget/helper'

module OneGadget
  module Fetcher
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

      # Set the extra options to be passed to objdump.
      # @param [Array<String>] options The options.
      # @example
      #   objdump.extra_options = %w[-M intel]
      def extra_options=(options)
        @options = options
      end

      # @param [Integer] start The start address to be dumpped from.
      # @param [Integer] stop The end address.
      # @return [String] The CLI command to be executed.
      def command(start: nil, stop: nil)
        cmd = [bin, '--no-show-raw-insn', '-w', '-d', *@options, @file]
        cmd.push('--start-address', start) if start
        cmd.push('--stop-address', stop) if stop
        ::Shellwords.join(cmd)
      end

      private

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
