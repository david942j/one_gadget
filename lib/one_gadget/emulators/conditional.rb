# frozen_string_literal: true

require 'one_gadget/helper'

module OneGadget
  module Emulators
    # Shared modelling of compare instructions and conditional branches.
    #
    # A gadget candidate may cross a conditional branch: the fetcher stitches the
    # actual taken/not-taken path (see {OneGadget::Fetcher::Base#candidates}), and
    # the emulator turns the branch decision into a gadget constraint (e.g. a
    # +cmp x2, #1; b.ne+ that must *not* be taken becomes +x2 == 0x1+).
    #
    # Branches are resolved with one line of look-ahead: at the branch we queue a
    # pending decision, and on the next line we compare that line's address to the
    # branch target to learn whether the stitched path took the branch.
    module Conditional
      # Taken-semantics for each condition code: relation + signedness (+nil+/:u/:s).
      COND_RELATION = {
        'eq' => ['==', nil], 'ne' => ['!=', nil],
        'cs' => ['>=', :u], 'hs' => ['>=', :u], 'cc' => ['<', :u], 'lo' => ['<', :u],
        'hi' => ['>', :u], 'ls' => ['<=', :u],
        'ge' => ['>=', :s], 'lt' => ['<', :s], 'gt' => ['>', :s], 'le' => ['<=', :s],
        'mi' => ['<', :s], 'pl' => ['>=', :s]
      }.freeze
      # Relation under the not-taken branch.
      NEGATE = { '==' => '!=', '!=' => '==', '>=' => '<', '<' => '>=', '>' => '<=', '<=' => '>' }.freeze

      # Record a compare so a following conditional branch can be rendered.
      # @param [Symbol] kind +:cmp+, +:cmn+ or +:tst+.
      # @param [String] lhs Rendered left operand (e.g. a register's current value).
      # @param [String] rhs Rendered right operand.
      def record_compare(kind, lhs, rhs)
        @flags = { kind:, lhs:, rhs: }
        true
      end

      # Model a compare line (+cmp+/+test+/...): record its two operands' current
      # values so a following conditional branch can be rendered. +operands+ is the
      # arch's operand splitter; +cmd+ is whatever it expects (a full line or its
      # operand part).
      def handle_compare(mnem, cmd)
        lhs, rhs = operands(cmd)
        record_compare(mnem.to_sym, operand_str(lhs), operand_str(rhs))
      end

      # The mnemonic of an objdump line (e.g. +"cmp"+, +"b.ne"+, +"je"+).
      def mnemonic(cmd)
        cmd[/\A[0-9a-f]+:\s*(\S+)/, 1] || ''
      end

      # Render an operand for a constraint: a register becomes its current value,
      # an immediate becomes hex, anything else (a memory operand) stays as-is.
      def operand_str(operand)
        return registers[operand].to_s if register?(operand)

        OneGadget::Helper.hex(Integer(operand))
      rescue ArgumentError
        operand
      end

      # Queue a cmp-based conditional branch (+b.<cond>+) for deferred resolution.
      # @return [true, :fail] +:fail+ (abort the path) when it cannot be expressed
      #   soundly, e.g. no compare was seen or a non-zero condition follows +tst+/+cmn+.
      def queue_cond_branch(cond, target)
        return :fail if @flags.nil?

        rel = COND_RELATION[cond]
        return :fail if rel.nil?
        # tst/cmn only give us a reliable zero (eq/ne) result.
        return :fail if @flags[:kind] != :cmp && !%w[eq ne].include?(cond)

        lhs = @flags[:lhs]
        rhs = @flags[:rhs]
        @pending = { target:, render: ->(taken) { relation(rel, taken, lhs, rhs) } }
        true
      end

      # Queue a compare-with-zero branch (+cbz+/+cbnz+).
      def queue_cbz(target, reg, negate:)
        hit = negate ? '!=' : '==' # cbz taken => reg == 0
        miss = negate ? '==' : '!='
        @pending = { target:, render: ->(taken) { "#{reg} #{taken ? hit : miss} 0" } }
        true
      end

      # Queue a test-bit branch (+tbz+/+tbnz+).
      def queue_tbz(target, reg, bit, negate:)
        mask = OneGadget::Helper.hex(1 << bit)
        hit = negate ? '!=' : '=='
        miss = negate ? '==' : '!='
        @pending = { target:, render: ->(taken) { "(#{reg} & #{mask}) #{taken ? hit : miss} 0" } }
        true
      end

      # Resolve a queued branch using +cmd+'s address: if it equals the branch
      # target the stitched path took the branch, else it fell through.
      # Must be called at the top of +process!+ for every line.
      def resolve_pending_branch(cmd)
        return if @pending.nil?

        taken = branch_addr(cmd) == @pending[:target]
        @constraints << [:raw, @pending[:render].call(taken)]
        @pending = nil
      end

      private

      def relation(rel, taken, lhs, rhs)
        op, sign = rel
        op = NEGATE[op] unless taken
        cast = { u: "(u#{self.class.bits})", s: "(s#{self.class.bits})" }[sign] || ''
        "#{cast}#{lhs} #{op} #{rhs}"
      end

      def branch_addr(cmd)
        cmd[/\A\s*([0-9a-f]+):/, 1].to_i(16)
      end
    end
  end
end
