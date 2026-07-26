# frozen_string_literal: true

require 'json'
require 'one_gadget'

require_relative 'arch/aarch64'
require_relative 'satisfier'
require_relative 'oracle'

module Aletheia
  # Ties the pieces together: enumerate a libc's gadgets, satisfy each into a
  # plan, run the oracle, and aggregate machine-readable results.
  #
  # A gadget is reported as:
  #   PASS  - the spawned shell listed the real root (see {Oracle})
  #   FAIL  - a complete, satisfied plan still failed to yield a working shell
  #           (a candidate one_gadget bug -- most often a missing constraint)
  #   SKIP  - the satisfier could not produce a plan (a harness limitation, not
  #           a verdict on the gadget)
  class Runner
    ARCHES = { 'aarch64' => Arch::AArch64 }.freeze

    def initialize(target:, arch: Arch::AArch64, strict: false)
      @target = target
      @arch = arch
      @satisfier = Satisfier.new(arch, strict: strict)
      @oracle = Oracle.new(target: target)
    end

    # @param [Array<Integer>, nil] offsets restrict to these gadget offsets
    # @param [Integer] level one_gadget output level; 0 keeps only the
    #   highest-scoring gadgets, 1 enumerates every gadget found
    # @return [Array<Hash>] one result record per gadget
    def run(offsets: nil, level: 0, &block)
      gadgets = OneGadget.gadgets(file: @target, force_file: true, details: true, level: level)
      gadgets = gadgets.select { |g| offsets.include?(g.offset) } if offsets
      gadgets.map do |g|
        result = verify(g)
        block&.call(result)
        result
      end
    end

    private

    def verify(gadget)
      verify!(gadget)
    rescue StandardError => e
      { offset: format('%#x', gadget.offset), effect: gadget.effect,
        result: 'SKIP', reason: "harness error: #{e.class}: #{e.message}" }
    end

    def verify!(gadget)
      plan = @satisfier.satisfy(gadget)
      record = {
        offset: format('%#x', gadget.offset),
        effect: gadget.effect,
        constraints: gadget.constraints,
        chosen_branches: plan.branches,
        plan_regs: plan.regs.transform_values { |v| v.is_a?(Integer) ? format('%#x', v) : v }
      }
      if plan.status == 'skip'
        return record.merge(result: 'SKIP', reason: plan.reason)
      end

      res = @oracle.run(plan)
      record.merge(
        result: res.result, reason: res.reason, base: res.base, l0: res.l0,
        seen_root_entries: res.seen, expected_root_entries: res.expected
      )
    end
  end
end
