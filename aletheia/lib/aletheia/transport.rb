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

      def stub = File.join(ROOT, @arch.stub_binary)
      def driver = File.join(ROOT, 'driver.py')
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
        qenv = { 'QEMU_LD_PREFIX' => q['ld_prefix'], 'ALETHEIA_STUB_OUT' => stub_out }
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
