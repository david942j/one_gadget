# OneGadget - To find the execve(/bin/sh, 0, 0) in glibc.
#
# @author david942j
require 'one_gadget/helper'

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
    # @return [Array<OneGadget::Gadget::Gadget>, Array<Integer>]
    #   The gadgets found.
    # @example
    #   OneGadget.gadgets(file: './libc.so.6')
    #   OneGadget.gadgets(build_id: '60131540dadc6796cab33388349e6e4e68692053')
    def gadgets(file: nil, build_id: nil, details: false, force_file: false)
      if build_id
        OneGadget::Fetcher.from_build_id(build_id, details: details)
      elsif file
        file = OneGadget::Helper.abspath(file)
        build_id = OneGadget::Helper.build_id_of(file)
        if !force_file && build_id
          gadgets = OneGadget::Fetcher.from_build_id(build_id, details: details, remote: false)
          return gadgets unless gadgets.empty?
        end
        OneGadget::Fetcher.from_file(file, details: details)
      end
    end
  end
end

# Shorter way to use one gadget.
# @param [String?] arg
#   Can be either +build_id+ or path to libc.
# @param [Mixed] options
#   See {OneGadget#gadgets} for ore information.
# @param [String] build_id
#   Libc's +build_id+.
# @return [Array<OneGadget::Gadget::Gadget>, Array<Integer>]
#   The gadgets found.
# @example
#   one_gadget('./libc.so.6')
#   one_gadget('cbfa941a8eb7a11e4f90e81b66fcd5a820995d7c')
#   one_gadget('./libc.so.6', details: true)
def one_gadget(arg = nil, **options)
  unless arg.nil?
    if arg =~ /\A#{OneGadget::Helper::BUILD_ID_FORMAT}\Z/
      options[:build_id] = arg
    else
      options[:file] = arg
    end
  end
  OneGadget.gadgets(**options)
end

require 'one_gadget/fetcher'
require 'one_gadget/helper'
require 'one_gadget/logger'
require 'one_gadget/version'
