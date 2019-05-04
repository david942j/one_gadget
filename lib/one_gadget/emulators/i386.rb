# frozen_string_literal: true

require 'one_gadget/abi'
require 'one_gadget/emulators/x86'

module OneGadget
  module Emulators
    # Emulator of amd64 instruction set.
    class I386 < X86
      class << self
        # Yap, bits.
        def bits
          32
        end
      end

      # Instantiate an {I386} object.
      def initialize
        super(OneGadget::ABI.i386, 'esp', 'eip')
      end

      # Get function call arguments.
      #
      # For i386 this is a little bit tricky.
      # We need to fetch the stack slots reference to current 'esp'
      # but not original 'esp'.
      # So we need to evaluate the offset of current esp first.
      # @param [Integer] idx
      # @return [Lambda, Integer]
      def argument(idx)
        cur_top = registers['esp'].evaluate('esp' => 0)
        stack[cur_top + idx * 4]
      end
    end
  end
end
