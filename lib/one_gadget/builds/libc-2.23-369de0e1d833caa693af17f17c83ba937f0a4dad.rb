require 'one_gadget/gadget'
# Ubuntu GLIBC 2.23-0ubuntu3
# ELF 64-bit LSB shared object, x86-64
build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 0x4525a, constraints: ['[rsp+0x30] == NULL'])
OneGadget::Gadget.add(build_id, 0xef9f4, constraints: ['[rsp+0x50] == NULL'])
OneGadget::Gadget.add(build_id, 0xf0897, constraints: ['[rsp+0x70] == NULL'])
OneGadget::Gadget.add(build_id, 0xf5e40, constraints: ['[rbp-0xf8] == NULL', 'rcx == NULL'])
