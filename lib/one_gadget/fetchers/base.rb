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

      def emulate(cmds)
        cmds.each_with_object(emulator) { |cmd, obj| break obj unless obj.process!(cmd) }
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
