require 'one_gadget/gadget'
# https://launchpad.net/ubuntu/+archive/primary/+files/libc6_2.30-0ubuntu3_amd64.deb
# 
# Advanced Micro Devices X86-64 processor
# 
# GNU C Library (Ubuntu GLIBC 2.30-0ubuntu3) stable release version 2.30.
# Copyright (C) 2019 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 9.2.1 20191127.
# libc ABIs: UNIQUE IFUNC ABSOLUTE
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 348314,
                      constraints: ["[$base+0x1ed200] == 0x1", "[$base+0x1ed2a0] == 0x1", "readable: r13", "readable: rbp", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 348333,
                      constraints: ["[$base+0x1ed200] == 0x1", "readable: r13", "readable: rbp", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 348352,
                      constraints: ["readable: r13", "readable: rbp", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 348360,
                      constraints: ["readable: r13", "readable: rbp", "rsp & 0xf == 0x0", "writable: r12", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[r12] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r12, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 348363,
                      constraints: ["readable: r13", "readable: rbp", "rsp & 0xf == 0x0", "writable: r12", "writable: rdi", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[r12] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r12, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 348368,
                      constraints: ["readable: r13", "readable: rbp", "rsp & 0xf == 0x0", "writable: r12", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[r12] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r12, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 348371,
                      constraints: ["readable: r13", "readable: rsi", "rsp & 0xf == 0x0", "writable: r12", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[r12] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r12, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 348374,
                      constraints: ["readable: r13", "readable: rsi", "rsp & 0xf == 0x0", "writable: r12", "writable: rdi", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[r12] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r12, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 348379,
                      constraints: ["readable: r13", "rsp & 0xf == 0x0", "writable: r12", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[r12] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r12, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 348382,
                      constraints: ["readable: rsi", "rsp & 0xf == 0x0", "writable: r12", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[r12] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r12, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 348385,
                      constraints: ["readable: rsi", "rsp & 0xf == 0x0", "writable: r12", "writable: rdi", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[r12] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r12, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 348390,
                      constraints: ["rsp & 0xf == 0x0", "writable: r12", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[r12] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r12, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 348395,
                      constraints: ["rsp & 0xf == 0x0", "writable: r12", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[r12] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r12, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 348398,
                      constraints: ["rsp & 0xf == 0x0", "writable: rdi", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "r12 == NULL || (u16)[r12] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r12, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 348403,
                      constraints: ["rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "r12 == NULL || (u16)[r12] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r12, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 348410,
                      constraints: ["rsp & 0xf == 0x0", "rax == NULL || {\"sh\", rax, rbx, NULL} is a valid argv", "r12 == NULL || (u16)[r12] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r12, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 348415,
                      constraints: ["rsp & 0xf == 0x0", "rax == NULL || {\"sh\", rax, rbx, NULL} is a valid argv", "rdi == NULL || writable: rdi", "r12 == NULL || (u16)[r12] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", 0, r12, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 348417,
                      constraints: ["rsp & 0xf == 0x0", "rax == NULL || {\"sh\", rax, rbx, NULL} is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "r12 == NULL || (u16)[r12] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, r12, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 348422,
                      constraints: ["rsp & 0xf == 0x0", "(u64)xmm1 == NULL || {\"sh\", (u64)xmm1, rbx, NULL} is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "r12 == NULL || (u16)[r12] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, r12, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 348429,
                      constraints: ["readable: rax", "rsp & 0xf == 0x0", "(u64)xmm1 == NULL || {\"sh\", (u64)xmm1, rbx, NULL} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "r12 == NULL || (u16)[r12] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, r12, rsp+0x50, [rax])")
OneGadget::Gadget.add(build_id, 348436,
                      constraints: ["readable: rax", "rsp & 0xf == 0x0", "rcx == NULL || {rcx, (u64)xmm1, rbx, NULL} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "r12 == NULL || (u16)[r12] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, r12, rsp+0x50, [rax])")
OneGadget::Gadget.add(build_id, 348441,
                      constraints: ["readable: rax", "rsp & 0xf == 0x0", "[r8] == NULL || r8 is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "r12 == NULL || (u16)[r12] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, r12, r8, [rax])")
OneGadget::Gadget.add(build_id, 348446,
                      constraints: ["readable: rax", "rsp & 0xf == 0x0", "[r8] == NULL || r8 is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "r12 == NULL || (u16)[r12] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, r12, r8, [rax])")
OneGadget::Gadget.add(build_id, 553338,
                      constraints: ["r14 == 0x0", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 553338,
                      constraints: ["[r14+0xe8] == 0x0", "r13d == [r14+0x70]", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 553343,
                      constraints: ["[r14+0xe8] == 0x0", "r13d == [r14+0x70]", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 553344,
                      constraints: ["[r14+0xe8] == 0x0", "r13d == [r14+0x70]", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 553348,
                      constraints: ["[r14+0xe8] == 0x0", "r13d == esi", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 553361,
                      constraints: ["[r14+0xe8] == 0x0", "eax == 0x0", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 553369,
                      constraints: ["[r14+0xe8] == 0x0", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 553376,
                      constraints: ["r14 == 0x0", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 553381,
                      constraints: ["rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 553388,
                      constraints: ["rsp & 0xf == 0x0", "rax == NULL || {\"sh\", rax, rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 553395,
                      constraints: ["rsp & 0xf == 0x0", "rcx == NULL || {rcx, rax, rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 553398,
                      constraints: ["rsp & 0xf == 0x0", "rcx == NULL || {rcx, rax, rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 553403,
                      constraints: ["rsp & 0xf == 0x0", "rcx == NULL || {rcx, rax, [rsp+0x70], NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 553408,
                      constraints: ["rsp & 0xf == 0x0", "rcx == NULL || {rcx, (u64)xmm1, [rsp+0x70], NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 553415,
                      constraints: ["readable: rax", "rsp & 0xf == 0x0", "rcx == NULL || {rcx, (u64)xmm1, [rsp+0x70], NULL} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, 0, rsp+0x60, [rax])")
OneGadget::Gadget.add(build_id, 553420,
                      constraints: ["readable: rax", "rsp & 0xf == 0x0", "(u64)xmm0 == NULL || {(u64)xmm0, (u64)xmm1, [rsp+0x70], NULL} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, 0, rsp+0x60, [rax])")
OneGadget::Gadget.add(build_id, 553422,
                      constraints: ["readable: rax", "rsp & 0xf == 0x0", "(u64)xmm0 == NULL || {(u64)xmm0, (u64)xmm1, [rsp+0x70], NULL} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, rcx, rsp+0x60, [rax])")
OneGadget::Gadget.add(build_id, 553426,
                      constraints: ["readable: rax", "rsp & 0xf == 0x0", "(u64)xmm0 == NULL || {(u64)xmm0, (u64)(xmm0 >> 64), [rsp+0x70], NULL} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, rcx, rsp+0x60, [rax])")
OneGadget::Gadget.add(build_id, 553433,
                      constraints: ["readable: rax", "rsp & 0xf == 0x0", "(u64)xmm0 == NULL || {(u64)xmm0, (u64)(xmm0 >> 64), [rsp+0x70], NULL} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, rsp+0x60, [rax])")
OneGadget::Gadget.add(build_id, 553438,
                      constraints: ["readable: rax", "rsp & 0xf == 0x0", "[r8] == NULL || r8 is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, [rax])")
OneGadget::Gadget.add(build_id, 553440,
                      constraints: ["readable: rax", "rsp & 0xf == 0x0", "[r8] == NULL || r8 is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, [rax])")
OneGadget::Gadget.add(build_id, 553443,
                      constraints: ["rsp & 0xf == 0x0", "[r8] == NULL || r8 is a valid argv", "[r9] == NULL || r9 == NULL || r9 is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, r9)")
OneGadget::Gadget.add(build_id, 944347,
                      constraints: ["[rbx] == 0x0", "writable: rbp-0x50", "r13 == NULL || {\"/bin/sh\", r13, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 944352,
                      constraints: ["[rbx] == 0x0", "writable: rbp-0x50", "r13 == NULL || {\"/bin/sh\", r13, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 944354,
                      constraints: ["[rbx] == 0x0", "writable: rbp-0x50", "r13 == NULL || {\"/bin/sh\", r13, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 944360,
                      constraints: ["writable: rbp-0x50", "r13 == NULL || {\"/bin/sh\", r13, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 944524,
                      constraints: ["rax == 0x1", "writable: r15+0x10", "[r15] == NULL || r15 == NULL || r15 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r15, r12)")
OneGadget::Gadget.add(build_id, 944534,
                      constraints: ["writable: r15+0x10", "[r15] == NULL || r15 == NULL || r15 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r15, r12)")
OneGadget::Gadget.add(build_id, 944542,
                      constraints: ["[r15] == NULL || r15 == NULL || r15 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r15, r12)")
OneGadget::Gadget.add(build_id, 944545,
                      constraints: ["[r15] == NULL || r15 == NULL || r15 is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", r15, rdx)")
OneGadget::Gadget.add(build_id, 944548,
                      constraints: ["[rsi] == NULL || rsi == NULL || rsi is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, rdx)")
OneGadget::Gadget.add(build_id, 944666,
                      constraints: ["[rbx] == 0x0", "eax == 0x8", "writable: rbp-0x78", "[rbp-0x68] == NULL || {\"/bin/sh\", [rbp-0x68], NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 944784,
                      constraints: ["[r15] == NULL || r15 == NULL || r15 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r15, r12)")
OneGadget::Gadget.add(build_id, 944853,
                      constraints: ["[rbx] == 0x0", "writable: rbp-0x78", "[rbp-0x68] == NULL || {\"/bin/sh\", [rbp-0x68], NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 944856,
                      constraints: ["[rbx] == 0x0", "writable: rbp-0x78", "[rbp-0x68] == NULL || {\"/bin/sh\", [rbp-0x68], NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 944858,
                      constraints: ["[rbx] == 0x0", "writable: rbp-0x78", "[rbp-0x68] == NULL || {\"/bin/sh\", [rbp-0x68], NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 944864,
                      constraints: ["writable: rbp-0x78", "[rbp-0x68] == NULL || {\"/bin/sh\", [rbp-0x68], NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 945029,
                      constraints: ["rax == 0x1", "writable: r10+0x10", "writable: rbp-0x78", "[r10] == NULL || r10 == NULL || r10 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r10, r12)")
OneGadget::Gadget.add(build_id, 945035,
                      constraints: ["writable: r10+0x10", "writable: rbp-0x78", "[r10] == NULL || r10 == NULL || r10 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r10, r12)")
OneGadget::Gadget.add(build_id, 945043,
                      constraints: ["writable: rbp-0x78", "[r10] == NULL || r10 == NULL || r10 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r10, r12)")
OneGadget::Gadget.add(build_id, 945046,
                      constraints: ["writable: rbp-0x78", "[r10] == NULL || r10 == NULL || r10 is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", r10, rdx)")
OneGadget::Gadget.add(build_id, 945049,
                      constraints: ["writable: rbp-0x78", "[rsi] == NULL || rsi == NULL || rsi is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, rdx)")
OneGadget::Gadget.add(build_id, 945144,
                      constraints: ["writable: rbp-0x78", "[[rbp-0x78]] == NULL || [rbp-0x78] == NULL || [rbp-0x78] is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x78], r12)")
OneGadget::Gadget.add(build_id, 945148,
                      constraints: ["writable: rbp-0x78", "[r10] == NULL || r10 == NULL || r10 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r10, r12)")
OneGadget::Gadget.add(build_id, 945152,
                      constraints: ["writable: rbp-0x78", "[r10] == NULL || r10 == NULL || r10 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r10, r12)")
OneGadget::Gadget.add(build_id, 945154,
                      constraints: ["writable: rbp-0x50", "r13 == NULL || {\"/bin/sh\", r13, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 945161,
                      constraints: ["writable: rbp-0x50", "rax == NULL || {rax, r13, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 945165,
                      constraints: ["writable: rbp-0x50", "rax == NULL || {rax, [rbp-0x48], NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 945168,
                      constraints: ["writable: rbp-0x50", "rax == NULL || {rax, [rbp-0x48], NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 945172,
                      constraints: ["writable: r15+0x10", "writable: rbp-0x50", "[r15] == NULL || r15 == NULL || r15 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r15, r12)")
OneGadget::Gadget.add(build_id, 945176,
                      constraints: ["writable: r15+0x10", "[r15] == NULL || r15 == NULL || r15 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r15, r12)")
OneGadget::Gadget.add(build_id, 945223,
                      constraints: ["writable: rbp-0x78", "[rbp-0x68] == NULL || {\"/bin/sh\", [rbp-0x68], NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 945230,
                      constraints: ["writable: rbp-0x78", "rax == NULL || {rax, [rbp-0x68], NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 945233,
                      constraints: ["writable: rbp-0x78", "rax == NULL || {rax, [rbp-0x68], NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 945237,
                      constraints: ["writable: r10+0x10", "writable: rbp-0x78", "[r10] == NULL || r10 == NULL || r10 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r10, r12)")
OneGadget::Gadget.add(build_id, 945241,
                      constraints: ["writable: r10+0x10", "writable: rbp-0x78", "[r10] == NULL || r10 == NULL || r10 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r10, r12)")
OneGadget::Gadget.add(build_id, 945245,
                      constraints: ["writable: r10+0x10", "writable: rbp-0x78", "[r10] == NULL || r10 == NULL || r10 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r10, r12)")
OneGadget::Gadget.add(build_id, 945249,
                      constraints: ["writable: r10+0x10", "writable: rbp-0x78", "[r10] == NULL || r10 == NULL || r10 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r10, r12)")
OneGadget::Gadget.add(build_id, 1093117,
                      constraints: ["ebx != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x6c]", "[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1093121,
                      constraints: ["ebx != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["rdi", "[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1093126,
                      constraints: ["ebx != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1093216,
                      constraints: ["([rsp+0xa8] & 0xf000) == 0x2000", "[rsp+0xb8] == 0x103", "eax == 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1093220,
                      constraints: ["([rsp+0xa8] & 0xf000) == 0x2000", "[rsp+0xb8] == 0x103", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1093227,
                      constraints: ["(eax & 0xf000) == 0x2000", "[rsp+0xb8] == 0x103", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1093232,
                      constraints: ["[rsp+0xb8] == 0x103", "eax == 0x2000", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1093239,
                      constraints: ["[rsp+0xb8] == 0x103", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1093428,
                      constraints: ["ebx != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1093524,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1093536,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1093540,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["rdi"])
OneGadget::Gadget.add(build_id, 1093545,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)")
OneGadget::Gadget.add(build_id, 1093552,
                      constraints: ["readable: rax", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, [rax])")
OneGadget::Gadget.add(build_id, 1093557,
                      constraints: ["readable: rax", "[rsi] == NULL || rsi == NULL || rsi is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, [rax])")

