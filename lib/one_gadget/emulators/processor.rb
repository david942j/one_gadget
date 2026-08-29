# frozen_string_literal: true

require 'one_gadget/abi'
require 'one_gadget/emulators/conditional'
require 'one_gadget/emulators/lambda'
require 'one_gadget/emulators/register_file'
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

      attr_reader :registers # @return [RegisterFile] The current registers' state.
      attr_reader :sp # @return [String] Stack pointer.
      attr_reader :pc # @return [String] Program counter.
      attr_reader :bp # @return [String, nil] Frame pointer, or nil when this arch tracks none.

      # @return [Hash{Integer => OneGadget::Emulators::Lambda}] Memory written through +sp+.
      def sp_based_stack = get_corresponding_stack(sp)

      # @return [Hash{Integer => Lambda}, nil] Memory written through {#bp}, or nil when the arch has none.
      def bp_based_stack = bp && get_corresponding_stack(bp)

      # Instantiate a {Processor} object.
      # @param [Array<String>] registers
      #   Registers that supported in the architecture.
      # @param [String] sp
      #   The stack register.
      def initialize(registers, sp)
        @registers = RegisterFile.build(registers, OneGadget::ABI::NARROW_VIEWS.fetch(arch_name, {})) do |reg|
          to_lambda(reg)
        end
        @sp = sp
        @constraints = []
        @deferred_reads = [] # pointer args of safe calls, resolved once emulation ends
        @closed_fds = []     # where each descriptor closed before the terminal call comes from
        @flags = nil     # last compare, for a following conditional branch
        @pending = nil   # a conditional branch awaiting one-line-ahead resolution
      end

      # Enable frame-pointer stack tracking with +bp+ as the frame register, so a
      # gadget staging data at +[bp+imm]+ (e.g. an argv array off the frame
      # pointer) is recovered instead of collapsing to a bare +writable:+. A nil
      # +bp+ leaves the arch +sp+-only. Call from the arch initializer after +super+.
      # @return [void]
      def setup_frame_pointer(bp)
        @bp = bp
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
        self.class.line_memo(:parse)[cmd] ||= begin
          list, index = self.class.instruction_table { instructions }
          mnem = cmd[/\A[0-9a-f]+:\s*(\S+)/, 1] || cmd[/\A\s*(\S+)/, 1]
          inst = index[mnem]
          # Fall back to the original scan for any mnemonic that isn't a bare word.
          inst ||= list.find { |i| i.match?(cmd) }
          raise Error::UnsupportedInstructionError, "Not implemented instruction in #{cmd}" if inst.nil?

          [inst, inst.fetch_args(cmd)]
        end
      end

      class << self
        # What a line always reads as, remembered per architecture and +kind+ of
        # reading: a candidate is emulated once for every window it yields, so the
        # same line is read thousands of times, and nothing about how it reads
        # depends on the state the emulator holds.
        # @param [Symbol] kind
        # @return [Hash]
        def line_memo(kind)
          (@line_memo ||= Hash.new { |memo, k| memo[k] = {} })[kind]
        end

        # The architecture's supported instructions, and the same set indexed by
        # mnemonic, built on first use and shared by every emulator of that
        # architecture: the set is fixed, while an emulator is made for each of the
        # thousands of windows a candidate yields.
        # @yieldreturn [Array<Instruction>] The table, asked for only on first use.
        # @return [(Array<Instruction>, Hash{String => Instruction})]
        def instruction_table
          @instruction_table ||= begin
            list = yield
            [list, list.each_with_object({}) { |i, h| h[i.inst] ||= i }]
          end
        end
      end

      # Process one command, without raising any exceptions.
      # @param [String] cmd
      #   See {#process!} for more information.
      # @return [Boolean]
      def process(cmd)
        process!(cmd)
      # rescue OneGadget::Error::UnsupportedError => e; p e # for debugging
      rescue OneGadget::Error::UnsupportedInstructionError
        @refused_line = cmd
        false
      rescue OneGadget::Error::Error
        false
      end

      # The line this emulator could not run at all: an instruction outside
      # {#instructions}. Only what {#parse} reads decides that -- the mnemonic and
      # the operands, never the state the emulator holds -- so the same line stops
      # every emulation that reaches it.
      # @return [String, nil]
      attr_reader :refused_line

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

      # Drop a "<X> == 0x0" branch constraint that a NULL requirement on the same
      # value already states (see {#require_null}). Both ask for the same zero, and
      # the one naming it NULL is the one that says what the zero is for.
      # @param [Array<[Symbol, Object]>] cons The de-duplicated constraint list.
      # @return [Array<[Symbol, Object]>]
      def drop_restated_null(cons)
        nulls = cons.filter_map { |type, obj| obj[/\A(.+) == NULL\z/, 1] if type == :raw }
        return cons if nulls.empty?

        cons.reject do |type, obj|
          type == :cmp && obj[1] == '==' && obj[2] == ZERO && nulls.include?(obj[0])
        end
      end

      # Where +address+ lands in the memory this emulator tracks: the stack it
      # falls in and its offset within it. A load or store passes the address it
      # dereferences, i.e. its operand with that dereference peeled off.
      # @param [Lambda, String] address An address.
      # @return [(Hash{Integer => Lambda}?, Integer)] The stack, +nil+ if none
      #   tracks this address, and the offset to index it at.
      # @example an offset from a register
      #   resolve_address(Lambda.parse('rsp+0x10')) #=> [sp_based_stack, 0x10]
      # @example an offset from a pointer no register names
      #   resolve_address(Lambda.parse('[rbp-0x48]+0x8')) #=> [the "[rbp-0x48]" stack, 0x8]
      def resolve_address(address)
        base, offset = address_base(address)
        [get_corresponding_stack(base), offset]
      end

      # The memory +base+ addresses: what this candidate has written through it,
      # keyed by offset. Every base gets one -- the stack pointer, the frame
      # pointer, any other register, and a value no register names at all (a
      # pointer the candidate derived and then built an array through).
      #
      # Keyed by how the base renders, which is what makes one store enough: a
      # register that gets reassigned addresses somewhere else and renders
      # differently, so it lands on a different key without any invalidation to
      # arrange. Only a store overwriting what the base itself reads from would
      # break that, which a candidate short enough to be a gadget doesn't do.
      # @example a register
      #   get_corresponding_stack('x21')
      # @example a pointer rounded down before use
      #   get_corresponding_stack(Lambda.parse('(rsi & 0xfffffffffffffff0)'))
      # @param [String, Lambda] base A base, as {#resolve_address} yields it --
      #   not an offset expression, whose offset belongs in the key it indexes.
      # @return [Hash{Integer => Lambda}, nil] nil when +base+ names nothing this
      #   emulator tracks memory for.
      def get_corresponding_stack(base)
        return nil unless base.is_a?(OneGadget::Emulators::Lambda) || registers.key?(base.to_s)

        tracked_memory[base.to_s]
      end

      private

      # Every base this candidate has written through, each mapped to the memory
      # it addresses. See {#get_corresponding_stack}, which is how it is reached.
      # @return [Hash{String => Hash{Integer => Lambda}}]
      def tracked_memory
        @tracked_memory ||= Hash.new { |memory, base| memory[base] = tracked_stack(base) }
      end

      # Split +address+ into the base it is offset from and that offset, in the
      # forms {#get_corresponding_stack} and a tracked stack expect.
      # @param [Lambda, String] address See {#resolve_address}.
      # @return [(String, Lambda), Integer]
      def address_base(address)
        return [address, 0] unless address.is_a?(OneGadget::Emulators::Lambda)
        # Still a dereference deep, so the whole thing names one value rather than
        # an offset from anything: its own immediate is part of that name.
        return [address, 0] if address.deref_count.positive?
        # An operation's +obj+ is only the value it operates on, which addresses
        # somewhere else entirely -- a candidate building an array through
        # +(rsi & ~0xf)+ is not writing through +rsi+.
        return [address.dup.tap { |base| base.immi = 0 }, address.immi] if address.operation?

        [address.obj, address.immi]
      end

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
        end
      end

      # Accept a +call+ to a libc function the emulator treats as non-terminal
      # (a syscall wrapper). {SafeCalls::COMMON} maps each function name to its
      # per-argument requirements: an argument index paired with one of
      # * +:global_var?+ - a precondition that must already hold, else the
      #   candidate is aborted (+:fail+).
      # * +:closed_fd+ - the descriptor the callee closes. Nothing is required of
      #   it; it is recorded, because closing a standard descriptor changes what
      #   the spawned shell can still do (see {#note_closed_fd}).
      # * +:null+ - the callee must be given NULL here, so +<arg> == NULL+ is
      #   recorded for the caller to arrange. A value that can never be NULL --
      #   a fixed address, or any other non-zero literal -- aborts the candidate.
      #   @example +__sigaction(sig, act, oldact)+ writes the old action through
      #     +oldact+ unless it is NULL
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

        SafeCalls::COMMON[func].each do |idx, req|
          next note_closed_fd(argument(idx)) if req == :closed_fd

          ok = POINTER_REQUIREMENTS.include?(req) ? record_pointer(argument(idx), req) : check_argument(idx, req)
          return :fail unless ok
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
        reg = return_register
        registers[reg] = 0 if reg && registers.key?(reg)
      end

      # The register this architecture's calling convention returns a value in.
      def return_register
        OneGadget::ABI::RETURN_REGISTER[arch_name]
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

      # The value an instruction reads through +val+: what this candidate put at
      # that address, when it is one the candidate has written, and the
      # dereference itself otherwise (recording the read, see {#note_read}).
      #
      # A slot the gadget fills in reads back as what was put there, so a
      # constraint on it names the value the caller has to arrange rather than
      # whatever the slot held on entry -- which the gadget has already replaced.
      # @param [Object] val The operand's value, as produced by {#arg_to_lambda}.
      # @return [Object]
      # @example (arm) +str r3, [sp, #4]+ then +ldr r0, [sp, #4]+ reads back r3
      def read_value(val)
        stored = stored_value(val)
        return stored unless stored.nil?

        note_read(val)
        val
      end

      # What this candidate stored at the address +val+ dereferences, or +nil+ if
      # it stored nothing there. Only a single dereference of an address this
      # emulator tracks names a slot it can answer for (see {#resolve_address}).
      # @param [Object] val
      # @return [Object, nil]
      def stored_value(val)
        return nil unless val.is_a?(OneGadget::Emulators::Lambda) && val.deref_count.positive?

        stack, offset = resolve_address(val.dup.ref!)
        stack&.key?(offset) ? stack[offset] : nil
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

      # The value +op+ produces from +lhs+ and +rhs+: folded when both are
      # concrete, and otherwise named as the operation itself, since no
      # base+offset expresses it (see {Lambda.operation}). +nil+ when it is
      # neither -- an operation on something this emulator cannot name, which the
      # caller reports against its own mnemonic.
      # @param [Symbol] op A Ruby operator that doubles as how the operation renders.
      # @param [Lambda, Integer] lhs The value operated on.
      # @param [Lambda, Integer] rhs The value it is operated on with.
      # @return [Lambda, Integer, nil] The result, or nil when it is not one this
      #   emulator can name.
      # @example (amd64) +and rax, 0xf+ with rax unknown leaves +(rax & 0xf)+
      #   operation_result(:&, registers['rax'], 0xf)
      def operation_result(op, lhs, rhs)
        return lhs.send(op, rhs) if lhs.is_a?(Integer) && rhs.is_a?(Integer)
        return nil unless lhs.is_a?(OneGadget::Emulators::Lambda)

        # Exclusive-or of a value with itself is zero whether or not the value is
        # known -- how every arch spells "zero this register".
        return 0 if op == :^ && lhs.to_s == rhs.to_s

        OneGadget::Emulators::Lambda.operation(lhs, op.to_s, rhs)
      end

      # Add or subtract, and store the result.
      #
      # A sum of two values neither of which is known folds into no base+offset,
      # so it is named as the operation it is -- a candidate deriving a pointer
      # that way still says what the caller has to arrange. That is the only
      # fallback: an offset from a known base stays a base+offset, which the rest
      # of the emulator can resolve against tracked memory.
      # @param [Symbol] op +:++ or +:-+.
      # @param [String] dst The destination register.
      # @param [String] src The value added to, or the only operand given.
      # @param [String, nil] op2 The value to add, or nil in the 2-operand form.
      # @return [void]
      # @raise [OneGadget::Error::UnsupportedInstructionArgumentError]
      #   When the result is not one this emulator can name.
      def arith(op, dst, src, op2)
        check_register!(dst)
        src, op2 = shorthand(dst, src, op2)
        lhs = value_of(src)
        rhs = value_of(op2)

        result = offset_result(op, lhs, rhs)
        # The stack pointer has to stay an offset from itself: every tracked
        # stack slot is keyed on it, and a candidate that reads one back after
        # allocating a variable-size frame would be answered from the wrong
        # place. Such a frame also puts the array a gadget builds at an address
        # only a register the caller supplies decides, which no constraint this
        # emulator emits states.
        result ||= operation_result(op, lhs, rhs) unless dst == sp
        raise_unsupported(op, dst, src, op2) if result.nil?

        registers[dst] = result
      end

      # +lhs op rhs+ when the result is an offset from +lhs+'s base, which
      # {Lambda} expresses directly. +nil+ when it is not, leaving the caller to
      # name the operation instead.
      # @return [Lambda, Integer, nil]
      def offset_result(op, lhs, rhs)
        return lhs.send(op, rhs) if rhs.is_a?(Integer)
        # Adding a known offset to an unknown value is the same value shifted;
        # subtracting from one is not, so only addition commutes here.
        return rhs + lhs if op == :+ && lhs.is_a?(Integer)

        nil
      end

      # Apply a data-processing instruction and store its result. An arch that
      # allows the 2-operand shorthand may pass +src+ as the only operand.
      # @param [Symbol] op A Ruby operator that doubles as how the operation renders.
      # @param [String] dst The destination register.
      # @param [String] src The left operand, or the only one given (see {#shorthand}).
      # @param [String, nil] op2 The right operand, or nil in the 2-operand form.
      # @param [String] name The mnemonic, named in an abort.
      # @return [void]
      # @raise [OneGadget::Error::UnsupportedInstructionArgumentError]
      #   When the result is nothing this emulator can name.
      def data_op(op, dst, src, op2, name:)
        check_register!(dst)
        src, op2 = shorthand(dst, src, op2)
        result = operation_result(op, value_of(src), value_of(op2))
        raise_unsupported(name, dst, src, op2) if result.nil?

        # A shift can push bits past the register width, which the arbitrary-
        # precision fold above would otherwise keep.
        registers[dst] = result.is_a?(Integer) ? result & width_mask : result
      end

      # +op2+ with every bit flipped. Only a concrete value has a complement this
      # emulator can name; a symbolic one aborts rather than being recorded as a
      # mask it isn't.
      # @param [String] name The mnemonic to report an abort against.
      # @param [String] op2 The operand to complement.
      # @param [Array<String>] reported The operands to name in that abort.
      # @return [Integer] +op2+ complemented, within the register width.
      def complement(name, op2, *reported)
        value = value_of(op2)
        raise_unsupported(name, *reported) unless value.is_a?(Integer)

        ~value & width_mask
      end

      # Every bit of a register, for masking a result back to its width.
      # @return [Integer]
      def width_mask = (1 << self.class.bits) - 1

      # The value of an operand. {Arm} overrides it for +pc+, whose value depends
      # on the address of the instruction reading it.
      # @param [String] arg The operand, as written.
      # @return [OneGadget::Emulators::Lambda, Integer] Its current value.
      def value_of(arg) = arg_to_lambda(arg)

      # Expand a 2-operand data-processing form into its (src, op2) operands:
      # +add dst, op2+ is shorthand for +add dst, dst, op2+, while an explicit
      # 3-operand form is passed through unchanged.
      # @param [String] dst The destination register, which the 2-operand form
      #   also reads as its left operand.
      # @param [String] src The left operand, or the right one in the 2-operand form.
      # @param [String, nil] op2 The right operand, or nil in the 2-operand form.
      # @return [(String, String)] The left and right operands.
      # @example
      #   shorthand('r0', 'r4', nil) # 2-operand: add r0, r4
      #   #=> ['r0', 'r4']
      #   shorthand('r0', 'r4', '8') # 3-operand: add r0, r4, 8
      #   #=> ['r4', '8']
      def shorthand(dst, src, op2)
        op2.nil? ? [dst, src] : [src, op2]
      end

      # An instruction with no effect this emulator models anything of.
      # @return [void]
      def inst_nop(*); end

      # Track a store: write +values+ (one per word from +dst_l+) into the stack
      # {#resolve_address} resolves +dst_l+ to, and require +dst_l+
      # writable -- unless it is a pure +sp+ store. +sp+ is invariantly the
      # writable stack; the frame pointer only conventionally is, so a store
      # through it stays a real precondition (like amd64's +writable: rbp+imm+).
      # @param [OneGadget::Emulators::Lambda] dst_l The destination, zero-deref.
      # @param [Array<OneGadget::Emulators::Lambda, Integer>] values One per word.
      # @return [void]
      def track_write(dst_l, *values)
        stack, offset = resolve_address(dst_l)
        values.each_with_index { |v, i| stack[offset + size_t * i] = v } if stack
        add_writable(dst_l) unless stack.equal?(sp_based_stack)
      end

      # Replace register tokens that currently hold a concrete integer with that
      # integer, so a register-indexed memory operand becomes an offset one the
      # Lambda parser handles.
      # @example
      #   # with the index register currently holding 0xd8
      #   resolve_int_regs('[r8, r2]')  #=> '[r8, 0xd8]'
      #   resolve_int_regs('[x8, x2]')  #=> '[x8, 0xd8]'
      def resolve_int_regs(str)
        str.gsub(/[a-z]+\d*/) do |tok|
          v = registers[tok] if register?(tok)
          v.is_a?(Integer) ? OneGadget::Helper.hex(v) : tok
        end
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
