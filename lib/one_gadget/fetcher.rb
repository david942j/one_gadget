require 'one_gadget/fetchers/amd64'
require 'one_gadget/fetchers/i386'
require 'one_gadget/gadget'
require 'one_gadget/helper'

module OneGadget
  # To find gadgets.
  module Fetcher
    # Define class methods here.
    module ClassMethods
      # Fetch one-gadget offsets of this build id.
      # @param [String] build_id The targets' BuildID.
      # @param [Boolean] remote
      #   When local not found, try search in latest version?
      # @return [Array<Integer>, Array<OneGadget::Gadget::Gadget>, nil]
      #   +nil+ is returned if cannot find target id in database.
      #   If +details+ is +false+, +Array<Integer>+ is returned, which contains offset only.
      #   Otherwise, array of gadgets is returned.
      def from_build_id(build_id, remote: true)
        if (build_id =~ /\A#{OneGadget::Helper::BUILD_ID_FORMAT}\Z/).nil?
          raise ArgumentError, format('invalid BuildID format: %p', build_id)
        end
        OneGadget::Gadget.builds(build_id, remote: remote)
      end

      # Fetch one-gadget offsets from file.
      # @param [String] file The absolute path of libc file.
      # @return [Array<Integer>, Array<OneGadget::Gadget::Gadget>]
      #   If +details+ is +false+, +Array<Integer>+ is returned, which
      #   contains offset only.
      #   Otherwise, array of gadgets is returned.
      def from_file(file)
        klass = {
          amd64: OneGadget::Fetcher::Amd64,
          i386: OneGadget::Fetcher::I386
        }[OneGadget::Helper.architecture(file)]
        raise ArgumentError, 'Unsupported architecture!' if klass.nil?
        trim_gadgets(klass.new(file).find)
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
