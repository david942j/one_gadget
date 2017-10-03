require 'one_gadget/emulators/x86'
require 'one_gadget/abi'

module OneGadget
  module Emulators
    # Emulator of amd64 instruction set.
    class Amd64 < X86
      # Instantiate an {Amd64} object.
      def initialize
        super(OneGadget::ABI.amd64, 'rsp', 'rip')
      end

      def argument(idx)
        case idx
        when 0 then registers['rdi']
        when 1 then registers['rsi']
        when 2 then registers['edx']
        end
      end
    end
  end
end
