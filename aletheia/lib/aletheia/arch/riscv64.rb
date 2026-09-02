# frozen_string_literal: true

module Aletheia
  module Arch
    # RISC-V (RV64) backend. Runs under qemu-user; the exec* arguments reach the
    # kernel the same way aarch64's do -- the generic unistd numbers in +a7+, the
    # arguments in +a0..a2+.
    module Riscv64
      module_function

      def name = 'riscv64'

      # General-purpose registers the satisfier may assign / the driver fills.
      # +zero+ is hardwired and +sp+ is the stack; +gp+ and +tp+ are left out as
      # well, because the parked stub is a live process whose libc reaches its
      # thread-local storage through +tp+ -- poisoning it breaks the very libc the
      # gadget is about to run in, which is a harness failure, not a gadget one.
      def gprs
        %w[ra] + (0..7).map { |i| "a#{i}" } + (0..11).map { |i| "s#{i}" } +
          (0..6).map { |i| "t#{i}" }
      end

      # Only +sp+ invariantly names a live stack address that can't be NULL; +s0+
      # is the frame pointer by convention but a general register the attacker
      # controls in these gadgets (like aarch64's +x29+), so a store through it
      # carries an explicit +writable: s0+imm+ constraint rather than being assumed
      # valid.
      def stack_regs = %w[sp]

      def sp = 'sp'
      def pc = 'pc'

      # Whether this backend can run the target libc natively on the host.
      # @param [String] host_machine value of +uname -m+
      def native_on?(host_machine) = host_machine == 'riscv64'

      # Under qemu, a libc whose version differs from the cross toolchain's needs a
      # per-version sysroot (its init crashes under a newer ld.so); the matched one
      # loads directly.
      def version_strict? = true

      # This arch spells no register more than one way: objdump emits neither the
      # numbered +x0+-+x31+ names nor +fp+ for +s0+, so a name arrives as itself.
      def normalize_reg(reg) = reg

      # park_stub binary for this arch (built by the build helper).
      def stub_binary = 'park_stub_riscv64'

      # qemu-user transport config: emulator binary, the sysroot providing the
      # stub's own ld.so + libc (QEMU_LD_PREFIX), and the gdb architecture to select.
      def qemu
        { 'bin' => 'qemu-riscv64', 'ld_prefix' => '/usr/riscv64-linux-gnu',
          'gdb_arch' => 'riscv:rv64' }
      end

      # Register/syscall model the gdb driver needs (serialized into the plan).
      def driver_model
        { 'gprs' => gprs, 'sp' => sp, 'pc' => pc, 'gdb_arch' => 'riscv:rv64', 'word_size' => 8,
          'sysno_reg' => 'a7', 'execve_syscalls' => [221, 281],
          'path_reg' => 'a0', 'argv_reg' => 'a1', 'envp_reg' => 'a2' }
      end
    end
  end
end
