require 'one_gadget/helper'
require 'one_gadget/gadget'

module OneGadget
  # To find gadgets.
  module Fetcher
    # Define class methods here.
    module ClassMethods
      # Fetch one-gadget offsets of this build id.
      # @param [String] build_id The targets' BuildID.
      # @param [Boolean] details
      #   If needs to return the gadgets' constraints.
      # @return [Array<Integer>, Array<OneGadget::Gadget::Gadget>]
      #   If +details+ is +false+, +Array<Integer>+ is returned, which
      #   contains offset only.
      #   Otherwise, array of gadgets is returned.
      def from_build_id(build_id, details: false)
        if (build_id =~ /\A#{OneGadget::Helper::BUILD_ID_FORMAT}\Z/).nil?
          raise ArgumentError, format('invalid BuildID format: %p', build_id)
        end
        gadgets = OneGadget::Gadget.builds(build_id)
        return gadgets if details
        gadgets.map(&:offset)
      end

      # Fetch one-gadget offsets from file.
      # @param [String] file The absolute path of libc file.
      # @param [Boolean] details
      #   If needs to return the gadgets' constraints.
      # @return [Array<Integer>, Array<OneGadget::Gadget::Gadget>]
      #   If +details+ is +false+, +Array<Integer>+ is returned, which
      #   contains offset only.
      #   Otherwise, array of gadgets is returned.
      def from_file(file, details: false)
        bin_sh_hex = str_offset(file, '/bin/sh').to_s(16)
        candidates = `objdump -d -M intel #{file}|grep -E '<execve[^+]+>$' -B 10`.split('--').select do |candidate|
          next false unless candidate.include?(bin_sh_hex)
          next false unless candidate.lines.last.include?('call') # last line must be +call execve+
          true
        end
        candidates.map! do |candidate|
          # remove other calls
          lines = candidate.lines
          to_rm = lines[0...-1].rindex { |c| c.include?('call') }
          lines = lines[to_rm + 1..-1] unless to_rm.nil?
          lines.map! { |s| s.gsub(/#\s+#{bin_sh_hex}\s+<.*>$/, "# #{bin_sh_hex} \"/bin/sh\"") }
          lines.join
        end
        gadgets = candidates.map { |c| convert_to_gadget(c) }
        return gadgets if details
        gadgets.map(&:offset)
      end

      private

      def str_offset(file, str)
        match = `strings -tx #{file} | grep '#{str}'`.lines.map(&:strip).first
        return nil if match.nil?
        # 17c8c3 /bin/sh
        match.split.first.to_i(16)
      end

      def convert_to_gadget(assembly)
        lines = assembly.lines.map(&:strip)
        offset = lines.first.scan(/^([\da-f]+):/)[0][0].to_i(16)
        # fetch those might be constraints lines.
        important_lines = lines.select { |line| ['rsi'].any? { |r| line.include?(r) } }.map do |line|
          line.split("\t").last.gsub(/\s+/, ' ')
        end
        OneGadget::Gadget::Gadget.new(offset, constraints: important_lines)
      end
    end
    extend ClassMethods
  end
end
