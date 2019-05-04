# frozen_string_literal: true

require 'one_gadget/fetchers/base'

module OneGadget
  module Fetcher
    # Define common methods for gadget fetchers.
    class X86 < Base
      private

      # If str contains a branch instruction.
      def branch?(str)
        %w[jmp je jne jl jb ja jg].any? { |f| str.include?(f) }
      end

      def objdump_options
        %w[-M intel]
      end

      def call_str
        'call'
      end
    end
  end
end
