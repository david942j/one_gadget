require 'one_gadget/emulators/aarch64'
require 'one_gadget/fetchers/base'

module OneGadget
  module Fetcher
    # Define common methods for gadget fetchers.
    class AArch64 < Base
      private

      def emulator
        OneGadget::Emulators::AArch64.new
      end

      # If str contains a branch instruction.
      def branch?(str)
        %w[b b.hi b.gt b.eq b.le b.ls b.lt b.ne b.cs].any? { |f| str.include?(' ' + f + ' ') }
      end

      def objdump_bin
        '/home/david942j/binutils-2.32/binutils/objdump'
      end

      def call_str
        'bl'
      end

      def str_bin_sh?(str)
        # TODO
        str.include?('$base')
      end

      def str_sh?(str)
        # TODO
        str.include?('$base')
      end

      def global_var?(str)
        str.include?('$base')
      end
    end
  end
end
