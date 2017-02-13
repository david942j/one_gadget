require 'shellwords'

module OneGadget
  module Fetcher
    # define common methods for gadget fetchers.
    class Base
      attr_reader :file
      def initialize(file)
        @file = ::Shellwords.escape(file)
      end

      def find; raise NotImplementedError
      end

      # fetch candidates that end with call exec*.
      def candidates
        `objdump -d -M intel #{file}|egrep '<execve[^+]*>$' -B 20`.split('--').select do |candidate|
          next false unless candidate.lines.last.include?('call') # last line must be +call execve+
          true
        end
      end

      private

      def str_offset(str)
        match = `strings -tx #{file} | grep #{::Shellwords.escape(str)}`.lines.map(&:strip).first
        return nil if match.nil?
        # 17c8c3 /bin/sh
        match.split.first.to_i(16)
      end

      def convert_to_gadget(assembly, &block)
        lines = assembly.lines.map(&:strip)
        offset = lines.first.scan(/^([\da-f]+):/)[0][0].to_i(16)
        # fetch those might be constraints lines.
        important_lines = lines.select(&block).map do |line|
          line.split("\t").last.gsub(/\s+/, ' ')
        end
        OneGadget::Gadget::Gadget.new(offset, constraints: important_lines)
      end
    end
  end
end
