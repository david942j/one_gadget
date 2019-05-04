# frozen_string_literal: true

require 'one_gadget/abi'
require 'one_gadget/emulators/x86'

module OneGadget
  module Emulators
    # Emulator of amd64 instruction set.
    class Amd64 < X86
      class << self
        # Bits.
        def bits
          64
        end
      end

      # Instantiate an {Amd64} object.
      def initialize
        super(OneGadget::ABI.amd64, 'rsp', 'rip')
      end

      # Return the argument value of calling a function.
      # @param [Integer] idx
      # @return [Lambda, Integer]
      def argument(idx)
        case idx
        when 0 then registers['rdi']
        when 1 then registers['rsi']
        when 2 then registers['rdx']
        end
      end
    end
  end
end
