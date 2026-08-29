# frozen_string_literal: true

module OneGadget
  module Fetchers
    # Where a gadget could start: a backward control-flow walk from each terminal
    # call, yielding every instruction sequence that reaches it. A conditional
    # branch on the way is explored both ways and its decision becomes a constraint
    # on the candidate, bounded so a loop-heavy region cannot fork forever. Mixed
    # into {Base}.
    module CandidateWalk
      # Give up on a control-flow path once it has crossed this many conditional branches.
      MAX_FORKS = 4

      # Hard cap on a single path's length (loop/runaway guard).
      PATH_BUDGET = 80

      # Fetch candidates that end with call exec*.
      #
      # Provide a block to filter gadget candidates.
      # @yieldparam [String] cand
      #   Is this candidate valid?
      # @yieldreturn [Boolean]
      #   True for valid.
      # @return [Array<String>]
      #   Each +String+ returned is multi-lines of assembly code.
      def candidates(&)
        branch_aware_candidates(&)
      end

      private

      # Enumerate gadget candidates by walking the control-flow graph *backward*
      # from each terminal call along its predecessors (the instruction that falls
      # through to it, plus any branch that targets it), forking at conditional
      # edges up to {MAX_FORKS} times. Each emitted candidate is a flat,
      # address-preserving line-list ending at the terminal call, consumed
      # unchanged by {#find}; the emulator turns each crossed conditional edge into
      # a constraint (see {OneGadget::Emulators::Conditional}).
      def branch_aware_candidates(&)
        cands = []
        re = /#{terminal_call_regexp}/
        disasm_lines.each_with_index do |line, idx|
          next unless line.match?(re)

          back_walk(idx, 0, Set.new, []) { |lines| cands << lines.join("\n") }
        end
        cands.uniq!
        cands.select!(&) if block_given?
        cands
      end

      # Depth-first backward walk. +visited+ (a Set) and +path+ are mutated with
      # backtracking so a fork explores independently without per-step copies;
      # +path+ is built in forward order (the terminal call stays last). Emits a
      # candidate at each leaf - {#find} then tries every start line within it.
      def back_walk(idx, forks, visited, path, &blk)
        addr = addr_at(idx)
        return if path.size >= PATH_BUDGET

        visited.add(addr)
        path.unshift(disasm_lines[idx])
        edges = predecessors(idx).reject do |pidx, cond|
          visited.include?(addr_at(pidx)) || (cond && forks >= MAX_FORKS)
        end
        if edges.empty?
          blk.call(path.dup)
        else
          edges.each { |pidx, cond| back_walk(pidx, forks + (cond ? 1 : 0), visited, path, &blk) }
        end
        path.shift
        visited.delete(addr)
      end

      # The address of the instruction at +idx+, remembered as it is asked for.
      # Only the lines the backward walk reaches ever need one, a small part of a
      # whole libc's disassembly.
      def addr_at(idx)
        (@addr_at ||= {})[idx] ||= offset_of(disasm_lines[idx])
      end

      # Predecessors of +disasm_lines[idx]+ as +[pred_index, conditional_edge?]+:
      # the instruction that falls through to it, plus any branch that targets it.
      # Computed lazily (the walk only touches lines near terminal calls) and cached.
      def predecessors(idx)
        (@predecessors ||= {})[idx] ||= begin
          preds = []
          # Nothing falls through into the first line of a window: the line before
          # it is the last of another window, a different part of the binary.
          if idx.positive? && !window_starts.key?(idx)
            kind = branch_kind(disasm_lines[idx - 1])
            preds << [idx - 1, kind == :conditional] unless %i[unconditional terminator].include?(kind)
          end
          (branch_pred_map[addr_at(idx)] || []).each do |b|
            preds << [b, branch_kind(disasm_lines[b]) == :conditional]
          end
          preds
        end
      end

      # Map of target-address => indexes of (conditional or unconditional) direct
      # branches that jump there. Scans the whole disassembly once (a branch can
      # target a call region from anywhere), so keep the per-line test cheap.
      def branch_pred_map
        @branch_pred_map ||= Base.cached(:branch_pred, @objdump.command) do
          lead = branch_lead_regex
          disasm_lines.each_with_index.with_object(Hash.new { |h, k| h[k] = [] }) do |(line, i), map|
            # Cheap precompiled reject (no per-line allocation) before the full test.
            next unless line.match?(lead)
            next unless %i[conditional unconditional].include?(branch_kind(line))

            tgt = branch_target(line)
            map[tgt] << i if tgt
          end
        end
      end

      # Precompiled over-approximation of a branch line, built from the arch's
      # {#branch_lead_chars}, to skip the full test for the (majority) non-branch
      # lines during the whole-binary scan.
      def branch_lead_regex
        @branch_lead_regex ||= /\A[0-9a-f]+:\s+[#{branch_lead_chars}]/
      end

      # Parse the (direct) target address of a branch line, or +nil+ if indirect.
      def branch_target(line)
        line.sub(/\A[0-9a-f]+:\s*\S+\s*/, '')[/\b([0-9a-f]+)\b\s*(?:<|\z)/, 1]&.to_i(16)
      end

      # The mnemonic of an objdump line, memoized because each line is tested by
      # several branch predicates during the CFG scan.
      # @example
      #   mnemonic('4a1d0: b.ne 4a200 <foo>') #=> 'b.ne'
      #   mnemonic('4a1c0: cbz  x0, 4a200')   #=> 'cbz'
      def mnemonic(line)
        (@mnemonic ||= {})[line] ||= line[/\A[0-9a-f]+:\s*(\S+)/, 1] || ''
      end

      # Where in {#disasm_lines} each window begins, keyed for lookup. Empty when
      # the whole file was disassembled, since then every line does follow the one
      # before it.
      # @return [Hash{Integer => true}]
      def window_starts
        disassembly[:starts]
      end
    end
  end
end
