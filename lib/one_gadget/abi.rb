# frozen_string_literal: true

module OneGadget
  # Defines the abi of different architectures.
  module ABI
    # Registers of i386.
    X86_32 = %w[eax ebx ecx edx edi esi ebp esp] + 0.upto(7).map { |i| "xmm#{i}" }
    # Registers of x86_64.
    X86_64 = X86_32 +
             %w[rax rbx rcx rdx rdi rsi rbp rsp] +
             8.upto(15).map { |i| "r#{i}" } +
             8.upto(15).map { |i| "xmm#{i}" }

    # Registers of AArch64.
    AARCH64 = %w[xzr wzr sp] + 0.upto(30).map { |i| ["x#{i}", "w#{i}"] }.flatten

    module_function

    # Registers' name of amd64.
    # @return [Array<String>] List of registers.
    def amd64
      X86_64.uniq
    end

    # Registers' name of i386.
    # @return [Array<String>] List of registers.
    def i386
      X86_32
    end

    # Registers' name of aarch64.
    # @return [Array<String>] List of registers.
    def aarch64
      AARCH64
    end

    # Returns all names of registers.
    # @return [Array<String>] List of registers.
    def all
      amd64 + aarch64
    end

    # Checks if the register is a stack-related pointer.
    # @param [String] reg
    #   Register's name.
    # @return [Boolean]
    def stack_register?(reg)
      %w[esp ebp rsp rbp sp x29].include?(reg)
    end
  end
end
