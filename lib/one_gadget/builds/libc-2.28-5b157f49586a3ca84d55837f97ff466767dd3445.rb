require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc6_2.28-0ubuntu1_amd64/lib/x86_64-linux-gnu/libc-2.28.so
# 
# Advanced Micro Devices X86-64
# 
# GNU C Library (Ubuntu GLIBC 2.28-0ubuntu1) stable release version 2.28.
# Copyright (C) 2018 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 8.2.0.
# libc ABIs: UNIQUE IFUNC ABSOLUTE
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 328070,
                      constraints: ["rsp & 0xf == 0", "rcx == NULL"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 328163,
                      constraints: ["[rsp+0x40] == NULL"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 328175,
                      constraints: ["[rsi] == NULL || rsi == NULL", "[[rax]] == NULL || [rax] == NULL"],
                      effect: "execve(\"/bin/sh\", rsi, [rax])")
OneGadget::Gadget.add(build_id, 913902,
                      constraints: ["[r15] == NULL || r15 == NULL", "[r13] == NULL || r13 == NULL"],
                      effect: "execve(\"/bin/sh\", r15, r13)")
OneGadget::Gadget.add(build_id, 913905,
                      constraints: ["[r15] == NULL || r15 == NULL", "[rdx] == NULL || rdx == NULL"],
                      effect: "execve(\"/bin/sh\", r15, rdx)")
OneGadget::Gadget.add(build_id, 913908,
                      constraints: ["[rsi] == NULL || rsi == NULL", "[rdx] == NULL || rdx == NULL"],
                      effect: "execve(\"/bin/sh\", rsi, rdx)")
OneGadget::Gadget.add(build_id, 914335,
                      constraints: ["[rcx] == NULL || rcx == NULL", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL"],
                      effect: "execve(\"/bin/sh\", rcx, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 914339,
                      constraints: ["[rcx] == NULL || rcx == NULL", "[rdx] == NULL || rdx == NULL"],
                      effect: "execve(\"/bin/sh\", rcx, rdx)")
OneGadget::Gadget.add(build_id, 1064784,
                      constraints: ["[rsp+0x70] == NULL"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)")

