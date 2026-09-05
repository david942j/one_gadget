# frozen_string_literal: true

require 'one_gadget/abi'
require 'one_gadget/emulators/x86'

module OneGadget
  module Emulators
    # Emulator of amd64 instruction set.
    class I386 < X86
      class << self
        # Yap, bits.
        # @return [Integer]
        def bits
          32
        end
      end

      # Instantiate an {I386} object.
      def initialize
        super(OneGadget::ABI.i386, 'esp', 'ebp', 'eip')
      end

      # The value on the stack slot holding the +idx+-th argument. The slots are
      # relative to the +esp+ the line sees, not the one the candidate was entered
      # with, so its offset is evaluated first.
      # @param [Integer] idx The 0-based index of the argument.
      # @return [Lambda, Integer] The value on the stack slot holding the +idx+-th argument.
      def argument(idx)
        cur_top = registers['esp'].evaluate('esp' => 0)
        sp_based_stack[cur_top + idx * 4]
      end
    end
  end
end
