require 'one_gadget/gadget'
# https://launchpad.net/ubuntu/+archive/primary/+files/libc6_2.31-0ubuntu10_amd64.deb
# 
# Advanced Micro Devices X86-64 processor
# 
# GNU C Library (Ubuntu GLIBC 2.31-0ubuntu10) stable release version 2.31.
# Copyright (C) 2020 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 9.3.0.
# libc ABIs: UNIQUE IFUNC ABSOLUTE
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 348034,
                      constraints: ["[$base+0x1ee200] == 0x1", "[$base+0x1ee2a0] == 0x1", "readable: r12", "readable: r13", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 348053,
                      constraints: ["[$base+0x1ee200] == 0x1", "readable: r12", "readable: r13", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 348072,
                      constraints: ["readable: r12", "readable: r13", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 348080,
                      constraints: ["readable: r12", "readable: r13", "rsp & 0xf == 0x0", "writable: rbp", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rbp, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 348083,
                      constraints: ["readable: r12", "readable: r13", "rsp & 0xf == 0x0", "writable: rbp", "writable: rdi", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rbp, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 348088,
                      constraints: ["readable: r12", "readable: r13", "rsp & 0xf == 0x0", "writable: rbp", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rbp, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 348091,
                      constraints: ["readable: r13", "readable: rsi", "rsp & 0xf == 0x0", "writable: rbp", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rbp, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 348094,
                      constraints: ["readable: r13", "readable: rsi", "rsp & 0xf == 0x0", "writable: rbp", "writable: rdi", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rbp, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 348099,
                      constraints: ["readable: r13", "rsp & 0xf == 0x0", "writable: rbp", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rbp, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 348102,
                      constraints: ["readable: rsi", "rsp & 0xf == 0x0", "writable: rbp", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rbp, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 348105,
                      constraints: ["readable: rsi", "rsp & 0xf == 0x0", "writable: rbp", "writable: rdi", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rbp, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 348110,
                      constraints: ["rsp & 0xf == 0x0", "writable: rbp", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rbp, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 348115,
                      constraints: ["rsp & 0xf == 0x0", "writable: rbp", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rbp, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 348118,
                      constraints: ["rsp & 0xf == 0x0", "writable: rdi", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rbp == NULL || (u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rbp, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 348123,
                      constraints: ["rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rbp == NULL || (u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rbp, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 348130,
                      constraints: ["rsp & 0xf == 0x0", "rax == NULL || {\"sh\", rax, rbx, NULL} is a valid argv", "rbp == NULL || (u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rbp, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 348137,
                      constraints: ["rsp & 0xf == 0x0", "rcx == NULL || {rcx, rax, rbx, NULL} is a valid argv", "rbp == NULL || (u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rbp, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 348139,
                      constraints: ["rsp & 0xf == 0x0", "rcx == NULL || {rcx, rax, rbx, NULL} is a valid argv", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rbp == NULL || (u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", rdx, rbp, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 348144,
                      constraints: ["rsp & 0xf == 0x0", "rcx == NULL || {rcx, (u64)xmm1, rbx, NULL} is a valid argv", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rbp == NULL || (u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", rdx, rbp, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 348149,
                      constraints: ["rsp & 0xf == 0x0", "(u64)xmm0 == NULL || {(u64)xmm0, (u64)xmm1, rbx, NULL} is a valid argv", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rbp == NULL || (u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", rdx, rbp, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 348154,
                      constraints: ["rsp & 0xf == 0x0", "(u64)xmm0 == NULL || {(u64)xmm0, (u64)xmm1, rbx, NULL} is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rbp == NULL || (u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rbp, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 348161,
                      constraints: ["readable: rax", "rsp & 0xf == 0x0", "(u64)xmm0 == NULL || {(u64)xmm0, (u64)xmm1, rbx, NULL} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rbp == NULL || (u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rbp, rsp+0x50, [rax])")
OneGadget::Gadget.add(build_id, 348165,
                      constraints: ["readable: rax", "rsp & 0xf == 0x0", "(u64)xmm0 == NULL || {(u64)xmm0, (u64)(xmm0 >> 64), rbx, NULL} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rbp == NULL || (u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rbp, rsp+0x50, [rax])")
OneGadget::Gadget.add(build_id, 348170,
                      constraints: ["readable: rax", "rsp & 0xf == 0x0", "[r8] == NULL || r8 is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rbp == NULL || (u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rbp, r8, [rax])")
OneGadget::Gadget.add(build_id, 348173,
                      constraints: ["readable: rax", "rsp & 0xf == 0x0", "[r8] == NULL || r8 is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, [rax])")
OneGadget::Gadget.add(build_id, 348178,
                      constraints: ["readable: rax", "rsp & 0xf == 0x0", "[r8] == NULL || r8 is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, [rax])")
OneGadget::Gadget.add(build_id, 348181,
                      constraints: ["rsp & 0xf == 0x0", "[r8] == NULL || r8 is a valid argv", "[r9] == NULL || r9 == NULL || r9 is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, r9)")
OneGadget::Gadget.add(build_id, 553706,
                      constraints: ["r14 == 0x0", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 553706,
                      constraints: ["[r14+0xe8] == 0x0", "r13d == [r14+0x70]", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 553711,
                      constraints: ["[r14+0xe8] == 0x0", "r13d == [r14+0x70]", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 553712,
                      constraints: ["[r14+0xe8] == 0x0", "r13d == [r14+0x70]", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 553716,
                      constraints: ["[r14+0xe8] == 0x0", "r13d == esi", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 553729,
                      constraints: ["[r14+0xe8] == 0x0", "eax == 0x0", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 553737,
                      constraints: ["[r14+0xe8] == 0x0", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 553744,
                      constraints: ["r14 == 0x0", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 553749,
                      constraints: ["rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 553756,
                      constraints: ["rsp & 0xf == 0x0", "rax == NULL || {\"sh\", rax, rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 553763,
                      constraints: ["rsp & 0xf == 0x0", "rcx == NULL || {rcx, rax, rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 553766,
                      constraints: ["rsp & 0xf == 0x0", "rcx == NULL || {rcx, rax, rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 553771,
                      constraints: ["rsp & 0xf == 0x0", "rcx == NULL || {rcx, rax, [rsp+0x70], NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 553776,
                      constraints: ["rsp & 0xf == 0x0", "rcx == NULL || {rcx, (u64)xmm1, [rsp+0x70], NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 553783,
                      constraints: ["readable: rax", "rsp & 0xf == 0x0", "rcx == NULL || {rcx, (u64)xmm1, [rsp+0x70], NULL} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, 0, rsp+0x60, [rax])")
OneGadget::Gadget.add(build_id, 553788,
                      constraints: ["readable: rax", "rsp & 0xf == 0x0", "(u64)xmm0 == NULL || {(u64)xmm0, (u64)xmm1, [rsp+0x70], NULL} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, 0, rsp+0x60, [rax])")
OneGadget::Gadget.add(build_id, 553790,
                      constraints: ["readable: rax", "rsp & 0xf == 0x0", "(u64)xmm0 == NULL || {(u64)xmm0, (u64)xmm1, [rsp+0x70], NULL} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, rcx, rsp+0x60, [rax])")
OneGadget::Gadget.add(build_id, 553794,
                      constraints: ["readable: rax", "rsp & 0xf == 0x0", "(u64)xmm0 == NULL || {(u64)xmm0, (u64)(xmm0 >> 64), [rsp+0x70], NULL} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, rcx, rsp+0x60, [rax])")
OneGadget::Gadget.add(build_id, 553801,
                      constraints: ["readable: rax", "rsp & 0xf == 0x0", "(u64)xmm0 == NULL || {(u64)xmm0, (u64)(xmm0 >> 64), [rsp+0x70], NULL} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, rsp+0x60, [rax])")
OneGadget::Gadget.add(build_id, 553806,
                      constraints: ["readable: rax", "rsp & 0xf == 0x0", "[r8] == NULL || r8 is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, [rax])")
OneGadget::Gadget.add(build_id, 553808,
                      constraints: ["readable: rax", "rsp & 0xf == 0x0", "[r8] == NULL || r8 is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, [rax])")
OneGadget::Gadget.add(build_id, 553811,
                      constraints: ["rsp & 0xf == 0x0", "[r8] == NULL || r8 is a valid argv", "[r9] == NULL || r9 == NULL || r9 is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, r9)")
OneGadget::Gadget.add(build_id, 944779,
                      constraints: ["[rbx] == 0x0", "writable: rbp-0x50", "r13 == NULL || {\"/bin/sh\", r13, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 944784,
                      constraints: ["[rbx] == 0x0", "writable: rbp-0x50", "r13 == NULL || {\"/bin/sh\", r13, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 944786,
                      constraints: ["[rbx] == 0x0", "writable: rbp-0x50", "r13 == NULL || {\"/bin/sh\", r13, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 944792,
                      constraints: ["writable: rbp-0x50", "r13 == NULL || {\"/bin/sh\", r13, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 944956,
                      constraints: ["rax == 0x1", "writable: r15+0x10", "[r15] == NULL || r15 == NULL || r15 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r15, r12)")
OneGadget::Gadget.add(build_id, 944966,
                      constraints: ["writable: r15+0x10", "[r15] == NULL || r15 == NULL || r15 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r15, r12)")
OneGadget::Gadget.add(build_id, 944974,
                      constraints: ["[r15] == NULL || r15 == NULL || r15 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r15, r12)")
OneGadget::Gadget.add(build_id, 944977,
                      constraints: ["[r15] == NULL || r15 == NULL || r15 is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", r15, rdx)")
OneGadget::Gadget.add(build_id, 944980,
                      constraints: ["[rsi] == NULL || rsi == NULL || rsi is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, rdx)")
OneGadget::Gadget.add(build_id, 945098,
                      constraints: ["[rbx] == 0x0", "eax == 0x8", "writable: rbp-0x78", "[rbp-0x68] == NULL || {\"/bin/sh\", [rbp-0x68], NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 945216,
                      constraints: ["[r15] == NULL || r15 == NULL || r15 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r15, r12)")
OneGadget::Gadget.add(build_id, 945285,
                      constraints: ["[rbx] == 0x0", "writable: rbp-0x78", "[rbp-0x68] == NULL || {\"/bin/sh\", [rbp-0x68], NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 945288,
                      constraints: ["[rbx] == 0x0", "writable: rbp-0x78", "[rbp-0x68] == NULL || {\"/bin/sh\", [rbp-0x68], NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 945290,
                      constraints: ["[rbx] == 0x0", "writable: rbp-0x78", "[rbp-0x68] == NULL || {\"/bin/sh\", [rbp-0x68], NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 945296,
                      constraints: ["writable: rbp-0x78", "[rbp-0x68] == NULL || {\"/bin/sh\", [rbp-0x68], NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 945461,
                      constraints: ["rax == 0x1", "writable: r10+0x10", "writable: rbp-0x78", "[r10] == NULL || r10 == NULL || r10 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r10, r12)")
OneGadget::Gadget.add(build_id, 945467,
                      constraints: ["writable: r10+0x10", "writable: rbp-0x78", "[r10] == NULL || r10 == NULL || r10 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r10, r12)")
OneGadget::Gadget.add(build_id, 945475,
                      constraints: ["writable: rbp-0x78", "[r10] == NULL || r10 == NULL || r10 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r10, r12)")
OneGadget::Gadget.add(build_id, 945478,
                      constraints: ["writable: rbp-0x78", "[r10] == NULL || r10 == NULL || r10 is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", r10, rdx)")
OneGadget::Gadget.add(build_id, 945481,
                      constraints: ["writable: rbp-0x78", "[rsi] == NULL || rsi == NULL || rsi is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, rdx)")
OneGadget::Gadget.add(build_id, 945576,
                      constraints: ["writable: rbp-0x78", "[[rbp-0x78]] == NULL || [rbp-0x78] == NULL || [rbp-0x78] is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x78], r12)")
OneGadget::Gadget.add(build_id, 945580,
                      constraints: ["writable: rbp-0x78", "[r10] == NULL || r10 == NULL || r10 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r10, r12)")
OneGadget::Gadget.add(build_id, 945584,
                      constraints: ["writable: rbp-0x78", "[r10] == NULL || r10 == NULL || r10 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r10, r12)")
OneGadget::Gadget.add(build_id, 945586,
                      constraints: ["writable: rbp-0x50", "r13 == NULL || {\"/bin/sh\", r13, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 945593,
                      constraints: ["writable: rbp-0x50", "rax == NULL || {rax, r13, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 945597,
                      constraints: ["writable: rbp-0x50", "rax == NULL || {rax, [rbp-0x48], NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 945600,
                      constraints: ["writable: rbp-0x50", "rax == NULL || {rax, [rbp-0x48], NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 945604,
                      constraints: ["writable: r15+0x10", "writable: rbp-0x50", "[r15] == NULL || r15 == NULL || r15 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r15, r12)")
OneGadget::Gadget.add(build_id, 945608,
                      constraints: ["writable: r15+0x10", "[r15] == NULL || r15 == NULL || r15 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r15, r12)")
OneGadget::Gadget.add(build_id, 945655,
                      constraints: ["writable: rbp-0x78", "[rbp-0x68] == NULL || {\"/bin/sh\", [rbp-0x68], NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 945662,
                      constraints: ["writable: rbp-0x78", "rax == NULL || {rax, [rbp-0x68], NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 945665,
                      constraints: ["writable: rbp-0x78", "rax == NULL || {rax, [rbp-0x68], NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 945669,
                      constraints: ["writable: r10+0x10", "writable: rbp-0x78", "[r10] == NULL || r10 == NULL || r10 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r10, r12)")
OneGadget::Gadget.add(build_id, 945673,
                      constraints: ["writable: r10+0x10", "writable: rbp-0x78", "[r10] == NULL || r10 == NULL || r10 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r10, r12)")
OneGadget::Gadget.add(build_id, 945677,
                      constraints: ["writable: r10+0x10", "writable: rbp-0x78", "[r10] == NULL || r10 == NULL || r10 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r10, r12)")
OneGadget::Gadget.add(build_id, 945681,
                      constraints: ["writable: r10+0x10", "writable: rbp-0x78", "[r10] == NULL || r10 == NULL || r10 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r10, r12)")
OneGadget::Gadget.add(build_id, 1090841,
                      constraints: ["rax == 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[rsp+0x38] == NULL || (s32)[[rsp+0x38]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", [rsp+0x38], 0, rsp+0x70, environ)")
OneGadget::Gadget.add(build_id, 1091055,
                      constraints: ["[rsp+0xe8] != 0xffffffffffffffff", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[[rsp+0xf0]] == NULL || [rsp+0xf0] == NULL || [rsp+0xf0] is a valid envp", "[rsp+0x38] == NULL || (s32)[[rsp+0x38]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", [rsp+0x38], 0, rsp+0x70, [rsp+0xf0])")
OneGadget::Gadget.add(build_id, 1091066,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[[rsp+0xf0]] == NULL || [rsp+0xf0] == NULL || [rsp+0xf0] is a valid envp", "[rsp+0x38] == NULL || (s32)[[rsp+0x38]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", [rsp+0x38], 0, rsp+0x70, [rsp+0xf0])")
OneGadget::Gadget.add(build_id, 1091074,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[r9] == NULL || r9 == NULL || r9 is a valid envp", "[rsp+0x38] == NULL || (s32)[[rsp+0x38]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", [rsp+0x38], 0, rsp+0x70, r9)")
OneGadget::Gadget.add(build_id, 1091079,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[r9] == NULL || r9 == NULL || r9 is a valid envp", "rdx == NULL || (s32)[rdx+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", rdx, 0, rsp+0x70, r9)")
OneGadget::Gadget.add(build_id, 1091084,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[r9] == NULL || r9 == NULL || r9 is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, 0, rsp+0x70, r9)")
OneGadget::Gadget.add(build_id, 1091089,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "[r9] == NULL || r9 == NULL || r9 is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, 0, r8, r9)")
OneGadget::Gadget.add(build_id, 1091091,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "[r9] == NULL || r9 == NULL || r9 is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, r9)")
OneGadget::Gadget.add(build_id, 1092874,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[rsp+0x38] == NULL || (s32)[[rsp+0x38]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", [rsp+0x38], 0, rsp+0x70, environ)")
OneGadget::Gadget.add(build_id, 1092881,
                      constraints: ["readable: rax", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp", "[rsp+0x38] == NULL || (s32)[[rsp+0x38]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", [rsp+0x38], 0, rsp+0x70, [rax])")
OneGadget::Gadget.add(build_id, 1092884,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[r9] == NULL || r9 == NULL || r9 is a valid envp", "[rsp+0x38] == NULL || (s32)[[rsp+0x38]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", [rsp+0x38], 0, rsp+0x70, r9)")
OneGadget::Gadget.add(build_id, 1093031,
                      constraints: ["[rsp+0xe8] != 0xffffffffffffffff", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[[rsp+0xf0]] == NULL || [rsp+0xf0] == NULL || [rsp+0xf0] is a valid envp", "[rsp+0x38] == NULL || (s32)[[rsp+0x38]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", [rsp+0x38], 0, rsp+0x70, [rsp+0xf0])")

