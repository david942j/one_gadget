# frozen_string_literal: true

# OneGadget - To find the execve(/bin/sh, 0, 0) in glibc.
#
# @author david942j

# Main module.
module OneGadget
end

require 'one_gadget/helper'
require 'one_gadget/one_gadget'
require 'one_gadget/version'

# Shorter way to use one gadget.
# @param [String?] arg
#   Can be either +build_id+ or path to libc.
# @param [Mixed] options
#   See {OneGadget#gadgets} for ore information.
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

require 'one_gadget/update'
OneGadget::Update.check!
