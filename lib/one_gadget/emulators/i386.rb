require 'one_gadget/emulators/x86'
require 'one_gadget/abi'

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
    end
  end
end
