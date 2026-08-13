# frozen_string_literal: true

require 'json'
require 'socket'

module Aletheia
  # How the target process is launched and driven: natively (host arch) or under
  # qemu-user (foreign arch) via a gdbstub. Both expose the same contract to the
  # oracle -- launch the stub + gdb driver with the guest's tty on +slave+ -- and
  # return the pids to reap. The self-describing park_stub means neither transport
  # needs inferior function calls or /proc access from gdb.
  module Transport
    ROOT = File.expand_path('../..', __dir__) # aletheia/

    # Pick the transport from the *host* arch, not a per-arch flag, so the same
    # backend runs natively on its own host and under qemu-user anywhere else. Set
    # +ALETHEIA_FORCE_QEMU+ to drive a native arch through qemu too (e.g. to
    # exercise the aarch64 qemu path on an aarch64 host).
    # @return [Transport::Native, Transport::Qemu, Transport::SelfInject]
    def self.for(arch, target)
      if arch.native_on?(host_machine) && !ENV['ALETHEIA_FORCE_QEMU']
        Native.new(arch, target)
      elsif arch.respond_to?(:self_inject?) && arch.self_inject?
        SelfInject.new(arch, target)
      else
        Qemu.new(arch, target)
      end
    end

    # +uname -m+ of the host running the harness.
    def self.host_machine
      @host_machine ||= `uname -m`.strip
    end

    class Base
      def initialize(arch, target)
        @arch = arch
        @target = target
      end

      def driver = File.join(ROOT, 'driver.py')

      # A per-version sysroot for this fixture (under +sysroots/<arch>-<major.minor>/+),
      # or nil. Used for a libc too far from the runtime's own version to dlopen
      # directly -- it carries the matching ld.so and a park_stub linked against
      # that libc. Built on demand (and cached) when missing, so the git-ignored
      # +sysroots/+ can be deleted anytime to reclaim disk.
      #
      # Needed under a *native* transport too, not just qemu: dlopen-ing a full
      # libc.so.6 as a secondary shared object binds glibc-private, ld.so-internal
      # symbols (e.g. +_dl_exception_create+, +__tunable_get_val+) that aren't
      # ABI-stable across versions -- found via a native aarch64 host (glibc 2.43)
      # SIGILLing inside its own ld.so while calling a libc-2.27 fixture's init,
      # a version gap plenty of *qemu* runs already carry safely. A version match
      # is the only thing that's actually safe to assume needs nothing extra.
      def sysroot
        return @sysroot if defined?(@sysroot)

        ver = File.basename(@target)[/(\d+\.\d+)/, 1]
        need = ver && @arch.version_strict? && ver != default_libc_version
        dir = need && File.join(ROOT, 'sysroots', "#{@arch.name}-#{ver}")
        @sysroot = (dir && (stub_built?(dir) || build_sysroot(dir))) ? dir : nil
      end

      # Whether this run drives the target through qemu (a foreign arch, or a native
      # one forced under qemu) rather than natively.
      def qemu_transport?
        !@arch.native_on?(Transport.host_machine) || ENV['ALETHEIA_FORCE_QEMU']
      end

      # QEMU_LD_PREFIX base: the host root for a native arch (forced under qemu),
      # else the arch's cross sysroot.
      def runtime_prefix
        @arch.native_on?(Transport.host_machine) ? '/' : @arch.qemu['ld_prefix']
      end

      # glibc major.minor of the libc the runtime prefix resolves to (the host libc
      # for a native arch, the cross sysroot's otherwise).
      def default_libc_version
        libc = Dir[File.join(runtime_prefix, 'lib', '**', 'libc.so.6')].first ||
               Dir[File.join(runtime_prefix, 'lib', '*', 'libc.so.6')].first
        libc && File.binread(libc)[/GLIBC (\d+\.\d+)/, 1]
      end

      # Built, and not stale: a per-version stub is a cross-compile of park_stub.c
      # baked with the memory-layout constants (SCRATCH_SIZE etc.) current when it
      # was built. If park_stub.c has since changed, a cached stub silently drifts
      # out of sync with the driver/satisfier's current layout -- e.g. a stub built
      # before a SCRATCH_SIZE bump still only mmaps the old (smaller) size, so a
      # plan computed against the new size writes past its actual mapping and
      # faults. Rebuild whenever the source is newer than the cached binary.
      def stub_built?(dir)
        src_mtime = File.mtime(File.join(ROOT, 'park_stub.c'))
        %w[park_stub park_stub_native].all? do |name|
          stub = File.join(dir, name)
          File.file?(stub) && File.mtime(stub) >= src_mtime
        end
      end

      # A few fixtures are plain (non-Ubuntu) glibc builds and carry no "Ubuntu
      # GLIBC" banner to parse an exact package version from -- e.g.
      # libc-2.26-2104f3d4...'s banner reads "GNU C Library (GNU libc) stable
      # release version 2.26", with no Ubuntu package suffix. Recorded by hand
      # from a same-major.minor sibling fixture that does carry the banner
      # (same glibc release, so ABI-equivalent for sysroot purposes).
      NON_UBUNTU_FIXTURE_VERSIONS = {
        'libc-2.26-2104f3d4ad5cf68603afbe7ba1a17f5ac99c5988' => '2.26-0ubuntu2.1'
      }.freeze

      # Build the per-version sysroot from the fixture's own Ubuntu package version
      # (Ubuntu-sourced fixtures only). Returns whether its park_stub now exists.
      def build_sysroot(dir)
        uver = File.binread(@target)[/Ubuntu E?GLIBC (\d[^)]*)/, 1] ||
               NON_UBUNTU_FIXTURE_VERSIONS[File.basename(@target, '.so')] or return false
        warn "aletheia: building #{File.basename(dir)} sysroot (libc #{uver})..."
        system(File.join(ROOT, 'build_sysroot.sh'), @arch.name, uver, %i[out err] => File::NULL)
        stub_built?(dir)
      end

      # The park_stub to run: an explicit override, else the per-version sysroot's
      # stub, else the arch default.
      def stub
        ENV['ALETHEIA_STUB'] || (sysroot && File.join(sysroot, 'park_stub')) ||
          File.join(ROOT, @arch.stub_binary)
      end
    end

    # Native: one gdb process runs the stub directly; L2 tty via inferior-tty.
    class Native < Base
      def launch(plan_path:, stub_out:, slave:, log:)
        env = { 'ALETHEIA_PLAN' => plan_path, 'ALETHEIA_STUB_OUT' => stub_out, 'ALETHEIA_CONNECT' => 'run' }
        cmd = ['gdb', '-nx', '-q', '-batch', '-ex', "set inferior-tty #{slave.path}",
               '-x', driver, '--args', stub, @target]
        [spawn(env, *cmd, out: log, err: log, pgroup: true)]
      end

      private

      # A version-matched sysroot's normal park_stub keeps a generic interpreter
      # path (qemu's QEMU_LD_PREFIX redirects it into the sysroot) -- a real
      # execve has no such redirection, so it would still load through the
      # HOST's system ld.so, the exact mismatch {#sysroot} exists to avoid.
      # +park_stub_native+ (build_sysroot.sh) has the sysroot's own ld.so baked
      # into its interpreter via +--dynamic-linker+, so the kernel loads the
      # right one directly, and GDB still sees a normal, immediately-symboled
      # primary executable (no pending-breakpoint dance for a stub loaded only
      # via a hand-invoked interpreter).
      def stub
        return super unless sysroot && !ENV['ALETHEIA_STUB']

        File.join(sysroot, 'park_stub_native')
      end
    end

    # Qemu-user: the emulator runs the stub with the guest's stdio on the tty and
    # exposes a gdbstub; gdb-multiarch attaches over TCP and runs the driver.
    class Qemu < Base
      def launch(plan_path:, stub_out:, slave:, log:)
        q = @arch.qemu
        port = free_port
        # An explicit override, else the per-version sysroot (matching ld.so for an
        # older libc), else the runtime prefix (host root for a native arch forced
        # under qemu, the cross sysroot for a foreign one).
        ld_prefix = ENV['ALETHEIA_LD_PREFIX'] || sysroot || runtime_prefix
        qenv = { 'QEMU_LD_PREFIX' => ld_prefix, 'ALETHEIA_STUB_OUT' => stub_out }
        qpid = spawn(qenv, q['bin'], '-g', port.to_s, stub, @target,
                     in: slave, out: slave, err: log, pgroup: true)
        sleep 0.8 # let the gdbstub come up (don't pre-connect: it accepts one client)
        genv = { 'ALETHEIA_PLAN' => plan_path, 'ALETHEIA_STUB_OUT' => stub_out,
                 'ALETHEIA_CONNECT' => "localhost:#{port}", 'ALETHEIA_SYSROOT' => ld_prefix }
        gpid = spawn(genv, 'gdb-multiarch', '-nx', '-q', '-batch', '-x', driver, stub,
                     out: log, err: log, pgroup: true)
        [gpid, qpid]
      end

      def free_port
        s = TCPServer.new('127.0.0.1', 0)
        port = s.addr[1]
        s.close
        port
      end
    end

    # Self-injecting: plain qemu-user with no gdbstub. The stub applies the plan
    # (passed as text in $ALETHEIA_SELFINJECT) and jumps to the gadget itself, so
    # the whole run stays under plain qemu-user. Without gdb there is no L0 signal,
    # so a gadget is judged purely on L2 (PASS) or its absence.
    #
    # Runs qemu with +-strace+ so its syscall log lands in +log+ (the tty stays
    # clean): it lets the oracle see when qemu can't emulate a syscall the gadget
    # needs and report SKIP instead of FAIL.
    #
    # @example A limitation and its workaround
    #   glibc >= 2.34 posix_spawn forks via clone3, which qemu-arm doesn't
    #   implement ("Unknown syscall 435"). +ALETHEIA_CLONE3_HACK+ redirects the
    #   libc's __clone3 to legacy clone (see park_stub.c patch_clone3), so these
    #   spawn and L2-verify; without it they SKIP on syscall 435.
    class SelfInject < Base
      def launch(plan_path:, stub_out:, slave:, log:)
        q = @arch.qemu
        ld_prefix = ENV['ALETHEIA_LD_PREFIX'] || sysroot || q['ld_prefix']
        env = { 'QEMU_LD_PREFIX' => ld_prefix, 'ALETHEIA_STUB_OUT' => stub_out,
                'ALETHEIA_SELFINJECT' => plan_text(JSON.parse(File.read(plan_path))),
                # TEMPORARY: redirect glibc's clone3 to legacy clone so posix_spawn
                # can fork under qemu-arm (which lacks clone3). No-op if the stub's
                # signature check doesn't match. See park_stub.c patch_clone3.
                'ALETHEIA_CLONE3_HACK' => '1' }
        [spawn(env, q['bin'], '-strace', stub, @target, in: slave, out: slave, err: log, pgroup: true)]
      end

      # Render the JSON plan as the stub's line grammar (see park_stub.c). Offsets
      # are emitted as 32-bit two's-complement so a negative scratch_off survives.
      def plan_text(plan)
        lines = ["default #{default_fill(plan)}"]
        (plan['regs'] || {}).each do |name, val|
          # The stub addresses registers by number, so a role name has to be
          # resolved to one first (arm's +fp+ is +r11+). Dropping a register the
          # plan asked for would run the gadget without a value it requires and
          # report the resulting miss as the gadget's fault, so this raises.
          num = @arch.normalize_reg(name)[/\d+/]
          raise ArgumentError, "plan sets #{name}, which the stub cannot address" if num.nil?

          lines << reg_line(num, val)
        end
        (plan['mem'] || {}).each { |off, val| lines << mem_line('mem', off, val) }
        (plan['base_mem'] || {}).each { |off, val| lines << mem_line('bmem', off, val) }
        lines << "sp #{hex(plan['sp_offset'] || 0x2000)}"
        lines << "pc #{hex(Integer(plan['offset']))}"
        lines << 'thumb 1' if plan.dig('arch', 'thumb')
        "#{lines.join("\n")}\n"
      end

      def default_fill(plan)
        return 'poison' if plan['poison_default']
        return 'null' if plan['null_default']

        'benign'
      end

      def reg_line(num, val)
        if val.is_a?(Hash)
          return "reg #{num} s #{hex(val['scratch_off'])}" if val.key?('scratch_off')

          "reg #{num} b #{hex(val['base_off'])}"
        else
          "reg #{num} l #{hex(val)}"
        end
      end

      def hex(val) = format('0x%x', val & 0xffffffff)

      # A memory write the satisfier needs applied before the jump, into scratch
      # (+mem+) or a libc global (+bmem+): either a scratch pointer, so a chained
      # dereference finds a real pointer (see Satisfier#apply_deep_null), or the
      # literal a value comparison comes down to.
      def mem_line(directive, off, val)
        kind = val.is_a?(Hash) ? "s #{hex(val['scratch_off'])}" : "l #{hex(val)}"
        "#{directive} #{hex(Integer(off))} #{kind}"
      end
    end
  end
end
