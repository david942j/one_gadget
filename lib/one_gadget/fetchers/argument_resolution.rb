# frozen_string_literal: true

module OneGadget
  module Fetchers
    # What a reached +exec+/+posix_spawn+ call requires of its caller. Reads the
    # arguments the emulator left, decides whether each is something a caller can
    # arrange -- a +"/bin/sh"+ pointer, an argv array that is already valid or can
    # be built in place, an acceptable envp -- and states what is left as the
    # gadget's constraints. Anything it cannot describe drops the candidate rather
    # than reporting a gadget that would not run. Mixed into {Base}.
    module ArgumentResolution
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
    end
  end
end
