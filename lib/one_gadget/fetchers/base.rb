require 'shellwords'

module OneGadget
  module Fetcher
    # define common methods for gadget fetchers.
    class Base
      # The absolute path of glibc.
      # @return [String] The filename.
      attr_reader :file
      # Instantiate a fetcher object.
      # @param [String] file Absolute path of target libc.
      def initialize(file)
        @file = ::Shellwords.escape(file)
      end

      # Method need to be implemented in inheritors.
      # @return [Array<OneGadget::Gadget::Gadget>] Gadgets found.
      def find; raise NotImplementedError
      end

      # Fetch candidates that end with call exec*.
      # @return [Array<String>]
      #   Each +String+ returned is multi-lines of assembly code.
      def candidates(&block)
        cands = `objdump -w -d -M intel "#{file}"|egrep 'call.*<exec[^+]*>$' -B 20`.split('--').map do |cand|
          cand.lines.map(&:strip).reject(&:empty?).join("\n")
        end
        # remove all calls, jmps
        cands = slice_prefix(cands, &method(:branch?))
        cands.select!(&block) if block_given?
        cands
      end

      private

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
        match = `strings -tx #{file} -n #{str.size} | grep " #{::Shellwords.escape(str)}"`.lines.map(&:strip).first
        return nil if match.nil?
        # 17c8c3 /bin/sh
        match.split.first.to_i(16)
      end

      def offset_of(assembly)
        assembly.scan(/^([\da-f]+):/)[0][0].to_i(16)
      end
    end
  end
end
