# frozen_string_literal: true

module Aletheia
  module Arch
    # AArch64 backend: the reference architecture. All arch-specific facts the
    # satisfier, driver, and oracle need live here so a new architecture is a
    # new backend object rather than edits scattered across the harness.
    module AArch64
      module_function

      def name = 'aarch64'

      # General-purpose registers the satisfier may assign.
      def gprs = (0..30).map { |i| "x#{i}" }

      # Registers that name the stack; an equality-to-NULL on +sp+imm+ (imm!=0)
      # is unsatisfiable because the value is a live stack address.
      def stack_regs = %w[sp x29]

      def sp = 'sp'
      def pc = 'pc'

      # Whether this backend can run the target libc natively on the host.
      # @param [String] host_machine value of +uname -m+
      def native_on?(host_machine) = host_machine == 'aarch64'

      # Under qemu, an older aarch64 libc needs a per-version sysroot (its ld.so
      # differs too much from the host's); the native run loads it directly.
      def version_strict? = true

      # gdb register expression for GPR +name+ (e.g. "x0" -> "$x0").
      def gdb_reg(name) = "$#{name}"

      # Normalise a 32-bit view to its 64-bit register.
      # @example +w21+ -> +x21+, +wzr+ -> +xzr+
      def normalize_reg(reg) = reg.sub(/\Aw(\d+|zr)\z/, 'x\1')

      # park_stub binary for this arch (built by the build helper).
      def stub_binary = 'park_stub_aarch64'

      # qemu-user transport config. Used when aarch64 is the *foreign* arch (a
      # non-aarch64 host), or when +ALETHEIA_FORCE_QEMU+ drives it under qemu on an
      # aarch64 host -- there the transport resolves the runtime prefix to the host
      # root instead of this cross sysroot.
      def qemu = { 'bin' => 'qemu-aarch64', 'ld_prefix' => '/usr/aarch64-linux-gnu',
                   'gdb_arch' => 'aarch64' }

      # Register/syscall model the gdb driver needs (serialized into the plan).
      def driver_model
        { 'gprs' => gprs, 'sp' => sp, 'pc' => pc, 'gdb_arch' => 'aarch64',
          'sysno_reg' => 'x8', 'execve_syscalls' => [221, 281],
          'path_reg' => 'x0', 'argv_reg' => 'x1', 'envp_reg' => 'x2' }
      end
    end
  end
end
