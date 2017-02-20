require 'one_gadget/emulators/x86'

module OneGadget
  module Emulators
    # Emulator of amd64 instruction set.
    class I386 < X86
      class << self
        def bits
          32
        end
      end

      REGISTERS = %w(eax ebx ecx edx edi esi ebp esp eip).freeze
      # Instantiate a {I386} object.
      def initialize
        super(REGISTERS, 'esp', 'eip')
      end
    end
  end
end
