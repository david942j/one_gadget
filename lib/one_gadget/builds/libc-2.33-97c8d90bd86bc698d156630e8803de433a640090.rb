require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc6_2.33-0ubuntu7_amd64/lib/x86_64-linux-gnu/libc-2.33.so
# 
# Advanced Micro Devices X86-64
# 
# GNU C Library (Ubuntu GLIBC 2.33-0ubuntu7) release release version 2.33.
# Copyright (C) 2021 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 10.3.0.
# libc ABIs: UNIQUE IFUNC ABSOLUTE
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 325071,
                      constraints: ["rsp & 0xf == 0", "rcx == NULL", "rbp == NULL || (u16)[rbp] == NULL"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rbp, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 325083,
                      constraints: ["rsp & 0xf == 0", "(u64)xmm0 == NULL", "rdx == NULL || (s32)[rdx+0x4] <= 0", "rbp == NULL || (u16)[rbp] == NULL"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", rdx, rbp, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 325104,
                      constraints: ["rsp & 0xf == 0", "[r8] == NULL", "[[rax]] == NULL || [rax] == NULL", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0", "rbp == NULL || (u16)[rbp] == NULL"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rbp, r8, [rax])")
OneGadget::Gadget.add(build_id, 325112,
                      constraints: ["rsp & 0xf == 0", "[r8] == NULL", "[[rax]] == NULL || [rax] == NULL", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0", "rcx == NULL || (u16)[rcx] == NULL"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, [rax])")
OneGadget::Gadget.add(build_id, 526067,
                      constraints: ["rsp & 0xf == 0", "rcx == NULL", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 526080,
                      constraints: ["rsp & 0xf == 0", "rcx == NULL", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 526092,
                      constraints: ["rsp & 0xf == 0", "(u64)xmm0 == NULL", "[[rax]] == NULL || [rax] == NULL", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, 0, rsp+0x60, [rax])")
OneGadget::Gadget.add(build_id, 526105,
                      constraints: ["rsp & 0xf == 0", "(u64)xmm0 == NULL", "[[rax]] == NULL || [rax] == NULL", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0", "rcx == NULL || (u16)[rcx] == NULL"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, rsp+0x60, [rax])")
OneGadget::Gadget.add(build_id, 911244,
                      constraints: ["[r15] == NULL || r15 == NULL", "[r12] == NULL || r12 == NULL"],
                      effect: "execve(\"/bin/sh\", r15, r12)")
OneGadget::Gadget.add(build_id, 911247,
                      constraints: ["[r15] == NULL || r15 == NULL", "[rdx] == NULL || rdx == NULL"],
                      effect: "execve(\"/bin/sh\", r15, rdx)")
OneGadget::Gadget.add(build_id, 911250,
                      constraints: ["[rsi] == NULL || rsi == NULL", "[rdx] == NULL || rdx == NULL"],
                      effect: "execve(\"/bin/sh\", rsi, rdx)")
OneGadget::Gadget.add(build_id, 911733,
                      constraints: ["writable: rbp-0x78", "[r10] == NULL || r10 == NULL", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL"],
                      effect: "execve(\"/bin/sh\", r10, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 911737,
                      constraints: ["writable: rbp-0x78", "[r10] == NULL || r10 == NULL", "[rdx] == NULL || rdx == NULL"],
                      effect: "execve(\"/bin/sh\", r10, rdx)")
OneGadget::Gadget.add(build_id, 911846,
                      constraints: ["writable: rbp-0x48", "[rbp-0x50] == NULL || rbp-0x50 == NULL", "[r12] == NULL || r12 == NULL"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 911853,
                      constraints: ["writable: rbp-0x50", "[rbp-0x50] == NULL || rbp-0x50 == NULL", "[r12] == NULL || r12 == NULL"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 911915,
                      constraints: ["writable: rbp-0x48", "[rbp-0x50] == NULL || rbp-0x50 == NULL", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 911922,
                      constraints: ["writable: rbp-0x50", "[rbp-0x50] == NULL || rbp-0x50 == NULL", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 911926,
                      constraints: ["writable: r10+0x10", "writable: rbp-0x50", "[r10] == NULL || r10 == NULL", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL"],
                      effect: "execve(\"/bin/sh\", r10, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 1052938,
                      constraints: ["[rsp+0x70] == NULL", "[[rsp+0xf0]] == NULL || [rsp+0xf0] == NULL", "[rsp+0x38] == NULL || (s32)[[rsp+0x38]+0x4] <= 0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", [rsp+0x38], 0, rsp+0x70, [rsp+0xf0])")
OneGadget::Gadget.add(build_id, 1052946,
                      constraints: ["[rsp+0x70] == NULL", "[r9] == NULL || r9 == NULL", "[rsp+0x38] == NULL || (s32)[[rsp+0x38]+0x4] <= 0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", [rsp+0x38], 0, rsp+0x70, r9)")
OneGadget::Gadget.add(build_id, 1052951,
                      constraints: ["[rsp+0x70] == NULL", "[r9] == NULL || r9 == NULL", "rdx == NULL || (s32)[rdx+0x4] <= 0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", rdx, 0, rsp+0x70, r9)")
OneGadget::Gadget.add(build_id, 1052961,
                      constraints: ["[r8] == NULL", "[r9] == NULL || r9 == NULL", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, 0, r8, r9)")

