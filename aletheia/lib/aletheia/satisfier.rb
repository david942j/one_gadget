# frozen_string_literal: true

require_relative 'operand'

module Aletheia
  # Turns a gadget's constraint list into a concrete injection plan: which
  # registers to set, and how scratch memory is laid out. This is the inverse of
  # one_gadget's +calculate_score+ dispatch, but it *produces assignments* and
  # its constraint semantics are written independently (see {OperandParser}).
  #
  # Memory model assumed by the plan: the driver allocates one zeroed, RW scratch
  # region and sets +sp+ to +scratch + sp_offset+. So any +sp+-relative
  # dereference the constraints need NULL is satisfied by the zero-fill, any
  # +sp+imm+ effect argument points into scratch, and a register pointed at
  # scratch is a readable+writable pointer (and, being zero-filled, a valid empty
  # string / a NULL-terminated empty argv|envp).
  class Satisfier
    # @return [Aletheia::Plan]
    # @!attribute mem
    #   [Hash{Integer => Integer, Hash}] scratch-relative memory writes the driver
    #   applies before jumping (a pointer value, keyed by the scratch offset to
    #   write it at) -- e.g. so a chained dereference like +[[sp]]+ finds a real
    #   pointer at +[sp]+ instead of the zero-fill a single dereference relies on.
    Plan = Struct.new(:offset, :effect, :constraints, :regs, :mem, :base_mem, :scratch_size, :sp_offset,
                      :benign_default, :poison_default, :null_default, :branches, :status,
                      :reason, :writable_count, keyword_init: true)

    SCRATCH_SIZE    = 0x20000
    # Headroom below sp: some gadgets land inside a function whose own prologue
    # allocates its stack frame *after* we've jumped in (e.g. aarch64 execl's
    # `sub sp, sp, #0x2000; sub sp, sp, #0xd0`, ~8.4KB) -- too little headroom lets
    # that write run off the start of the scratch mmap. Found via Aletheia itself:
    # a too-tight sp_offset (0x2000) let exactly this happen, silently absorbed by
    # an adjacent mapping under native ASLR but faulting reliably under qemu-user's
    # stricter layout -- a harness bug, not a one_gadget one. 64KB comfortably
    # covers any observed gadget's local stack usage.
    SP_OFFSET       = 0x10000
    STRING_POOL     = 0x100    # readable+writable zeroed bytes: a valid "" / [NULL] array
    COMMAND_POOL    = 0x200    # the "ls /" L2 command the driver seeds here
    # A descriptor for a gadget to close harmlessly: high enough to be unused, so
    # closing it costs the spawned shell nothing (see #spare_the_shells_fds).
    # Written as a 4-byte field, since two descriptors sit 4 bytes apart and a
    # word-sized write of one would zero the other.
    SPARE_FD        = 42
    COMMAND_RESERVED = 0x40    # generous window at COMMAND_POOL treated as non-zero
    WRITABLE_BASE   = 0x12000  # write-areas live above the stack region (sp is at SP_OFFSET)
    WRITABLE_STRIDE = 0x800
    # Room reserved per register inside libc's spare data, so two base sums in
    # one gadget can't land on top of each other (see {#spare_slot}).
    SPARE_STRIDE    = 0x80
    WORD            = 8 # conservative pointer width for a "reads zero" check
    MASK64          = (1 << 64) - 1
    IMM             = /-?(?:0x[0-9a-fA-F]+|\d+)/
    # A literal zero, in whichever form one_gadget renders it for that context:
    # decimal +0+ (a bare register's "== NULL" branch) or hex +0x0+ (a sized value
    # comparison, e.g. +(s32)[..] <= 0x0+). Use in place of a hardcoded +0+ so a
    # rendering choice on the one_gadget side can't silently stop the satisfier
    # from recognising a branch it already knows how to solve.
    ZERO            = /(?:0|0x0+)/
    # Bare +reg & mask == want+ (no parens): a low-bits/alignment constraint. The
    # parenthesised +(reg & mask) == want+ is a settable-register relation instead
    # (see {#parse_relation}).
    ALIGN           = /\A(\w+) & (#{IMM}) == (#{IMM})\z/

    # +(X & mask)+ -- an operation one_gadget kept as itself because no base+offset
    # expresses its result. What the mask means depends on where it appears: as an
    # address it is an alignment of +X+ (see {#alignment_mask?}); as a value it is
    # a requirement on +X+'s bits (see {#parse_relation}).
    MASKED = /\A\((.+) & (#{IMM})\)\z/
    # The same, embedded rather than whole -- e.g. the +(rsi & ~0xf)+ inside
    # +[(rsi & ~0xf)] == NULL+ (see {#unmask_address}).
    MASKED_INNER = /\((\w+(?:[+-]#{IMM})?) & (#{IMM})\)/

    # An equality between two operands, neither of them a literal. The operands
    # are matched loosely rather than as non-space runs: a steered base sum
    # renders with spaces in it (+[[$base+0x1000]+0x38]+ only after
    # {#steer_base_sums} rewrites it), and each side is validated by parsing it
    # anyway, so a wrong split yields no operand rather than a wrong one.
    RELATION = /\A(?:\([su]\d+\))?(.+?) (==|!=) (?:\([su]\d+\))?(.+)\z/

    # +<reg> is the GOT address of libc+ (i386 PIC): the register must hold the
    # libc GOT base, i.e. +base + PLTGOT offset+. An ABI whose caller restores
    # that register after every call (o32) names the slot it restores from the
    # same way, so a memory location can be asked for it too.
    GOT = /\A(\w+|\[[^\]]+\]) is the GOT address of libc\z/

    # A +(reg + $base+imm)+ used as an address rather than a value: dereferenced,
    # or named as a +writable:+/+readable:+ target (see {#steer_base_sums}).
    BASE_SUM_ADDRESS = /(?:\[|writable: |readable: )\((\w+) \+ \$base([+-](?:0x[0-9a-fA-F]+|\d+))\)/

    # A term of an indexed address that carries the element scale, e.g. the
    # +(a5 << 0x3)+ of +((a5 << 0x3) + [sp+0xd0])+.
    SCALED_TERM = /\A\((.+) << (#{IMM})\)\z/

    # +writable: [base]+imm+ (a compound base -- offset from a *dereferenced*
    # value, not a bare register, e.g. a store through a pointer read off the
    # stack). +base+'s own content is only pinned by a *later* argv/envp
    # constraint, so this is handled by deferring it (see {#satisfy}) rather
    # than by {#writable_cost}/{#apply_writable}, which assume a bare register.
    WRITABLE_COMPOUND = /\Awritable: (\[.+\])[+-]#{IMM}\z/

    # @param arch an arch backend (e.g. {Arch::AArch64})
    # @param [Integer, nil] got_offset the libc PLTGOT file offset, for i386's
    #   "+<reg> is the GOT address of libc+" constraint (see {GOT}).
    # @param [Range, nil] spare_writable libc offsets that are mapped writable but
    #   that libc itself does not use, where a store through an address only a
    #   register decides is steered (see {#pin_sum_into_spare}).
    # @param [Boolean] strict when true, uncontrolled registers are poisoned
    #   (unmapped) so any unlisted dependency faults -- a completeness test for
    #   the constraint list. When false, they point at readable scratch.
    def initialize(arch, got_offset: nil, spare_writable: nil, strict: false)
      @arch = arch
      @got_offset = got_offset
      @spare_writable = spare_writable
      @strict = strict
    end

    # @param [OneGadget::Gadget::Gadget] gadget
    # @return [Aletheia::Plan]
    def satisfy(gadget)
      plan = Plan.new(
        offset: format('%#x', gadget.offset), effect: gadget.effect,
        constraints: gadget.constraints.dup, regs: {}, mem: {}, base_mem: {}, scratch_size: SCRATCH_SIZE,
        sp_offset: SP_OFFSET, benign_default: !@strict, poison_default: @strict,
        branches: {}, status: 'ok', reason: nil, writable_count: 0
      )
      # A `writable: [base]+imm` constraint can only be checked once `base`'s own
      # content is pinned by its own (argv/envp) constraint -- deferred to run
      # last. That constraint must not pick its NULL branch for `base`: with
      # base == NULL, `[base]+imm` is a fixed low address (e.g. 0x10), an
      # unmapped-page write in reality, not a merely-untracked one.
      unsteerable = steer_base_sums(plan, gadget.constraints)
      return skip(plan, "unsupported-or-unsat: #{unsteerable}") if unsteerable

      ordered = order_constraints(gadget.constraints)
      @null_unsafe_bases = ordered.grep(WRITABLE_COMPOUND) { Regexp.last_match(1) }
      @nonzero_witnesses = []
      ordered.each_with_index do |constraint, i|
        chosen = satisfy_constraint(plan, constraint)
        return skip(plan, "unsupported-or-unsat: #{constraint}") unless chosen

        plan.branches["c#{i}"] = chosen
      end
      spare_the_shells_fds(plan, gadget)
      plan
    end

    private

    # A descriptor the gadget closes but does not constrain is the caller's to
    # choose (one_gadget reports it as a +close(...)+ caveat). Left alone it reads
    # as 0 out of the zero-filled scratch, so the gadget closes the shell's stdin
    # and nothing can be driven through it -- an accident of this harness, not a
    # property of the gadget. Put a spare descriptor there, which is what an
    # exploit would do.
    #
    # A descriptor any constraint mentions is left alone: that constraint decides
    # its value, and where it decides on 0 or 1 the gadget really does cost the
    # shell that channel, which the verdict should show. Emptiness of the plan is
    # not enough to go on -- a stack slot required NULL is satisfied by the zero
    # fill without writing anything.
    def spare_the_shells_fds(plan, gadget)
      return unless gadget.respond_to?(:closed_fds)

      gadget.closed_fds.each do |slot|
        next if gadget.constraints.any? { |c| c.include?(slot) }

        op = safe_parse(slot) or next
        if op.deref == 1
          off = mem_addr_off(plan, op)
          set_mem(plan, off, { 'int32' => SPARE_FD }) if off && plan.mem[off].nil?
        elsif op.deref.zero? && op.reg && reg_value(plan, op.reg).nil?
          set_reg(plan, xreg(op.reg), SPARE_FD)
        end
      end
    end

    # Try each disjunct of +constraint+ cheapest-first; accept the first that is
    # already satisfied by the current plan or that applies without conflict. The
    # register map and memory-write map are snapshot/restored around a failed
    # apply so a partial assignment can't leak into the next attempt.
    # @return [String, nil] the chosen disjunct, or nil if none worked.
    def satisfy_constraint(plan, constraint)
      ordered = constraint.split(' || ').map(&:strip)
                          .filter_map { |b| (cost = evaluate(b)) && [cost, b] }
                          .sort_by(&:first).map(&:last)
      ordered.each do |branch|
        return branch if satisfied?(plan, branch)

        regs_snapshot = plan.regs.dup
        mem_snapshot = plan.mem.dup
        return branch if apply(plan, branch)

        plan.regs = regs_snapshot
        plan.mem = mem_snapshot
      end
      nil
    end

    def skip(plan, reason)
      plan.status = 'skip'
      plan.reason = reason
      plan
    end

    # An address built by indexing an array -- a (scaled) index added to a base,
    # both supplied by the caller, as an element's address is in a copy loop.
    # Emptying the index leaves the address wherever the base points, which is an
    # ordinary writable target, so the pair is what this returns.
    # @param [String] text The address, as the constraint writes it.
    # @return [Array<(String, Integer, String)>, nil] the (index, scale shift,
    #   base) orders worth trying; nil when +text+ is not that shape. A scaled term
    #   can only be the index -- zeroing the other one leaves the scale multiplying
    #   whatever the caller did not choose.
    # @example
    #   index_sum('((a5 << 0x3) + [sp+0xd0])')  #=> [['a5', 3, '[sp+0xd0]']]
    #   index_sum('(a5 + a4)')                  #=> [['a5', 0, 'a4'], ['a4', 0, 'a5']]
    #   index_sum('sp+0x50')                    #=> nil
    def index_sum(text)
      terms = sum_terms(text) or return nil
      # A sum naming a libc address is steered whole (see {#steer_base_sums}),
      # which places it in a region that is writable by construction -- nothing
      # here has to be emptied to arrange that.
      return nil if terms.any? { |t| t.include?('$base') }

      parsed = terms.map { |t| (m = t.match(SCALED_TERM)) ? [m[1], Integer(m[2])] : [t, 0] }
      return nil unless parsed.all? { |t, _| safe_parse(t) }

      (first, first_shift), (second, second_shift) = parsed
      orders = []
      orders << [first, first_shift, second] if second_shift.zero?
      orders << [second, second_shift, first] if first_shift.zero?
      orders.empty? ? nil : orders
    end

    # Split a parenthesised +(a + b)+ into its two terms, respecting the brackets
    # and parentheses either may itself contain. nil when +text+ is not one.
    # @return [Array<String>, nil]
    def sum_terms(text)
      return nil unless text.start_with?('(') && text.end_with?(')')

      depth = 0
      inner = text[1..-2]
      inner.each_char.with_index do |c, i|
        depth += 1 if '(['.include?(c)
        depth -= 1 if ')]'.include?(c)
        return [inner[0...i].strip, inner[(i + 3)..].strip] if depth.zero? && inner[i, 3] == ' + '
      end
      nil
    end

    # +(reg + $base+imm)+ where the sum is used as an ADDRESS -- the target of a
    # +writable:+/+readable:+, or a dereference. Where it lands is the register's
    # to decide, so each such register is pinned once, up front, to put its sums
    # in libc's spare data; every operand built on it then reads as the plain
    # +$base+off+ it has become (see {#safe_parse}), which the rest of this
    # satisfier already resolves.
    #
    # Pinning up front is only sound because the address uses are unconditional:
    # a sum inside a disjunction is a *value* (an argv element, or a +== NULL+),
    # whose treatment depends on which branch is taken and so cannot be settled
    # here. One appearing as an address inside a disjunction is refused rather
    # than pinned, since pinning a register a rejected branch asked for would
    # hand a poisoned register a valid value and weaken the strict test.
    # @return [String, nil] the constraint that could not be steered, or nil.
    def steer_base_sums(plan, constraints)
      @steered = {}
      constraints.each do |constraint|
        base_sum_addresses(constraint).each do |reg, off|
          slot = constraint.include?(' || ') ? nil : spare_slot(reg)
          return constraint unless slot && set_reg(plan, reg, (slot - off) & MASK64)

          @steered[reg] = slot
        end
      end
      nil
    end

    # Every +(reg + $base+imm)+ in +constraint+ that names an address, as
    # [register, offset] pairs. An occupied +[+ before it makes it a dereference;
    # a +writable:+/+readable:+ prefix makes it that constraint's target.
    def base_sum_addresses(constraint)
      pairs = constraint.to_enum(:scan, BASE_SUM_ADDRESS).map do
        m = Regexp.last_match
        [xreg(m[1]), Integer(m[2])]
      end
      pairs.select { |reg, _| settable?(reg) }
    end

    # Order constraints so each runs once its inputs are settled and so a
    # register-pinning constraint wins over a mere bound on the same register:
    # * a plain `writable: reg+imm` runs FIRST -- it pins `reg` to a (nonzero,
    #   mapped) scratch pointer, which then already satisfies a co-occurring bound
    #   like `reg != 0` (see {#scratch_satisfies_relation?}); applying the bound
    #   first would pin `reg` to a bare literal and block the writable.
    # * a compound `writable: [base]+imm` (see {WRITABLE_COMPOUND}) runs LAST, once
    #   `base`'s own constraint has picked and applied its resolution.
    def order_constraints(constraints)
      compound, rest = constraints.partition { |c| c.match?(WRITABLE_COMPOUND) }
      writable, others = rest.partition { |c| c.start_with?('writable: ') }
      # A nested readable (readable: [base+imm]) resolves its base through
      # mem_addr_off, which needs base already pointed at scratch -- done by a
      # shallower readable/writable on that base. Apply readables shallowest
      # first, keeping every other constraint's relative order (stable sort via
      # the original index).
      others = others.each_with_index.sort_by { |c, i| [readable_depth(c), i] }.map(&:first)
      writable + others + compound
    end

    # The dereference depth of a +readable:+ constraint's pointer (0 for a bare
    # +readable: reg+imm+, 1 for +readable: [base+imm]+); 0 for any non-readable
    # constraint, so {#order_constraints} leaves those in place.
    def readable_depth(constraint)
      m = constraint.match(/\Areadable: (.+)\z/) or return 0
      (op = safe_parse(m[1])) ? op.deref : 0
    end

    # Cost of satisfying a single disjunct (lower = easier); nil = unsatisfiable
    # or a category this satisfier doesn't handle.
    # @return [Float, nil]
    def evaluate(disjunct)
      case disjunct
      when WRITABLE_COMPOUND then 0.9 # deferred; see #order_compound_writable_last
      when /\Awritable: (.+)\z/
        target = Regexp.last_match(1)
        # Two assignments rather than one, so ranked just above a plain target.
        if index_sum(target) then 0.3
        else (op = writable_target(target)) && writable_cost(op)
        end
      when /\Areadable: (.+)\z/
        (op = address_operand(Regexp.last_match(1))) && op.reg && 0.4 # point it at scratch
      when /\A(.+?) == NULL\z/, /\A(.+?) <= #{ZERO}\z/
        base = Regexp.last_match(1)
        return nil if @null_unsafe_bases&.include?(base)
        # Ranked just BELOW the array builder above: taking this branch empties the
        # array, and which shape yields an observable shell varies per gadget, so
        # cost must not be what decides it. It is reached when the array cannot be
        # built -- an element only cancelling the address could place.
        return 0.55 if cancelling_sum(base)

        (op = address_operand(base)) && null_cost(op)
      # Cost is unchanged by which array shape this is: whether a built argv or a
      # short one produces the observable shell varies per gadget -- an empty argv
      # leaves a drivable interactive shell for some and an immediate exit for
      # others -- so preferring either loses gadgets the other would have caught.
      # Picking the witnessable one belongs in a retry, not in a cost.
      when /\A\{.*\} is a valid (?:argv|envp)\z/ then 0.5 # array literal: element builder
      when /is a valid (?:argv|envp)\z/         then 0.4 # pointer form: point it at scratch
      when ALIGN                                then alignment_cost(disjunct)
      when GOT                                  then got_cost(disjunct)
      else
        if (op = deref_zero(disjunct)) then null_cost(op)
        elsif (parsed = deref_relation(disjunct)) then literal_cost(parsed[0])
        elsif reg_relation(disjunct) then 0.45 # pin both registers
        elsif reg_mem_relation(disjunct) then 0.5 # pin the register, store a matching value
        elsif mem_mem_relation(disjunct) then 0.55 # match the value in memory on both sides
        else relational_cost(disjunct)
        end
      end
    end

    # A dereferenced value required to be zero (+[X] == 0+) -- equivalent to
    # +[X] == NULL+. A bare +reg == 0+ is a settable relation handled elsewhere,
    # so only the dereferenced form is returned here.
    def deref_zero(disjunct)
      m = disjunct.match(/\A(.+?) == #{ZERO}\z/) or return nil
      op = safe_parse(m[1])
      op if op&.reg && op.deref.positive?
    end

    # A dereferenced value compared against a literal, e.g. +[rbp-0x50] == 0x1+ or
    # +[$base+0x1c2430] != 0x0+ -- a value read from tracked memory that a later
    # comparison in the *same* candidate constrains. Returns the operand together
    # with the value to store so the comparison holds (see {#relation_witness}),
    # which the register-side relation machinery can't express: {#parse_relation}
    # matches a bare register name, never a memory operand. The zero-equality case
    # is claimed by {#deref_zero} first. Only a single dereference is modeled -- a
    # chained +[[X]+imm]+ would need the same deep-pointer machinery as
    # {#apply_deep_null}.
    # @return [(Aletheia::Operand, Integer), nil]
    def deref_relation(disjunct)
      m = disjunct.match(/\A(?:\([su]\d+\))?(.+?) (==|!=|<=|>=|<|>) (#{IMM})\z/) or return nil
      lhs, mask = unmask(m[1])
      op = safe_parse(lhs)
      return nil unless op&.reg && op.deref == 1

      relop = m[2]
      imm = Integer(m[3])
      # A masked read wants a value whose masked bits meet the target; writing
      # that value into the slot satisfies it, the mask having nothing to say
      # about the bits it clears.
      return masked_deref_relation(op, mask, relop, imm) if mask

      witness = relation_witness(relop, imm)
      # "must be nonzero" admits any value, so record that a pointer will do:
      # storing one keeps the location usable as a pointer by another constraint
      # (+[$base+off] != 0+ alongside +[[$base+off]+0xe8] == 0+), which pinning
      # the bare literal 1 would block.
      # The excluded value travels with the witness: an inequality is satisfied by
      # anything but that one value, which is not the same as holding the witness
      # picked for it (see {#literal_satisfied?}).
      witness && [op, witness & MASK64, relop == '!=' && imm.zero?, (imm if relop == '!=')]
    end

    # +<reg> is the GOT address of libc+: settable when we know the PLTGOT offset
    # and the register is assignable (see {GOT}).
    # @return [Float, nil]
    def got_cost(disjunct)
      holder = disjunct[GOT, 1]
      return nil unless @got_offset

      settable?(holder) || got_slot_shape?(holder) ? 0.3 : nil
    end

    # +reg & mask == want+: the stack pointer is aligned by construction (the
    # driver sets +sp+ to an aligned scratch address); a GPR can be pointed at an
    # aligned scratch slot. Only +want == 0+ (the alignment case) is handled.
    # @return [Float, nil]
    def alignment_cost(disjunct)
      reg, _mask, want = parse_alignment(disjunct)
      return 0.05 if stack_reg?(reg) && want.zero?

      settable?(reg) && want.zero? ? 0.3 : nil
    end

    def parse_alignment(disjunct)
      m = disjunct.match(ALIGN)
      [xreg(m[1]), Integer(m[2]), Integer(m[3])]
    end

    # @return [Float, nil]
    def writable_cost(op)
      # A steered base sum: a fixed libc address in a region that is writable by
      # construction, so there is nothing further to arrange (see {#steer_base_sums}).
      return 0.05 if op.deref.zero? && base_reg?(op)
      return 0.05 if op.deref.zero? && op.reg && stack_reg?(op.reg) # already in scratch via sp
      return 0.25 if op.deref == 1 && op.reg # store the pointer it must go through

      op.deref.zero? && op.reg ? 0.2 : nil
    end

    # @return [Float, nil]
    def null_cost(op)
      if op.deref.zero?
        return nil if op.reg && stack_reg?(op.reg) # sp/x29 (+imm) is a live address, never NULL
        return nil if op.reg.nil?                  # a bare literal == NULL is fixed, not ours to set

        op.imm.zero? ? 0.1 : 0.3 # set reg = -imm
      elsif op.deref == 1
        # A single dereferenced value must be zero in memory. If it hangs off the
        # stack it lands in our zeroed scratch for free; off a register, that
        # register can be pointed at scratch.
        return 0.05 if stack_reg?(op.reg)

        op.reg ? 0.2 : nil
      else
        deep_null_cost(op)
      end
    end

    # +[[X]] == NULL+ (or deeper): X's OWN first-level target isn't guaranteed
    # zero (only what it points AT, at the next level, needs to be) -- so unlike a
    # single deref this needs a real pointer written into scratch at each level of
    # the chain, terminating in the always-zero {STRING_POOL}. See {#apply_deep_null}.
    # Costed above a single deref (one extra scratch write per extra level), and
    # requires a settable register when X isn't the stack pointer.
    # @return [Float, nil]
    def deep_null_cost(op)
      return nil unless stack_reg?(op.reg) || base_reg?(op) || (op.reg && settable?(op.reg))

      base = stack_reg?(op.reg) ? 0.15 : 0.25
      base + (0.05 * (op.deref - 2))
    end

    # Unlike a zero target ({#null_cost}), a nonzero literal is never already
    # sitting in zeroed scratch for free -- it always needs a real write, so
    # this costs above the zero case at each tier.
    # @return [Float, nil]
    def literal_cost(op)
      return 0.15 if stack_reg?(op.reg)
      return 0.2 if base_reg?(op) # a libc global the driver writes directly

      op.reg && settable?(op.reg) ? 0.3 : nil
    end

    # @return [Float, nil]
    def relational_cost(disjunct)
      parse_relation(disjunct) ? 0.4 : nil
    end

    # Whether +branch+ already holds under the current register assignment.
    def satisfied?(plan, branch)
      case branch
      when WRITABLE_COMPOUND
        compound_writable_satisfied?(plan, Regexp.last_match(1))
      when /\Awritable: (.+)\z/
        op = writable_target(Regexp.last_match(1))
        if op.nil? then false
        elsif op.deref == 1 && op.reg then pointer_resolved?(plan, op)
        else op.deref.zero? && op.reg && (base_reg?(op) || stack_reg?(op.reg) || scratch?(plan, op.reg))
        end
      when /\Areadable: (.+)\z/
        (op = address_operand(Regexp.last_match(1))) && pointer_resolved?(plan, op)
      when /is a valid (?:argv|envp)\z/
        (op = pointer_form(branch)) && pointer_resolved?(plan, op)
      when ALIGN
        reg, _mask, want = parse_alignment(branch)
        (stack_reg?(reg) && want.zero?) || (want.zero? && scratch?(plan, reg))
      when /\A(.+?) == NULL\z/, /\A(.+?) <= #{ZERO}\z/
        text = Regexp.last_match(1)
        if (sum = cancelling_sum(text)) then reg_value(plan, sum.first) == { 'neg_base_off' => sum.last }
        else (op = address_operand(text)) && deref_reads_zero?(plan, op)
        end
      when GOT
        got_holder_resolved?(plan, branch[GOT, 1])
      else
        if (op = deref_zero(branch))
          deref_reads_zero?(plan, op)
        elsif (parsed = deref_relation(branch))
          literal_satisfied?(plan, parsed[0], parsed[1], any_nonzero: parsed[2], exclude: parsed[3])
        elsif (pair = reg_relation(branch))
          reg_relation_satisfied?(plan, *pair)
        elsif (trio = reg_mem_relation(branch))
          reg_mem_satisfied?(plan, *trio)
        elsif (pair2 = mem_mem_relation(branch))
          mem_mem_satisfied?(plan, *pair2)
        else
          reg, value = parse_relation(branch)
          current = reg && reg_value(plan, reg)
          if current.is_a?(Hash) then scratch_satisfies_relation?(branch)
          else reg && !current.nil? && current == (value & MASK64)
          end
        end
      end
    end

    # Whether a memory-relation operand's tracked memory already holds +literal+
    # (see {#deref_relation}).
    def literal_satisfied?(plan, op, literal, any_nonzero: false, exclude: nil)
      value = mem_value(plan, op)
      return pointer_value?(value) || (value.is_a?(Integer) && !value.zero?) if any_nonzero
      # An inequality is answered by whatever is already there, the excluded value
      # aside. Checking against the witness instead would rewrite a location that
      # was already fine -- and that write is what collides with the next
      # constraint reading the same location.
      return (value & MASK64) != (exclude & MASK64) if exclude && value.is_a?(Integer)

      value == literal
    end

    # A stored scratch pointer: a mapped, nonzero address the driver resolves.
    def pointer_value?(value)
      value.is_a?(Hash) && value.key?('scratch_off')
    end

    # Locations written only to satisfy a "must be nonzero" constraint, which a
    # later constraint may promote to a scratch pointer (see {#apply_literal}).
    def nonzero_witnesses
      @nonzero_witnesses ||= []
    end

    # Identifies the memory a single-dereference operand names, across the two
    # address spaces the plan writes: scratch and the libc globals.
    def witness_key(op)
      base_reg?(op) ? [:base, op.imm] : [:mem, op.reg, op.imm]
    end

    # Whether a +== NULL+ / +<= 0+ operand already reads zero under the current
    # plan: a bare register pinned to 0, or a single deref off a scratch-pointing
    # register whose target lands in the zero-filled region. This lets one register
    # assignment (e.g. a +writable: reg+imm+) also satisfy a +[reg+imm] == NULL+ on
    # the same slot, instead of the two conflicting.
    def deref_reads_zero?(plan, op)
      return pinned_to_zero?(reg_value(plan, op.reg)) if op.deref.zero? && op.reg
      return pinned_to_zero?(mem_value(plan, op)) if op.deref >= 2
      return false unless op.inner_imm.zero?
      return pinned_to_zero?(plan.base_mem[op.imm]) if op.deref == 1 && base_reg?(op) # zeroed libc global
      return false unless op.deref == 1 && op.reg && scratch?(plan, op.reg)

      zeroed_scratch?(reg_value(plan, op.reg)['scratch_off'] + op.imm)
    end

    # A +$base+<off>+ operand: a fixed libc-global address (the load base plus an
    # offset), which the driver writes directly rather than the satisfier pinning
    # a register.
    def base_reg?(op)
      op&.reg == '$base'
    end

    # Whether a word read at scratch offset +off+ is zero: in-bounds, and clear of
    # the L2 command the driver seeds at COMMAND_POOL (the only non-zero region).
    def zeroed_scratch?(off)
      return false unless off >= 0 && off + WORD <= SCRATCH_SIZE

      off + WORD <= COMMAND_POOL || off >= COMMAND_POOL + COMMAND_RESERVED
    end

    # A register pointed at scratch holds a large, nonzero, mapped address, so it
    # already satisfies +!= <imm>+ and +>|>= <small imm>+ (but not an equality or a
    # low bound).
    def scratch_satisfies_relation?(branch)
      m = branch.match(/\A(?:\([su]\d+\))?\w+ (==|!=|<=|>=|<|>) (#{IMM})\z/)
      return false unless m

      op = m[1]
      imm = Integer(m[2])
      op == '!=' || (['>', '>='].include?(op) && imm <= 0x1000)
    end

    # Mutate +plan+ to satisfy +disjunct+; false on an irreconcilable conflict.
    def apply(plan, disjunct)
      case disjunct
      when WRITABLE_COMPOUND
        compound_writable_satisfied?(plan, Regexp.last_match(1))
      when /\Awritable: (.+)\z/
        target = Regexp.last_match(1)
        (orders = index_sum(target)) ? apply_index_sum(plan, orders) : apply_plain_writable(plan, target)
      when /\Areadable: (.+)\z/
        (op = address_operand(Regexp.last_match(1))) ? apply_pointer(plan, op) : false
      when /\A(.+?) == NULL\z/, /\A(.+?) <= #{ZERO}\z/
        apply_null(plan, Regexp.last_match(1))
      when /\A\{(.*)\} is a valid (?:argv|envp)\z/ then apply_argv_list(plan, Regexp.last_match(1))
      when /is a valid (?:argv|envp)\z/            then apply_pointer(plan, pointer_form(disjunct))
      when ALIGN                                   then apply_alignment(plan, disjunct)
      when GOT                                     then apply_got(plan, disjunct)
      else
        if (op = deref_zero(disjunct)) then apply_deref_null(plan, op)
        elsif (parsed = deref_relation(disjunct)) then apply_literal(plan, parsed[0], parsed[1], any_nonzero: parsed[2])
        elsif (pair = reg_relation(disjunct)) then apply_reg_relation(plan, *pair)
        elsif (trio = reg_mem_relation(disjunct)) then apply_reg_mem_relation(plan, *trio)
        elsif (mm = mem_mem_relation(disjunct)) then apply_mem_mem_relation(plan, *mm)
        else apply_relation(plan, disjunct)
        end
      end
    end

    # Make what +text+ names read as zero.
    def apply_null(plan, text)
      if (sum = cancelling_sum(text))
        return set_reg(plan, sum.first, { 'neg_base_off' => sum.last })
      end

      op = address_operand(text) or return false

      if op.deref.zero? then set_reg(plan, op.reg, (-op.imm) & MASK64)
      elsif op.deref == 1 && base_reg?(op) then set_base_mem(plan, op.imm, 0) # zero the libc global
      elsif op.deref == 1 && stack_reg?(op.reg) then stack_slot_still_zero?(plan, op)
      elsif op.deref == 1 && op.reg then set_reg(plan, op.reg, { 'scratch_off' => STRING_POOL - op.imm })
      elsif op.deref >= 2 then apply_deep_null(plan, op)
      else false
      end
    end

    # Whether an +sp+-relative slot still reads zero. It does by default -- the
    # stack lands in the zero-filled scratch, so nothing has to be written to make
    # it NULL -- but only while nothing else has put something there. Another
    # constraint may have pointed that very slot at scratch, and answering "already
    # zero" then would hand back a plan whose two constraints contradict each
    # other, with the write landing at a fixed low address.
    # @param [Aletheia::Operand] op The slot, at one dereference.
    # @return [Boolean]
    def stack_slot_still_zero?(plan, op)
      existing = plan.mem[mem_addr_off(plan, op)]
      existing.nil? || pinned_to_zero?(existing)
    end

    # A +(reg + $base+imm)+ that has to come out zero. Nothing the register can be
    # *added* to makes a libc address vanish, so the register has to hold that
    # address negated -- a value only the driver knows once the library is loaded,
    # so the plan names it rather than computing it. Distinct from a base sum used
    # as an address, which is steered instead (see {#steer_base_sums}).
    # @return [(String, Integer), nil] the register to pin and the offset its value
    #   has to cancel; nil when this isn't that shape, or the register isn't one
    #   the plan can set.
    def cancelling_sum(text)
      op = parse_operand(text)
      return nil unless op && !op.base_imm.zero? && op.deref.zero? && op.reg && settable?(op.reg)

      [xreg(op.reg), op.base_imm + op.imm]
    end

    # Satisfy a dereferenced +== <imm>+ (nonzero) by pinning +op.reg+ to a fresh
    # scratch slot (unless it's already resolvable -- sp, or a register some
    # other constraint in this candidate already pinned) and writing +literal+
    # there. Unlike a zero target, there's no already-correct region to point
    # at, so this always needs a real write.
    def apply_literal(plan, op, literal, any_nonzero: false)
      # "Nonzero" is satisfied by the smallest value that works. A scratch pointer
      # would also do and stays dereferenceable, but it writes a full word where
      # the code may read a narrower field, clobbering the neighbouring one --
      # observed turning working gadgets into faults. So store 1 and record the
      # location, letting {#deep_target_off} promote it to a pointer only if some
      # constraint actually dereferences it (a pointer is nonzero either way).
      if any_nonzero
        literal = 1
        nonzero_witnesses << witness_key(op)
      end
      if op.deref >= 2
        target = deep_target_off(plan, op, allocate: true)
        return target ? set_mem(plan, target, literal) : false
      end
      # The displacement adds to the value read, so store the literal less it.
      literal = (literal - op.inner_imm) & MASK64 if literal.is_a?(Integer)
      return set_base_mem(plan, op.imm, literal) if base_reg?(op)

      addr_off = mem_addr_off(plan, op)
      if addr_off.nil?
        return false unless op.reg && settable?(op.reg)

        slot = scratch_slot(plan, op.imm)
        return false unless set_reg(plan, xreg(op.reg), slot)

        addr_off = slot['scratch_off'] + op.imm
      end
      set_mem(plan, addr_off, literal)
    end

    # Satisfy a dereferenced +== 0+ by pointing the register at zeroed scratch
    # (an sp-relative slot is already zero); cf. the +== NULL+ deref handling.
    def apply_deref_null(plan, op)
      return true if op.deref == 1 && stack_reg?(op.reg)
      return set_base_mem(plan, op.imm, 0) if op.deref == 1 && base_reg?(op) # zero the libc global
      return apply_deep_null(plan, op) if op.deref >= 2

      op.reg ? set_reg(plan, op.reg, { 'scratch_off' => STRING_POOL - op.imm }) : false
    end

    # Build a chain of scratch pointers so a chained dereference (+[[X]] == NULL+,
    # or deeper) is genuinely valid at every level, not just the last: unlike a
    # single dereference, +[X]+ (the first level) is NOT already guaranteed zero,
    # so it must hold a real pointer for the next level to read -- terminating in
    # the always-zero {STRING_POOL} so the final read is 0.
    # @param [Aletheia::Operand] op A parsed operand with +op.deref >= 2+.
    # @example +[[sp]] == NULL+ (deref 2): one write, sp's own scratch slot -> STRING_POOL
    # @example +[[r5+8]] == NULL+ (deref 2, register): r5 is pointed at a fresh
    #   slot, and that slot -> STRING_POOL
    # @example deref 3: X -> slot_1 -> STRING_POOL (two writes, one extra slot)
    # @example +[[[$base+0x171fc0]]] == NULL+ (deref 3, libc global): the global
    #   itself holds the first pointer, which the driver writes once the load base
    #   is known, and the chain continues in scratch from there
    def apply_deep_null(plan, op)
      # A field read off a pointer ([[base+imm]+inner]): point that pointer at a
      # fresh scratch area so the field lands in the zero fill.
      unless op.inner_imm.zero?
        target = deep_target_off(plan, op, allocate: true)
        return target ? set_mem(plan, target, 0) : false
      end

      # A chain rooted in a libc global starts one level in: the global holds the
      # first pointer (written by the driver, which alone knows the load base),
      # and the rest of it is walked through scratch like any other.
      levels = op.deref - 1
      addr_off =
        if base_reg?(op)
          slot = scratch_slot(plan, 0)
          return false unless set_base_mem(plan, op.imm, slot)

          levels -= 1
          slot['scratch_off']
        elsif stack_reg?(op.reg)
          SP_OFFSET + op.imm
        elsif op.reg && settable?(op.reg)
          slot = scratch_slot(plan, op.imm)
          return false unless set_reg(plan, xreg(op.reg), slot)

          slot['scratch_off'] + op.imm
        end
      return false unless addr_off

      levels.times do |i|
        target_off = i == levels - 1 ? STRING_POOL : scratch_slot(plan, 0)['scratch_off']
        return false unless set_mem(plan, addr_off, { 'scratch_off' => target_off })

        addr_off = target_off
      end
      true
    end

    # Set the base register to the libc GOT, +base + PLTGOT offset+; the driver
    # resolves the +base_off+ against the runtime load base (cf. +scratch_off+).
    # An ABI may point that register a fixed distance *into* the table rather than
    # at its start -- o32 puts +gp+ 0x7ff0 in, so one signed 16-bit offset reaches
    # most of it -- which the backend states.
    def apply_got(plan, disjunct)
      return false unless @got_offset

      bias = @arch.respond_to?(:got_bias) ? @arch.got_bias : 0
      value = { 'base_off' => @got_offset + bias }
      holder = disjunct[GOT, 1]
      return set_reg(plan, xreg(holder), value) if settable?(holder)

      op = address_operand(holder) or return false

      set_mem(plan, mem_addr_off(plan, op), value)
    end

    # Whether a GOT constraint names a location the plan can write rather than a
    # register: one dereference of the stack pointer, which is the slot an ABI has
    # the caller restore its GOT register from.
    # @param [String] holder
    # @return [Boolean]
    def got_slot_shape?(holder)
      op = address_operand(holder)
      !op.nil? && op.deref == 1 && stack_reg?(op.reg)
    end

    # Whether the plan has put the libc GOT where this constraint asks for it --
    # in the register, or in the slot the caller restores it from.
    # @param [String] holder
    # @return [Boolean]
    def got_holder_resolved?(plan, holder)
      return base_relative?(reg_value(plan, holder)) if settable?(holder)
      return false unless got_slot_shape?(holder)

      base_relative?(plan.mem[mem_addr_off(plan, address_operand(holder))])
    end

    # A register value the driver resolves against the libc load base.
    def base_relative?(value)
      value.is_a?(Hash) && value.key?('base_off')
    end

    def apply_alignment(plan, disjunct)
      reg, _mask, want = parse_alignment(disjunct)
      return want.zero? if stack_reg?(reg) # sp is aligned by construction; nothing to set
      return false unless want.zero? && settable?(reg)

      set_reg(plan, reg, { 'scratch_off' => STRING_POOL }) # a 16-aligned readable slot
    end

    # Steer +(reg + $base+off)+ into libc's own spare data by pinning the register
    # to the literal that puts the sum there. The address is a fixed libc one, so
    # unlike a scratch target there is no pointer to hand out: the register
    # carries the whole displacement. The region is mapped, zeroed and used by
    # nothing, so it serves as somewhere harmless to store and as a valid empty
    # string alike.
    def pin_sum_into_spare(plan, reg, off)
      slot = spare_slot(reg) or return false

      set_reg(plan, reg, (slot - off) & MASK64)
    end

    # +writable: [X]+ (a bare dereference, no trailing displacement -- the compound
    # +writable: [X]+imm+ form is {WRITABLE_COMPOUND}) requires the pointer *stored*
    # at X to reference writable memory, so point that slot at scratch, exactly as
    # a pointer-form argv/envp constraint does.
    def apply_plain_writable(plan, target)
      (op = writable_target(target)) ? apply_writable(plan, op) : false
    end

    # Make an indexed address writable by emptying the index and pointing the base
    # somewhere writable, which is what the two terms of it are for. Each order is
    # tried whole, and a failed one leaves nothing behind.
    # @param [Array<(String, String)>] orders (index, base) pairs, as {#index_sum} yields them.
    # @return [Boolean]
    def apply_index_sum(plan, orders)
      orders.any? do |index, shift, base|
        regs_snapshot = plan.regs.dup
        mem_snapshot = plan.mem.dup
        next true if empty_index?(plan, index, shift) && writable_base?(plan, base)

        plan.regs = regs_snapshot
        plan.mem = mem_snapshot
        false
      end
    end

    # Make the index contribute nothing -- or accept one already pinned, provided
    # its element still lands inside the area the base is pointed at. A gadget
    # writing both +base[i]+ and +base[i+1]+ states two such addresses, and the
    # second cannot empty an index the first already settled.
    # @param [String] index The index term, as the constraint writes it.
    # @param [Integer] shift The element scale, as a shift.
    # @return [Boolean]
    def empty_index?(plan, index, shift)
      return true if apply_null(plan, index)

      op = safe_parse(index)
      return false unless op&.deref&.zero? && op.reg

      value = reg_value(plan, op.reg)
      return false unless value.is_a?(Integer)

      ((value + op.imm) & MASK64) << shift < WRITABLE_STRIDE
    end

    # Whether +base+ points somewhere writable, arranging it if it does not
    # already. Asking first matters: a base some other constraint has already
    # pointed at scratch is writable, and applying again would refuse to replace
    # that pointer with a second slot.
    # @return [Boolean]
    def writable_base?(plan, base)
      satisfied?(plan, "writable: #{base}") || apply_plain_writable(plan, base)
    end

    def apply_writable(plan, op)
      return true if op.deref.zero? && base_reg?(op) # steered into libc's spare data

      if op.deref == 1 && op.reg
        addr_off = level1_addr_off(plan, op, allocate: true) or return false

        return set_mem(plan, addr_off, scratch_slot(plan, 0))
      end
      return false unless op.deref.zero? && op.reg
      return true if stack_reg?(op.reg)

      set_reg(plan, op.reg, scratch_slot(plan, op.imm))
    end

    # +writable: [base]+imm+ (see {WRITABLE_COMPOUND}): satisfied once +base+'s
    # own content -- pinned by its own constraint, which {#order_compound_writable_last}
    # guarantees ran first -- is a scratch pointer. Nothing further to write:
    # +imm+ always lands comfortably inside that region (an argv/envp element
    # offset, never close to {STRING_POOL}/{WRITABLE_STRIDE}'s size).
    def compound_writable_satisfied?(plan, base_text)
      op = safe_parse(base_text)
      return false unless op && op.deref == 1 && op.reg

      addr_off = mem_addr_off(plan, op)
      return false unless addr_off

      target = plan.mem[addr_off]
      target.is_a?(Hash) && target.key?('scratch_off')
    end

    # The scratch-relative offset a single-deref operand's memory lives at (an
    # +sp+-relative slot, or off a register the plan already points at scratch),
    # or +nil+ when neither -- +base+ isn't resolved (yet).
    def mem_addr_off(plan, op)
      return SP_OFFSET + op.imm if stack_reg?(op.reg)
      return reg_value(plan, op.reg)['scratch_off'] + op.imm if scratch?(plan, op.reg)

      nil
    end

    # +{e0, e1, ...}+ argv/envp contents: fill the elements the gadget leaves to
    # the caller, so the array is one the spawned shell can be driven from.
    #
    # Established by running +/bin/sh+ under a pty with each shape and driving
    # +ls /+:
    #
    #   NULL, {NULL}, {<str>, NULL}              drivable -- the shell reads stdin
    #   {"/bin/sh", "-c", <cmd>, NULL}           drivable -- the shell runs <cmd>
    #   {"/bin/sh", "-", NULL}                   drivable -- "-" means read stdin
    #   {<str>, "", NULL}, {"", "", "", NULL}    NOT: the element after argv[0] is
    #                                            a script name the shell fails to
    #                                            open, and it exits
    #
    # So argv[0]'s content doesn't matter, and everything hangs on what follows
    # it: the command where the gadget supplies +"-c"+, and the terminator
    # otherwise. A NULL element ends the array; nothing past it needs building.
    def apply_argv_list(plan, inner)
      elements = inner.split(',').map(&:strip).reject { |e| e == '...' }
      seen_c = false
      command_set = false
      index = 0
      elements.each do |e|
        seen_c ||= (e == '"-c"')
        # A fixed string the gadget supplies needs nothing, but still occupies a
        # position.
        placement = e.start_with?('"') ? nil : argv_element_placement(plan, e)
        break if placement == :terminator
        return false if placement == :refuse

        if placement.nil?
          index += 1
          next
        end

        pool = argv_pool(index, seen_c, command_set)
        command_set ||= (pool == COMMAND_POOL)
        return false unless place_argv_element(plan, placement, pool)
        break if pool.nil? # the array ends here

        index += 1
      end
      true
    end

    # What an argv element at +index+ has to hold: the command where the gadget
    # supplies +"-c"+ (a +--+ separator, or any other fixed string, just delays
    # it), a readable string at argv[0], and otherwise NULL -- an element after
    # argv[0] is a script name, and no string there leaves a drivable shell.
    # @return [Integer, nil] a scratch offset, or nil for the terminator.
    def argv_pool(index, seen_c, command_set)
      return COMMAND_POOL if seen_c && !command_set
      return STRING_POOL if index.zero?

      nil
    end

    # Where an element's value has to be put, together with the operand it came
    # from; +:terminator+ when the array already ends there, nil when there is
    # nothing to place, and +:refuse+ when the element must be placed but cannot
    # be. Refusing matters as much as placing: an element left unplaced keeps
    # whatever the driver filled its register with, which under +--strict+ is
    # unmapped -- so the array reaches +execve+ with a bad pointer and the gadget
    # reports FAIL for a plan that was never complete.
    # @return [(Symbol, Object, Aletheia::Operand), :terminator, :refuse, nil]
    def argv_element_placement(plan, element)
      return :terminator if element == 'NULL'

      op = parse_operand(element) or return nil
      unless op.base_imm.zero?
        return :refuse unless op.reg && settable?(op.reg)

        return [:sum, xreg(op.reg), op]
      end

      placement = argv_placement(plan, op)
      return placement if placement == :terminator || placement.nil?

      [*placement, op]
    end

    # Put +pool+ (a scratch offset, or nil for the array terminator) where an argv
    # element is read from.
    def place_argv_element(plan, placement, pool)
      kind, target, op = placement
      case kind
      when :sum then place_base_sum_element(plan, target, op, pool)
      when :mem then set_mem(plan, target, pool.nil? ? 0 : { 'scratch_off' => pool })
      else set_reg(plan, target, pool.nil? ? 0 : { 'scratch_off' => pool - op.imm })
      end
    end

    # An element whose value is a register added to a fixed libc address carries
    # no pointer to store anywhere -- the register alone decides where the sum
    # lands, so it is pinned to put it in libc's spare data, whose zero fill is a
    # valid empty string. That meets a readable-string position and no other: a
    # terminator would need the register to cancel the libc address out, and the
    # command a +"-c"+ position wants lives in scratch -- neither is a value a
    # literal can name, since only the driver knows the load base.
    def place_base_sum_element(plan, reg, op, pool)
      off = op.base_imm + op.imm
      # The terminator has to be NULL, which only cancelling the libc address out
      # achieves; a readable-string position is met by steering the sum into
      # libc's spare data, whose zero fill is the empty string argv[0] needs. The
      # command a +"-c"+ position wants lives in scratch, which is neither.
      return set_reg(plan, reg, { 'neg_base_off' => off }) if pool.nil?
      return false unless pool == STRING_POOL

      pin_sum_into_spare(plan, reg, off)
    end

    # Where an argv element's string pointer has to go for the callee to find it:
    # the register that holds the element, or the memory slot it is read out of --
    # an array staged on the stack needs the pointer written there, not into a
    # register.
    # @return [(Symbol, Object), :terminator, nil] +:terminator+ when another
    #   constraint already pins the element to NULL (the array ends there); nil
    #   when it is nothing to place -- a fixed string the gadget supplies, or an
    #   address that cannot be resolved.
    def argv_placement(plan, op)
      return nil if op.reg.nil? || global?(op.reg)

      if op.deref == 1
        addr = mem_addr_off(plan, op)
        return nil if addr.nil?
        return :terminator if pinned_to_zero?(plan.mem[addr])

        [:mem, addr]
      elsif op.deref.zero? && !stack_reg?(op.reg)
        # An element off the GOT base (i386 PIC) is a fixed libc address -- the
        # real "sh"/"-c" string the gadget passes -- so it is already valid;
        # re-pointing that register would only conflict with the GOT constraint.
        return nil if base_relative?(reg_value(plan, op.reg))
        return :terminator if op.imm.zero? && pinned_to_zero?(reg_value(plan, op.reg))

        [:reg, op.reg]
      end
    end

    # +<ptr> is a valid argv/envp+: point the pointer at scratch (a zero-filled,
    # hence NULL-terminated empty array).
    def apply_pointer(plan, op)
      return false unless op
      return true if op.deref.zero? && base_reg?(op) # a fixed libc address is mapped
      return set_reg(plan, op.reg, { 'scratch_off' => STRING_POOL }) if op.deref.zero?
      return set_base_mem(plan, op.imm, { 'scratch_off' => STRING_POOL }) if base_reg?(op)

      addr_off = mem_addr_off(plan, op) || (point_base_at_scratch(plan, op) && mem_addr_off(plan, op))
      addr_off && set_mem(plan, addr_off, { 'scratch_off' => STRING_POOL })
    end

    # Give a single-deref operand's base register somewhere to point, so the
    # memory it names has an address to live at. Reading the pointer AT an address
    # requires that address readable, so a nested readable establishes its own
    # base -- nothing shallower has to say it.
    # @return [Boolean] false when the register is not one the plan may set.
    def point_base_at_scratch(plan, op)
      settable?(op.reg) && set_reg(plan, op.reg, { 'scratch_off' => STRING_POOL })
    end

    # Whether a pointer-form +X is a valid argv/envp+ operand already resolves to
    # scratch: +X+ itself (deref 0), or the memory +X+ dereferences (deref 1).
    def pointer_resolved?(plan, op)
      return base_reg?(op) || scratch?(plan, op.reg) if op.deref.zero?
      return pointer_value?(plan.base_mem[op.imm]) if base_reg?(op)

      addr_off = mem_addr_off(plan, op)
      addr_off && pointer_value?(plan.mem[addr_off])
    end

    def apply_relation(plan, disjunct)
      reg, value = parse_relation(disjunct)
      return false unless reg

      set_reg(plan, reg, value & MASK64)
    end

    # Parse a branch-condition disjunct into the [register, value] that satisfies
    # it, or [nil, nil] when it isn't a settable single-register relation.
    # @return [(String, Integer), (nil, nil)]
    def parse_relation(disjunct)
      if (m = disjunct.match(/\A\((\w+) & (#{IMM})\) (==|!=) (#{IMM})\z/))
        reg = m[1]
        mask = Integer(m[2])
        op = m[3]
        rhs = Integer(m[4])
        return [nil, nil] unless settable?(reg)

        witness = masked_witness(mask, op, rhs)
        return witness.nil? ? [nil, nil] : [xreg(reg), witness]
      end
      if (m = disjunct.match(/\A(?:\([su]\d+\))?(.+?) (==|!=|<=|>=|<|>) (#{IMM})\z/))
        # The left side may carry a displacement, e.g. `(x0 + 0x1) != 0x0`; the
        # register then holds the witness less that displacement.
        op = safe_parse(m[1])
        if op&.deref&.zero? && op.reg && op.inner_imm.zero? && settable?(op.reg)
          witness = relation_witness(m[2], Integer(m[3]))
          return [xreg(op.reg), (witness - op.imm) & MASK64] if witness
        end
      end
      [nil, nil]
    end

    # +([X] & mask) <op> want+: the value to write at +[X]+, in the shape
    # {#deref_relation} returns. Only equality and inequality are modelled -- an
    # ordering between a masked read and a literal hasn't been needed.
    # @return [(Aletheia::Operand, Integer, Boolean), nil]
    def masked_deref_relation(op, mask, relop, want)
      return nil unless %w[== !=].include?(relop)

      witness = masked_witness(mask, relop, want)
      witness && [op, witness, false]
    end

    # Split +text+ into the operand a mask is applied to and that mask, or leave
    # it alone when it carries none (see {MASKED}).
    # @return [(String, Integer or nil)]
    def unmask(text)
      m = text.match(MASKED) or return [text, nil]

      [m[1], Integer(m[2])]
    end

    # Rewrite a rounded-down address -- +(rsi & 0xfffffffffffffff0)+, a gadget
    # aligning a pointer -- to the pointer itself, since every address this hands
    # out is already aligned enough for the rounding to leave it untouched.
    #
    # Only for a context where the value IS an address. As a *value* a mask is a
    # requirement on bits, which {#masked_witness} answers exactly; dropping it
    # there would silently accept a target the mask cannot produce. A mask left in
    # place fails to parse, and the gadget skips rather than being mis-planned.
    # @example
    #   unmask_address('[(rsi & 0xfffffffffffffff0)] == NULL') #=> '[rsi] == NULL'
    #   unmask_address('(eax & 0xf000) == 0x2000')             #=> unchanged
    def unmask_address(text)
      text.gsub(MASKED_INNER) do
        operand = Regexp.last_match(1)
        mask = Integer(Regexp.last_match(2))
        alignment_mask?(mask) && slots_aligned_to?(mask) ? operand : Regexp.last_match(0)
      end
    end

    # Parse +text+ in a context where its value is an ADDRESS, so a rounding mask
    # is an alignment rather than a requirement on bits (see {#unmask_address}).
    # @return [Aletheia::Operand, nil] nil when this isn't an address we can place.
    def address_operand(text)
      safe_parse(unmask_address(text))
    end
    alias writable_target address_operand

    # Whether every address this satisfier hands out already satisfies +mask+, so
    # rounding one leaves it untouched. Checked against the actual offsets rather
    # than assumed: a coarser mask (page alignment, say) would not survive
    # {WRITABLE_STRIDE}.
    def slots_aligned_to?(mask)
      granularity = alignment_granularity(mask)
      [WRITABLE_BASE, WRITABLE_STRIDE, STRING_POOL, COMMAND_POOL].all? { |off| (off % granularity).zero? }
    end

    # The alignment +mask+ rounds to: its lowest set bit, which is where the run
    # of cleared low bits ends.
    def alignment_granularity(mask)
      mask & -mask
    end

    # A value whose masked bits meet +want+, for +(X & mask) <op> want+.
    #
    # +==+ needs +want+ to fit inside the mask, since bits the mask clears can
    # never be part of the result; when it does, +want+ itself is the value.
    # +!=+ needs any value differing from +want+ somewhere the mask keeps, and
    # flipping every masked bit gives one for free.
    # @return [Integer, nil] The value to give X, or nil when nothing can satisfy it.
    # @example
    #   masked_witness(0xf000, '==', 0x2000) #=> 0x2000
    #   masked_witness(0xf000, '==', 0x1)    #=> nil   -- 0x1 is outside the mask
    #   masked_witness(0x10, '!=', 0x0)      #=> 0x10
    def masked_witness(mask, op, want)
      return nil unless want.nobits?(~mask & MASK64)

      op == '==' ? want : (want ^ mask) & MASK64
    end

    # Whether +mask+ only clears low bits, i.e. it aligns rather than selects.
    # Such a mask on an address asks for an aligned one, which a scratch slot
    # already is (see {#slots_aligned_to?}).
    #
    # Every bit above the cleared run must be set, which is the same as the mask
    # carrying to the top when its own granularity is added. Tested against both
    # widths, so a 32-bit mask isn't mistaken for a field selector by complementing
    # it over 64 bits.
    # @example
    #   alignment_mask?(0xfffffffffffffff0) #=> true   -- clears the low 4 bits
    #   alignment_mask?(0xfffffff0)         #=> true   -- the same, 32-bit
    #   alignment_mask?(0xf000)             #=> false  -- selects a field
    def alignment_mask?(mask)
      return false unless mask.positive?

      [1 << 32, 1 << 64].include?(mask + alignment_granularity(mask))
    end

    # A comparison between two registers, e.g. +x3 == x0+ or +r3 != r1+: neither
    # side is a literal, so {#parse_relation} (a register against an immediate)
    # can't express it. Only equality is modeled -- an ordering between two
    # uncontrolled registers hasn't been needed, and picking witnesses for it
    # would constrain both sides more than the branch actually requires.
    # @return [(String, String, String), nil] normalised lhs, operator, rhs.
    def reg_relation(disjunct)
      m = disjunct.match(/\A(?:\([su]\d+\))?(\w+) (==|!=) (?:\([su]\d+\))?(\w+)\z/) or return nil
      lhs, op, rhs = m.captures
      # \w+ also matches a hex literal, which is {#parse_relation}'s business.
      return nil if [lhs, rhs].any? { |r| r.match?(/\A#{IMM}\z/) }
      return nil unless settable?(lhs) && settable?(rhs)

      [xreg(lhs), op, xreg(rhs)]
    end

    # Whether both registers already hold values meeting +op+.
    def reg_relation_satisfied?(plan, lhs, op, rhs)
      return op == '==' if lhs == rhs # the same register, after normalisation

      a, b = plan.regs.values_at(lhs, rhs)
      return false if a.nil? || b.nil?

      values_equal?(a, b) == (op == '==')
    end

    # Pin whichever side isn't pinned yet so +op+ holds. A register already set by
    # an earlier constraint is never overwritten -- the other side is matched to
    # it, and a genuine conflict falls through to {#set_reg}'s refusal.
    def apply_reg_relation(plan, lhs, op, rhs)
      return op == '==' if lhs == rhs

      a, b = plan.regs.values_at(lhs, rhs)
      return reg_relation_satisfied?(plan, lhs, op, rhs) unless a.nil? || b.nil?
      return set_reg(plan, lhs, counterpart(b, op)) if a.nil? && !b.nil?
      return set_reg(plan, rhs, counterpart(a, op)) if b.nil? && !a.nil?

      set_reg(plan, lhs, 0) && set_reg(plan, rhs, op == '==' ? 0 : 1)
    end

    # A value for the unpinned side of a register equality, given the pinned
    # side's value +val+ (an integer, or a scratch-pointer Hash).
    def counterpart(val, op)
      return val if op == '=='
      return 0 if val.is_a?(Hash) # a scratch pointer is a large nonzero address

      (val + 1) & MASK64
    end

    # A comparison between a register and a value read from memory, e.g.
    # +x3 == [x1+0x8]+ or +r13d == [r14+0x70]+: neither {#parse_relation}
    # (register against an immediate) nor {#deref_relation} (memory against an
    # immediate) covers it, since neither side is a literal. Returns the register
    # operand, the operator, and the memory operand, in whichever order they were
    # written.
    # @return [(Aletheia::Operand, String, Aletheia::Operand), nil]
    def reg_mem_relation(disjunct)
      m = disjunct.match(RELATION) or return nil
      lhs, op, rhs = m.captures
      return nil if [lhs, rhs].any? { |s| s.match?(/\A#{IMM}\z/) }

      a, b = [lhs, rhs].map { |s| safe_parse(s) }
      reg, mem = a&.deref&.zero? ? [a, b] : [b, a]
      return nil unless reg&.deref&.zero? && reg.reg && settable?(reg.reg)
      return nil unless (1..2).cover?(mem&.deref.to_i) && mem.reg

      [reg, op, mem]
    end

    # A comparison between two memory operands, e.g.
    # +[sp+0x10] == [[$base+0x1c2438]+0x70]+: with neither side a register or a
    # literal, the value has to be matched in memory on both sides.
    # @return [(Aletheia::Operand, String, Aletheia::Operand), nil]
    def mem_mem_relation(disjunct)
      m = disjunct.match(RELATION) or return nil
      lhs, op, rhs = m.captures
      return nil if [lhs, rhs].any? { |s| s.match?(/\A#{IMM}\z/) }

      a, b = [lhs, rhs].map { |s| safe_parse(s) }
      return nil unless a&.reg && b&.reg && a.deref.positive? && b.deref.positive?

      [a, op, b]
    end

    # Whether the two locations already read values meeting +op+.
    def mem_mem_satisfied?(plan, lhs, op, rhs)
      a = mem_value(plan, lhs)
      b = mem_value(plan, rhs)
      return false if a.nil? || b.nil?

      values_equal?(a, b) == (op == '==')
    end

    # Store matching (or deliberately differing) values in the two locations.
    # Whichever side already reads a known value drives the other, so a value an
    # earlier constraint pinned is preserved rather than overwritten.
    def apply_mem_mem_relation(plan, lhs, op, rhs)
      a = mem_value(plan, lhs)
      b = mem_value(plan, rhs)
      return apply_literal(plan, rhs, counterpart(a, op)) if a.is_a?(Integer)
      return apply_literal(plan, lhs, counterpart(b, op)) if b.is_a?(Integer)

      apply_literal(plan, lhs, 0) && apply_literal(plan, rhs, op == '==' ? 0 : 1)
    end

    # The value tracked memory holds at run time, or +nil+ when unknown. An
    # address inside our scratch reads zero unless the plan writes it; a libc
    # global keeps whatever libc left there, so it counts as known only once the
    # plan has written it.
    def mem_value(plan, op)
      if op.deref >= 2
        target = deep_target_off(plan, op)
        return target && (plan.mem[target] || (zeroed_scratch?(target) ? 0 : nil))
      end
      raw = base_reg?(op) ? plan.base_mem[op.imm] : single_deref_value(plan, op)
      # At one dereference the displacement adds to the value read (`[sp+0xc8]+0x1`),
      # where at two it addresses the field (handled above).
      return raw if op.inner_imm.zero? || !raw.is_a?(Integer)

      (raw + op.inner_imm) & MASK64
    end

    # The value a single-dereference operand reads out of scratch, or +nil+ when
    # its address isn't resolvable yet.
    def single_deref_value(plan, op)
      addr_off = mem_addr_off(plan, op)
      return nil unless addr_off

      plan.mem[addr_off] || (zeroed_scratch?(addr_off) ? 0 : nil)
    end

    # The scratch offset of the level-1 slot +[reg+imm]+, allocating a scratch
    # pointer for a settable base register when +allocate+ is set.
    def level1_addr_off(plan, op, allocate: false)
      off = mem_addr_off(plan, op)
      return off if off
      return nil unless allocate && op.reg && settable?(op.reg)

      slot = scratch_slot(plan, op.imm)
      set_reg(plan, xreg(op.reg), slot) ? slot['scratch_off'] + op.imm : nil
    end

    # The scratch offset a two-level operand +[[reg+imm]+inner]+ addresses: the
    # pointer stored at +[reg+imm]+, displaced by +inner_imm+. With +allocate+,
    # an unset pointer is made to reference a fresh scratch area, so the field it
    # addresses lands in the zero fill.
    def deep_target_off(plan, op, allocate: false)
      via_base = base_reg?(op)
      slot_off = via_base ? nil : level1_addr_off(plan, op, allocate:)
      return nil unless via_base || slot_off

      current = via_base ? plan.base_mem[op.imm] : plan.mem[slot_off]
      return current['scratch_off'] + op.inner_imm if pointer_value?(current)
      # A location pinned only as "nonzero" may be promoted to a pointer, which is
      # nonzero too, so the constraint that pinned it still holds.
      return nil unless allocate && (current.nil? || nonzero_witnesses.include?(witness_key(op)))

      target = scratch_slot(plan, 0)['scratch_off']
      pointer = { 'scratch_off' => target }
      via_base ? (plan.base_mem[op.imm] = pointer) : (plan.mem[slot_off] = pointer)
      stored = true
      stored ? target + op.inner_imm : nil
    end

    # Whether the register and the memory value already meet +op+.
    def reg_mem_satisfied?(plan, reg, op, mem)
      current = reg_value(plan, reg.reg)
      value = mem_value(plan, mem)
      return false if current.nil? || value.nil? || current.is_a?(Hash) || value.is_a?(Hash)

      (((current + reg.imm) & MASK64) == value) == (op == '==')
    end

    # Match the register and the memory it is compared against. Whichever side is
    # already settled drives the other: when the memory's contents are known (a
    # zero-filled scratch slot, or a value an earlier constraint stored) the
    # register is pinned to match it, rather than overwriting memory that another
    # constraint depends on -- e.g. +[$base+off] != 0+ pins the global first, and
    # +x3 == [$base+off]+ must then take its value, not reset it. A register
    # already pinned to a scratch pointer is left alone: its run-time address
    # isn't known here, so no stored literal can be shown to equal it.
    def apply_reg_mem_relation(plan, reg, op, mem)
      current = reg_value(plan, reg.reg)
      return false if current.is_a?(Hash)

      # The comparison is on `reg + imm`, so the register itself carries the
      # displacement: it holds the matched value less `imm`. Only a register still
      # free can be pinned from what memory holds -- one another constraint has
      # already settled would have to be repinned to a different value, which is a
      # conflict, so the memory side is the one to arrange instead.
      known = mem_value(plan, mem)
      if current.nil? && known && !known.is_a?(Hash)
        return set_reg(plan, xreg(reg.reg), (counterpart(known, op) - reg.imm) & MASK64)
      end

      value = current || 0
      lhs = (value + reg.imm) & MASK64
      set_reg(plan, xreg(reg.reg), value) && apply_literal(plan, mem, counterpart(lhs, op))
    end

    # Whether two plan values denote the same runtime value: two scratch pointers
    # at the same offset, or two equal integers. A scratch pointer and an integer
    # are never treated as equal -- the pointer's address isn't known until the
    # driver resolves it.
    def values_equal?(a, b)
      return a['scratch_off'] == b['scratch_off'] if a.is_a?(Hash) && b.is_a?(Hash)
      return false if a.is_a?(Hash) || b.is_a?(Hash)

      a == b
    end

    # A value satisfying +<reg> op imm+. An upper bound admits a whole range, so
    # pick the smallest benign member (zero) rather than the bound itself: a
    # register pinned to the extreme needlessly conflicts with a co-occurring
    # constraint on the same register, e.g. +(u64)rax <= 0xfffffffffffff000+
    # alongside +eax == 0x0+, which zero satisfies at once.
    def relation_witness(op, imm)
      case op
      when '==', '>=' then imm
      # Any value but +imm+ will do. Zero is the one to avoid: it is what every
      # unpinned register and every untouched scratch word already reads as, so a
      # witness of zero is the one certain to collide with another constraint
      # comparing this same value against something else.
      when '!=' then imm == 1 ? 2 : 1
      when '>'  then imm + 1
      when '<=' then imm.negative? ? imm : 0
      when '<'  then imm.positive? ? 0 : imm - 1
      end
    end

    # A distinct scratch write-area for a +writable: reg+imm+ target.
    def scratch_slot(plan, imm)
      slot = plan.writable_count
      plan.writable_count += 1
      { 'scratch_off' => WRITABLE_BASE + slot * WRITABLE_STRIDE - imm }
    end

    # +X+ in +X is a valid argv/envp+ (the bare-pointer form, not an array
    # literal): either +X+ itself is the pointer (deref 0 -- point the register
    # at scratch), or +X+ is +[base]+ (deref 1 -- a store through a pointer read
    # off the stack, e.g. Finding 6's shape; write the scratch pointer into
    # +base+'s own memory instead, via {#mem_addr_off}). A bare +readable: <reg>+
    # is handled directly in {#apply} via {#apply_pointer}, not here.
    # @return [Aletheia::Operand, nil]
    def pointer_form(branch)
      ptr = branch[/\A(\S+) is a valid (?:argv|envp)\z/, 1]
      return nil unless ptr && !ptr.start_with?('{')

      op = safe_parse(ptr)
      op if op&.reg && op.deref <= 1
    end

    # Parse an operand, refusing one this satisfier's scratch-and-register
    # machinery cannot place. A base sum names an address only its register
    # decides, so the constraint forms that know how to steer it ask for it
    # explicitly (see {#base_sum}); every other consumer would otherwise plan it
    # as if the fixed address weren't there.
    def safe_parse(str)
      op = parse_operand(str) or return nil
      op.base_imm.zero? ? op : steered(op)
    end

    # The plain libc-global operand a base sum becomes once its register is
    # pinned: +(reg + $base+B)+I+ addresses +$base+(slot+I)+, and a dereference
    # of it reads that libc memory. nil when the register was not steered, so a
    # sum used as a *value* still reaches only the constraint forms that know
    # what to make of it, rather than being read as an address it isn't.
    # @return [Aletheia::Operand, nil]
    def steered(op)
      slot = op.reg && @steered && @steered[xreg(op.reg)] or return nil

      Operand.new('$base', slot + op.imm, op.deref, op.cast_bits, op.inner_imm, 0)
    end

    # The libc offset base sums on +reg+ are steered to: one fixed area per
    # register, so the same sum always lands in the same place and two registers
    # never overlap. nil when the spare region has no area for that register.
    def spare_slot(reg)
      index = @arch.gprs.index(reg)
      return nil unless index && @spare_writable

      slot = @spare_writable.first + index * SPARE_STRIDE
      slot if @spare_writable.cover?(slot + SPARE_STRIDE - 1)
    end

    def parse_operand(str)
      OperandParser.parse(str)
    rescue ArgumentError
      nil
    end

    # A register the plan points at scratch (a readable+writable, zero-filled ptr).
    # A register holding some *other* resolved address -- the libc GOT, say -- is
    # not one: its scratch offset is what every caller goes on to read.
    def scratch?(plan, reg)
      pointer_value?(reg_value(plan, reg))
    end

    def global?(reg)
      reg.start_with?('$')
    end

    def settable?(reg)
      @arch.gprs.include?(xreg(reg))
    end

    # Normalise a sub-register view to its full-width register; the mapping is
    # arch-specific (+w21+ -> +x21+ on aarch64, +eax+ -> +rax+ on amd64).
    def xreg(reg)
      @arch.normalize_reg(reg)
    end

    # Whether the plan pins this to the literal zero, as opposed to a pointer, a
    # value only the driver can compute, or nothing at all.
    # @param [Integer, Hash, String, nil] value
    # @return [Boolean]
    def pinned_to_zero?(value)
      value.eql?(0)
    end

    # What the plan assigns +reg+, under whichever name it was written: a role
    # name and the register it denotes are one register, and reading only the
    # name asked for would miss an assignment made under the other.
    # @example (arm) +fp+ and +r11+
    def reg_value(plan, reg)
      plan.regs[xreg(reg)]
    end

    def set_reg(plan, reg, value)
      return false if reg.nil?

      reg = xreg(reg)
      existing = plan.regs[reg]
      return false if existing && existing != value

      plan.regs[reg] = value
      true
    end

    # As {#set_reg}, but for a scratch-relative memory write (+plan.mem+): false
    # on a conflicting write to an already-assigned offset.
    def set_mem(plan, off, value)
      existing = plan.mem[off]
      return false if existing && existing != value

      plan.mem[off] = value
      true
    end

    # As {#set_mem}, but for a libc global (+plan.base_mem+), which the driver
    # writes at +base + off+ once the runtime load base is known.
    def set_base_mem(plan, off, value)
      existing = plan.base_mem[off]
      return false if existing && existing != value

      plan.base_mem[off] = value
      true
    end

    def stack_reg?(reg)
      @arch.stack_regs.include?(reg)
    end
  end
end
