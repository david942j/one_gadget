# frozen_string_literal: true

module Aletheia
  module Arch
    # amd64 (x86-64) backend. Runs under qemu-user on a non-x86 host; the
    # transport/driver are arch-neutral, so only this register/ABI model differs.
    module Amd64
      module_function

      def name = 'amd64'

      # General-purpose registers the satisfier may assign / the driver fills.
      def gprs = %w[rax rbx rcx rdx rsi rdi rbp r8 r9 r10 r11 r12 r13 r14 r15]

      # Only rsp names a live stack address that can't be NULL; rbp is a general
      # register the attacker controls in these gadgets.
      def stack_regs = %w[rsp]

      def sp = 'rsp'
      def pc = 'rip'

      def native_on?(host_machine) = host_machine == 'x86_64'

      # A big enough version gap breaks dlopen just like the other arches (cf.
      # i386): the default cross sysroot's own ld.so is glibc 2.43, and dlopen-ing
      # a libc as old as 2.19/2.26 as a *secondary* object crashes -- an ifunc
      # resolver (compiled against that old glibc's internal CPU-feature-detection
      # ABI) gets invoked by the much-newer host ld.so and jumps to garbage
      # (observed: SIGSEGV at a bogus 0x500000000, even with no gdb involved at
      # all). A version-matched sysroot avoids the whole ABI gap.
      def version_strict? = true

      def gdb_reg(name) = "$#{name}"

      E2R = { 'eax' => 'rax', 'ebx' => 'rbx', 'ecx' => 'rcx', 'edx' => 'rdx',
              'esi' => 'rsi', 'edi' => 'rdi', 'ebp' => 'rbp', 'esp' => 'rsp' }.freeze
      private_constant :E2R

      # Normalise a 32-bit view to its 64-bit register; setting the full register
      # sets the low 32 bits, so an +eax+ constraint is satisfied via +rax+.
      # @example +eax+ -> +rax+, +r8d+ -> +r8+
      def normalize_reg(reg) = E2R[reg] || reg.sub(/\Ar(\d+)d\z/, 'r\1')

      def stub_binary = 'park_stub_x86_64'

      # qemu-user transport: emulator binary, the sysroot providing the stub's own
      # ld.so + libc (QEMU_LD_PREFIX), and the gdb architecture to select.
      def qemu = { 'bin' => 'qemu-x86_64', 'ld_prefix' => '/usr/x86_64-linux-gnu',
                   'gdb_arch' => 'i386:x86-64' }

      def driver_model
        { 'gprs' => gprs, 'sp' => sp, 'pc' => pc, 'gdb_arch' => 'i386:x86-64', 'word_size' => 8,
          'sysno_reg' => 'rax', 'execve_syscalls' => [59, 322],
          'path_reg' => 'rdi', 'argv_reg' => 'rsi', 'envp_reg' => 'rdx' }
      end
    end
  end
end
