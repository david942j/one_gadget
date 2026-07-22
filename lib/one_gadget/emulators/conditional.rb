# frozen_string_literal: true

require 'one_gadget/helper'

module OneGadget
  module Emulators
    # Shared modelling of compare instructions and conditional branches.
    #
    # A gadget candidate may cross a conditional branch: the fetcher stitches the
    # actual taken/not-taken path (see {OneGadget::Fetcher::Base#candidates}), and
    # the emulator turns the branch decision into a gadget constraint.
    #
    # Branches are resolved with one line of look-ahead: at the branch we queue a
    # pending decision, and on the next line we compare that line's address to the
    # branch target to learn whether the stitched path took the branch.
    #
    # @example A +b.ne+ whose branch is *not* taken becomes the constraint +x2 == 0x1+
    #   #   c7a4c: cmp  x2, 1
    #   #   c7a50: b.ne c7a9c    # stitched path falls through (does not jump)
    #   # => emitted gadget constraint:  x2 == 0x1
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
      # Normally reached through {#handle_compare}; call it directly only when an
      # arch models a flag-setting instruction that {#handle_compare} doesn't cover.
      # @param [Symbol] kind +:cmp+, +:cmn+ or +:tst+.
      # @param [String] lhs Rendered left operand: a register's current value, or an immediate in hex.
      # @param [String] rhs Rendered right operand.
      # @return [true]
      # @example Remember that +x2+ (currently holding +0x1+) was compared with +0x1+
      #   record_compare(:cmp, '0x1', '0x1') #=> true
      #   # a following +b.ne+ that is *not* taken now renders as  0x1 != 0x1
      #   # (a contradiction -> the candidate is dropped as infeasible)
      def record_compare(kind, lhs, rhs)
        @flags = { kind:, lhs:, rhs: }
        true
      end

      # Model a compare line (+cmp+/+test+/...): record its two operands' current
      # values so a following conditional branch can be rendered.
      #
      # Call this from +process!+ when the mnemonic is one of the arch's compares,
      # *before* dispatching to the +inst_*+ handlers.
      # @param [String] mnem The compare mnemonic; becomes the recorded +kind+.
      # @param [String] cmd Passed to the arch's +operands+ splitter, so it is whatever
      #   that splitter expects (a full objdump line, or just its operand part).
      # @return [true]
      # @example Wiring in an arch's +process!+ (aarch64)
      #   mnem = mnemonic(cmd)
      #   return handle_compare(mnem, cmd) if %w[cmp cmn tst].include?(mnem)
      # @example What it records for +cmp x2, #1+ (with +#1+ already normalized to +1+)
      #   handle_compare('cmp', '4a1c0: cmp x2, 1') #=> true
      #   # records lhs = x2's current value, rhs = 0x1, ready for the next branch
      def handle_compare(mnem, cmd)
        lhs, rhs = operands(cmd)
        record_compare(mnem.to_sym, operand_str(lhs), operand_str(rhs))
      end

      # The mnemonic of an objdump line. Use it at the top of +process!+ to decide
      # whether a line is a compare or a branch.
      # @param [String] cmd One objdump line.
      # @return [String] The mnemonic, or +''+ when the line has none.
      # @example
      #   mnemonic('4a1c0: cmp x2, 1')           #=> 'cmp'
      #   mnemonic('4a1d0: b.ne 4a200 <foo>')    #=> 'b.ne'
      #   mnemonic('4a1d4: je   4a200')          #=> 'je'
      #   mnemonic('')                           #=> ''
      def mnemonic(cmd)
        cmd[/\A[0-9a-f]+:\s*(\S+)/, 1] || ''
      end

      # Render an operand for a constraint: a register becomes its current value,
      # an immediate becomes hex, anything else (a memory operand) stays as-is.
      # {#handle_compare} uses it on each compare operand; call it yourself only
      # when writing a bespoke +queue_*+ helper.
      # @param [String] operand A single operand string from a compare/branch line.
      # @return [String] The rendered operand.
      # @example (assuming register +x2+ currently holds the immediate +0x1+)
      #   operand_str('x2')       #=> '0x1'       # a register -> its current value
      #   operand_str('0x40')     #=> '0x40'      # a hex immediate -> unchanged
      #   operand_str('16')       #=> '0x10'      # a decimal immediate -> hex
      #   operand_str('[sp+0x8]') #=> '[sp+0x8]'  # a memory operand -> unchanged
      def operand_str(operand)
        return registers[operand].to_s if register?(operand)

        OneGadget::Helper.hex(Integer(operand))
      rescue ArgumentError
        operand
      end

      # Queue a cmp-based conditional branch (+b.<cond>+) for deferred resolution.
      # Call it from +handle_branch+ for any conditional branch that reads flags;
      # +cond+ is the arch-independent condition code (a {COND_RELATION} key) and
      # +target+ is the branch's direct destination address.
      # @param [String] cond The arch-independent condition code, a {COND_RELATION}
      #   key. aarch64 passes +b.ne+ as +'ne'+; x86 maps +jne+ through its +JCC+ table.
      # @param [Integer] target Destination address of the branch.
      # @return [true, :fail] +:fail+ (abort the path) when it cannot be expressed
      #   soundly: no compare was seen, or a non-zero condition follows +tst+/+cmn+.
      # @example After +cmp x2, #1+, queue the following +b.ne 4a200+
      #   queue_cond_branch('ne', 0x4a200) #=> true
      #   # if the stitched path FALLS THROUGH (doesn't reach 0x4a200) the not-taken
      #   # relation of +!=+ is emitted:  x2 == 0x1 ; if it jumps there:  x2 != 0x1
      # @example No preceding compare -> the path is unsound and is aborted
      #   queue_cond_branch('ne', 0x4a200) #=> :fail   # when @flags is nil
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

      # Queue a compare-with-zero branch (+cbz+/+cbnz+). These carry their own
      # compare, so no preceding +cmp+ is needed. +negate:+ distinguishes the
      # branch-if-zero form (+cbz+, +false+) from branch-if-non-zero (+cbnz+, +true+).
      # @param [Integer] target Destination address of the branch.
      # @param [String] reg The tested register, already rendered (as {#operand_str} returns).
      # @param [Boolean] negate +false+ for +cbz+, +true+ for +cbnz+.
      # @example aarch64 +cbz x0, 4a200+ - branch taken when +x0 == 0+
      #   queue_cbz(0x4a200, 'x0', negate: false) #=> true
      #   # fall-through path emits  x0 != 0 ; taken path emits  x0 == 0
      # @example x86 reuses it for +jrcxz+/+jecxz+/+jcxz+ (always branch-if-zero)
      #   queue_cbz(0x4a200, 'rcx', negate: false)
      def queue_cbz(target, reg, negate:)
        hit = negate ? '!=' : '==' # cbz taken => reg == 0
        miss = negate ? '==' : '!='
        @pending = { target:, render: ->(taken) { "#{reg} #{taken ? hit : miss} 0" } }
        true
      end

      # Queue a test-bit branch (+tbz+/+tbnz+): also self-contained (no preceding
      # +cmp+). Renders a bitmask test of a single bit.
      # @param [Integer] target Destination address of the branch.
      # @param [String] reg The tested register, already rendered (as {#operand_str} returns).
      # @param [Integer] bit The bit index being tested.
      # @param [Boolean] negate +false+ for +tbz+, +true+ for +tbnz+.
      # @example aarch64 +tbz w0, #4, 4a200+ - branch taken when bit 4 of +w0+ is 0
      #   queue_tbz(0x4a200, 'w0', 4, negate: false) #=> true
      #   # taken path emits  (w0 & 0x10) == 0 ; fall-through emits  (w0 & 0x10) != 0
      def queue_tbz(target, reg, bit, negate:)
        mask = OneGadget::Helper.hex(1 << bit)
        hit = negate ? '!=' : '=='
        miss = negate ? '==' : '!='
        @pending = { target:, render: ->(taken) { "(#{reg} & #{mask}) #{taken ? hit : miss} 0" } }
        true
      end

      # Resolve a queued branch using +cmd+'s address: if it equals the branch
      # target the stitched path took the branch, else it fell through. On
      # resolution the rendered relation is appended to the gadget's constraints.
      # Must be called at the top of +process!+ for every line (a no-op when nothing
      # is pending), so the branch queued on the previous line sees this line's address.
      # @param [String] cmd The current objdump line.
      # @example The fixed first line of every arch's +process!+
      #   def process!(cmd)
      #     resolve_pending_branch(cmd)
      #     ...
      #   end
      #   # if the previous line did +queue_cond_branch('ne', 0x4a200)+ and this
      #   # +cmd+ sits at 0x4a200, the branch was taken; otherwise it fell through
      def resolve_pending_branch(cmd)
        return if @pending.nil?

        taken = branch_addr(cmd) == @pending[:target]
        @constraints << [:raw, @pending[:render].call(taken)]
        @pending = nil
      end

      private

      # Render a relational constraint from a {COND_RELATION} entry, flipping the
      # operator via {NEGATE} on the not-taken edge and prefixing a signedness cast.
      # @example +b.ne+ that is not taken, after +cmp x2, 1+ (64-bit arch)
      #   relation(['!=', nil], false, 'x2', '0x1') #=> 'x2 == 0x1'
      # @example +b.cs+ (unsigned >=) that is taken
      #   relation(['>=', :u], true, 'x0', '0x10')  #=> '(u64)x0 >= 0x10'
      def relation(rel, taken, lhs, rhs)
        op, sign = rel
        op = NEGATE[op] unless taken
        cast = { u: "(u#{self.class.bits})", s: "(s#{self.class.bits})" }[sign] || ''
        "#{cast}#{lhs} #{op} #{rhs}"
      end

      # The address of an objdump line, used to tell whether the pending branch
      # was taken.
      # @example
      #   branch_addr('4a200: nop') #=> 0x4a200
      def branch_addr(cmd)
        cmd[/\A\s*([0-9a-f]+):/, 1].to_i(16)
      end
    end
  end
end
