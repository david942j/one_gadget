require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc6_2.27-3ubuntu1.5_amd64/lib/x86_64-linux-gnu/libc-2.27.so
# 
# Advanced Micro Devices X86-64
# 
# GNU C Library (Ubuntu GLIBC 2.27-3ubuntu1.5) stable release version 2.27.
# Copyright (C) 2018 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 7.5.0.
# libc ABIs: UNIQUE IFUNC
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 324261,
                      constraints: ["rsp & 0xf == 0", "rcx == NULL"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324354,
                      constraints: ["[rsp+0x40] == NULL"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 938831,
                      constraints: ["[r13] == NULL || r13 == NULL", "[rbx] == NULL || rbx == NULL"],
                      effect: "execve(\"/bin/sh\", r13, rbx)")
OneGadget::Gadget.add(build_id, 939255,
                      constraints: ["[[rbp-0x88]] == NULL || [rbp-0x88] == NULL", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL"],
                      effect: "execve(\"/bin/sh\", [rbp-0x88], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 939262,
                      constraints: ["[rcx] == NULL || rcx == NULL", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL"],
                      effect: "execve(\"/bin/sh\", rcx, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 939266,
                      constraints: ["[rcx] == NULL || rcx == NULL", "[rdx] == NULL || rdx == NULL"],
                      effect: "execve(\"/bin/sh\", rcx, rdx)")
OneGadget::Gadget.add(build_id, 939325,
                      constraints: ["writable: [rbp-0x78]+0x10", "writable: rbp-0x80", "[[rbp-0x78]] == NULL || [rbp-0x78] == NULL", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL"],
                      effect: "execve(\"/bin/sh\", [rbp-0x78], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 1090300,
                      constraints: ["[rsp+0x70] == NULL"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)")
OneGadget::Gadget.add(build_id, 1090312,
                      constraints: ["[rsi] == NULL || rsi == NULL", "[[rax]] == NULL || [rax] == NULL"],
                      effect: "execve(\"/bin/sh\", rsi, [rax])")

