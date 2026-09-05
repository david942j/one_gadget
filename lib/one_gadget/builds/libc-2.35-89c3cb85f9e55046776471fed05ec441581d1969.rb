require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc6_2.35-0ubuntu3_amd64/lib/x86_64-linux-gnu/libc.so.6
# 
# Advanced Micro Devices X86-64 processor
# 
# GNU C Library (Ubuntu GLIBC 2.35-0ubuntu3) stable release version 2.35.
# Copyright (C) 2022 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 11.2.0.
# libc ABIs: UNIQUE IFUNC ABSOLUTE
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 330195,
                      constraints: ["[$base+0x21b7a0] == 0x1", "readable: r12", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x220 == NULL || (u16)[rsp+0x220] == 0x0"],
                      effect: "posix_spawn(rsp+0x1c, \"/bin/sh\", 0, rsp+0x220, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 330217,
                      constraints: ["readable: r12", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x220 == NULL || (u16)[rsp+0x220] == 0x0"],
                      effect: "posix_spawn(rsp+0x1c, \"/bin/sh\", 0, rsp+0x220, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 330225,
                      constraints: ["readable: r12", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x220 == NULL || (u16)[rsp+0x220] == 0x0"],
                      effect: "posix_spawn(rsp+0x1c, \"/bin/sh\", 0, rsp+0x220, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 330233,
                      constraints: ["readable: r12", "rsp & 0xf == 0x0", "writable: rbp", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rsp+0x1c, \"/bin/sh\", 0, rbp, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 330236,
                      constraints: ["readable: r12", "rsp & 0xf == 0x0", "writable: rbp", "writable: rdi", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rsp+0x1c, \"/bin/sh\", 0, rbp, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 330241,
                      constraints: ["readable: r12", "rsp & 0xf == 0x0", "writable: rbp", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rsp+0x1c, \"/bin/sh\", 0, rbp, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 330244,
                      constraints: ["readable: rsi", "rsp & 0xf == 0x0", "writable: rbp", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rsp+0x1c, \"/bin/sh\", 0, rbp, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 330247,
                      constraints: ["readable: rsi", "rsp & 0xf == 0x0", "writable: rbp", "writable: rdi", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rsp+0x1c, \"/bin/sh\", 0, rbp, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 330252,
                      constraints: ["rsp & 0xf == 0x0", "writable: rbp", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rsp+0x1c, \"/bin/sh\", 0, rbp, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 330260,
                      constraints: ["readable: rsi", "rsp & 0xf == 0x0", "writable: rbp", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rsp+0x1c, \"/bin/sh\", 0, rbp, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 330263,
                      constraints: ["readable: rsi", "rsp & 0xf == 0x0", "writable: rbp", "writable: rdi", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rsp+0x1c, \"/bin/sh\", 0, rbp, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 330268,
                      constraints: ["rsp & 0xf == 0x0", "writable: rbp", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rsp+0x1c, \"/bin/sh\", 0, rbp, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 330273,
                      constraints: ["rsp & 0xf == 0x0", "writable: rbp", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rsp+0x1c, \"/bin/sh\", 0, rbp, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 330276,
                      constraints: ["rsp & 0xf == 0x0", "writable: rdi", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rbp == NULL || (u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rsp+0x1c, \"/bin/sh\", 0, rbp, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 330281,
                      constraints: ["rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rbp == NULL || (u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rsp+0x1c, \"/bin/sh\", 0, rbp, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 330288,
                      constraints: ["rsp & 0xf == 0x0", "rax == NULL || {\"sh\", rax, rbx, NULL} is a valid argv", "rbp == NULL || (u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rsp+0x1c, \"/bin/sh\", 0, rbp, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 330295,
                      constraints: ["rsp & 0xf == 0x0", "rcx == NULL || {rcx, rax, rbx, NULL} is a valid argv", "rbp == NULL || (u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rsp+0x1c, \"/bin/sh\", 0, rbp, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 330297,
                      constraints: ["rsp & 0xf == 0x0", "rcx == NULL || {rcx, rax, rbx, NULL} is a valid argv", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rbp == NULL || (u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rsp+0x1c, \"/bin/sh\", rdx, rbp, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 330302,
                      constraints: ["rsp & 0xf == 0x0", "rcx == NULL || {rcx, (u64)xmm3, rbx, NULL} is a valid argv", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rbp == NULL || (u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rsp+0x1c, \"/bin/sh\", rdx, rbp, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 330307,
                      constraints: ["rsp & 0xf == 0x0", "(u64)xmm0 == NULL || {(u64)xmm0, (u64)xmm3, rbx, NULL} is a valid argv", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rbp == NULL || (u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rsp+0x1c, \"/bin/sh\", rdx, rbp, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 330312,
                      constraints: ["rsp & 0xf == 0x0", "(u64)xmm0 == NULL || {(u64)xmm0, (u64)xmm3, rbx, NULL} is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rbp == NULL || (u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rbp, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 330319,
                      constraints: ["readable: rax", "rsp & 0xf == 0x0", "(u64)xmm0 == NULL || {(u64)xmm0, (u64)xmm3, rbx, NULL} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rbp == NULL || (u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rbp, rsp+0x60, [rax])")
OneGadget::Gadget.add(build_id, 330323,
                      constraints: ["readable: rax", "rsp & 0xf == 0x0", "(u64)xmm0 == NULL || {(u64)xmm0, (u64)(xmm0 >> 64), rbx, NULL} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rbp == NULL || (u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rbp, rsp+0x60, [rax])")
OneGadget::Gadget.add(build_id, 330328,
                      constraints: ["readable: rax", "rsp & 0xf == 0x0", "[r8] == NULL || r8 is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rbp == NULL || (u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rbp, r8, [rax])")
OneGadget::Gadget.add(build_id, 330331,
                      constraints: ["readable: rax", "rsp & 0xf == 0x0", "[r8] == NULL || r8 is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, [rax])")
OneGadget::Gadget.add(build_id, 330336,
                      constraints: ["readable: rax", "rsp & 0xf == 0x0", "[r8] == NULL || r8 is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, [rax])")
OneGadget::Gadget.add(build_id, 330339,
                      constraints: ["rsp & 0xf == 0x0", "[r8] == NULL || r8 is a valid argv", "[r9] == NULL || r9 == NULL || r9 is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, r9)")
OneGadget::Gadget.add(build_id, 527365,
                      constraints: ["r15 == 0x0", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 527365,
                      constraints: ["[r15+0xe8] == 0x0", "r13d == [r15+0x70]", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 527370,
                      constraints: ["[r15+0xe8] == 0x0", "r13d == [r15+0x70]", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 527376,
                      constraints: ["[r15+0xe8] == 0x0", "r13d == [r15+0x70]", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 527380,
                      constraints: ["[r15+0xe8] == 0x0", "r13d == esi", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 527393,
                      constraints: ["[r15+0xe8] == 0x0", "eax == 0x0", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 527401,
                      constraints: ["[r15+0xe8] == 0x0", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 527408,
                      constraints: ["r15 == 0x0", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 527413,
                      constraints: ["rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 527420,
                      constraints: ["rsp & 0xf == 0x0", "rax == NULL || {\"sh\", rax, rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 527427,
                      constraints: ["rsp & 0xf == 0x0", "rcx == NULL || {rcx, rax, rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 527430,
                      constraints: ["rsp & 0xf == 0x0", "rcx == NULL || {rcx, rax, rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 527435,
                      constraints: ["rsp & 0xf == 0x0", "rcx == NULL || {rcx, rax, [rsp+0x70], NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 527440,
                      constraints: ["rsp & 0xf == 0x0", "rcx == NULL || {rcx, (u64)xmm1, [rsp+0x70], NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 527445,
                      constraints: ["rsp & 0xf == 0x0", "(u64)xmm0 == NULL || {(u64)xmm0, (u64)xmm1, [rsp+0x70], NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 527450,
                      constraints: ["rsp & 0xf == 0x0", "[r8] == NULL || r8 is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, 0, r8, environ)")
OneGadget::Gadget.add(build_id, 527452,
                      constraints: ["rsp & 0xf == 0x0", "[r8] == NULL || r8 is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 527459,
                      constraints: ["readable: rax", "rsp & 0xf == 0x0", "[r8] == NULL || r8 is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, rcx, r8, [rax])")
OneGadget::Gadget.add(build_id, 527463,
                      constraints: ["readable: rax", "rsp & 0xf == 0x0", "[r8] == NULL || r8 is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, rcx, r8, [rax])")
OneGadget::Gadget.add(build_id, 527470,
                      constraints: ["readable: rax", "rsp & 0xf == 0x0", "[r8] == NULL || r8 is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, [rax])")
OneGadget::Gadget.add(build_id, 965195,
                      constraints: ["[rbx] == 0x0", "writable: rbp-0x50", "r13 == NULL || {\"/bin/sh\", r13, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 965200,
                      constraints: ["[rbx] == 0x0", "writable: rbp-0x50", "r13 == NULL || {\"/bin/sh\", r13, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 965202,
                      constraints: ["[rbx] == 0x0", "writable: rbp-0x50", "r13 == NULL || {\"/bin/sh\", r13, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 965211,
                      constraints: ["writable: rbp-0x50", "r13 == NULL || {\"/bin/sh\", r13, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 965497,
                      constraints: ["[rbx] == 0x0", "eax == 0x8", "writable: rbp-0x78", "r12 == NULL || {\"/bin/sh\", r12, NULL} is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 965693,
                      constraints: ["[rbx] == 0x0", "writable: rbp-0x78", "r12 == NULL || {\"/bin/sh\", r12, NULL} is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 965696,
                      constraints: ["[rbx] == 0x0", "writable: rbp-0x78", "r12 == NULL || {\"/bin/sh\", r12, NULL} is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 965698,
                      constraints: ["[rbx] == 0x0", "writable: rbp-0x78", "r12 == NULL || {\"/bin/sh\", r12, NULL} is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 965707,
                      constraints: ["writable: rbp-0x78", "r12 == NULL || {\"/bin/sh\", r12, NULL} is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 965859,
                      constraints: ["rax == 0x1", "writable: r10+0x10", "writable: rbp-0x78", "[r10] == NULL || r10 == NULL || r10 is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", r10, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 965865,
                      constraints: ["writable: r10+0x10", "writable: rbp-0x78", "[r10] == NULL || r10 == NULL || r10 is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", r10, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 965873,
                      constraints: ["writable: rbp-0x78", "[r10] == NULL || r10 == NULL || r10 is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", r10, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 965877,
                      constraints: ["writable: rbp-0x78", "[r10] == NULL || r10 == NULL || r10 is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", r10, rdx)")
OneGadget::Gadget.add(build_id, 965880,
                      constraints: ["writable: rbp-0x78", "[rsi] == NULL || rsi == NULL || rsi is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, rdx)")
OneGadget::Gadget.add(build_id, 965960,
                      constraints: ["writable: rbp-0x78", "[[rbp-0x78]] == NULL || [rbp-0x78] == NULL || [rbp-0x78] is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x78], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 965964,
                      constraints: ["writable: rbp-0x78", "[r10] == NULL || r10 == NULL || r10 is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", r10, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 965968,
                      constraints: ["writable: rbp-0x78", "[r10] == NULL || r10 == NULL || r10 is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", r10, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 965970,
                      constraints: ["writable: rbp-0x50", "r13 == NULL || {\"/bin/sh\", r13, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 966056,
                      constraints: ["writable: rbp-0x78", "r12 == NULL || {\"/bin/sh\", r12, NULL} is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 966063,
                      constraints: ["writable: rbp-0x78", "rax == NULL || {rax, r12, NULL} is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 966067,
                      constraints: ["writable: rbp-0x78", "rax == NULL || {rax, [rbp-0x48], NULL} is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 966071,
                      constraints: ["writable: r10+0x10", "writable: rbp-0x78", "[r10] == NULL || r10 == NULL || r10 is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", r10, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 966075,
                      constraints: ["writable: r10+0x10", "writable: rbp-0x78", "[r10] == NULL || r10 == NULL || r10 is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", r10, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 1104608,
                      constraints: ["rax == 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[rsp+0x40] == NULL || (s32)[[rsp+0x40]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", [rsp+0x40], 0, rsp+0x70, environ)")
OneGadget::Gadget.add(build_id, 1104823,
                      constraints: ["[rsp+0xe8] != 0xffffffffffffffff", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[[rsp+0xf0]] == NULL || [rsp+0xf0] == NULL || [rsp+0xf0] is a valid envp", "[rsp+0x40] == NULL || (s32)[[rsp+0x40]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", [rsp+0x40], 0, rsp+0x70, [rsp+0xf0])")
OneGadget::Gadget.add(build_id, 1104834,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[[rsp+0xf0]] == NULL || [rsp+0xf0] == NULL || [rsp+0xf0] is a valid envp", "[rsp+0x40] == NULL || (s32)[[rsp+0x40]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", [rsp+0x40], 0, rsp+0x70, [rsp+0xf0])")
OneGadget::Gadget.add(build_id, 1104842,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[r9] == NULL || r9 == NULL || r9 is a valid envp", "[rsp+0x40] == NULL || (s32)[[rsp+0x40]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", [rsp+0x40], 0, rsp+0x70, r9)")
OneGadget::Gadget.add(build_id, 1104847,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[r9] == NULL || r9 == NULL || r9 is a valid envp", "rdx == NULL || (s32)[rdx+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", rdx, 0, rsp+0x70, r9)")
OneGadget::Gadget.add(build_id, 1104852,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[r9] == NULL || r9 == NULL || r9 is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, 0, rsp+0x70, r9)")
OneGadget::Gadget.add(build_id, 1104857,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "[r9] == NULL || r9 == NULL || r9 is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, 0, r8, r9)")
OneGadget::Gadget.add(build_id, 1104859,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "[r9] == NULL || r9 == NULL || r9 is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, r9)")
OneGadget::Gadget.add(build_id, 1106618,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[rsp+0x40] == NULL || (s32)[[rsp+0x40]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", [rsp+0x40], 0, rsp+0x70, environ)")
OneGadget::Gadget.add(build_id, 1106625,
                      constraints: ["readable: rax", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp", "[rsp+0x40] == NULL || (s32)[[rsp+0x40]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", [rsp+0x40], 0, rsp+0x70, [rax])")
OneGadget::Gadget.add(build_id, 1106628,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[r9] == NULL || r9 == NULL || r9 is a valid envp", "[rsp+0x40] == NULL || (s32)[[rsp+0x40]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", [rsp+0x40], 0, rsp+0x70, r9)")
OneGadget::Gadget.add(build_id, 1106772,
                      constraints: ["[rsp+0xe8] != 0xffffffffffffffff", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[[rsp+0xf0]] == NULL || [rsp+0xf0] == NULL || [rsp+0xf0] is a valid envp", "[rsp+0x40] == NULL || (s32)[[rsp+0x40]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", [rsp+0x40], 0, rsp+0x70, [rsp+0xf0])")

