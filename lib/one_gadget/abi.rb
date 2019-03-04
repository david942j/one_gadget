module OneGadget
  # Defines the abi of different architectures.
  module ABI
    # Registers in i386.
    X86_32 = %w[eax ebx ecx edx edi esi ebp esp] + 0.upto(7).map { |i| "xmm#{i}" }
    # Registers in x86_64.
    X86_64 = X86_32 +
             %w[rax rbx rcx rdx rdi rsi rbp rsp] +
             8.upto(15).map { |i| "r#{i}" } +
             8.upto(15).map { |i| "xmm#{i}" }

    AARCH64 = %w[xzr wzr sp] + 0.upto(30).map { |i| ["x#{i}", "w#{i}"] }.flatten

    module_function

    # Registers' name in amd64.
    # @return [Array<String>] List of registers.
    def amd64
      X86_64.uniq
    end

    # Registers' name in i386.
    # @return [Array<String>] List of registers.
    def i386
      X86_32
    end

    def aarch64
      AARCH64
    end

    def all
      amd64 + aarch64
    end
  end
end
