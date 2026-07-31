# frozen_string_literal: true

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
          lines = cand.lines
          (lines.size - 2).downto(0) do |i|
            suffix = lines[i..]
            next if seen.key?(key = suffix.join)

            seen[key] = true
            gadget = resolve_suffix(suffix)
            gadgets << gadget unless gadget.nil?
          end
        end
        gadgets
      end

      # Emulate a candidate suffix and turn it into a gadget, or +nil+ if it isn't one.
      def resolve_suffix(lines)
        processor = emulate(lines)
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
        arg0 = processor.argument(0).to_s
        arg1 = processor.argument(1).to_s
        arg2 = processor.argument(2).to_s
        res = resolve_execve_args(processor, arg0, arg1, arg2)
        return nil if res.nil?

        { constraints: res[:constraints], effect: %(execve("/bin/sh", #{arg1}, #{res[:envp]})) }
      end

      def resolve_execve_args(processor, arg0, arg1, arg2, allow_null_argv: true)
        return unless str_bin_sh?(arg0)

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
      #   as +argv+ (the string form of +processor.argument(n)+). Examples: +"rsi"+, +"rsp+0x10"+,
      #   +"[rbp-0x8]"+, or a global-variable reference.
      # * +argv+ - the array *pointed to* by +argv_ptr+: its dereferenced entries
      #   +[argv[0], argv[1], argv[2], argv[3]]+, each already converted to a string.
      #
      # @param [OneGadget::Emulators::Processor] processor The processor state at the call site.
      # @param [String] argv_ptr The pointer to the argv array. See above.
      # @param [Boolean] allow_null
      #   Whether +argv_ptr+ itself may be +NULL+ (true for +execve+, false for +posix_spawn+).
      # @return [String, nil] The constraint string, or +nil+ when no constraint is needed.
      def check_argv(processor, argv_ptr, allow_null)
        lmda = OneGadget::Emulators::Lambda.parse(argv_ptr)

        if lmda.deref_count.zero? && resolvable_stack(processor, lmda)
          return check_stack_argv(processor, argv_ptr, lmda, allow_null)
        end

        check_nonstack_argv(argv_ptr, allow_null)
      end

      # Whether resolving +lmda+'s target via tracked memory is worth attempting,
      # as opposed to the plain opaque "==NULL || is a valid .." form
      # ({#check_nonstack_argv}/the envp equivalent). Always true for the arch's
      # dedicated stack/frame pointer. For any other register, only when element
      # 0 -- what {#argv_already_valid?}/{#generate_argv_with_sh} branch on --
      # was actually written within this candidate.
      # @example element 0 tracked -- resolvable
      #   reg tracked (element 0), reg+0x8 tracked (element 1) => resolvable
      # @example a later, unrelated write must not trigger array resolution
      #   reg+0x10 (element 2) tracked, reg/reg+0x8 (elements 0/1) untracked
      #   => not resolvable; falls back to the opaque form instead of a garbled array
      # @param [OneGadget::Emulators::Processor] processor
      # @param [OneGadget::Emulators::Lambda] lmda A zero-deref pointer operand.
      # @return [Hash{Integer => OneGadget::Emulators::Lambda}, nil]
      def resolvable_stack(processor, lmda)
        stack = processor.get_corresponding_stack(lmda.obj)
        return nil unless stack
        return stack if OneGadget::ABI.stack_register?(lmda.obj)

        stack if stack.key?(lmda.immi)
      end

      # Handle the case where +argv_ptr+ points into the stack, so the +argv+ entries can be read off it.
      # @param [String] argv_ptr The pointer to the argv array. See {#check_argv}.
      # @param [OneGadget::Emulators::Lambda] lmda The parsed +argv_ptr+ (a stack register, zero dereference).
      def check_stack_argv(processor, argv_ptr, lmda, allow_null)
        stack = processor.get_corresponding_stack(lmda.obj)
        # A stack register we don't track a stack for (the frame pointer):
        # fall back to treating it as an opaque pointer.
        return check_nonstack_argv(lmda.to_s, allow_null) if stack.nil?

        argv = (0..3).map { |i| stack[lmda.immi + processor.class.bits / 8 * i].to_s }

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

      # Handle the case where +argv_ptr+ is not a plain stack pointer (e.g. a register or global variable).
      # @param [String] argv_ptr The pointer to the argv array. See {#check_argv}.
      def check_nonstack_argv(argv_ptr, allow_null)
        if allow_null
          "[#{argv_ptr}] == NULL || #{argv_ptr} == NULL || #{argv_ptr} is a valid argv"
        else
          "[#{argv_ptr}] == NULL || #{argv_ptr} is a valid argv"
        end
      end

      # If +ptr+ is a single dereference of a tracked stack slot (e.g. an earlier
      # +mov ecx, -0x30(%ebp)+ recorded what +[ebp-0x30]+ holds), resolve it to
      # that slot's own tracked value -- e.g. +"ecx"+ -- so the rest of argv/envp
      # resolution can treat it exactly like a bare register instead of an opaque
      # pointer. Only substitutes when the tracked value is itself fully resolved
      # (no further indirection): an untracked slot's placeholder is just +ptr+
      # again, so substituting would be a no-op, not a simplification.
      # @param [OneGadget::Emulators::Processor] processor
      # @param [String] ptr An argv_ptr/envp_ptr expression, e.g. +"[ebp-0x30]"+.
      # @return [String] +ptr+, or the resolved expression when it simplifies.
      # @example A stack slot holding an unresolved register
      #   # mov ecx, -0x30(%ebp)   (earlier in the same candidate)
      #   resolve_stack_deref(processor, '[ebp-0x30]') #=> 'ecx'
      def resolve_stack_deref(processor, ptr)
        lmda = OneGadget::Emulators::Lambda.parse(ptr)
        return ptr unless lmda.is_a?(OneGadget::Emulators::Lambda) && lmda.deref_count == 1 &&
                          OneGadget::ABI.stack_register?(lmda.obj)

        stack = processor.get_corresponding_stack(lmda.obj)
        tracked = stack && stack[lmda.immi]
        return ptr unless tracked.is_a?(OneGadget::Emulators::Lambda) && tracked.deref_count.zero?

        tracked.to_s
      end

      # Generate the +envp+-related constraint for an +exec*+ call.
      #
      # Mirrors the +argv+ terminology from {#check_argv}: +envp_ptr+ is the *pointer to* the envp array
      # (the string form of +processor.argument(n)+), while +envp+ is the array of dereferenced entries
      # it points to.
      #
      # @param [OneGadget::Emulators::Processor] processor The processor state at the call site.
      # @param [String] envp_ptr The pointer to the envp array.
      # @yieldparam [String] cons The +envp+ constraint, yielded only when one is required.
      # @return [Object, nil] Truthy when +envp+ is acceptable, +nil+ to reject the gadget.
      def check_envp(processor, envp_ptr)
        # If str starts with [[ and is a global variable,
        # believe it is environ.
        # If it starts with [[ but not a global var, drop it.
        return global_var?(envp_ptr) if envp_ptr.start_with?('[[')

        envp_ptr = resolve_stack_deref(processor, envp_ptr)
        lmda = OneGadget::Emulators::Lambda.parse(envp_ptr)
        # A concrete integer, or a register with nothing useful tracked for it,
        # falls through to the opaque-pointer case (see {#resolvable_stack}).
        stack = lmda.is_a?(OneGadget::Emulators::Lambda) && lmda.deref_count.zero? &&
                resolvable_stack(processor, lmda)
        if stack
          # I haven't see this case after some tests, but just in case :)
          envp = (0..3).map { |i| stack[lmda.immi + processor.class.bits / 8 * i].to_s }
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

        res = resolve_execve_args(processor, args[1].to_s, args[4].to_s, args[5].to_s, allow_null_argv: false)
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

      def str_bin_sh?(_str); raise NotImplementedError
      end

      def str_sh?(_str); raise NotImplementedError
      end

      def call_str; raise NotImplementedError
      end

      def emulate(cmds)
        cmds.each_with_object(emulator) { |cmd, obj| break obj unless obj.process(cmd) }
      end

      def emulator; raise NotImplementedError
      end

      def objdump_options
        []
      end

      def str_offset(str)
        File.binread(file).index("#{str}\x00") ||
          raise(Error::ArgumentError, "File #{file.inspect} doesn't contain string #{str.inspect}, not glibc?")
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
        m = /\A\$base\+(0x[0-9a-f]+)\z/.match(element) or return nil

        bytes = File.binread(file)
        off = m[1].to_i(16)
        stop = bytes.index("\x00", off) or return nil
        str = bytes[off...stop]
        str if str.length.between?(1, 16) && str.each_byte.all? { |c| c.between?(0x20, 0x7e) }
      end

      def offset_of(assembly)
        assembly.scan(/^([\da-f]+):/)[0][0].to_i(16)
      end

      # A single (non-disjunctive) branch condition comparing a value with
      # itself: +X == X+ / +X >= X+ is always true; +X != X+ / +X < X+ never is.
      def trivial_relation(con)
        return nil if con.include?(' || ')

        m = con.match(/\A(?:\([su]\d+\))?(.+?) (==|!=|<=|>=|<|>) (.+)\z/)
        return nil unless m && m[1] == m[3]

        %w[== >= <=].include?(m[2])
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
        disasm_lines.each_index do |idx|
          next unless disasm_lines[idx].match?(re)

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
        addr = disasm_addrs[idx]
        return if path.size >= PATH_BUDGET

        visited.add(addr)
        path.unshift(disasm_lines[idx])
        edges = predecessors(idx).reject do |pidx, cond|
          visited.include?(disasm_addrs[pidx]) || (cond && forks >= MAX_FORKS)
        end
        if edges.empty?
          blk.call(path.dup)
        else
          edges.each { |pidx, cond| back_walk(pidx, forks + (cond ? 1 : 0), visited, path, &blk) }
        end
        path.shift
        visited.delete(addr)
      end

      # Address of each disassembly line, by index. Cached (per objdump command).
      def disasm_addrs
        @disasm_addrs ||= Base.cached(:addrs, @objdump.command) { disasm_lines.map { |l| offset_of(l) } }
      end

      # Predecessors of +disasm_lines[idx]+ as +[pred_index, conditional_edge?]+:
      # the instruction that falls through to it, plus any branch that targets it.
      # Computed lazily (the walk only touches lines near terminal calls) and cached.
      def predecessors(idx)
        (@predecessors ||= {})[idx] ||= begin
          preds = []
          if idx.positive?
            kind = branch_kind(disasm_lines[idx - 1])
            preds << [idx - 1, kind == :conditional] unless %i[unconditional terminator].include?(kind)
          end
          (branch_pred_map[disasm_addrs[idx]] || []).each do |b|
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
          disasm_lines.each_index.with_object(Hash.new { |h, k| h[k] = [] }) do |i, map|
            line = disasm_lines[i]
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

      # The target's full objdump disassembly as stripped +"ADDR: insn"+ lines,
      # cached for the lifetime of the fetcher.
      def disasm_lines
        @disasm_lines ||= Base.cached(:disasm, @objdump.command) do
          sites = terminal_call_sites
          sites.nil? || sites.empty? ? full_disasm : windowed_disasm(sites)
        end
      end

      # Disassemble the whole file (the exhaustive default).
      def full_disasm
        objdump_lines
      end

      # Disassemble only [call-WINDOW_BACK, call+WINDOW_FWD] around each call site,
      # merging overlaps. Used when {#terminal_call_sites} located the calls without
      # a full disassembly (the win on the slow-to-objdump Thumb-2 arm libcs).
      def windowed_disasm(sites)
        windows = sites.sort.map { |a| [[a - WINDOW_BACK, 0].max, a + WINDOW_FWD] }
        merge_ranges(windows).flat_map { |lo, hi| objdump_lines(start: lo, stop: hi) }
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

      def objdump_lines(start: nil, stop: nil)
        `#{@objdump.command(start:, stop:)}`.lines.map(&:strip).grep(/\A[0-9a-f]+:/)
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
