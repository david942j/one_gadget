require 'one_gadget/emulators/x86'

module OneGadget
  module Emulators
    # Emulator of amd64 instruction set.
    class Amd64 < X86
      REGISTERS = %w(rax rbx rcx rdx rdi rsi rbp rsp rip) + 7.upto(15).map { |i| "r#{i}" }

      # Instantiate a {Amd64} object.
      def initialize
        @bits = 64
        super(REGISTERS)
      end
    end
  end
end
