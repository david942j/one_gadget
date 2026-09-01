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

    # Registers of RISC-V (RV64), by the ABI names objdump prints: it emits neither
    # the numbered +x0+-+x15+ names nor +fp+ for +s0+, so neither is listed.
    RISCV64 = %w[zero ra sp gp tp] + 0.upto(6).map { |i| "t#{i}" } +
              0.upto(11).map { |i| "s#{i}" } + 0.upto(7).map { |i| "a#{i}" }

    # Registers of MIPS (32-bit), by the names objdump prints: it emits the ABI
    # names rather than the numbered +$0+-+$31+, and +fp+ rather than +s8+.
    MIPS = %w[zero at v0 v1 gp sp fp ra] +
           0.upto(3).map { |i| "a#{i}" } + 0.upto(9).map { |i| "t#{i}" } +
           0.upto(7).map { |i| "s#{i}" } + 0.upto(1).map { |i| "k#{i}" }

    # Registers of ARM (32-bit).
    # objdump never prints the numbered name of a register that has a role name:
    # +r10+-+r15+ always appear as +sl+/+fp+/+ip+/+sp+/+lr+/+pc+, so those are
    # what this list holds.
    ARM = %w[sl fp ip sp lr pc] + 0.upto(9).map { |i| "r#{i}" }

    # Names that address part of a wider register rather than storage of their
    # own, mapped to the register they name part of. A write through either name
    # is visible through the other, which is what
    # {OneGadget::Emulators::RegisterFile} keeps them consistent about.
    # @example writing +edi+ is writing the low half of +rdi+
    # @example writing +r8d+ is writing the low half of +r8+
    NARROW_VIEWS = {
      amd64: (%w[ax bx cx dx di si bp sp].map { |reg| ["e#{reg}", "r#{reg}"] } +
              8.upto(15).map { |i| ["r#{i}d", "r#{i}"] }).to_h,
      i386: {},
      aarch64: 0.upto(30).to_h { |i| ["w#{i}", "x#{i}"] }.merge('wzr' => 'xzr'),
      arm: {},
      # RISC-V names no part of a register: its 32-bit operations are instructions
      # of their own (+addiw+, +sext.w+), each writing the whole register.
      riscv64: {},
      # MIPS names no part of a register either.
      mips: {}
    }.freeze

    # Registers a call may destroy, per each ABI's calling convention: the return
    # register, the argument registers and the scratch ones. A callee is free to
    # leave anything here in an arbitrary state, so what it holds afterwards is not
    # something the caller of a gadget can choose. Named by their full registers;
    # the narrower views of each go with it (see {NARROW_VIEWS}).
    CALLER_SAVED = {
      # SysV amd64: return rax, arguments rdi/rsi/rdx/rcx/r8/r9, scratch r10/r11.
      amd64: %w[rax rcx rdx rsi rdi r8 r9 r10 r11] + 0.upto(15).map { |i| "xmm#{i}" },
      # cdecl i386: return eax, scratch ecx/edx; arguments go on the stack.
      i386: %w[eax ecx edx] + 0.upto(7).map { |i| "xmm#{i}" },
      # AAPCS64: x0-x7 arguments and return, x9-x15 temporaries, x16/x17 the
      # intra-procedure-call scratch, x18 the platform register.
      aarch64: (0.upto(7).to_a + 9.upto(18).to_a).map { |i| "x#{i}" },
      # AAPCS: r0-r3 arguments and return, ip (r12) the intra-procedure scratch,
      # and lr, which the call itself overwrites with the return address.
      arm: %w[r0 r1 r2 r3 ip lr],
      # RISC-V LP64: a0-a7 arguments (a0/a1 also the return), t0-t6 temporaries,
      # and ra, which the call itself overwrites with the return address.
      riscv64: %w[ra] + 0.upto(7).map { |i| "a#{i}" } + 0.upto(6).map { |i| "t#{i}" },
      # o32: v0/v1 the return, a0-a3 arguments, t0-t9 temporaries, at the
      # assembler's scratch, and ra, which the call itself overwrites. gp goes
      # with them: PIC code reloads it from the stack after every call, because
      # the callee establishes its own.
      mips: %w[at v0 v1 gp ra] + 0.upto(3).map { |i| "a#{i}" } + 0.upto(9).map { |i| "t#{i}" }
    }.freeze

    # The register each ABI leaves an integer return value in.
    RETURN_REGISTER = { amd64: 'rax', i386: 'eax', aarch64: 'x0', arm: 'r0', riscv64: 'a0' }.freeze

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

    # Registers' name of RISC-V (RV64).
    # @return [Array<String>] List of registers.
    def riscv64
      RISCV64
    end

    # Registers' name of MIPS (32-bit).
    # @return [Array<String>] List of registers.
    def mips
      MIPS
    end

    # Returns all names of registers.
    # @return [Array<String>] List of registers.
    def all
      amd64 + aarch64 + arm + riscv64 + mips
    end

    # Checks if the register is a stack-related pointer.
    # @param [String] reg
    #   Register's name.
    # @return [Boolean] +true+ if +reg+ is a stack or frame pointer (e.g. +rsp+, +rbp+, +sp+).
    def stack_register?(reg)
      %w[esp ebp rsp rbp sp x29 s0].include?(reg)
    end
  end
end
