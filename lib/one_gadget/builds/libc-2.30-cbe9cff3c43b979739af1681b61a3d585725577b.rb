require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc6_2.30-0ubuntu2.2_amd64/lib/x86_64-linux-gnu/libc-2.30.so
# 
# Advanced Micro Devices X86-64
# 
# GNU C Library (Ubuntu GLIBC 2.30-0ubuntu2.2) stable release version 2.30.
# Copyright (C) 2019 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 9.2.1 20191008.
# libc ABIs: UNIQUE IFUNC ABSOLUTE
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 348436,
                      constraints: ["rsp & 0xf == 0", "rcx == NULL", "[[rax]] == NULL || [rax] == NULL", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0", "r12 == NULL || (u16)[r12] == NULL"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, r12, rsp+0x50, [rax])")
OneGadget::Gadget.add(build_id, 348446,
                      constraints: ["rsp & 0xf == 0", "[r8] == NULL", "[[rax]] == NULL || [rax] == NULL", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0", "r12 == NULL || (u16)[r12] == NULL"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, r12, r8, [rax])")
OneGadget::Gadget.add(build_id, 553395,
                      constraints: ["rsp & 0xf == 0", "rcx == NULL", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 553408,
                      constraints: ["rsp & 0xf == 0", "rcx == NULL", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 553420,
                      constraints: ["rsp & 0xf == 0", "(u64)xmm0 == NULL", "[[rax]] == NULL || [rax] == NULL", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, 0, rsp+0x60, [rax])")
OneGadget::Gadget.add(build_id, 553433,
                      constraints: ["rsp & 0xf == 0", "(u64)xmm0 == NULL", "[[rax]] == NULL || [rax] == NULL", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0", "rcx == NULL || (u16)[rcx] == NULL"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, rsp+0x60, [rax])")
OneGadget::Gadget.add(build_id, 553440,
                      constraints: ["rsp & 0xf == 0", "[r8] == NULL", "[[rax]] == NULL || [rax] == NULL", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0", "rcx == NULL || (u16)[rcx] == NULL"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, [rax])")
OneGadget::Gadget.add(build_id, 553443,
                      constraints: ["rsp & 0xf == 0", "[r8] == NULL", "[r9] == NULL || r9 == NULL", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0", "rcx == NULL || (u16)[rcx] == NULL"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, r9)")
OneGadget::Gadget.add(build_id, 944542,
                      constraints: ["[r15] == NULL || r15 == NULL", "[r12] == NULL || r12 == NULL"],
                      effect: "execve(\"/bin/sh\", r15, r12)")
OneGadget::Gadget.add(build_id, 944545,
                      constraints: ["[r15] == NULL || r15 == NULL", "[rdx] == NULL || rdx == NULL"],
                      effect: "execve(\"/bin/sh\", r15, rdx)")
OneGadget::Gadget.add(build_id, 944548,
                      constraints: ["[rsi] == NULL || rsi == NULL", "[rdx] == NULL || rdx == NULL"],
                      effect: "execve(\"/bin/sh\", rsi, rdx)")
OneGadget::Gadget.add(build_id, 945043,
                      constraints: ["writable: rbp-0x78", "[r10] == NULL || r10 == NULL", "[r12] == NULL || r12 == NULL"],
                      effect: "execve(\"/bin/sh\", r10, r12)")
OneGadget::Gadget.add(build_id, 945046,
                      constraints: ["writable: rbp-0x78", "[r10] == NULL || r10 == NULL", "[rdx] == NULL || rdx == NULL"],
                      effect: "execve(\"/bin/sh\", r10, rdx)")
OneGadget::Gadget.add(build_id, 945161,
                      constraints: ["writable: rbp-0x48", "[rbp-0x50] == NULL || rbp-0x50 == NULL", "[r12] == NULL || r12 == NULL"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 945168,
                      constraints: ["writable: rbp-0x50", "[rbp-0x50] == NULL || rbp-0x50 == NULL", "[r12] == NULL || r12 == NULL"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 945237,
                      constraints: ["writable: r10+0x10", "writable: rbp-0x50", "[r10] == NULL || r10 == NULL", "[r12] == NULL || r12 == NULL"],
                      effect: "execve(\"/bin/sh\", r10, r12)")
OneGadget::Gadget.add(build_id, 945245,
                      constraints: ["writable: r10+0x10", "writable: rbp-0x48", "[r10] == NULL || r10 == NULL", "[r12] == NULL || r12 == NULL"],
                      effect: "execve(\"/bin/sh\", r10, r12)")
OneGadget::Gadget.add(build_id, 1093433,
                      constraints: ["[rsp+0x70] == NULL"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)")
OneGadget::Gadget.add(build_id, 1093445,
                      constraints: ["[rsi] == NULL || rsi == NULL", "[[rax]] == NULL || [rax] == NULL"],
                      effect: "execve(\"/bin/sh\", rsi, [rax])")

