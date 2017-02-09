require 'one_gadget/gadget'
# Ubuntu GLIBC 2.23-0ubuntu5
# ELF 64-bit LSB shared object, x86-64
build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 0x4526a, constraints: ['[rsp+0x30] == NULL'])
OneGadget::Gadget.add(build_id, 0xef6c4, constraints: ['[rsp+0x50] == NULL'])
OneGadget::Gadget.add(build_id, 0xf0567, constraints: ['[rsp+0x70] == NULL'])
