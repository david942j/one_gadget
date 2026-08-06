# frozen_string_literal: true

require 'one_gadget/abi'
require 'one_gadget/emulators/conditional'
require 'one_gadget/emulators/lambda'
require 'one_gadget/emulators/safe_calls'
require 'one_gadget/error'

module OneGadget
  # Instruction emulator to solve the constraint of gadgets.
  module Emulators
    # Base of the per-architecture instruction emulators, used to symbolically
    # execute a candidate and solve its constraints. A subclass implements the
    # arch's supported instructions, calling convention and stack model; the
    # shared branch/compare machinery comes from {Conditional}.
    #
    # To add an architecture, see +docs/adding-an-architecture.md+.
    class Processor
      include Conditional

      attr_reader :registers # @return [Hash{String => OneGadget::Emulators::Lambda}] The current registers' state.
      attr_reader :sp_based_stack # @return [Hash{Integer => OneGadget::Emulators::Lambda}] Stack content based on sp.
      attr_reader :sp # @return [String] Stack pointer.
      attr_reader :pc # @return [String] Program counter.
      attr_reader :bp # @return [String, nil] Frame pointer, or nil when this arch tracks none.
      attr_reader :bp_based_stack # @return [Hash{Integer => Lambda}, nil] Stack content based on {#bp}, or nil.

      # Instantiate a {Processor} object.
      # @param [Array<String>] registers
      #   Registers that supported in the architecture.
      # @param [String] sp
      #   The stack register.
      def initialize(registers, sp)
        @registers = registers.to_h { |reg| [reg, to_lambda(reg)] }
        @sp = sp
        @constraints = []
        @deferred_reads = [] # pointer args of safe calls, resolved once emulation ends
        @flags = nil     # last compare, for a following conditional branch
        @pending = nil   # a conditional branch awaiting one-line-ahead resolution
        @sp_based_stack = tracked_stack(sp)
      end

      # Enable frame-pointer stack tracking with +bp+ as the frame register, so a
      # gadget staging data at +[bp+imm]+ (e.g. an argv array off the frame
      # pointer) is recovered instead of collapsing to a bare +writable:+. A nil
      # +bp+ leaves the arch +sp+-only. Call from the arch initializer after +super+.
      # @return [void]
      def setup_frame_pointer(bp)
        @bp = bp
        @bp_based_stack = tracked_stack(bp) unless bp.nil?
      end

      # Function names whose call ends a gadget: the real +exec*+ entry points.
      # Deliberately excludes the +posix_spawn+ setup helpers
      # (+posix_spawnattr_*+, +posix_spawn_file_actions_*+), which merely share the
      # +posix_spawn+ prefix.
      # @example matches +posix_spawn+, +execve+, +execveat+, +execlp+; not +posix_spawnattr_init+
      TERMINAL_CALL_RE = /\A(?:posix_spawnp?|exec(?:ve|l|v)[a-z]*)\z/

      # Whether +addr+ calls a terminal +exec*+ entry point (see
      # {#reach_terminal_call}). Matches the resolved symbol name exactly so a
      # setup helper isn't mistaken for the call it precedes.
      # @param [String] addr The call target, e.g. +"10c7d0 <posix_spawn@@GLIBC_2.15>"+.
      # @return [Boolean]
      def terminal_call?(addr)
        name = addr[/<([^@>]+)/, 1]
        !name.nil? && TERMINAL_CALL_RE.match?(name)
      end

      # Record a reached terminal +exec*+ call as the gadget's effect and stop
      # emulating: it is the gadget's goal, and any following instruction would
      # clobber the argument registers that {#resolve} reads to describe it.
      # @param [String] addr The call target.
      # @return [Symbol] +:fail+, the sentinel {#process!} maps to "stop".
      def reach_terminal_call(addr)
        registers[pc] = addr
        :fail
      end

      # Parse one command into instruction and arguments.
      # @param [String] cmd One line of result of objdump.
      # @return [(Instruction, Array<String>)]
      #   The parsing result.
      def parse(cmd)
        # instructions is a constant set; build the array (and a mnemonic index)
        # once instead of re-allocating it for every line.
        @inst_index ||= instructions.each_with_object({}) { |i, h| h[i.inst] ||= i }
        mnem = cmd[/\A[0-9a-f]+:\s*(\S+)/, 1] || cmd[/\A\s*(\S+)/, 1]
        inst = @inst_index[mnem]
        # Fall back to the original scan for any mnemonic that isn't a bare word.
        inst ||= (@inst_list ||= instructions).find { |i| i.match?(cmd) }
        raise Error::UnsupportedInstructionError, "Not implemented instruction in #{cmd}" if inst.nil?

        [inst, inst.fetch_args(cmd)]
      end

      # Process one command, without raising any exceptions.
      # @param [String] cmd
      #   See {#process!} for more information.
      # @return [Boolean]
      def process(cmd)
        process!(cmd)
      # rescue OneGadget::Error::UnsupportedError => e; p e # for debugging
      rescue OneGadget::Error::Error
        false
      end

      # Method need to be implemented in inheritors.
      #
      # Process one command.
      # Will raise exceptions when encounter unhandled instruction.
      # @param [String] _cmd
      #   One line from result of objdump.
      # @return [Boolean]
      #   If successfully processed.
      def process!(_cmd); raise NotImplementedError
      end

      # Method need to be implemented in inheritors.
      # @return [Array<Instruction>] The support instructions.
      def instructions; raise NotImplementedError
      end

      # To be inherited.
      #
      # @param [Integer] _idx
      #   The idx-th argument.
      #
      # @return [Lambda, Integer]
      #   Return value can be a {Lambda} or an +Integer+.
      def argument(_idx); raise NotImplementedError
      end

      # Marks a register holding whatever a call returned or left behind; see
      # {#clobber_caller_saved}.
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
        cons = drop_implied_nonzero(cons)
        cons.map { |type, obj| render_constraint(type, obj) }.sort
      end

      # Whether +(type, obj)+ is an address constraint on a bare (deref-0) target,
      # i.e. one carrying a base register and offset to normalise.
      def address_deref0?(type, obj)
        ADDRESS_TYPES.include?(type) && obj.deref_count.zero?
      end

      # De-duplication key: an address constraint collapses per (type, base) so
      # constraints of different types on the same register stay distinct; a raw
      # constraint keys on its own text.
      def constraint_key(type, obj)
        return obj unless ADDRESS_TYPES.include?(type)

        [type, obj.deref_count.zero? ? obj.obj.to_s : obj.to_s]
      end

      # Render a constraint to its output string.
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
          type == :cmp && obj[1] == '!=' && obj[2] == ZERO && nonzero_regs.include?(obj[0])
        end
      end

      # The stack that +obj+ addresses -- +sp+-based, {#bp}-based, or a per-register
      # write history ({#reg_based_stack}) for any other register the candidate has
      # written through.
      # @param [String, Lambda] obj A lambda object or its string.
      # @return [Hash{Integer => Lambda}, nil] The corresponding stack, or nil.
      # @example
      #   get_corresponding_stack('sp+0x10')  #=> sp_based_stack
      #   get_corresponding_stack('x29+0x40') #=> bp_based_stack (when bp is x29)
      #   get_corresponding_stack('x21')      #=> nil, or a write history if written through
      def get_corresponding_stack(obj)
        # A compound base (a nested Lambda, e.g. the address is itself "[reg]+imm" --
        # one more indirection than a simple register+offset) isn't something any of
        # sp/bp/reg_based_stack model correctly: their imm is always "an offset from a
        # *named register*", not "an offset from a dereferenced value". Matching it via
        # a substring check on its rendered form (e.g. "[rbp-0x78]" contains "rbp")
        # would silently mistrack it as bp-relative.
        return nil if obj.is_a?(OneGadget::Emulators::Lambda)

        s = obj.to_s
        return sp_based_stack if s.include?(sp)
        return bp_based_stack if bp && s.include?(bp)

        reg_based_stack(s)
      end

      # A per-register write history for a register that ISN'T the arch's
      # dedicated stack/frame pointer (those get an always-on tracked stack; see
      # the +get_corresponding_stack+ overrides in {ArmFamily}/{X86}). Lets a
      # subclass's +get_corresponding_stack+ fall back to this for any other
      # register a candidate happens to write through and immediately reuse
      # (e.g. an argv array staged via an incoming register, not sp/bp).
      #
      # Valid only while +reg+'s CURRENT value is the exact object it was when
      # the tracked writes happened: a later reassignment (e.g. +mov x4, x9+)
      # transparently starts a fresh, empty history instead of returning stale
      # content. sp/bp never needed this because they're essentially never
      # reassigned mid-candidate; an arbitrary register can be.
      # @param [String] reg A register name; returns +nil+ if it isn't a real one.
      # @return [Hash{Integer => Lambda}, nil]
      def reg_based_stack(reg)
        return nil unless reg.is_a?(String) && registers.key?(reg)

        identity = registers[reg]
        @reg_stacks ||= {}
        cached = @reg_stacks[reg]
        return cached[:mem] if cached && cached[:identity].equal?(identity)

        mem = Hash.new do |h, k|
          h[k] = OneGadget::Emulators::Lambda.new(reg).tap do |l|
            l.immi = k
            l.deref!
          end
        end
        @reg_stacks[reg] = { identity:, mem: }
        mem
      end

      private

      # An always-on tracked stack keyed by offset: a Hash that lazily materialises
      # +[reg+off]+ as a one-deref {Lambda}. Used for the +sp+- and {#bp}-based stacks.
      def tracked_stack(reg)
        Hash.new do |h, k|
          h[k] = OneGadget::Emulators::Lambda.new(reg).tap do |lmda|
            lmda.immi = k
            lmda.deref!
          end
        end
      end

      def check_register!(reg)
        raise Error::InstructionArgumentError, "#{reg.inspect} is not a valid register" unless register?(reg)
      end

      def check_argument(idx, expect)
        case expect
        when :global_var? then global_var?(argument(idx))
        when :zero? then argument(idx).is_a?(Integer) && argument(idx).zero?
        end
      end

      # Accept a +call+ to a libc function the emulator treats as non-terminal
      # (a syscall wrapper). {SafeCalls::COMMON} maps each function name to its
      # per-argument requirements: an argument index paired with one of
      # * +:zero?+ / +:global_var?+ - a precondition that must already hold, else
      #   the candidate is aborted (+:fail+).
      # * +:nullable_deref+ - the callee dereferences this argument *unless it is
      #   NULL*, which glibc guards with an explicit NULL check. When the pointer
      #   isn't already known to be mapped, +<arg> == NULL+ is recorded so the
      #   callee takes the skip-the-dereference path. Only tag an argument this way
      #   after confirming the callee both NULL-checks it and still reaches the
      #   terminal call on the NULL path.
      # * +:deref+ - the callee dereferences this argument *unconditionally* (no
      #   NULL guard), so it can't be made safe by forcing it NULL. When the pointer
      #   isn't already known to be mapped, +readable: <arg>+ is recorded so the
      #   attacker knows it must reference readable memory.
      #   @example +posix_spawnattr_setsigmask(attr, set)+ runs +attr->__ss = *set+
      # * +:writable+ - the callee *writes through* this argument (an out-param), so
      #   +writable: <arg>+ is recorded (via {#add_writable}, which drops the
      #   pc/+$base+/sp targets that are writable or fixed for free).
      #   @example +posix_spawnattr_init(attr)+ writes +*attr+
      # Both deref checks are deferred to {#finalize_deferred_reads} because a
      # +<reg>+<imm>+ pointer may only become known-mapped once a later store marks
      # +<reg>+ writable.
      # @return [nil, :fail] +nil+ = call accepted, +:fail+ = abort the candidate.
      def dispatch_safe_call(addr)
        func = SafeCalls::COMMON.keys.find { |n| addr.include?(n) }
        return :fail unless func

        requirements = SafeCalls::COMMON[func]
        requirements.each do |idx, req|
          if req == :nullable_deref
            @deferred_reads << [argument(idx), :nullable]
          elsif req == :deref
            @deferred_reads << [argument(idx), :readable]
          elsif req == :writable
            # A literal here is an address the callee would write through -- NULL
            # after a preceding call, say. Not a precondition anyone can meet.
            return :fail unless argument(idx).is_a?(OneGadget::Emulators::Lambda)

            add_writable(argument(idx))
          elsif !check_argument(idx, req)
            return :fail
          end
        end
        clobber_caller_saved
        nil
      end

      # Forget the caller-saved registers, which the call it just accepted is free
      # to leave in any state (see {OneGadget::ABI::CALLER_SAVED}). Keeping their
      # entry values would let a later branch on one -- +call __close+ then
      # +test eax, eax+ -- read as a condition on a value the caller chooses, when
      # it is really the callee's return.
      #
      # The return register is set to zero rather than forgotten: these calls are
      # accepted on the basis that they succeed, and success is what they all
      # report that way, so a branch on the result resolves instead of ending the
      # path. A path that needs the failing side then contradicts itself and drops.
      #
      # TODO: success is assumed, not required. A path that keeps going after the
      # call fails can reach a terminal call just as well, and is dropped here
      # only because the return is pinned. Modelling the result per function --
      # which values it can return, and what each one requires -- would let both
      # sides be walked, at the cost of a constraint describing the failing one.
      # @return [void]
      def clobber_caller_saved
        caller_saved.each do |reg|
          next unless registers.key?(reg)

          # A vector register holds one value per lane; keep that shape.
          current = registers[reg]
          registers[reg] = current.is_a?(Array) ? Array.new(current.size) { clobbered_value } : clobbered_value
        end
        return_registers.each { |reg| registers[reg] = 0 if registers.key?(reg) }
      end

      # Names this architecture's calling convention returns a value in.
      def return_registers
        @return_registers ||= OneGadget::ABI::RETURN_REGISTERS.fetch(arch_name, [])
      end

      # Registers this architecture's calling convention lets a call destroy.
      def caller_saved
        @caller_saved ||= OneGadget::ABI::CALLER_SAVED.fetch(arch_name, [])
      end

      def arch_name
        self.class.name.split('::').last.downcase.to_sym
      end

      # Stands for a value left by a call: unknowable, and not the caller's to pick.
      def clobbered_value
        OneGadget::Emulators::Lambda.new(CLOBBERED)
      end

      # Whether +value+ is one a call left behind. Nothing can be said about it, so
      # reading one as a constraint operand abandons the path (see
      # {Conditional#operand_str}).
      def clobbered?(value)
        return value.any? { |v| clobbered?(v) } if value.is_a?(Array)

        value.is_a?(OneGadget::Emulators::Lambda) && value.obj == CLOBBERED
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
      # through its base register during emulation -- either an explicit
      # +writable+ constraint (a store {#get_corresponding_stack} couldn't
      # place, e.g. a compound destination), or a tracked write history (see
      # {#reg_based_stack}; a store the emulator *could* place -- the same
      # evidence, a different bookkeeping path).
      def writable_pointer?(val)
        return false unless val.is_a?(OneGadget::Emulators::Lambda) && val.deref_count.zero?

        base = val.obj.to_s
        return true if @constraints.any? { |type, obj| type == :writable && obj.obj.to_s == base }

        stack = reg_based_stack(base)
        !!stack && !stack.empty?
      end

      # Whether an address expression names memory known to be mapped: a stack slot,
      # the libc base, or a libc global.
      def mapped_pointer?(obj)
        obj.include?(sp) || obj == libc_base.obj.to_s || global_var?(obj)
      end

      # The libc load base as a symbolic +$base+ lambda. Only the arches that
      # concretize libc-relative operands (amd64's +rip+, arm's +pc+) ever produce
      # it; elsewhere it never matches a real operand, so it's harmless.
      # @example
      #   libc_base.to_s #=> '$base'
      def libc_base
        @libc_base ||= OneGadget::Emulators::Lambda.new('$base')
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

      # The innermost base name of a (possibly nested or dereferenced) address
      # lambda, following +obj+ through any nested lambdas.
      # @param [OneGadget::Emulators::Lambda] lmda
      # @return [String, nil] The root base name, or +nil+ for an absolute address.
      # @example
      #   root_base(arg_to_lambda('[[$base+0x10]+0x8]')) #=> '$base'
      #   root_base(arg_to_lambda('x19+0xed8'))          #=> 'x19'
      def root_base(lmda)
        obj = lmda.obj
        obj = obj.obj while obj.is_a?(OneGadget::Emulators::Lambda)
        obj
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

      def register?(reg)
        registers.include?(reg)
      end

      def to_lambda(reg)
        OneGadget::Emulators::Lambda.new(reg)
      end

      # Fetch the corresponding lambda value of instruction arguments from the current register sets.
      #
      # @param [String] arg The instruction argument passed to inst_* functions.
      # @return [Lambda]
      def arg_to_lambda(arg)
        OneGadget::Emulators::Lambda.parse(arg, predefined: registers)
      end

      def raise_unsupported(inst, *args)
        raise OneGadget::Error::UnsupportedInstructionArgumentError, "#{inst} #{args.join(', ')}"
      end

      # Resolve +sp+- and (when tracked) {#bp}-relative operands to their offset.
      def eval_dict
        bp ? { sp => 0, bp => 0 } : { sp => 0 }
      end

      def size_t
        self.class.bits / 8
      end

      def global_var?(obj)
        obj.to_s.include?(pc)
      end

      class << self
        # 32 or 64.
        # @return [Integer] 32 or 64.
        def bits; raise NotImplementedError
        end
      end
    end
  end
end
