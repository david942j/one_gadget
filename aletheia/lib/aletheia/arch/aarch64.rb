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

      # gdb register expression for GPR +name+ (e.g. "x0" -> "$x0").
      def gdb_reg(name) = "$#{name}"
    end
  end
end
