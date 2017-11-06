require 'shellwords'

module OneGadget
  module Fetcher
    # Define common methods for gadget fetchers.
    class Base
      # The absolute path of glibc.
      # @return [String] The filename.
      attr_reader :file
      # Instantiate a fetcher object.
      # @param [String] file Absolute path of target libc.
      def initialize(file)
        @file = file
      end

      # Do find gadgets in glibc.
      # @return [Array<OneGadget::Gadget::Gadget>] Gadgets found.
      def find
        candidates.map do |cand|
          lines = cand.lines
          # use processor to find which can lead to a valid one-gadget call.
          gadgets = []
          (lines.size - 2).downto(0) do |i|
            processor = emulate(lines[i..-1])
            options = resolve(processor)
            next if options.nil? # impossible be a gadget
            offset = offset_of(lines[i])
            gadgets << OneGadget::Gadget::Gadget.new(offset, options)
          end
          gadgets
        end.flatten.compact
      end

      # Fetch candidates that end with call exec*.
      #
      # Give a block to filter gadget candidates.
      # @yieldparam [String] cand
      #   Is this candidate valid?
      # @yieldreturn [Boolean]
      #   True for valid.
      # @return [Array<String>]
      #   Each +String+ returned is multi-lines of assembly code.
      def candidates(&block)
        cands = `#{objdump_cmd}|egrep 'call.*<exec[^+]*>$' -B 30`.split('--').map do |cand|
          cand.lines.map(&:strip).reject(&:empty?).join("\n")
        end
        # remove all jmps
        cands = slice_prefix(cands, &method(:branch?))
        cands.select!(&block) if block_given?
        cands
      end

      private

      # Generating constraints to be a valid gadget.
      # @param [OneGadget::Emulators::Processor] processor The processor after executing the gadgets.
      # @return [Hash{Symbol => Array<String>, String}?]
      #   The options to create a {OneGadget::Gadget::Gadget} object.
      #   Keys might be:
      #   1. constraints: Array<String> List of constraints.
      #   2. effect: String Result function call of this gadget.
      #   If the constraints can never be satisfied, +nil+ is returned.
      def resolve(processor)
        call = processor.registers[processor.pc].to_s
        # This costs cheaper, so check first.
        # check call execve / execl
        return unless %w[execve execl].any? { |n| call.include?(n) }
        # check first argument contains /bin/sh
        # since the logic is different between amd64 and i386,
        # invoke str_bin_sh? for checking
        return unless str_bin_sh?(processor.argument(0).to_s)
        if call.include?('execve')
          resolve_execve(processor)
        elsif call.include?('execl')
          resolve_execl(processor)
        end
      end

      def resolve_execve(processor)
        # arg[1] == NULL || [arg[1]] == NULL
        # arg[2] == NULL || [arg[2]] == NULL || arg[2] == envp
        arg1 = processor.argument(1).to_s
        arg2 = processor.argument(2).to_s
        cons = []
        cons << check_execve_arg(processor, arg1)
        return nil unless cons.all?
        envp = 'environ'
        return nil unless check_envp(processor, arg2) do |c|
          cons << c
          envp = arg2
        end
        { constraints: cons, effect: %(execve("/bin/sh", #{arg1}, #{envp})) }
      end

      # arg[1] == NULL || [arg[1]] == NULL
      def check_execve_arg(processor, arg)
        if arg.start_with?(processor.sp) # arg = sp+<num>
          # in this case, the only constraint is [sp+<num>] == NULL
          num = Integer(arg[processor.sp.size..-1])
          slot = processor.stack[num].to_s
          return if global_var?(slot)
          "#{slot} == NULL"
        else
          "[#{arg}] == NULL || #{arg} == NULL"
        end
      end

      def check_envp(processor, arg)
        # if str starts with [[ and is global var,
        # believe it is environ
        # if starts with [[ but not global, drop it.
        return global_var?(arg) if arg.start_with?('[[')
        # normal
        cons = check_execve_arg(processor, arg)
        return nil if cons.nil?
        yield cons
      end

      # Resolve +call execl+ case.
      def resolve_execl(processor)
        args = []
        arg = processor.argument(1).to_s
        if str_sh?(arg)
          arg = processor.argument(2).to_s
          args << '"sh"'
        end
        return nil if global_var?(arg) # we don't want base-related constraints
        args << arg
        # now arg is the constraint.
        { constraints: ["#{arg} == NULL"], effect: %(execl("/bin/sh", #{args.join(', ')})) }
      end

      def global_var?(_str); raise NotImplementedError
      end

      def str_bin_sh?(_str); raise NotImplementedError
      end

      def str_sh?(_str); raise NotImplementedError
      end

      def emulate(cmds)
        cmds.each_with_object(emulator) { |cmd, obj| break obj unless obj.process(cmd) }
      end

      def emulator; raise NotImplementedError
      end

      def objdump_cmd(start: nil, stop: nil)
        cmd = %(objdump --no-show-raw-insn -w -d -M intel #{::Shellwords.escape(file)})
        cmd.concat(" --start-address #{start}") if start
        cmd.concat(" --stop-address #{stop}") if stop
        cmd
      end

      def slice_prefix(cands)
        cands.map do |cand|
          lines = cand.lines
          to_rm = lines[0...-1].rindex { |c| yield(c) }
          lines = lines[to_rm + 1..-1] unless to_rm.nil?
          lines.join
        end
      end

      # If str contains a branch instruction.
      def branch?(str)
        %w(jmp je jne jl jb ja jg).any? { |f| str.include?(f) }
      end

      def str_offset(str)
        IO.binread(file).index(str + "\x00")
      end

      def offset_of(assembly)
        assembly.scan(/^([\da-f]+):/)[0][0].to_i(16)
      end
    end
  end
end
