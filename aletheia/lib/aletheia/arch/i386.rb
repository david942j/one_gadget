# frozen_string_literal: true

module Aletheia
  module Arch
    # i386 (x86-32) backend. Like {Amd64}, runs under qemu-user on a non-x86 host;
    # only the register/ABI model differs. The exec* arguments reach the kernel in
    # +ebx/ecx/edx+ (the 32-bit syscall ABI), even though the libc call takes them
    # on the stack.
    module I386
      module_function

      def name = 'i386'

      # General-purpose registers the satisfier may assign / the driver fills.
      def gprs = %w[eax ebx ecx edx esi edi ebp]

      # Only esp names a live stack address that can't be NULL.
      def stack_regs = %w[esp]

      def sp = 'esp'
      def pc = 'eip'

      def native_on?(host_machine) = %w[i386 i486 i586 i686].include?(host_machine)

      def gdb_reg(name) = "$#{name}"

      # i386 constraints already name the 32-bit registers, so no folding is needed.
      def normalize_reg(reg) = reg

      def stub_binary = 'park_stub_i386'

      # qemu-user transport: emulator binary, the sysroot providing the stub's own
      # ld.so + libc (QEMU_LD_PREFIX), and the gdb architecture to select.
      def qemu = { 'bin' => 'qemu-i386', 'ld_prefix' => '/usr/i686-linux-gnu',
                   'gdb_arch' => 'i386' }

      def driver_model
        { 'gprs' => gprs, 'sp' => sp, 'pc' => pc, 'gdb_arch' => 'i386',
          'sysno_reg' => 'eax', 'execve_syscalls' => [11, 358],
          'path_reg' => 'ebx', 'argv_reg' => 'ecx', 'envp_reg' => 'edx' }
      end
    end
  end
end
