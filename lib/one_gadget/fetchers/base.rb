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

      # Method need to be implemented in inheritors.
      # @return [Array<OneGadget::Gadget::Gadget>] Gadgets found.
      def find; raise NotImplementedError
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
        cands = `#{objdump_cmd}|egrep 'call.*<exec[^+]*>$' -B 20`.split('--').map do |cand|
          cand.lines.map(&:strip).reject(&:empty?).join("\n")
        end
        # remove all calls, jmps
        cands = slice_prefix(cands, &method(:branch?))
        cands.select!(&block) if block_given?
        cands
      end

      private

      def objdump_cmd(start: nil, stop: nil)
        cmd = %(objdump -w -d -M intel #{::Shellwords.escape(file)})
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
        %w(call jmp je jne jl jb ja jg).any? { |f| str.include?(f) }
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
