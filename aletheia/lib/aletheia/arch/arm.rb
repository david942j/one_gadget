# frozen_string_literal: true

module Aletheia
  module Arch
    # 32-bit ARM (armhf) backend. Runs under qemu-user; like i386 the exec*
    # arguments reach the kernel in registers (the EABI syscall ABI: number in
    # +r7+, args +r0..r2+). Modern armhf libc is Thumb-2, so the driver enters
    # gadgets in Thumb state (+thumb+ in {#driver_model}).
    module Arm
      module_function

      def name = 'arm'

      # General-purpose registers the satisfier may assign / the driver fills.
      def gprs = (0..12).map { |i| "r#{i}" }

      # Only sp names a live stack address that can't be NULL.
      def stack_regs = %w[sp]

      def sp = 'sp'
      def pc = 'pc'

      def native_on?(host_machine) = %w[armv7l armv6l arm].include?(host_machine)

      # arm runs via stub self-injection rather than a gdbstub: qemu-arm's
      # gdbstub kills the fork'd child of a posix_spawn gadget, so the L2 shell
      # never runs. The stub applies the plan and jumps itself, keeping the whole
      # run under plain qemu-user where the child survives (see {Transport::SelfInject}).
      def self_inject? = true

      # Like i386, an older armhf libc needs a per-version sysroot (its init
      # crashes under a newer ld.so); the toolchain-matched version uses the default.
      def version_strict? = true

      def gdb_reg(name) = "$#{name}"

      def normalize_reg(reg) = reg

      def stub_binary = 'park_stub_arm'

      def qemu = { 'bin' => 'qemu-arm', 'ld_prefix' => '/usr/arm-linux-gnueabihf',
                   'gdb_arch' => 'arm' }

      def driver_model
        { 'gprs' => gprs, 'sp' => sp, 'pc' => pc, 'gdb_arch' => 'arm',
          'sysno_reg' => 'r7', 'execve_syscalls' => [11, 387],
          'path_reg' => 'r0', 'argv_reg' => 'r1', 'envp_reg' => 'r2',
          'thumb' => true }
      end
    end
  end
end
