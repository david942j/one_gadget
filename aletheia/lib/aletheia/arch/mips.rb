# frozen_string_literal: true

module Aletheia
  module Arch
    # What both byte orders of MIPS (32-bit, o32) share. This architecture is
    # deployed big-endian as widely as little-endian -- ath79 against ramips --
    # and the two differ only in which emulator and stub they need, so the model
    # lives here and {Mips}/{Mipsel} state the difference.
    #
    # exec* arguments reach the kernel in +a0..a2+ with the syscall number in
    # +v0+, counted from the o32 base of 4000.
    module MipsFamily
      # aletheia/, where the stubs and their sysroots are built.
      ROOT = File.expand_path('../../..', __dir__)

      # General-purpose registers the satisfier may assign / the driver fills.
      # +zero+ is hardwired and +sp+ is the stack. +k0+/+k1+ belong to the kernel
      # and +ra+ is the return address the call itself writes, but both are
      # ordinary registers to a gadget, so they stay. +gp+ is here on purpose:
      # every gadget on this arch requires it to be the GOT base, which is a
      # precondition the driver has to be able to arrange.
      def gprs
        %w[at v0 v1 gp fp ra] + (0..3).map { |i| "a#{i}" } + (0..9).map { |i| "t#{i}" } +
          (0..7).map { |i| "s#{i}" }
      end

      # Only +sp+ invariantly names a live stack address that can't be NULL; +fp+
      # is the frame pointer by convention but a general register the attacker
      # controls in these gadgets, so a store through it carries an explicit
      # +writable:+ constraint rather than being assumed valid.
      def stack_regs = %w[sp]

      def sp = 'sp'
      def pc = 'pc'

      # The host this harness runs on is not MIPS, so this always drives qemu.
      # @param [String] _host_machine value of +uname -m+
      def native_on?(_host_machine) = false

      # o32 points +gp+ this far into the GOT, so that one signed 16-bit offset
      # reaches the most of it. A gadget's "gp is the GOT address of libc" is met
      # by the value the ABI actually asks for, not by the table's first byte.
      def got_bias = 0x7ff0

      # A glibc fixture here is the same release as the stub's own sysroot, so it
      # loads directly; a musl one is run as the stub's own libc rather than
      # beside it (see +Transport::Base#self_hosted?+), which needs no version
      # match either.
      def version_strict? = false

      # objdump prints the ABI name of every register except +$30+, which it
      # spells +fp+ where the ABI calls it +s8+.
      def normalize_reg(reg) = reg == 's8' ? 'fp' : reg

      # Register/syscall model the gdb driver needs (serialized into the plan).
      def driver_model
        { 'gprs' => gprs, 'sp' => sp, 'pc' => pc, 'gdb_arch' => 'mips', 'word_size' => 4,
          # gdb's own +$fp+ is frame-derived and cannot be assigned; the same
          # register answers to its other ABI name.
          'reg_aliases' => { 'fp' => 's8' },
          'sysno_reg' => 'v0', 'execve_syscalls' => [4011, 4356],
          'path_reg' => 'a0', 'argv_reg' => 'a1', 'envp_reg' => 'a2' }
      end
    end

    # MIPS, big-endian -- ath79 and the other router targets built that way.
    module Mips
      extend MipsFamily

      module_function

      def name = 'mips'

      # The backend that answers for +target+: this architecture ships in both
      # byte orders and each needs its own emulator and stub, so the file decides.
      # @param [String] target
      # @return [Module]
      def for_target(target)
        File.open(target) { |fd| ELFTools::ELFFile.new(fd).endian } == :big ? Mips : Mipsel
      end

      def stub_binary = 'park_stub_mips'

      # What a musl stub for this byte order asks for as its interpreter, and so
      # the name the fixture is given when it is run as that stub's own libc.
      def musl_loader = 'ld-musl-mips-sf.so.1'

      # What the driver writes into memory has to be in the target's byte order,
      # not the host's.
      def driver_model = super.merge('big_endian' => true)

      def qemu
        { 'bin' => 'qemu-mips', 'ld_prefix' => File.join(MipsFamily::ROOT, 'sysroots', 'mipsel'),
          'gdb_arch' => 'mips' }
      end
    end

    # MIPS, little-endian -- ramips, and the Debian mipsel port.
    module Mipsel
      extend MipsFamily

      module_function

      def name = 'mipsel'

      def stub_binary = 'park_stub_mipsel'

      def musl_loader = 'ld-musl-mipsel-sf.so.1'

      # The sysroot is built beside the harness rather than installed: the
      # distribution ships no MIPS cross toolchain, so it comes from Debian's own
      # mipsel packages (see build_stubs.sh).
      def qemu
        { 'bin' => 'qemu-mipsel', 'ld_prefix' => File.join(MipsFamily::ROOT, 'sysroots', 'mipsel'),
          'gdb_arch' => 'mips' }
      end
    end
  end
end
