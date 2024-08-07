# frozen_string_literal: true

require 'one_gadget/error'
require 'one_gadget/fetchers/objdump'

module OneGadget
  module Fetcher
    # Define common methods for gadget fetchers.
    class Base
      # The absolute path to glibc.
      # @return [String] The filename.
      attr_reader :file

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
        candidates.map do |cand|
          lines = cand.lines
          # use processor to find which can lead to a valid one-gadget call.
          gadgets = []
          (lines.size - 2).downto(0) do |i|
            processor = emulate(lines[i..])
            options = resolve(processor)
            next if options.nil? # impossible to be a gadget

            offset = offset_of(lines[i])
            gadgets << OneGadget::Gadget::Gadget.new(offset, **options)
          end
          gadgets
        end.flatten
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
        call_regexp = "#{call_str}.*<(exec[^+]*|posix_spawn[^+]*)>$"
        cands = []
        `#{@objdump.command}|grep -E '#{call_regexp}' -B 30`.split('--').each do |cand|
          lines = cand.lines.map(&:strip).reject(&:empty?)
          # split with call_regexp
          loop do
            idx = lines.index { |l| l =~ /#{call_regexp}/ }
            break if idx.nil?

            cands << lines.shift(idx + 1).join("\n")
          end
        end
        # remove all jmps
        cands = slice_prefix(cands, &method(:branch?))
        cands.select!(&) if block_given?
        cands
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

      def check_argv(processor, arg, allow_null)
        lmda = OneGadget::Emulators::Lambda.parse(arg)

        if lmda.deref_count.zero? && OneGadget::ABI.stack_register?(lmda.obj)
          return check_stack_argv(processor, lmda, allow_null)
        end

        check_nonstack_argv(arg, allow_null)
      end

      def check_stack_argv(processor, lmda, allow_null)
        stack = processor.get_corresponding_stack(lmda.obj)
        argv = (0..3).map { |i| stack[lmda.immi + processor.class.bits / 8 * i].to_s }

        # if argv is already valid, no constraints are needed! (but probably won't happen :p)
        return if argv_already_valid?(argv)

        return generate_argv_with_sh(argv) if global_var?(argv[0])

        generate_argv_without_sh(argv, allow_null)
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
            "{\"sh\", \"-c\", #{argv[2]}, #{argv_gte3}} is a valid argv"
          else
            "#{argv[1]} == NULL || {\"sh\", #{argv[1]}, #{argv[2]}, #{argv_gte3}} is a valid argv"
          end
        end
      end

      def generate_argv_without_sh(argv, allow_null)
        argv_cons = "{#{argv[0]}"
        (1..argv.length - 1).each do |i|
          if argv[i] == '0'
            argv_cons += ', NULL'
            break
          elsif i == 1 && global_var?(argv[i])
            # TODO: We probably need to get the true content of the global variable for a more accurate result
            argv_cons += ', "-c"'
          else
            argv_cons += ", #{argv[i]}"
          end
        end
        argv_cons += ', ...' unless argv_cons.end_with?('NULL')
        argv_cons += '} is a valid argv'

        if allow_null && argv.all? { |a| OneGadget::ABI.stack_register?(a) }
          # If libc writes something into the stack, arg cannot be NULL.
          # TODO: Find a better way to check can arg be NULL
          "#{arg} == NULL || #{argv[0]} == NULL || #{argv_cons}"
        else
          "#{argv[0]} == NULL || #{argv_cons}"
        end
      end

      def check_nonstack_argv(arg, allow_null)
        if allow_null
          "[#{arg}] == NULL || #{arg} == NULL || #{arg} is a valid argv"
        else
          "[#{arg}] == NULL || #{arg} is a valid argv"
        end
      end

      def check_envp(processor, arg)
        # If str starts with [[ and is a global variable,
        # believe it is environ.
        # If it starts with [[ but not a global var, drop it.
        return global_var?(arg) if arg.start_with?('[[')

        lmda = OneGadget::Emulators::Lambda.parse(arg)
        if lmda.deref_count.zero? && OneGadget::ABI.stack_register?(lmda.obj)
          # I haven't see this case after some tests, but just in case :)
          stack = processor.get_corresponding_stack(lmda.obj)
          envp = (0..3).map { |i| stack[lmda.immi + processor.class.bits / 8 * i].to_s }
          # TODO: Handle the case when libc will write something into envp
          cons = global_var?(envp[0]) ? nil : "#{arg} == NULL || {#{envp.join(', ')}, ...} is a valid envp"
        else
          cons = "[#{arg}] == NULL || #{arg} == NULL || #{arg} is a valid envp"
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
        cons << "#{arg2} == NULL || (s32)#{(arg2 + 4).deref} <= 0" if arg2.to_s != '0'
        arg3 = args[3]
        cons << "#{arg3} == NULL || (u16)#{arg3.deref} == NULL" if arg3.to_s != '0'

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

      def slice_prefix(cands, &block)
        cands.map do |cand|
          lines = cand.lines
          to_rm = lines[0...-1].rindex(&block)
          lines = lines[to_rm + 1..] unless to_rm.nil?
          lines.join
        end
      end

      # If str contains a branch instruction.
      def branch?(_str); raise NotImplementedError
      end

      def str_offset(str)
        File.binread(file).index("#{str}\x00") ||
          raise(Error::ArgumentError, "File #{file.inspect} doesn't contain string #{str.inspect}, not glibc?")
      end

      def offset_of(assembly)
        assembly.scan(/^([\da-f]+):/)[0][0].to_i(16)
      end
    end
  end
end
