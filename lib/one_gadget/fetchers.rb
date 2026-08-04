# frozen_string_literal: true

require 'one_gadget/error'
require 'one_gadget/fetchers/aarch64'
require 'one_gadget/fetchers/amd64'
require 'one_gadget/fetchers/arm'
require 'one_gadget/fetchers/i386'
require 'one_gadget/gadget'
require 'one_gadget/helper'

module OneGadget
  # To find gadgets.
  module Fetchers
    # At and above this level, keep every distinct gadget instead of trimming
    # down to the easiest-to-reach set (see {ClassMethods#from_file}).
    RAW_LEVEL = 2

    # Define class methods here.
    module ClassMethods
      # Fetch one-gadget offsets of this build id.
      # @param [String] build_id The targets' BuildID.
      # @param [Boolean] remote
      #   When local not found, try search in latest version?
      # @return [Array<OneGadget::Gadget::Gadget>?]
      #   +nil+ is returned if cannot find target id in database.
      def from_build_id(build_id, remote: true)
        OneGadget::Helper.verify_build_id!(build_id)
        OneGadget::Gadget.builds(build_id, remote:)
      end

      # Fetch one-gadget offsets from file.
      # @param [String] file The absolute path of libc file.
      # @param [Integer] level
      #   Output level. Below {RAW_LEVEL} the result is trimmed to the
      #   easiest-to-reach gadgets ({#trim_gadgets}); at {RAW_LEVEL} and above
      #   every distinct gadget is kept ({#all_gadgets}), including ones a lower
      #   level drops as duplicate or harder-to-satisfy.
      # @return [Array<OneGadget::Gadget::Gadget>]
      #   Array of all found gadgets is returned.
      def from_file(file, level: 0)
        arch = OneGadget::Helper.architecture(file)
        klass = {
          aarch64: OneGadget::Fetchers::AArch64,
          amd64: OneGadget::Fetchers::Amd64,
          arm: OneGadget::Fetchers::Arm,
          i386: OneGadget::Fetchers::I386
        }[arch]
        raise Error::UnsupportedArchitectureError, arch if klass.nil?

        gadgets = klass.new(file).find
        level >= RAW_LEVEL ? all_gadgets(gadgets) : trim_gadgets(gadgets)
      end

      private

      # Keep every distinct gadget, dropping only exact +(offset, constraints)+
      # repeats (the same suffix reached by more than one candidate path). Unlike
      # {#trim_gadgets} this keeps duplicate-constraint and dominated gadgets, and
      # lists an offset once per constraint set it can be reached under.
      def all_gadgets(gadgets)
        gadgets.uniq { |g| [g.offset, g.constraints] }
               .sort_by { |g| [g.offset, g.constraints.size] }
      end

      # Unique, remove gadgets with harder constraints.
      def trim_gadgets(gadgets)
        gadgets = gadgets.uniq(&:constraints).sort_by { |g| g.constraints.size }
        res = []
        gadgets.each_with_index do |g, i|
          res << g unless i.times.any? do |j|
            (gadgets[j].constraints - g.constraints).empty?
          end
        end
        # The same offset can reach the call via more than one branch direction;
        # list it once, keeping the easiest (fewest-constraint) variant.
        res.group_by(&:offset).map { |_, gs| gs.min_by { |g| g.constraints.size } }.sort_by(&:offset)
      end
    end
    extend ClassMethods
  end
end
