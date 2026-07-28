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

      # Runs natively (no qemu sysroot), so version-matching never applies.
      def version_strict? = false

      # gdb register expression for GPR +name+ (e.g. "x0" -> "$x0").
      def gdb_reg(name) = "$#{name}"

      # Normalise a 32-bit view to its 64-bit register.
      # @example +w21+ -> +x21+, +wzr+ -> +xzr+
      def normalize_reg(reg) = reg.sub(/\Aw(\d+|zr)\z/, 'x\1')

      # park_stub binary for this arch (built by the build helper).
      def stub_binary = 'park_stub_aarch64'

      # qemu-user transport config, or nil when the arch runs natively on the host.
      def qemu = nil

      # Register/syscall model the gdb driver needs (serialized into the plan).
      def driver_model
        { 'gprs' => gprs, 'sp' => sp, 'pc' => pc, 'gdb_arch' => nil,
          'sysno_reg' => 'x8', 'execve_syscalls' => [221, 281],
          'path_reg' => 'x0', 'argv_reg' => 'x1', 'envp_reg' => 'x2' }
      end
    end
  end
end
