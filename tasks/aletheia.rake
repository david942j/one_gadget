# frozen_string_literal: true

ARCHES = %w[aarch64 amd64 arm i386].freeze
FIXTURES = 'spec/data/*.so'

namespace :aletheia do
  desc 'Run every gadget one_gadget reports for a libc and check a real shell comes back'
  # Verification is always strict: whatever a gadget's constraints do not name is
  # poisoned, so an incomplete constraint list fails here instead of passing by
  # luck. Needs the harness's prerequisites -- see aletheia/README.md.
  #
  # bundle exec rake aletheia:verify                              # every fixture, level 0
  # bundle exec rake "aletheia:verify[1]"                         # deeper output level
  # bundle exec rake "aletheia:verify[0, arm]"                    # one architecture
  # bundle exec rake "aletheia:verify[2, spec/data/arm-libc-2.39.so]"
  task :verify, :level, :target do |_t, args|
    require 'json'

    bin = File.expand_path('../aletheia/bin/aletheia', __dir__)
    raise "#{bin} is missing; the harness lives on the aletheia branch" unless File.executable?(bin)

    level = (args.level || 0).to_i
    targets = aletheia_targets(args.target)
    raise "no libc matches #{args.target.inspect}" if targets.empty?

    totals = Hash.new(0)
    targets.each do |file|
      results = aletheia_verify(bin, file, level)
      results.each { |r| totals[r['result']] += 1 }
      report(file, results)
    end
    puts "level #{level}: #{totals.sort.map { |result, n| "#{n} #{result}" }.join(', ')}"
    unverified = totals.sum { |result, n| result == 'PASS' ? 0 : n }
    raise "#{unverified} gadgets did not verify" unless unverified.zero?
  end

  # A libc to verify: everything shipped for the specs by default, an
  # architecture's share of them, or whatever a path or glob names.
  # @param [String, nil] target
  # @return [Array<String>]
  def aletheia_targets(target)
    return Dir.glob(FIXTURES) if target.nil? || target.empty?

    target = target.strip
    if ARCHES.include?(target)
      require 'one_gadget'
      return Dir.glob(FIXTURES).select { |f| OneGadget::Helper.architecture(f).to_s == target }
    end

    Dir.glob(target).select { |f| File.file?(f) }
  end

  # @return [Array<Hash>] one entry per gadget, as the harness reports it.
  def aletheia_verify(bin, file, level)
    out = IO.popen([bin, 'verify', file, '--level', level.to_s, '--strict', '--json'], &:read)
    out.lines.filter_map { |l| JSON.parse(l) rescue nil } # rubocop:disable Style/RescueModifier
  end

  def report(file, results)
    counts = results.group_by { |r| r['result'] }.transform_values(&:size)
    puts format('%-56s %s', File.basename(file), counts.sort.map { |k, v| "#{v} #{k}" }.join(', '))
    results.reject { |r| r['result'] == 'PASS' }.each do |r|
      puts format('    %-10s %s  %s', r['result'], r['offset'], r['reason'])
    end
  end
end
