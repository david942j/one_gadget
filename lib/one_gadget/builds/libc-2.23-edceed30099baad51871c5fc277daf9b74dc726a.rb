require 'one_gadget/gadget'
# Ubuntu GLIBC 2.23-0ubuntu5
# ELF 32-bit LSB shared object, Intel 80386
build_id = File.basename(__FILE__, '.rb').split('-').last
rw_area_constraint = 'esi is the address of `rw-p` area of libc'
OneGadget::Gadget.add(build_id, 0x3a7f9, constraints: [rw_area_constraint, '[esp+0x34] == NULL'])
OneGadget::Gadget.add(build_id, 0x5ef3e, constraints: [rw_area_constraint, 'eax == NULL'])
OneGadget::Gadget.add(build_id, 0x11dcb5, constraints: [rw_area_constraint, 'eax == NULL'])
