require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/glibc-2.33-4-x86_64.pkg.tar/usr/lib/libc-2.33.so
# 
# Advanced Micro Devices X86-64
# 
# GNU C Library (GNU libc) release release version 2.33.
# Copyright (C) 2021 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 10.2.0.
# libc ABIs: UNIQUE IFUNC ABSOLUTE
# For bug reporting instructions, please see:
# <https://bugs.archlinux.org/>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 838682,
                      constraints: ["[r12] == NULL || r12 == NULL", "[r13] == NULL || r13 == NULL"],
                      effect: "execve(\"/bin/sh\", r12, r13)")
OneGadget::Gadget.add(build_id, 838685,
                      constraints: ["[r12] == NULL || r12 == NULL", "[rdx] == NULL || rdx == NULL"],
                      effect: "execve(\"/bin/sh\", r12, rdx)")
OneGadget::Gadget.add(build_id, 838688,
                      constraints: ["[rsi] == NULL || rsi == NULL", "[rdx] == NULL || rdx == NULL"],
                      effect: "execve(\"/bin/sh\", rsi, rdx)")
OneGadget::Gadget.add(build_id, 838778,
                      constraints: ["writable: rbp-0x38", "[rbp-0x40] == NULL || rbp-0x40 == NULL", "[r13] == NULL || r13 == NULL"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r13)")
OneGadget::Gadget.add(build_id, 838785,
                      constraints: ["writable: rbp-0x40", "[rbp-0x40] == NULL || rbp-0x40 == NULL", "[r13] == NULL || r13 == NULL"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r13)")

