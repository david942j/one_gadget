# frozen_string_literal: true

require 'one_gadget/error'
require 'one_gadget/fetcher'
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
    #   Output level.
    #   If +level+ equals to zero, only gadgets with highest successful probability would be output.
    # @return [Array<OneGadget::Gadget::Gadget>, Array<Integer>]
    #   The gadgets found.
    # @example
    #   OneGadget.gadgets(file: './libc.so.6')
    #   OneGadget.gadgets(build_id: '60131540dadc6796cab33388349e6e4e68692053')
    def gadgets(file: nil, build_id: nil, details: false, force_file: false, level: 0)
      ret = if build_id
              OneGadget::Fetcher.from_build_id(build_id) || OneGadget::Logger.not_found(build_id)
            else
              from_file(OneGadget::Helper.abspath(file), force: force_file)
            end
      ret = refine_gadgets(ret, level)
      ret = ret.map(&:offset) unless details
      ret
    rescue OneGadget::Error::Error => e
      OneGadget::Logger.error("#{e.class.name.split('::').last}: #{e.message}")
      []
    end

    private

    # Try from build id first, then file
    def from_file(path, force: false)
      OneGadget::Helper.verify_elf_file!(path)
      gadgets = try_from_build(path) unless force
      gadgets || OneGadget::Fetcher.from_file(path)
    end

    def try_from_build(file)
      build_id = OneGadget::Helper.build_id_of(file)
      return unless build_id

      OneGadget::Fetcher.from_build_id(build_id, remote: false)
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
