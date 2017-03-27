require 'one_gadget/helper'
require 'one_gadget/fetchers/amd64'
require 'one_gadget/fetchers/i386'
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
        klass = {
          amd64: OneGadget::Fetcher::Amd64,
          i386: OneGadget::Fetcher::I386
        }[OneGadget::Helper.architecture(file)]
        raise ArgumentError, 'Unsupported architecture!' if klass.nil?
        gadgets = trim_gadgets(klass.new(file).find)
        return gadgets if details
        gadgets.map(&:offset)
      end

      private

      # Unique, remove gadgets with harder constraints.
      def trim_gadgets(gadgets)
        gadgets = gadgets.uniq(&:constraints).sort_by { |g| g.constraints.size }
        res = []
        gadgets.each_with_index do |g, i|
          res << g unless i.times.any? do |j|
            (gadgets[j].constraints - g.constraints).empty?
          end
        end
        res.sort_by!(&:offset)
      end
    end
    extend ClassMethods
  end
end
