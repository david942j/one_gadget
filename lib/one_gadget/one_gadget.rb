# frozen_string_literal: true

require 'one_gadget/error'
require 'one_gadget/fetchers'
require 'one_gadget/helper'
require 'one_gadget/logger'

# Main module.
module OneGadget
  class << self
    # The man entry of gem +one_gadget+.
    # If want to find gadgets from file, it will search gadgets by its
    # build id first.
    #
    # @param [String] file
    #   The relative path of libc.so.6.
    # @param [String] build_id
    #   The BuildID of target libc.so.6.
    # @param [Boolean] details
    #   Return gadget objects or offset only.
    # @param [Boolean] force_file
    #   When +file+ is given, {OneGadget} will search gadgets according its
    #   build id first. +force_file = true+ to disable this feature.
    # @param [Integer] level
    #   Output level. Higher levels show more of the gadgets found.
    #   +0+ (default) shows only the gadgets with the highest successful
    #   probability; +1+ shows the full trimmed set; +2+ and above additionally
    #   include gadgets a lower level drops as duplicate or harder-to-satisfy
    #   (this emulates the file, bypassing the build-id database).
    # @return [Array<OneGadget::Gadget::Gadget>, Array<Integer>]
    #   The gadgets found.
    # @example
    #   OneGadget.gadgets(file: './libc.so.6')
    #   OneGadget.gadgets(build_id: '60131540dadc6796cab33388349e6e4e68692053')
    def gadgets(file: nil, build_id: nil, details: false, force_file: false, level: 0)
      ret = if build_id
              OneGadget::Fetchers.from_build_id(build_id, level:) || OneGadget::Logger.not_found(build_id)
            else
              # level >= RAW_LEVEL wants every gadget, but the build-id database
              # only stores the trimmed set, so emulate the file instead of it.
              force = force_file || level >= OneGadget::Fetchers::RAW_LEVEL
              from_file(OneGadget::Helper.abspath(file), force:, level:)
            end
      ret = refine_gadgets(ret, level)
      # An offset can recur at level >= 2 (one entry point, several branch-reach
      # constraint sets); the offset-only view lists it once. A no-op at lower
      # levels, where offsets are already unique.
      ret = ret.map(&:offset).uniq unless details
      ret
    rescue OneGadget::Error::Error => e
      OneGadget::Logger.error("#{e.class.name.split('::').last}: #{e.message}")
      []
    end

    private

    # Try from build id first, then file
    def from_file(path, force: false, level: 0)
      OneGadget::Helper.verify_elf_file!(path)
      gadgets = try_from_build(path, level:) unless force
      gadgets || OneGadget::Fetchers.from_file(path, level:)
    end

    def try_from_build(file, level:)
      build_id = OneGadget::Helper.build_id_of(file)
      return unless build_id

      OneGadget::Fetchers.from_build_id(build_id, remote: false, level:)
    end

    # Remove hard-to-reach-constraints gadgets according to level
    def refine_gadgets(gadgets, level)
      return [] if gadgets.empty?
      return gadgets if level.positive? # currently only supports level > 0 or not

      high, low = gadgets.partition { |g| g.score >= 0.2 }
      return take_until(low, 3) if high.empty?

      take_until(high, 3)
    end

    def take_until(ary, count)
      return ary if ary.size <= count

      threshold = ary.sort_by(&:score)[-count].score
      ary.select { |g| g.score >= threshold }
    end
  end
end
