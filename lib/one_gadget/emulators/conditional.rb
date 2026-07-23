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
      # Taken-semantics of each supported branch condition, keyed by a predicate
      # named after the comparison it encodes (the LLVM +icmp+ names): a leading
      # +u+ = unsigned, +s+ = signed. Value is +[relation, signedness]+, where
      # signedness (+nil+/+:u+/+:s+) selects the operand cast.
      #   :eq  :ne                equality
      #   :ult :ule :ugt :uge     unsigned  <  <=  >  >=
      #   :slt :sle :sgt :sge     signed    <  <=  >  >=
      RELATION = {
        eq: ['==', nil], ne: ['!=', nil],
        ult: ['<', :u], ule: ['<=', :u], ugt: ['>', :u], uge: ['>=', :u],
        slt: ['<', :s], sle: ['<=', :s], sgt: ['>', :s], sge: ['>=', :s]
      }.freeze

      # Relation under the not-taken branch.
      NEGATE = { '==' => '!=', '!=' => '==', '>=' => '<', '<' => '>=', '>' => '<=', '<=' => '>' }.freeze

      # The flag-setting compares we model, keyed by the ALU operation the compare
      # performs -- its flags reflect that result. +ordered+ says whether magnitude
      # conditions (anything beyond +eq+/+ne+) are sound afterwards; the constraint
      # text for each op is rendered by {#compare_constraint}. An arch maps its own
      # mnemonics onto these ops (its +COMPARES+); adding an arch needs no change
      # here. Adding a genuinely new ALU op means one entry here plus a branch in
      # {#compare_constraint}.
      COMPARE = {
        sub: { ordered: true },  # cmp:      flags from  lhs - rhs
        add: { ordered: true },  # cmn:      flags from  lhs + rhs
        and: { ordered: false }  # tst/test: flags from  lhs & rhs  (zero flag only)
      }.freeze

      # Record a compare so a following conditional branch can be rendered.
      # Normally reached through {#handle_compare}; call it directly only when an
      # arch models a flag-setting instruction that {#handle_compare} doesn't cover.
      # @param [Symbol] op The ALU operation the compare performs -- a {COMPARE} key
      #   (+:sub+ for +cmp+, +:add+ for +cmn+, +:and+ for +tst+/+test+). Its flags
      #   reflect this result, which decides both which branch conditions are
      #   expressible and how the constraint is rendered. Arches map their own
      #   mnemonics to these ops (their +COMPARES+); a new arch adds a {COMPARE}
      #   entry only for a genuinely new operation.
      # @param [String] lhs Rendered left operand: a register's current value, or an immediate in hex.
      # @param [String] rhs Rendered right operand.
      # @return [true]
      # @example Record +cmp x2, 0x1+ (subtraction), readying the next branch
      #   record_compare(:sub, '0x1', '0x1') #=> true
      #   # a following +b.ne+ not taken renders  0x1 == 0x1  (a stripped tautology)
      def record_compare(op, lhs, rhs)
        @flags = { op:, lhs:, rhs: }
        true
      end

      # Model a compare line: record its two operands' current values under the
      # compare's ALU op, so a following conditional branch can be rendered.
      #
      # Call this from +process!+ when the mnemonic is one of the arch's compares
      # (its +COMPARES+ maps the mnemonic to the op), *before* dispatching to the
      # +inst_*+ handlers.
      # @param [Symbol] op The compare's ALU operation (a {COMPARE} key), which the
      #   arch resolves from the mnemonic.
      # @param [String] cmd Passed to the arch's +operands+ splitter, so it is whatever
      #   that splitter expects (a full objdump line, or just its operand part).
      # @return [true]
      # @example Wiring in an arch's +process!+ (its +COMPARES+ holds the mnemonic map)
      #   return handle_compare(COMPARES[mnem], cmd) if COMPARES.key?(mnem)
      # @example What it records for +cmp x2, 1+ (x2 currently 0x30)
      #   handle_compare(:sub, '4a1c0: cmp x2, 1') #=> true
      #   # records op :sub, lhs = 0x30, rhs = 0x1, ready for the next branch
      def handle_compare(op, cmd)
        lhs, rhs = operands(cmd)
        record_compare(op, operand_str(lhs), operand_str(rhs))
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
      # +cond+ is the comparison predicate and +target+ is the branch's direct
      # destination address.
      # @param [Symbol] cond The comparison predicate, a {RELATION} key. Each arch
      #   first maps its own branch mnemonic to it (its +COND+/+JCC+ adapter table).
      # @param [Integer] target Destination address of the branch.
      # @return [true, :fail] +:fail+ (abort the path) when it cannot be expressed
      #   soundly: no compare was seen, or a magnitude condition follows an
      #   equality-only compare (a {COMPARE} op with +ordered: false+, e.g. +tst+).
      # @example After +cmp x2, #1+, queue the following +b.ne 4a200+ (arch maps +b.ne+ to +:ne+)
      #   queue_cond_branch(:ne, 0x4a200) #=> true
      #   # if the stitched path FALLS THROUGH (doesn't reach 0x4a200) the not-taken
      #   # relation of +:ne+ is emitted:  x2 == 0x1 ; if it jumps there:  x2 != 0x1
      # @example No preceding compare -> the path is unsound and is aborted
      #   queue_cond_branch(:ne, 0x4a200) #=> :fail   # when @flags is nil
      def queue_cond_branch(cond, target)
        return :fail if @flags.nil?

        rel = RELATION[cond]
        return :fail if rel.nil?
        # A magnitude condition needs a compare whose flags reflect a full ordering
        # (+:sub+/+:add+); an equality-only compare (+:and+) supports just eq/ne.
        return :fail unless COMPARE[@flags[:op]][:ordered] || %i[eq ne].include?(cond)

        op = @flags[:op]
        lhs = @flags[:lhs]
        rhs = @flags[:rhs]
        @pending = { target:, render: ->(taken) { compare_constraint(op, lhs, rhs, rel, taken) } }
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

      # Render the constraint a taken/not-taken branch imposes on the recorded
      # compare: flip the operator via {NEGATE} on the not-taken edge, prefix the
      # signedness cast, then format per the compare's {COMPARE} op:
      #   :sub  ->  "lhs <op> rhs"            (cmp is a direct comparison)
      #   :add  ->  "(lhs + rhs) <op> 0"      (cmn compares the sum against 0)
      #   :and  ->  "(lhs & rhs) <op> 0", or  "lhs <op> 0" when both sides are the
      #             same operand (the common +test reg, reg+ / +tst rN, rN+ idiom)
      # @param [Symbol] op The compare's ALU operation (a {COMPARE} key).
      # @param [Array(String, Symbol)] rel The +[operator, signedness]+ from {RELATION}.
      # @example +b.ne+ (not taken) after +cmp x2, 1+ -- a +:sub+ compare, 64-bit
      #   compare_constraint(:sub, 'x2', '0x1', ['!=', nil], false) #=> 'x2 == 0x1'
      # @example +jne+ (taken) after +test eax, eax+ -- an +:and+ compare
      #   compare_constraint(:and, 'eax', 'eax', ['!=', nil], true) #=> 'eax != 0'
      def compare_constraint(op, lhs, rhs, rel, taken)
        operator, sign = rel
        operator = NEGATE[operator] unless taken
        cast = sign ? "(#{sign}#{self.class.bits})" : ''
        case op
        when :sub then "#{cast}#{lhs} #{operator} #{rhs}"
        when :add then "#{cast}(#{lhs} + #{rhs}) #{operator} 0"
        when :and then lhs == rhs ? "#{lhs} #{operator} 0" : "(#{lhs} & #{rhs}) #{operator} 0"
        end
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
