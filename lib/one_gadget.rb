# OneGadget - To find the execve(/bin/sh, 0, 0) in glibc.
#
# @author david942j
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
    # @return [Array<OneGadget::Gadget::Gadget>, Array<Integer>]
    #   The gadgets found.
    # @example
    #   OneGadget.gadgets(file: './libc.so.6')
    #   OneGadget.gadgets(build_id: '60131540dadc6796cab33388349e6e4e68692053')
    def gadgets(file: nil, build_id: nil, details: false)
      if build_id
        OneGadget::Fetcher.from_build_id(build_id, details: details)
      elsif file
        file = OneGadget::Helper.abspath(file)
        build_id = OneGadget::Helper.build_id_of(file)
        gadgets = OneGadget::Fetcher.from_build_id(build_id, details: details)
        return gadgets unless gadgets.empty?
        OneGadget::Fetcher.from_file(file, details: details)
      end
    end
  end
end

require 'one_gadget/fetcher'
require 'one_gadget/helper'
require 'one_gadget/logger'
require 'one_gadget/version'
