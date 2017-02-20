module OneGadget
  # define the abi of different architecture.
  module ABI
    # Define class methods here.
    module ClassMethods
      LINUX_X86_32 = %w(eax ebx ecx edx edi esi ebp esp).freeze
      LINUX_X86_64 = LINUX_X86_32 + %w(rax rbx rcx rdx rdi rsi rbp rsp) + 7.upto(15).map { |i| "r#{i}" }
      def amd64
        LINUX_X86_64
      end

      def i386
        LINUX_X86_32
      end

      alias all amd64
    end
    extend ClassMethods
  end
end
