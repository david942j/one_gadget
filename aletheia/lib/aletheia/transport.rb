# frozen_string_literal: true

require 'socket'

module Aletheia
  # How the target process is launched and driven: natively (host arch) or under
  # qemu-user (foreign arch) via a gdbstub. Both expose the same contract to the
  # oracle -- launch the stub + gdb driver with the guest's tty on +slave+ -- and
  # return the pids to reap. The self-describing park_stub means neither transport
  # needs inferior function calls or /proc access from gdb.
  module Transport
    ROOT = File.expand_path('../..', __dir__) # aletheia/

    # @return [Transport::Native, Transport::Qemu]
    def self.for(arch, target)
      arch.qemu ? Qemu.new(arch, target) : Native.new(arch, target)
    end

    class Base
      def initialize(arch, target)
        @arch = arch
        @target = target
      end

      def driver = File.join(ROOT, 'driver.py')

      # A per-version sysroot for this fixture (under +sysroots/<arch>-<major.minor>/+),
      # or nil. Used for a foreign libc too old to dlopen under the default cross
      # sysroot -- it carries the matching ld.so and a park_stub linked against that
      # libc. Built on demand (and cached) when missing, so the git-ignored
      # +sysroots/+ can be deleted anytime to reclaim disk.
      def sysroot
        return @sysroot if defined?(@sysroot)

        ver = File.basename(@target)[/(\d+\.\d+)/, 1]
        # The default cross sysroot already loads its own toolchain version; only a
        # DIFFERENT version on a version-strict arch (i386) needs a matched sysroot.
        need = ver && @arch.version_strict? && ver != default_libc_version
        dir = need && File.join(ROOT, 'sysroots', "#{@arch.name}-#{ver}")
        @sysroot = (dir && (stub_built?(dir) || build_sysroot(dir))) ? dir : nil
      end

      # glibc major.minor of the arch's default cross sysroot (its +ld_prefix+ libc).
      def default_libc_version
        libc = Dir[File.join(@arch.qemu['ld_prefix'], 'lib', '**', 'libc.so.6')].first
        libc && File.binread(libc)[/GLIBC (\d+\.\d+)/, 1]
      end

      def stub_built?(dir) = File.file?(File.join(dir, 'park_stub'))

      # Build the per-version sysroot from the fixture's own Ubuntu package version
      # (Ubuntu-sourced fixtures only). Returns whether its park_stub now exists.
      def build_sysroot(dir)
        uver = File.binread(@target)[/Ubuntu E?GLIBC (\d[^)]*)/, 1] or return false
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
    end

    # Qemu-user: the emulator runs the stub with the guest's stdio on the tty and
    # exposes a gdbstub; gdb-multiarch attaches over TCP and runs the driver.
    class Qemu < Base
      def launch(plan_path:, stub_out:, slave:, log:)
        q = @arch.qemu
        port = free_port
        # An explicit override, else the per-version sysroot (matching ld.so for an
        # older foreign libc), else the arch's default cross sysroot.
        ld_prefix = ENV['ALETHEIA_LD_PREFIX'] || sysroot || q['ld_prefix']
        qenv = { 'QEMU_LD_PREFIX' => ld_prefix, 'ALETHEIA_STUB_OUT' => stub_out }
        qpid = spawn(qenv, q['bin'], '-g', port.to_s, stub, @target,
                     in: slave, out: slave, err: log, pgroup: true)
        sleep 0.8 # let the gdbstub come up (don't pre-connect: it accepts one client)
        genv = { 'ALETHEIA_PLAN' => plan_path, 'ALETHEIA_STUB_OUT' => stub_out,
                 'ALETHEIA_CONNECT' => "localhost:#{port}" }
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
  end
end
