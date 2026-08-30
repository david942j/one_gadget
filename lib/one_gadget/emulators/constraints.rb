# frozen_string_literal: true

require 'one_gadget/emulators/conditional'
require 'one_gadget/emulators/lambda'

module OneGadget
  module Emulators
    # What a candidate requires of its caller, collected while it is emulated and
    # rendered once it ends. A path that dereferences a pointer, stores through an
    # address, or reaches a call that reads one records the requirement here rather
    # than assuming it holds; {#constraints} then drops the ones another already
    # implies and names what is left. Mixed into {Processor}.
    module Constraints
      # Marks a register holding whatever a call returned or left behind; see
      # {Processor#clobber_caller_saved}.
      CLOBBERED = '$clobbered'

      # Constraint types whose payload is an address {Lambda} asserting the target
      # is mapped -- +:writable+ (a store target) and +:readable+ (an unconditional
      # dereference, see {#finalize_deferred_reads}). Both are keyed, offset-
      # normalised, and imply non-NULL identically; they differ only in how they
      # render (see {#render_constraint}). The remaining type, +:raw+, carries a
      # ready-made constraint string that keys on itself, and +:cmp+ a comparison
      # recorded as its +[lhs, operator, rhs]+ parts (see {Conditional}), so it can
      # be inspected rather than re-parsed from the rendered text.
      ADDRESS_TYPES = %i[writable readable].freeze

      # {SafeCalls} requirements naming what a callee does with a pointer argument,
      # each recorded as something the caller must arrange (see {#record_pointer}),
      # as opposed to a precondition read off the value as it stands.
      POINTER_REQUIREMENTS = %i[writable deref nullable_deref null].freeze

      # The {POINTER_REQUIREMENTS} a NULL argument already satisfies: both ask for
      # a pointer the callee will leave alone, and NULL is how that is asked for.
      NULLABLE_REQUIREMENTS = %i[nullable_deref null].freeze

      # @return [Array<String>] Where each descriptor this candidate closes is read
      #   from, in the order they are closed, without repeats.
      def closed_fds
        @closed_fds.uniq
      end

      # @return [Array<String>]
      #   Extra constraints found during execution.
      def constraints
        finalize_deferred_reads
        return [] if @constraints.empty?

        # An address constraint is keyed by its base register (deref-0) or full
        # expression (compound); several through one base (e.g. stores at reg+0x0
        # and reg+0x8) impose the same requirement, so keep just the smallest
        # offset (sort ascending, then uniq keeps that first).
        cons = @constraints.sort_by { |type, obj| address_deref0?(type, obj) ? obj.immi : 0 }
                           .uniq { |type, obj| constraint_key(type, obj) }
        cons = drop_restated_null(drop_implied_nonzero(cons))
        cons.map { |type, obj| render_constraint(type, obj) }.sort
      end

      # Whether +(type, obj)+ is an address constraint on a bare (deref-0) target,
      # i.e. one carrying a base register and offset to normalise.
      # @param [Symbol] type The constraint's type.
      # @param [Object] obj Its payload.
      # @return [Boolean]
      def address_deref0?(type, obj)
        ADDRESS_TYPES.include?(type) && obj.deref_count.zero?
      end

      # De-duplication key: an address constraint collapses per (type, base) so
      # constraints of different types on the same register stay distinct; a raw
      # constraint keys on its own text.
      # @param [Symbol] type The constraint's type.
      # @param [Object] obj Its payload.
      # @return [Object] Equal for two constraints that impose the same requirement.
      def constraint_key(type, obj)
        return obj unless ADDRESS_TYPES.include?(type)

        [type, obj.deref_count.zero? ? obj.obj.to_s : obj.to_s]
      end

      # Render a constraint to its output string.
      # @param [Symbol] type The constraint's type.
      # @param [Object] obj Its payload.
      # @return [String] The constraint as reported.
      def render_constraint(type, obj)
        case type
        when :writable then "writable: #{obj}"
        when :readable then "readable: #{obj}"
        when :cmp then obj.join(' ')
        else obj
        end
      end

      # Drop a "<reg> != 0x0" branch constraint that another constraint already
      # implies: an address constraint (+writable: <reg>+imm+ store target, or
      # +readable: <reg>+) forces <reg> to be a valid (mapped, non-NULL) pointer,
      # so a NULL-check branch on the same register adds nothing. Keeps the
      # emitted set minimal.
      # @param [Array<[Symbol, Object]>] cons The de-duplicated constraint list.
      # @return [Array<[Symbol, Object]>]
      def drop_implied_nonzero(cons)
        nonzero_regs = cons.filter_map do |type, obj|
          obj.obj.to_s if address_deref0?(type, obj)
        end
        return cons if nonzero_regs.empty?

        cons.reject do |type, obj|
          type == :cmp && obj[1] == '!=' && obj[2] == Conditional::ZERO && nonzero_regs.include?(obj[0])
        end
      end

      # Drop a "<X> == 0x0" branch constraint that a NULL requirement on the same
      # value already states (see {#require_null}). Both ask for the same zero, and
      # the one naming it NULL is the one that says what the zero is for.
      # @param [Array<[Symbol, Object]>] cons The de-duplicated constraint list.
      # @return [Array<[Symbol, Object]>]
      def drop_restated_null(cons)
        nulls = cons.filter_map { |type, obj| obj[/\A(.+) == NULL\z/, 1] if type == :raw }
        return cons if nulls.empty?

        cons.reject do |type, obj|
          type == :cmp && obj[1] == '==' && obj[2] == Conditional::ZERO && nulls.include?(obj[0])
        end
      end

      private

      # Record a descriptor the gadget closes on its way to the terminal call, by
      # where it is read from.
      #
      # Only one the caller chooses is worth recording, since which descriptor
      # lands there decides whether the spawned shell keeps its I/O. One fixed in
      # the code is nobody's to change, and no path that reaches a terminal call
      # closes one, so it isn't modelled.
      # @param [Object] fd The descriptor argument, as {#argument} returns it.
      # @return [void]
      def note_closed_fd(fd)
        @closed_fds << fd.to_s unless fd.is_a?(Integer)
      end

      # Record what the callee does through a pointer argument.
      #
      # Only a symbolic value carries a precondition the caller can arrange: an
      # address that arrived as a literal is either one nobody can make readable
      # or writable, or NULL. The exception is the argument a callee leaves alone
      # when it is NULL -- passing NULL is exactly how that is asked for, so it is
      # accepted and needs nothing of the caller.
      # @return [Boolean] false to abort the candidate.
      def record_pointer(arg, req)
        return NULLABLE_REQUIREMENTS.include?(req) if arg.is_a?(Integer) && arg.zero?
        return false unless arg.is_a?(OneGadget::Emulators::Lambda)

        case req
        when :writable then add_writable(arg)
        when :deref then @deferred_reads << [arg, :readable]
        when :nullable_deref then @deferred_reads << [arg, :nullable]
        when :null then return require_null(arg)
        end
        true
      end

      # Record that +arg+ has to be NULL. An address that is mapped by the time
      # the gadget runs -- the stack, a libc global -- names real memory and so
      # can't also be NULL, and no caller can arrange otherwise.
      # @return [Boolean] false to abort the candidate.
      def require_null(arg)
        return false if mapped_nonnull_pointer?(arg)

        @constraints << [:raw, "#{arg} == NULL"]
        true
      end

      # Now that emulation is complete and the full writable set is known, record
      # the residual constraint for each deferred pointer argument, unless it is
      # already known to reference mapped memory. A +:nullable+ deref becomes a
      # +:raw+ +<arg> == NULL+ (take the skip-the-dereference path); a +:readable+
      # deref becomes a +:readable+ constraint (NULL can't satisfy an unconditional
      # dereference) -- a typed address constraint handled like +:writable+ (see
      # {#constraints}). Idempotent: the queue is cleared once resolved.
      def finalize_deferred_reads
        @deferred_reads.each do |arg, kind|
          if kind == :readable
            next if mapped_nonnull_pointer?(arg) || writable_pointer?(arg)

            @constraints << [:readable, arg]
          else
            next if deref_safe_pointer?(arg) || writable_pointer?(arg)

            @constraints << [:raw, "#{arg} == NULL"]
          end
        end
        @deferred_reads = []
      end

      # Whether dereferencing +val+ is safe: it is NULL, or a pointer already known
      # to reference mapped memory (see {#mapped_pointer?}).
      def deref_safe_pointer?(val)
        return true if val.is_a?(Integer) && val.zero?
        return false unless val.is_a?(OneGadget::Emulators::Lambda) && val.deref_count.zero?

        mapped_pointer?(val.obj.to_s)
      end

      # Whether +val+ is already known to be a non-NULL pointer into mapped memory
      # -- the safety bar for an *unconditional* dereference, which (unlike
      # {#deref_safe_pointer?}) NULL cannot clear.
      def mapped_nonnull_pointer?(val)
        return false unless val.is_a?(OneGadget::Emulators::Lambda) && val.deref_count.zero?

        mapped_pointer?(val.obj.to_s)
      end

      # Whether +val+ points into memory already known mapped from a store
      # through its base during emulation -- either an explicit +writable+
      # constraint (a store {#get_corresponding_stack} couldn't place, e.g. a
      # compound destination), or memory tracked against that base (a store it
      # could place -- the same evidence, a different bookkeeping path).
      def writable_pointer?(val)
        return false unless val.is_a?(OneGadget::Emulators::Lambda) && val.deref_count.zero?

        base = val.obj.to_s
        return true if @constraints.any? { |type, obj| type == :writable && obj.obj.to_s == base }

        stack = get_corresponding_stack(base)
        !!stack && !stack.empty?
      end

      # Whether an address expression names memory known to be mapped: a stack slot,
      # the libc base, or a libc global.
      def mapped_pointer?(obj)
        obj.include?(sp) || obj == libc_base.obj.to_s || global_var?(obj)
      end

      # Record a "must be writable" constraint for a store's target address.
      # @param [OneGadget::Emulators::Lambda] lmda The destination address, zero-deref
      #   (already +ref!+'d by the caller).
      def add_writable(lmda)
        @constraints << [:writable, lmda] if needs_writable?(lmda)
      end

      # Require +val+'s pointer be readable when a load dereferences an
      # uncontrolled base -- one that doesn't root at mapped memory (see
      # {#mapped_pointer?}), since a value read from the stack or a libc global is
      # reliably valid. Deferred like a safe call's +:deref+ so a later store
      # proving the base writable still discharges it.
      # @param [Object] val The loaded value, as produced by {#arg_to_lambda}.
      # @example note_read(arg_to_lambda('[x19+0xed8]')) records readable: x19+0xed8
      def note_read(val)
        return unless val.is_a?(OneGadget::Emulators::Lambda) && val.deref_count.positive?

        ptr = val.dup.ref!
        root = root_base(ptr)
        return if root && mapped_pointer?(root.to_s)

        @deferred_reads << [ptr, :readable]
      end

      # Whether a store through +lmda+ imposes a "must be writable" constraint. It
      # lands on writable-or-fixed memory for free when the target is the stack
      # pointer (the stack is always writable), the program counter, or the libc
      # base (a fixed libc-internal address); a frame pointer or attacker register
      # still needs the constraint.
      # @example (sp is +rsp+, pc is +rip+)
      #   needs_writable?(arg_to_lambda('rax'))        #=> true   # an attacker register
      #   needs_writable?(arg_to_lambda('[rsp+0x8]'))  #=> false  # the stack is writable
      #   needs_writable?(arg_to_lambda('$base+0x10')) #=> false  # a fixed libc global
      def needs_writable?(lmda)
        ![sp, pc, libc_base.obj.to_s].include?(lmda.obj.to_s)
      end
    end
  end
end
