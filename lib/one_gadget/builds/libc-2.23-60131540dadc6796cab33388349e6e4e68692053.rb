require 'one_gadget/gadget'
# Ubuntu GLIBC 2.23-0ubuntu5
# ELF 64-bit LSB shared object, x86-64
build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 0x4526a, constraints: ['[rsp+0x30] == NULL'],
                                         effect: 'execve("/bin/sh", rsp+0x30, environ)')
OneGadget::Gadget.add(build_id, 0xef6c4, constraints: ['[rsp+0x50] == NULL'],
                                         effect: 'execve("/bin/sh", rsp+0x50, environ)')
OneGadget::Gadget.add(build_id, 0xf0567, constraints: ['[rsp+0x70] == NULL'],
                                         effect: 'execve("/bin/sh", rsp+0x70, environ)')
OneGadget::Gadget.add(build_id, 0xcc543, constraints: ['rcx == NULL || [rcx] == NULL',
                                                       'r12 == NULL || [r12] == NULL'],
                                         effect: 'execve("/bin/sh", rcx, r12)')
OneGadget::Gadget.add(build_id, 0xcc618, constraints: ['rax == NULL || [rax] == NULL',
                                                       'r12 == NULL || [r12] == NULL'],
                                         effect: 'execve("/bin/sh", rax, r12)')
OneGadget::Gadget.add(build_id, 0xf5b10, constraints: ['[rbp-0xf8] == NULL || [[rbp-0xf8]] == NULL',
                                                       'rcx == NULL || [rcx] == NULL'],
                                         effect: 'execve("/bin/sh", rcx, [rbp-0xf8])')
