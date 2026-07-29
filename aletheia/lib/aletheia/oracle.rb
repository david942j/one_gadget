# frozen_string_literal: true

require 'pty'
require 'json'
require 'timeout'
require 'tempfile'

require_relative 'transport'
require_relative 'arch/aarch64'

module Aletheia
  # The success oracle. Launches the target libc under gdb with the plan
  # injected, then drives the spawned shell over a pty and validates that it can
  # run +ls /+ and reproduce the host's real root directory. That empirical
  # result -- a real shell listing the real filesystem -- is what decides PASS,
  # independent of anything one_gadget reports.
  class Oracle
    HERE = File.expand_path('..', __dir__) # aletheia/lib
    ROOT = File.expand_path('..', HERE)    # aletheia/

    Result = Struct.new(:result, :reason, :base, :shell_output, :seen, :expected, :l0,
                        keyword_init: true)

    def initialize(target:, arch: Arch::AArch64, quorum: %w[bin etc usr lib proc dev tmp var],
                   startup_wait: 2, io_timeout: 6)
      @target = target
      @arch = arch
      @transport = Transport.for(arch, target)
      @startup_wait = startup_wait
      @io_timeout = io_timeout
      real_root = Dir.children('/')
      @expected = quorum.select { |d| real_root.include?(d) }
    end

    # @param [Aletheia::Satisfier::Plan] plan
    # @return [Aletheia::Oracle::Result]
    def run(plan)
      plan_hash = plan.to_h.merge(arch: @arch.driver_model)
      Tempfile.create(['aletheia-plan', '.json']) do |f|
        f.write(JSON.generate(plan_hash))
        f.flush
        drive(f.path)
      end
    end

    private

    def drive(plan_path)
      master, slave = PTY.open
      log_path = tempfile_path('aletheia-gdb', '.log')
      stub_out = tempfile_path('aletheia-stub', '.txt')
      # Own process group(s) so a wedged inferior can be killed wholesale.
      pids = @transport.launch(plan_path: plan_path, stub_out: stub_out, slave: slave, log: log_path)
      slave.close

      begin
        Timeout.timeout(@startup_wait + 2) do
          sleep @startup_wait
          master.write("ls /\n")
          master.write("exit\n")
        end
      rescue Errno::EIO, Timeout::Error
        # fall through to reading whatever is available
      end

      output = read_all(master)
      reap(pids)
      log = File.read(log_path)
      [log_path, stub_out].each { |p| File.unlink(p) rescue nil }
      base = log[/ALETHEIA base=(0x[0-9a-f]+)/, 1]
      l0 = log.include?('ALETHEIA_L0=pass')

      seen = @expected.select { |d| output.include?(d) }
      common = { base: base, shell_output: output, seen: seen, expected: @expected, l0: l0 }
      if !@expected.empty? && seen.sort == @expected.sort
        # L2: the spawned shell actually listed the real root.
        Result.new(result: 'PASS', reason: nil, **common)
      elsif l0
        # The gadget reached execve("/bin/sh") with valid args, but the harness
        # could not drive `ls /` through this shell (e.g. a fixed `-c` command,
        # an uncontrolled argv[1], or a posix_spawn parent/child tty race).
        Result.new(result: 'EXEC', reason: 'execve("/bin/sh") reached; shell not L2-drivable', **common)
      elsif (sysno = log[/Unknown syscall (\d+)/, 1])
        # The emulator (qemu-user, -strace) hit a syscall it doesn't implement, so
        # the gadget couldn't run to a shell. A harness limit, not a gadget verdict.
        # @example qemu-arm lacks clone3 (435), which glibc posix_spawn forks with.
        Result.new(result: 'SKIP', reason: "qemu could not emulate syscall #{sysno} (harness limitation)", **common)
      else
        Result.new(result: 'FAIL', reason: 'no execve("/bin/sh") and no shell output', **common)
      end
    end

    # A fresh temp file path (created empty, closed) for a subprocess to write.
    def tempfile_path(prefix, suffix)
      f = Tempfile.create([prefix, suffix])
      path = f.path
      f.close
      path
    end

    # Wait briefly for each pid to exit; kill any wedged process group wholesale so
    # we never block the sweep. Reap the driver first, then the emulator.
    def reap(pids)
      Array(pids).each do |pid|
        Timeout.timeout(3) { Process.wait(pid) }
      rescue Timeout::Error
        (Process.kill('-KILL', Process.getpgid(pid)) rescue nil)
        (Process.wait(pid) rescue nil)
      rescue Errno::ECHILD
        nil
      end
    end

    def read_all(master)
      buf = +''
      Timeout.timeout(@io_timeout) { loop { buf << master.readpartial(4096) } }
      buf
    rescue Errno::EIO, EOFError, Timeout::Error
      buf
    end
  end
end
