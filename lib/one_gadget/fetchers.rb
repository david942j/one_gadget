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
      # @param [Integer] level
      #   Output level, interpreted as in {#from_file}.
      # @return [Array<OneGadget::Gadget::Gadget>?]
      #   +nil+ is returned if cannot find target id in database.
      def from_build_id(build_id, remote: true, level: 0)
        OneGadget::Helper.verify_build_id!(build_id)
        gadgets = OneGadget::Gadget.builds(build_id, remote:)
        gadgets && for_level(gadgets, level)
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

        for_level(klass.new(file).find, level)
      end

      private

      # Narrow a complete gadget set down to what an output level asks for.
      # @param [Array<OneGadget::Gadget::Gadget>] gadgets
      # @param [Integer] level
      # @return [Array<OneGadget::Gadget::Gadget>]
      def for_level(gadgets, level)
        level >= RAW_LEVEL ? all_gadgets(gadgets) : trim_gadgets(gadgets)
      end

      # Keep every distinct gadget, dropping only exact +(offset, constraints)+
      # repeats (the same suffix reached by more than one candidate path). Unlike
      # {#trim_gadgets} this keeps duplicate-constraint and dominated gadgets, and
      # lists an offset once per constraint set it can be reached under.
      def all_gadgets(gadgets)
        gadgets.uniq { |g| [g.offset, g.constraints] }
               .sort_by { |g| [g.offset, g.constraints.size] }
      end

      # Unique, remove gadgets whose constraints already meet an easier gadget's
      # (see {OneGadget::Gadget::Gadget#met_by?}): that one is the better answer,
      # and this one asks the reader for strictly more.
      def trim_gadgets(gadgets)
        # Order totally before anything is dropped: each step below keeps
        # whichever of several equally good gadgets it meets first, so without a
        # tie-break the answer depends on the order gadgets were discovered in
        # rather than on the libc alone. Gadgets sharing a constraint set are
        # interchangeable -- whoever satisfies one satisfies them all -- so the
        # last of them represents the set: it is the one that reaches the call
        # with the least code in between.
        gadgets = gadgets.sort_by { |g| [g.constraints.size, -g.offset, g.constraints] }
                         .uniq(&:constraints)
        res = []
        gadgets.each_with_index do |g, i|
          res << g unless i.times.any? { |j| gadgets[j].met_by?(g) }
        end
        # The same offset can reach the call via more than one branch direction;
        # list it once, keeping the easiest (fewest-constraint) variant.
        res.group_by(&:offset).map { |_, gs| gs.min_by { |g| g.constraints.size } }.sort_by(&:offset)
      end
    end
    extend ClassMethods
  end
end
