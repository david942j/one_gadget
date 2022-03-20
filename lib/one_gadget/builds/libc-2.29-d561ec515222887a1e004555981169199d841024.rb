require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc6_2.29-0ubuntu2_amd64/lib/x86_64-linux-gnu/libc-2.29.so
# 
# Advanced Micro Devices X86-64
# 
# GNU C Library (Ubuntu GLIBC 2.29-0ubuntu2) stable release version 2.29.
# Copyright (C) 2019 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 8.3.0.
# libc ABIs: UNIQUE IFUNC ABSOLUTE
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 339072,
                      constraints: ["rsp & 0xf == 0", "rcx == NULL", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0", "rbx == NULL || (u16)[rbx] == NULL"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rbx, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 339093,
                      constraints: ["rsp & 0xf == 0", "[r8] == NULL", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0", "rbx == NULL || (u16)[rbx] == NULL"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rbx, r8, environ)")
OneGadget::Gadget.add(build_id, 339096,
                      constraints: ["rsp & 0xf == 0", "[r8] == NULL", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0", "rcx == NULL || (u16)[rcx] == NULL"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 539140,
                      constraints: ["rsp & 0xf == 0", "[r8] == NULL", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0", "rcx == NULL || (u16)[rcx] == NULL"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 539182,
                      constraints: ["rsp & 0xf == 0", "[r8] == NULL", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0", "rcx == NULL || (u16)[rcx] == NULL"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 926158,
                      constraints: ["[r15] == NULL || r15 == NULL", "[r13] == NULL || r13 == NULL"],
                      effect: "execve(\"/bin/sh\", r15, r13)")
OneGadget::Gadget.add(build_id, 926161,
                      constraints: ["[r15] == NULL || r15 == NULL", "[rdx] == NULL || rdx == NULL"],
                      effect: "execve(\"/bin/sh\", r15, rdx)")
OneGadget::Gadget.add(build_id, 926164,
                      constraints: ["[rsi] == NULL || rsi == NULL", "[rdx] == NULL || rdx == NULL"],
                      effect: "execve(\"/bin/sh\", rsi, rdx)")
OneGadget::Gadget.add(build_id, 926591,
                      constraints: ["[rcx] == NULL || rcx == NULL", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL"],
                      effect: "execve(\"/bin/sh\", rcx, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 926595,
                      constraints: ["[rcx] == NULL || rcx == NULL", "[rdx] == NULL || rdx == NULL"],
                      effect: "execve(\"/bin/sh\", rcx, rdx)")
OneGadget::Gadget.add(build_id, 926677,
                      constraints: ["writable: rbp-0x48", "[rbp-0x50] == NULL || rbp-0x50 == NULL", "[r13] == NULL || r13 == NULL"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r13)")
OneGadget::Gadget.add(build_id, 926681,
                      constraints: ["writable: rbp-0x50", "[rbp-0x50] == NULL || rbp-0x50 == NULL", "[r13] == NULL || r13 == NULL"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r13)")
OneGadget::Gadget.add(build_id, 926739,
                      constraints: ["writable: [rbp-0x78]+0x10", "writable: rbp-0x80", "[[rbp-0x78]] == NULL || [rbp-0x78] == NULL", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL"],
                      effect: "execve(\"/bin/sh\", [rbp-0x78], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 926743,
                      constraints: ["writable: [rbp-0x78]+0x10", "writable: rbp-0x50", "[[rbp-0x78]] == NULL || [rbp-0x78] == NULL", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL"],
                      effect: "execve(\"/bin/sh\", [rbp-0x78], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 1076984,
                      constraints: ["[rsp+0x70] == NULL"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)")
OneGadget::Gadget.add(build_id, 1076996,
                      constraints: ["[rsi] == NULL || rsi == NULL", "[[rax]] == NULL || [rax] == NULL"],
                      effect: "execve(\"/bin/sh\", rsi, [rax])")

