# frozen_string_literal: true

module OneGadget
  # Defines the ABI of different architectures.
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

    # Registers of ARM (32-bit).
    # +r13+/+r14+/+r15+ are always shown by objdump as +sp+/+lr+/+pc+.
    ARM = %w[sp lr pc] + 0.upto(12).map { |i| "r#{i}" }

    # Registers a call may destroy, per each ABI's calling convention: the return
    # register, the argument registers and the scratch ones. A callee is free to
    # leave anything here in an arbitrary state, so what it holds afterwards is not
    # something the caller of a gadget can choose. Listed per architecture with the
    # narrower views of each register, which name the same storage.
    CALLER_SAVED = {
      # SysV amd64: return rax, arguments rdi/rsi/rdx/rcx/r8/r9, scratch r10/r11.
      amd64: %w[rax rcx rdx rsi rdi r8 r9 r10 r11] +
             %w[eax ecx edx esi edi] + 8.upto(11).map { |i| "r#{i}d" } +
             0.upto(15).map { |i| "xmm#{i}" },
      # cdecl i386: return eax, scratch ecx/edx; arguments go on the stack.
      i386: %w[eax ecx edx] + 0.upto(7).map { |i| "xmm#{i}" },
      # AAPCS64: x0-x7 arguments and return, x9-x15 temporaries, x16/x17 the
      # intra-procedure-call scratch, x18 the platform register.
      aarch64: (0.upto(7).to_a + 9.upto(18).to_a).flat_map { |i| ["x#{i}", "w#{i}"] },
      # AAPCS: r0-r3 arguments and return, r12 (ip) the intra-procedure scratch,
      # and lr, which the call itself overwrites with the return address.
      arm: %w[r0 r1 r2 r3 r12 lr]
    }.freeze

    # The names under which each ABI's integer return value is visible: the
    # register a call leaves it in, together with its narrower views, which name
    # the same storage.
    RETURN_REGISTERS = {
      amd64: %w[rax eax],
      i386: %w[eax],
      aarch64: %w[x0 w0],
      arm: %w[r0]
    }.freeze

    module_function

    # Registers' name of amd64.
    # @return [Array<String>] List of registers.
    def amd64
      X86_64
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

    # Registers' name of arm (32-bit).
    # @return [Array<String>] List of registers.
    def arm
      ARM
    end

    # Returns all names of registers.
    # @return [Array<String>] List of registers.
    def all
      amd64 + aarch64 + arm
    end

    # Checks if the register is a stack-related pointer.
    # @param [String] reg
    #   Register's name.
    # @return [Boolean] +true+ if +reg+ is a stack or frame pointer (e.g. +rsp+, +rbp+, +sp+).
    def stack_register?(reg)
      %w[esp ebp rsp rbp sp x29].include?(reg)
    end
  end
end
