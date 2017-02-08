require 'one_gadget/gadget'
# Ubuntu GLIBC 2.23-0ubuntu5
# ELF 64-bit LSB shared object, x86-64
build_id = File.basename(__FILE__, '.rb')
OneGadget::Gadget.define(build_id) do |g|
  g.offset = 0x4526a
  g.constraints = ['[rsp+0x30]=NULL']
end
