require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/glibc-2.31-2-x86_64.pkg.tar/usr/lib/libc-2.31.so
# 
# Advanced Micro Devices X86-64
# 
# GNU C Library (GNU libc) stable release version 2.31.
# Copyright (C) 2020 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 9.3.0.
# libc ABIs: UNIQUE IFUNC ABSOLUTE
# For bug reporting instructions, please see:
# <https://bugs.archlinux.org/>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 841002,
                      constraints: ["[r12] == NULL || r12 == NULL", "[r13] == NULL || r13 == NULL"],
                      effect: "execve(\"/bin/sh\", r12, r13)")
OneGadget::Gadget.add(build_id, 841005,
                      constraints: ["[r12] == NULL || r12 == NULL", "[rdx] == NULL || rdx == NULL"],
                      effect: "execve(\"/bin/sh\", r12, rdx)")
OneGadget::Gadget.add(build_id, 841008,
                      constraints: ["[rsi] == NULL || rsi == NULL", "[rdx] == NULL || rdx == NULL"],
                      effect: "execve(\"/bin/sh\", rsi, rdx)")
OneGadget::Gadget.add(build_id, 841098,
                      constraints: ["writable: rbp-0x38", "[rbp-0x40] == NULL || rbp-0x40 == NULL", "[r13] == NULL || r13 == NULL"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r13)")
OneGadget::Gadget.add(build_id, 841105,
                      constraints: ["writable: rbp-0x40", "[rbp-0x40] == NULL || rbp-0x40 == NULL", "[r13] == NULL || r13 == NULL"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r13)")

