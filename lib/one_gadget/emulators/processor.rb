# frozen_string_literal: true

require 'one_gadget/abi'
require 'one_gadget/emulators/conditional'
require 'one_gadget/emulators/constraints'
require 'one_gadget/emulators/data_processing'
require 'one_gadget/emulators/lambda'
require 'one_gadget/emulators/register_file'
require 'one_gadget/emulators/safe_calls'
require 'one_gadget/emulators/tracked_memory'
require 'one_gadget/error'

module OneGadget
  # Instruction emulator to solve the constraint of gadgets.
  module Emulators
    # Base of the per-architecture instruction emulators, used to symbolically
    # execute a candidate and solve its constraints. A subclass implements the
    # arch's supported instructions, calling convention and stack model; what it
    # inherits here is the emulation lifecycle (parse, dispatch, and the calls a
    # candidate may cross) plus four architecture-independent concerns kept in
    # modules of their own: {Conditional} for the branch/compare machinery,
    # {Constraints} for what a gadget requires of its caller, {TrackedMemory} for
    # the memory a candidate reads and writes, and {DataProcessing} for what an
    # instruction leaves in a register.
    #
    # To add an architecture, see +docs/adding-an-architecture.md+.
    class Processor
      include Conditional
      include Constraints
      include DataProcessing
      include TrackedMemory

      attr_reader :registers # @return [RegisterFile] The current registers' state.
      attr_reader :sp # @return [String] Stack pointer.
      attr_reader :pc # @return [String] Program counter.
      attr_reader :bp # @return [String, nil] Frame pointer, or nil when this arch tracks none.

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

      private

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

      # The libc load base as a symbolic +$base+ lambda. Only the arches that
      # concretize libc-relative operands (amd64's +rip+, arm's +pc+) ever produce
      # it; elsewhere it never matches a real operand, so it's harmless.
      # @example
      #   libc_base.to_s #=> '$base'
      def libc_base
        @libc_base ||= OneGadget::Emulators::Lambda.new('$base')
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
