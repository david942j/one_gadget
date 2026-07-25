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

    Result = Struct.new(:result, :reason, :base, :shell_output, :seen, :expected,
                        keyword_init: true)

    def initialize(target:, quorum: %w[bin etc usr lib proc dev tmp var],
                   startup_wait: 2, io_timeout: 12)
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
      pid = spawn(env, *cmd, out: gdb_log_path, err: gdb_log_path)
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
      Process.wait(pid)
      base = File.read(gdb_log_path)[/ALETHEIA base=(0x[0-9a-f]+)/, 1]
      File.unlink(gdb_log_path)

      seen = @expected.select { |d| output.include?(d) }
      if !@expected.empty? && seen.sort == @expected.sort
        Result.new(result: 'PASS', reason: nil, base: base, shell_output: output,
                   seen: seen, expected: @expected)
      else
        Result.new(result: 'FAIL', reason: 'shell did not list the real root',
                   base: base, shell_output: output, seen: seen, expected: @expected)
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
