# frozen_string_literal: true

require 'one_gadget/emulators/processor'
require 'one_gadget/error'
require 'one_gadget/fetchers/objdump'

module OneGadget
  module Fetchers
    # Base of the per-architecture gadget fetchers. It discovers candidate
    # instruction sequences - a backward control-flow walk from each
    # +exec+/+posix_spawn+ call - and turns a solved candidate into a
    # {OneGadget::Gadget::Gadget}. A subclass supplies only the arch-specific
    # pieces (call mnemonic, string/global recognition, branch classification).
    #
    # To add an architecture, see +docs/adding-an-architecture.md+; +AArch64+ is
    # the simplest example.
    class Base
      # The absolute path to glibc.
      # @return [String] The filename.
      attr_reader :file

      # Give up on a control-flow path once it has crossed this many conditional branches.
      MAX_FORKS = 4
      # Hard cap on a single path's length (loop/runaway guard).
      PATH_BUDGET = 80

      # How much to disassemble around each terminal call when an architecture can
      # locate the calls cheaply (see {#terminal_call_sites} / {#windowed_disasm}).
      #
      # The backward walk stays within {PATH_BUDGET} instructions and {MAX_FORKS}
      # branch hops of the call, and a branch *into* that region comes from close
      # by. Measured across real amd64/aarch64/arm libcs, the earliest line the
      # walk reaches is <0x98b before the call and branches into it come from
      # <0x8bb further - 0x1246 all told. WINDOW_BACK = 0x2000 leaves ~60% margin;
      # a gadget whose code and branch-predecessors exceed it would be missed,
      # which is why windowing is opt-in per arch (fast disassembly arches keep
      # the full, exhaustive scan) and falls back to full disassembly if the call
      # scan comes up empty.
      WINDOW_BACK = 0x2000
      # A little past the call, enough to cover the call instruction itself.
      WINDOW_FWD = 0x80

      # Cache values that are a deterministic function of an objdump command
      # (its output and everything derived from it), so re-analysing the same
      # file - common in the specs, harmless for the CLI which reads a file once -
      # doesn't redo the disassembly or the whole-binary scans.
      def self.cached(kind, command)
        @cached ||= Hash.new { |h, k| h[k] = {} }
        @cached[kind][command] ||= yield
      end

      # Instantiate a fetcher object.
      # @param [String] file Absolute path to the target libc.
      def initialize(file)
        @file = file
        arch = self.class.name.split('::').last.downcase.to_sym
        @objdump = Objdump.new(file, arch)
        @objdump.extra_options = objdump_options
      end

      # Do find gadgets in glibc.
      # @return [Array<OneGadget::Gadget::Gadget>] Gadgets found.
      def find
        str_offset('/bin/sh') # ensure it's glibc-like; raises "not glibc?" if not found
        gadgets = []
        # Overlapping candidate paths share tails, so the same suffix (a start line
        # and everything after it) recurs across candidates; emulate each once.
        seen = {}
        candidates.each do |cand|
          executed_windows(cand.lines) do |suffix|
            next if seen.key?(key = suffix.join)

            seen[key] = true
            next if refused_before_call?(suffix)

            gadget = resolve_suffix(suffix)
            gadgets << gadget unless gadget.nil?
          end
        end
        gadgets
      end

      # Every suffix of +lines+ -- a start line and everything after it, longest
      # last -- cut down to the part that runs: emulation ends at the terminal
      # call, so anything past one never executes. A suffix reaches beyond a
      # terminal call when the function holds several and the candidate was walked
      # back from a later one. Bounding each window here lets everything
      # downstream -- {#emulate} and its overrides, the dedup key in {#find} --
      # read a window as executed code.
      #
      # Each line is classified once per candidate rather than once per suffix
      # containing it: walking the start backwards, the first terminal call at or
      # after it only moves when the start is itself one.
      # @param [Array<String>] lines One candidate, as a line list.
      # @yieldparam [Array<String>] window
      # @return [void]
      def executed_windows(lines)
        stop = lines.size - 1 if terminal_call_line?(lines.last)
        (lines.size - 2).downto(0) do |i|
          stop = i if terminal_call_line?(lines[i])
          yield(stop ? lines[i..stop] : lines[i..])
        end
      end

      # Whether +line+ is the call that ends a gadget, by the same rule the emulator
      # stops on ({OneGadget::Emulators::Processor#terminal_call?}). Not
      # {#terminal_call_regexp}, which is looser so it can locate call sites: it
      # also matches the +posix_spawn+ setup helpers, which emulation runs through.
      # The mnemonic must be a call, so a branch whose target symbol merely looks
      # similar (+<execlp@@GLIBC_2.4+0x136>+) doesn't end the window.
      def terminal_call_line?(line)
        return false unless line[/\A\s*[0-9a-f]+:\s*(\S+)/, 1]&.match?(/\A#{call_str}x?(?:\.[wn])?\z/)

        name = line[/<([^@>]+)/, 1]
        !name.nil? && OneGadget::Emulators::Processor::TERMINAL_CALL_RE.match?(name)
      end

      # Whether emulating +window+ can only stop short of its terminal call: it
      # runs a line the emulator has already refused (see
      # {OneGadget::Emulators::Processor#refused_line}), and a window that never
      # reaches the call is not a gadget. Refusal belongs to the line, so one
      # learnt anywhere settles every window carrying it -- and overlapping
      # candidates carry the same lines over and over.
      # @param [Array<String>] window
      # @return [Boolean]
      def refused_before_call?(window)
        return false if @refused.nil?

        (window.size - 1).times.any? { |i| @refused.key?(window[i]) }
      end

      # Emulate a candidate suffix and turn it into a gadget, or +nil+ if it isn't one.
      def resolve_suffix(lines)
        processor = emulate(lines)
        (@refused ||= {})[processor.refused_line] = true if processor.refused_line
        # resolve reads argument registers, which may not be evaluable on an
        # exotic path; such a candidate simply isn't a gadget.
        options = begin
          resolve(processor)
        rescue OneGadget::Error::Error
          nil
        end
        return if options.nil?
        # A branch that compares a value with itself yields a trivial condition:
        # drop the gadget if it's unsatisfiable, else strip the always-true one.
        return if options[:constraints].any? { |c| contradiction?(c) }

        options[:constraints] = options[:constraints].reject { |c| tautology?(c) }
        options[:closed_fds] = processor.closed_fds
        OneGadget::Gadget::Gadget.new(offset_of(lines.first), **options)
      end

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

      # Generating constraints for being a valid gadget.
      # @param [OneGadget::Emulators::Processor] processor The processor after executing the gadgets.
      # @return [Hash{Symbol => Array<String>, String}?]
      #   The options to create a {OneGadget::Gadget::Gadget} object.
      #   Keys might be:
      #   1. constraints: Array<String> List of constraints.
      #   2. effect: String Result function call of this gadget.
      #   If the constraints can never be satisfied, +nil+ is returned.
      def resolve(processor)
        call = processor.registers[processor.pc].to_s
        return resolve_posix_spawn(processor) if call.include?('posix_spawn')
        return resolve_execve(processor) if call.include?('execve')

        resolve_execl(processor) if call.include?('execl')
      end

      def resolve_execve(processor)
        arg0, arg1, arg2 = (0..2).map { |i| processor.argument(i) }
        res = resolve_execve_args(processor, arg0, arg1, arg2)
        return nil if res.nil?

        { constraints: res[:constraints], effect: %(execve("/bin/sh", #{arg1}, #{res[:envp]})) }
      end

      def resolve_execve_args(processor, arg0, arg1, arg2, allow_null_argv: true)
        return unless str_bin_sh?(arg0.to_s)

        # arg1 == NULL || [arg1] == NULL
        # arg2 == NULL || [arg2] == NULL || arg[2] == envp
        cons = processor.constraints
        con = check_argv(processor, arg1, allow_null_argv)
        cons << con unless con.nil?
        return nil unless cons.all?

        envp = 'environ'
        return nil unless check_envp(processor, arg2) do |c|
          cons << c
          envp = arg2
        end

        { constraints: cons, envp: }
      end

      # Generate the +argv+-related constraint for an +exec*+ call.
      #
      # Terminology shared by all the +argv+ helpers below:
      # * +argv_ptr+ - the *pointer to* the argv array, i.e. the emulated content of the register passed
      #   as +argv+ ({OneGadget::Emulators::Processor#argument}), kept as the emulator produced it.
      #   Examples: +rsi+, +rsp+0x10+, +[rbp-0x8]+, a global-variable reference, or a bare integer.
      # * +argv+ - the array *pointed to* by +argv_ptr+: its dereferenced entries
      #   +[argv[0], argv[1], argv[2], argv[3]]+, each already converted to a string.
      #
      # @param [OneGadget::Emulators::Processor] processor The processor state at the call site.
      # @param [OneGadget::Emulators::Lambda, Integer] argv_ptr The pointer to the argv array. See above.
      # @param [Boolean] allow_null
      #   Whether +argv_ptr+ itself may be +NULL+ (true for +execve+, false for +posix_spawn+).
      # @return [String, nil, false] How {#resolve_execve_args} should treat this argv:
      #   a +String+ is a constraint it must add; +nil+ means the argv is already
      #   valid so no constraint is needed; +false+ means the argv can never launch
      #   a shell (e.g. a fixed noexec option), which it consumes as an
      #   unsatisfiable constraint and drops the gadget.
      def check_argv(processor, argv_ptr, allow_null)
        argv_ptr = resolve_stack_deref(processor, argv_ptr)
        return check_stack_argv(processor, argv_ptr, allow_null) if resolvable_stack(processor, argv_ptr)

        check_nonstack_argv(argv_ptr, allow_null)
      end

      # Whether resolving +lmda+'s target via tracked memory is worth attempting,
      # as opposed to the plain opaque "==NULL || is a valid .." form
      # ({#check_nonstack_argv}/the envp equivalent). Always true for the arch's
      # dedicated stack/frame pointer. For anything else, only when element
      # 0 -- what {#argv_already_valid?}/{#generate_argv_with_sh} branch on --
      # was actually written within this candidate.
      # @example element 0 tracked -- resolvable
      #   reg tracked (element 0), reg+0x8 tracked (element 1) => resolvable
      # @example a later, unrelated write must not trigger array resolution
      #   reg+0x10 (element 2) tracked, reg/reg+0x8 (elements 0/1) untracked
      #   => not resolvable; falls back to the opaque form instead of a garbled array
      # @param [OneGadget::Emulators::Processor] processor
      # @param [OneGadget::Emulators::Lambda, Integer] lmda A pointer operand. A
      #   concrete address is never resolvable: nothing was tracked against it.
      # @return [Hash{Integer => OneGadget::Emulators::Lambda}, nil]
      def resolvable_stack(processor, lmda)
        return nil unless lmda.is_a?(OneGadget::Emulators::Lambda)

        stack, offset = processor.resolve_address(lmda)
        return nil unless stack
        return stack if lmda.deref_count.zero? && OneGadget::ABI.stack_register?(lmda.obj)

        stack if stack.key?(offset)
      end

      # Handle the case where +argv_ptr+ points into memory this candidate wrote,
      # so the +argv+ entries can be read off it.
      # @param [OneGadget::Emulators::Lambda] argv_ptr The pointer to the argv array. See {#check_argv}.
      # @return [String, nil, false] The same three-way contract as {#check_argv},
      #   which returns this value unchanged: a constraint, +nil+ (already valid),
      #   or +false+ (drop the gadget).
      def check_stack_argv(processor, argv_ptr, allow_null)
        stack, offset = processor.resolve_address(argv_ptr)
        # A stack register we don't track a stack for (the frame pointer):
        # fall back to treating it as an opaque pointer.
        return check_nonstack_argv(argv_ptr, allow_null) if stack.nil?

        argv = (0..3).map { |i| stack[offset + processor.class.bits / 8 * i].to_s }

        # A shell spawned with a fixed "noexec" option never runs a command, so
        # drop the gadget (see this method's @return for the +false+ contract).
        return false if noexec_shell_argv?(argv)

        # if argv is already valid, no constraints are needed! (but probably won't happen :p)
        return if argv_already_valid?(argv)

        return generate_argv_with_sh(argv) if global_var?(argv[0])

        generate_argv_without_sh(argv_ptr, argv, allow_null)
      end

      def argv_already_valid?(argv)
        argv[0] == '0' || (global_var?(argv[0]) && argv[1] == '0')
      end

      def generate_argv_with_sh(argv)
        # argv[0] is not controlled by the user, argv[0] probably is "/bin/sh" or "sh" (but actually, the content of
        # argv[0] doesn't quite matter, just need to make sure it's readable)
        # So far (I checked glibc 2.37), we can make argv to be {"/bin/sh", sth, NULL} or {"sh", "-c", sth, NULL}
        # TODO: We need to update this when the above assumption is no longer true
        if argv[2] == '0' && !global_var?(argv[1])
          "#{argv[1]} == NULL || {\"/bin/sh\", #{argv[1]}, NULL} is a valid argv"
        else
          argv_gte3 = argv[3] == '0' ? 'NULL' : "#{argv[3]}, ..."
          if global_var?(argv[1])
            # A leading "sh -c" whose fixed elements (e.g. "-c", the "--" separator)
            # are libc globals -- resolve them so the controllable command operand
            # stands out (e.g. {"sh", "-c", "--", x21, ...}).
            "{\"sh\", #{resolve_argv_element(argv[1])}, #{resolve_argv_element(argv[2])}, #{argv_gte3}} is a valid argv"
          else
            "#{argv[1]} == NULL || {\"sh\", #{argv[1]}, #{argv[2]}, #{argv_gte3}} is a valid argv"
          end
        end
      end

      # @param [String] argv_ptr The pointer to the argv array. See {#check_argv}.
      # @param [Array<String>] argv The argv entries +argv_ptr+ points to, i.e. +[argv[0], .., argv[3]]+.
      def generate_argv_without_sh(argv_ptr, argv, allow_null)
        argv_cons = "{#{argv[0]}"
        (1..argv.length - 1).each do |i|
          if argv[i] == '0'
            argv_cons += ', NULL'
            break
          elsif global_var?(argv[i])
            # A fixed libc-global entry (e.g. "-c", "--") -- show its true content.
            argv_cons += ", #{resolve_argv_element(argv[i])}"
          else
            argv_cons += ", #{argv[i]}"
          end
        end
        argv_cons += ', ...' unless argv_cons.end_with?('NULL')
        argv_cons += '} is a valid argv'

        if allow_null && argv.all? { |a| OneGadget::ABI.stack_register?(a) }
          # If libc writes something into the stack, argv_ptr cannot be NULL.
          # TODO: Find a better way to check can argv_ptr be NULL
          "#{argv_ptr} == NULL || #{argv[0]} == NULL || #{argv_cons}"
        else
          "#{argv[0]} == NULL || #{argv_cons}"
        end
      end

      # Whether +argv+ invokes the shell with a fixed option word that disables
      # command execution. execve's program is always "/bin/sh", so +argv[1]+ is
      # that shell's option word; a libc-global bundle carrying the noexec flag
      # there yields a shell that reaches execve yet can never run a command --
      # a false positive to drop.
      # @param [Array<String>] argv The resolved argv entries. See {#check_stack_argv}.
      # @return [Boolean]
      # @example decided by argv[1]'s libc-global content (via global_str_content)
      #   # content "-nc" carries bash's noexec 'n' => true;
      #   # "-c" runs the command => false; a non-global (attacker) word => false
      def noexec_shell_argv?(argv)
        opt = global_str_content(argv[1])
        !opt.nil? && opt.match?(/\A-[a-zA-Z]*n[a-zA-Z]*\z/)
      end

      # Handle the case where +argv_ptr+ is not a plain stack pointer (e.g. a register or global variable).
      # @param [String] argv_ptr The pointer to the argv array. See {#check_argv}.
      def check_nonstack_argv(argv_ptr, allow_null)
        if allow_null
          "[#{argv_ptr}] == NULL || #{argv_ptr} == NULL || #{argv_ptr} is a valid argv"
        else
          "[#{argv_ptr}] == NULL || #{argv_ptr} is a valid argv"
        end
      end

      # If +ptr+ is a single dereference of a tracked stack slot, resolve it to
      # that slot's own tracked value so the rest of argv/envp resolution can
      # treat it like a bare register instead of an opaque pointer.
      # @param [OneGadget::Emulators::Processor] processor
      # @param [OneGadget::Emulators::Lambda, Integer] ptr An argv_ptr/envp_ptr.
      # @return [OneGadget::Emulators::Lambda, Integer] +ptr+, or the value it
      #   resolves to when it simplifies.
      # @example a tracked slot resolves to its source register
      #   # mov [ebp-0x30], ecx   (earlier in the same candidate)
      #   resolve_stack_deref(processor, Lambda.parse('[ebp-0x30]')) #=> the ecx lambda
      # @example an untracked slot is a no-op
      #   resolve_stack_deref(processor, Lambda.parse('[ebp-0x40]')) #=> that same lambda
      def resolve_stack_deref(processor, ptr)
        return ptr unless ptr.is_a?(OneGadget::Emulators::Lambda) && ptr.deref_count == 1 &&
                          OneGadget::ABI.stack_register?(ptr.obj)

        stack, offset = processor.resolve_address(ptr.dup.ref!)
        tracked = stack && stack[offset]
        return ptr unless tracked.is_a?(OneGadget::Emulators::Lambda) && tracked.deref_count.zero?

        tracked
      end

      # Generate the +envp+-related constraint for an +exec*+ call.
      #
      # Mirrors the +argv+ terminology from {#check_argv}: +envp_ptr+ is the *pointer to* the envp array
      # ({OneGadget::Emulators::Processor#argument}), while +envp+ is the array of dereferenced entries
      # it points to.
      #
      # @param [OneGadget::Emulators::Processor] processor The processor state at the call site.
      # @param [OneGadget::Emulators::Lambda, Integer] envp_ptr The pointer to the envp array.
      # @yieldparam [String] cons The +envp+ constraint, yielded only when one is required.
      # @return [Object, nil] Truthy when +envp+ is acceptable, +nil+ to reject the gadget.
      def check_envp(processor, envp_ptr)
        # A doubly-dereferenced pointer that names a global variable is believed to
        # be environ; one that doesn't drops the gadget.
        return global_var?(envp_ptr.to_s) if envp_ptr.is_a?(OneGadget::Emulators::Lambda) &&
                                             envp_ptr.deref_count >= 2

        envp_ptr = resolve_stack_deref(processor, envp_ptr)
        # A concrete integer, or a register with nothing useful tracked for it,
        # falls through to the opaque-pointer case (see {#resolvable_stack}).
        stack = envp_ptr.is_a?(OneGadget::Emulators::Lambda) && envp_ptr.deref_count.zero? &&
                resolvable_stack(processor, envp_ptr)
        if stack
          # I haven't see this case after some tests, but just in case :)
          envp = (0..3).map { |i| stack[envp_ptr.immi + processor.class.bits / 8 * i].to_s }
          # TODO: Handle the case when libc will write something into envp
          cons = global_var?(envp[0]) ? nil : "#{envp_ptr} == NULL || {#{envp.join(', ')}, ...} is a valid envp"
        else
          cons = "[#{envp_ptr}] == NULL || #{envp_ptr} == NULL || #{envp_ptr} is a valid envp"
        end
        return nil if cons.nil?

        yield cons
      end

      # Resolve +call execl+ cases.
      def resolve_execl(processor)
        return unless str_bin_sh?(processor.argument(0).to_s)

        args = []
        arg = processor.argument(1).to_s
        if str_sh?(arg)
          arg = processor.argument(2).to_s
          args << '"sh"'
        end
        return nil if global_var?(arg) # we don't want base-related constraints

        args << arg
        cons = processor.constraints + ["#{arg} == NULL"]
        { constraints: cons, effect: %(execl("/bin/sh", #{args.join(', ')})) }
      end

      # posix_spawn (*pid, *path, *file_actions, *attrp, argv[], envp[])
      # Constraints are
      # * pid == NULL || *pid is writable
      # * file_actions == NULL || (int) (file_actions->__used) <= 0
      # * attrp == NULL || attrp->flags == 0
      # Meet all constraints then posix_spawn eventually calls execve(path, argv, envp)
      def resolve_posix_spawn(processor)
        args = Array.new(6) { |i| processor.argument(i) }
        # pid/file_actions/attrp are reasoned about as pointers (Lambdas); a
        # concrete non-zero integer there is a fixed address we can't constrain.
        return nil if [args[0], args[2], args[3]].any? { |a| a.is_a?(Integer) && !a.zero? }

        res = resolve_execve_args(processor, args[1], args[4], args[5], allow_null_argv: false)
        return nil if res.nil?

        cons = res[:constraints]
        arg0 = args[0]
        if arg0.to_s != '0'
          if arg0.deref_count.zero? && arg0.to_s.include?(processor.sp)
            # Assume stack is always writable, no additional constraints.
          else
            cons << "#{arg0} == NULL || writable: #{arg0}"
          end
        end
        arg2 = args[2]
        cons << "#{arg2} == NULL || (s32)#{(arg2 + 4).deref} <= 0x0" if arg2.to_s != '0'
        arg3 = args[3]
        cons << "#{arg3} == NULL || (u16)#{arg3.deref} == 0x0" if arg3.to_s != '0'

        { constraints: cons, effect: %(posix_spawn(#{arg0}, "/bin/sh", #{arg2}, #{arg3}, #{args[4]}, #{res[:envp]})) }
      end

      def global_var?(_str); raise NotImplementedError
      end

      # Whether +str+ names a value at a fixed offset from +base+, i.e. an address
      # whose content can be read out of the file. An operation applied to such an
      # address (see {OneGadget::Emulators::Lambda.operation}) is that address plus
      # whatever the caller supplies, so it names no particular byte and must not be
      # resolved as though it did.
      # @param [String] str A rendered value.
      # @param [String] base The token a libc-relative address renders against.
      # @return [Boolean]
      # @example A fixed global, and the same global offset by a register.
      #   base_relative?('$base+0x10', '$base')        #=> true
      #   base_relative?('(r3 + $base+0x10)', '$base') #=> false
      def base_relative?(str, base)
        str.match?(/\A\[*#{Regexp.escape(base)}(?:[+-]0x[0-9a-f]+)?\]*\z/)
      end

      def str_bin_sh?(_str); raise NotImplementedError
      end

      def str_sh?(_str); raise NotImplementedError
      end

      def call_str; raise NotImplementedError
      end

      # Run a window through a fresh emulator, stopping at the first line it can't
      # process (an unsupported instruction, or the terminal call that ends the
      # gadget). +cmds+ is an executed window (see {#executed_windows}): every line
      # in it runs, so an override may read it as evidence of what the path does.
      # @param [Array<String>] cmds
      # @return [OneGadget::Emulators::Processor]
      def emulate(cmds)
        cmds.each_with_object(emulator) { |cmd, obj| break obj unless obj.process(cmd) }
      end

      def emulator; raise NotImplementedError
      end

      def objdump_options
        []
      end

      def str_offset(str)
        file_bytes.index("#{str}\x00") ||
          raise(Error::ArgumentError, "File #{file.inspect} doesn't contain string #{str.inspect}, not glibc?")
      end

      # The target's bytes, read once: a gadget names fixed strings by file offset,
      # and every argv entry of every candidate asks for them again.
      # @return [String]
      def file_bytes
        @file_bytes ||= File.binread(file)
      end

      # Render one argv/envp entry for a constraint. A libc global that points to a
      # fixed string is shown as that string (its true content); a controllable
      # operand, or a global that isn't a plain string, is shown unchanged.
      # @param [String] element A single argv entry.
      # @example +$base+0x16b250+ -> +"--"+ (the do_system separator); +x21+ -> +x21+.
      # @return [String]
      def resolve_argv_element(element)
        content = global_str_content(element)
        content ? content.inspect : element
      end

      # The NUL-terminated printable string a resolved-offset global (+$base+<off>+)
      # points to, or +nil+ when +element+ isn't such a global or the bytes aren't a
      # short printable string. Architectures whose globals aren't yet
      # file-offset-relative simply fall through.
      # @param [String] element
      # @return [String, nil]
      def global_str_content(element)
        off = string_file_offset(element) or return nil

        bytes = file_bytes
        return nil unless off.between?(0, bytes.size - 1)

        stop = bytes.index("\x00", off) or return nil
        str = bytes[off...stop]
        str if str.length.between?(1, 16) && str.each_byte.all? { |c| c.between?(0x20, 0x7e) }
      end

      # The file offset a fixed address names, or +nil+ when +element+ isn't one.
      # Here that is the resolved-offset form an arch produces once it concretizes
      # a pc-relative operand; an arch that reaches its globals through a register
      # instead overrides this (see +I386#string_file_offset+).
      # @param [String] element
      # @return [Integer, nil]
      def string_file_offset(element)
        m = /\A\$base\+(0x[0-9a-f]+)\z/.match(element) or return nil

        m[1].to_i(16)
      end

      def offset_of(assembly)
        assembly[/\A([\da-f]+):/, 1].to_i(16)
      end

      # Whether a single (non-disjunctive) branch condition already settles itself,
      # asking nothing of the caller: +X == X+ is always true, +X != X+ never is,
      # and so on for any two sides {#comparable_values} can put a number to.
      # @param [String] con One constraint.
      # @return [Boolean, nil] Whether the relation holds, or nil when it depends
      #   on something the caller arranges -- i.e. it is a real constraint.
      def trivial_relation(con)
        return nil if con.include?(' || ')

        m = con.match(/\A(?:\([su]\d+\))?(.+?) (==|!=|<=|>=|<|>) (.+)\z/)
        return nil unless m

        lhs, rhs = comparable_values(m[1], m[3])
        return nil if lhs.nil?

        lhs.public_send(m[2] == '!=' ? :!= : m[2].to_sym, rhs)
      end

      # The two sides of a relation as plain numbers, when they can be compared
      # without the caller arranging anything: the same expression twice, two
      # concrete values, or two offsets from one base (+r1+ against +r1+0x4+ can
      # never be equal). +nil+ leaves the relation a real constraint.
      #
      # Offsets are only comparable undereferenced. +[r1]+ and +[r1+0x4]+ address
      # different slots, but the values in them are unrelated -- nothing says they
      # differ.
      # @param [String] lhs The relation's left side, cast already stripped.
      # @param [String] rhs The relation's right side.
      # @return [(Numeric, Numeric), nil] Both sides as numbers, or nil when they
      #   cannot be compared without knowing what the caller supplies.
      def comparable_values(lhs, rhs)
        return [0, 0] if lhs == rhs

        left = OneGadget::Emulators::Lambda.parse(lhs)
        right = OneGadget::Emulators::Lambda.parse(rhs)
        return [left, right] if left.is_a?(Integer) && right.is_a?(Integer)
        return nil unless [left, right].all? do |l|
          l.is_a?(OneGadget::Emulators::Lambda) && l.deref_count.zero? && !l.operation?
        end
        return nil unless left.obj.to_s == right.obj.to_s

        [left.immi, right.immi]
      rescue OneGadget::Error::Error
        nil
      end

      def tautology?(con)
        trivial_relation(con) == true
      end

      def contradiction?(con)
        trivial_relation(con) == false
      end

      # Regexp (as a String) matching an objdump line that calls a terminal
      # function (+exec*+ / +posix_spawn*+) we can turn into a gadget.
      def terminal_call_regexp
        "#{call_str}.*<(exec[^+]*|posix_spawn[^+]*)>$"
      end

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

      # Classify a disassembly +line+ for the control-flow walk (arch-specific):
      #   :conditional   - may or may not be taken; the walk explores both edges
      #                    and turns the decision into a gadget constraint
      #   :unconditional - always taken, to a determined (direct) target
      #   :terminator    - ends the path with no determined successor (a return or
      #                    an indirect/computed jump)
      #   nil            - not a branch; execution falls through to the next line
      def branch_kind(_line); raise NotImplementedError
      end

      # The leading character(s) of this arch's branch mnemonics, used to build
      # {#branch_lead_regex}. Must be plain regex-safe literals: they are spliced
      # into a character class, so no +]+, +\+, +-+ or +^+.
      # @example
      #   'bct'  # aarch64/arm: b, cbz/cbnz, tbz/tbnz
      #   'j'    # x86: jmp, jcc
      def branch_lead_chars; raise NotImplementedError
      end

      # The target's objdump disassembly as stripped +"ADDR: insn"+ lines.
      def disasm_lines
        disassembly[:lines]
      end

      # Where in {#disasm_lines} each window begins, keyed for lookup. Empty when
      # the whole file was disassembled, since then every line does follow the one
      # before it.
      # @return [Hash{Integer => true}]
      def window_starts
        disassembly[:starts]
      end

      # The disassembly and the shape it was taken in, cached (per objdump command)
      # for the lifetime of the fetcher.
      # @return [Hash{Symbol => Array<String>, Hash}]
      def disassembly
        @disassembly ||= Base.cached(:disasm, @objdump.command) do
          sites = terminal_call_sites
          sites.nil? || sites.empty? ? full_disasm : windowed_disasm(sites)
        end
      end

      # Disassemble the whole file (the exhaustive default).
      def full_disasm
        { lines: objdump_lines, starts: {} }
      end

      # Disassemble only [call-WINDOW_BACK, call+WINDOW_FWD] around each call site,
      # merging overlaps. Used when {#terminal_call_sites} located the calls without
      # a full disassembly (the win on the slow-to-objdump Thumb-2 arm libcs).
      def windowed_disasm(sites)
        windows = sites.sort.map { |a| [[a - WINDOW_BACK, 0].max, a + WINDOW_FWD] }
        starts = {}
        lines = merge_ranges(windows).each_with_object([]) do |(lo, hi), acc|
          starts[acc.size] = true
          acc.concat(objdump_lines(start: lo, stop: hi))
        end
        { lines:, starts: }
      end

      # Merge a list of sorted [lo, hi] ranges, coalescing any that overlap.
      def merge_ranges(ranges)
        ranges.each_with_object([]) do |(lo, hi), merged|
          if merged.last && lo <= merged.last[1]
            merged.last[1] = hi if hi > merged.last[1]
          else
            merged << [lo, hi]
          end
        end
      end

      # An objdump line carries an instruction when it opens with its address.
      DISASSEMBLED = /\A[0-9a-f]+:/
      private_constant :DISASSEMBLED

      def objdump_lines(start: nil, stop: nil)
        # One pass, one string per line: a whole libc is hundreds of thousands of
        # them, and only the instructions are wanted.
        `#{@objdump.command(start:, stop:)}`.each_line.filter_map do |line|
          line = line.strip
          line if DISASSEMBLED.match?(line)
        end
      end

      # Addresses of `bl`/`call` sites reaching a terminal function, found without a
      # full disassembly. +nil+ (the default) means the arch has no cheap finder,
      # so the whole file is disassembled.
      def terminal_call_sites
        nil
      end

      # Map from an instruction's address to its index in {#disasm_lines}, so a
      # given address can be located in the disassembly in O(1).
      def disasm_index
        @disasm_index ||= disasm_lines.each_with_index.to_h { |line, i| [line[/\A([0-9a-f]+):/, 1].to_i(16), i] }
      end
    end
  end
end
