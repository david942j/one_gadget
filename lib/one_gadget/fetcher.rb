require 'one_gadget/helper'
require 'one_gadget/gadget'

module OneGadget
  # To find gadgets.
  module Fetcher
    # Define class methods here.
    module ClassMethods
      # @param [String] build_id The targets' BuildID.
      # @option [Boolean] details
      #   If needs to return the gadgets' constraints.
      # @return [Array]
      def from_build_id(build_id, details: false)
        if (build_id =~ /\A#{OneGadget::Helper::BUILD_ID_FORMAT}\Z/).nil?
          raise ArgumentError, format('invalid BuildID format: %p', build_id)
        end
        gadgets = OneGadget::Gadget.builds(build_id)
        return gadgets if details
        gadgets.map(&:offset)
      end

      def from_file(*) # file, details: false)
        # TODO
        []
      end
    end
    extend ClassMethods
  end
end
