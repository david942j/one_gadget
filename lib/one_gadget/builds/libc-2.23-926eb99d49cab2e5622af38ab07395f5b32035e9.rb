require 'one_gadget/gadget'
# Ubuntu GLIBC 2.23-0ubuntu5
# ELF 32-bit LSB shared object, Intel 80386
build_id = File.basename(__FILE__, '.rb').split('-').last
rw_area_constraint = 'esi is the address of `rw-p` area of libc'
OneGadget::Gadget.add(build_id, 0x3ac69, constraints: [rw_area_constraint, '[esp+0x34] == NULL'])
OneGadget::Gadget.add(build_id, 0x5fbbe, constraints: [rw_area_constraint, 'eax == NULL'])
OneGadget::Gadget.add(build_id, 0x12036c, constraints: [rw_area_constraint, 'eax == NULL'])
