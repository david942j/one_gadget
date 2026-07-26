# frozen_string_literal: true

require 'pty'
require 'json'
require 'timeout'
require 'tempfile'

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

    def initialize(target:, quorum: %w[bin etc usr lib proc dev tmp var],
                   startup_wait: 2, io_timeout: 6)
      @target = target
      @startup_wait = startup_wait
      @io_timeout = io_timeout
      real_root = Dir.children('/')
      @expected = quorum.select { |d| real_root.include?(d) }
    end

    # @param [Aletheia::Satisfier::Plan] plan
    # @return [Aletheia::Oracle::Result]
    def run(plan)
      Tempfile.create(['aletheia-plan', '.json']) do |f|
        f.write(JSON.generate(plan.to_h))
        f.flush
        drive(plan, f.path)
      end
    end

    private

    def drive(plan, plan_path)
      master, slave = PTY.open
      gdb_log = Tempfile.create(['aletheia-gdb', '.log'])
      gdb_log_path = gdb_log.path
      gdb_log.close
      env = { 'ALETHEIA_PLAN' => plan_path, 'ALETHEIA_TARGET' => File.expand_path(@target) }
      cmd = [
        'gdb', '-nx', '-q', '-batch',
        '-ex', "set inferior-tty #{slave.path}",
        '-x', File.join(ROOT, 'driver.py'),
        '--args', File.join(ROOT, 'park_stub'), @target
      ]
      # Own process group so a wedged inferior (e.g. a gadget that neither execs
      # nor faults) can be killed wholesale rather than blocking the sweep.
      pid = spawn(env, *cmd, out: gdb_log_path, err: gdb_log_path, pgroup: true)
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
      reap(pid)
      log = File.read(gdb_log_path)
      File.unlink(gdb_log_path)
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
      else
        Result.new(result: 'FAIL', reason: 'no execve("/bin/sh") and no shell output', **common)
      end
    end

    # Wait briefly for gdb to exit; if it doesn't (a wedged inferior), kill the
    # whole process group so we never block the sweep.
    def reap(pid)
      Timeout.timeout(3) { Process.wait(pid) }
    rescue Timeout::Error
      (Process.kill('-KILL', Process.getpgid(pid)) rescue nil)
      (Process.wait(pid) rescue nil)
    rescue Errno::ECHILD
      nil
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
