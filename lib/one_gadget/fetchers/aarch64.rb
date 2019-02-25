require 'one_gadget/fetchers/base'

module OneGadget
  module Fetcher
    # Define common methods for gadget fetchers.
    class AArch64 < Base
      def candidates
        super do |candidate|
          puts candidate
          puts '-----------------------'
          false
        end
      end

      private

      # If str contains a branch instruction.
      def branch?(str)
        %w[b b.hi b.gt b.eq b.le b.ls b.lt b.ne b.cs].any? { |f| str.include?(' ' + f + ' ') }
      end

      def objdump_bin
        '~/binutils-2.32/binutils/objdump'
      end

      def call_str
        'bl'
      end
    end
  end
end
