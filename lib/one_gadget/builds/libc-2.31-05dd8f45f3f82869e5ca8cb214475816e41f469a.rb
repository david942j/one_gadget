require 'one_gadget/gadget'
# https://launchpad.net/ubuntu/+archive/primary/+files/libc6-amd64_2.31-0ubuntu9.1_i386.deb
# 
# Advanced Micro Devices X86-64 processor
# 
# GNU C Library (Ubuntu GLIBC 2.31-0ubuntu9.1) stable release version 2.31.
# Copyright (C) 2020 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 9.3.0.
# libc ABIs: UNIQUE IFUNC ABSOLUTE
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 300168,
                      constraints: ["[$base+0x1c5200] == 0x1", "[$base+0x1c52a0] == 0x1", "readable: r12", "readable: rbp", "rsi == NULL", "rsp+0x168 == rbp", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 300173,
                      constraints: ["[$base+0x1c5200] == 0x1", "[$base+0x1c52a0] == 0x1", "readable: r12", "readable: rbp", "rsp+0x168 == rbp", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 300181,
                      constraints: ["[$base+0x1c5200] == 0x1", "[$base+0x1c52a0] == 0x1", "rax == rbp", "readable: r12", "readable: rbp", "writable: rax", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 300184,
                      constraints: ["[$base+0x1c5200] == 0x1", "[$base+0x1c52a0] == 0x1", "rax == rbp", "readable: r12", "readable: rbp", "writable: rax", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 300187,
                      constraints: ["[$base+0x1c5200] == 0x1", "[$base+0x1c52a0] == 0x1", "rdx == rbp", "readable: r12", "readable: rbp", "writable: rax", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 300194,
                      constraints: ["[$base+0x1c5200] == 0x1", "[$base+0x1c52a0] == 0x1", "rdx == rbp", "readable: r12", "readable: rbp", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 300198,
                      constraints: ["[$base+0x1c5200] == 0x1", "[$base+0x1c52a0] == 0x1", "rdx == rbp", "readable: r12", "readable: rbp", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 300203,
                      constraints: ["[$base+0x1c5200] == 0x1", "[$base+0x1c52a0] == 0x1", "readable: r12", "readable: rbp", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 300222,
                      constraints: ["[$base+0x1c5200] == 0x1", "readable: r12", "readable: rbp", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 300241,
                      constraints: ["readable: r12", "readable: rbp", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 300249,
                      constraints: ["readable: r12", "readable: rbp", "writable: r13", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 300252,
                      constraints: ["readable: r12", "readable: rbp", "writable: r13", "writable: rdi", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 300257,
                      constraints: ["readable: r12", "readable: rbp", "writable: r13", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 300260,
                      constraints: ["readable: rbp", "readable: rsi", "writable: r13", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 300263,
                      constraints: ["readable: rbp", "readable: rsi", "writable: r13", "writable: rdi", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 300268,
                      constraints: ["readable: rbp", "writable: r13", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 300271,
                      constraints: ["readable: rsi", "writable: r13", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 300274,
                      constraints: ["readable: rsi", "writable: r13", "writable: rdi", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 300279,
                      constraints: ["writable: r13", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 300284,
                      constraints: ["writable: r13", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 300287,
                      constraints: ["writable: rdi", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "r13 == NULL || (u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 300292,
                      constraints: ["{\"sh\", \"-c\", rbx, NULL} is a valid argv", "r13 == NULL || (u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 300297,
                      constraints: ["{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rdi == NULL || writable: rdi", "r13 == NULL || (u16)[r13] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 300299,
                      constraints: ["{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "r13 == NULL || (u16)[r13] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 300302,
                      constraints: ["{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 300309,
                      constraints: ["rax == NULL || {rax, \"-c\", rbx, NULL} is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 300314,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 300319,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 300324,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 300331,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 491655,
                      constraints: ["r14 == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 491655,
                      constraints: ["[r14+0xe8] == 0x0", "r13d == [r14+0x70]", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 491660,
                      constraints: ["[r14+0xe8] == 0x0", "r13d == [r14+0x70]", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 491664,
                      constraints: ["[r14+0xe8] == 0x0", "r13d == [r14+0x70]", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 491668,
                      constraints: ["[r14+0xe8] == 0x0", "r13d == esi", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 491681,
                      constraints: ["[r14+0xe8] == 0x0", "eax == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 491689,
                      constraints: ["[r14+0xe8] == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 491696,
                      constraints: ["r14 == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 491701,
                      constraints: ["{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 491706,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, r8, environ)")
OneGadget::Gadget.add(build_id, 491708,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 491711,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 491716,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 491723,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 491730,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 491732,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 491741,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 491746,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 491753,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 846947,
                      constraints: ["[rsi] == 0x0", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsp-0x48, rdx)")
OneGadget::Gadget.add(build_id, 846957,
                      constraints: ["[rsi] == 0x0", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsp-0x48, rdx)")
OneGadget::Gadget.add(build_id, 846960,
                      constraints: ["[rsi] == 0x0", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsp-0x48, rdx)")
OneGadget::Gadget.add(build_id, 846961,
                      constraints: ["[rsi] == 0x0", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsp-0x40, rdx)")
OneGadget::Gadget.add(build_id, 846964,
                      constraints: ["[rsi] == 0x0", "writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, rdx)")
OneGadget::Gadget.add(build_id, 846966,
                      constraints: ["[rsi] == 0x0", "writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, rdx)")
OneGadget::Gadget.add(build_id, 846968,
                      constraints: ["[rsi] == 0x0", "writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, rdx)")
OneGadget::Gadget.add(build_id, 846971,
                      constraints: ["[rsi] == 0x0", "writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r12)")
OneGadget::Gadget.add(build_id, 846972,
                      constraints: ["[rsi] == 0x0", "writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r12)")
OneGadget::Gadget.add(build_id, 846976,
                      constraints: ["[rsi] == 0x0", "writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r12)")
OneGadget::Gadget.add(build_id, 846985,
                      constraints: ["[rsi] == 0x0", "writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r12)")
OneGadget::Gadget.add(build_id, 846989,
                      constraints: ["[rsi] == 0x0", "writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r12)")
OneGadget::Gadget.add(build_id, 846991,
                      constraints: ["[rsi] == 0x0", "writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r12)")
OneGadget::Gadget.add(build_id, 846997,
                      constraints: ["writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r12)")
OneGadget::Gadget.add(build_id, 847155,
                      constraints: ["rax == 0x1", "writable: r13+0x10", "[r13] == NULL || r13 == NULL || r13 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r13, r12)")
OneGadget::Gadget.add(build_id, 847161,
                      constraints: ["writable: r13+0x10", "[r13] == NULL || r13 == NULL || r13 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r13, r12)")
OneGadget::Gadget.add(build_id, 847169,
                      constraints: ["[r13] == NULL || r13 == NULL || r13 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r13, r12)")
OneGadget::Gadget.add(build_id, 847172,
                      constraints: ["[r13] == NULL || r13 == NULL || r13 is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", r13, rdx)")
OneGadget::Gadget.add(build_id, 847175,
                      constraints: ["[rsi] == NULL || rsi == NULL || rsi is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, rdx)")
OneGadget::Gadget.add(build_id, 847232,
                      constraints: ["[r13] == NULL || r13 == NULL || r13 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r13, r12)")
OneGadget::Gadget.add(build_id, 847258,
                      constraints: ["writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r12)")
OneGadget::Gadget.add(build_id, 847265,
                      constraints: ["writable: rbp-0x40", "rax == NULL || {rax, rdi, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r12)")
OneGadget::Gadget.add(build_id, 847269,
                      constraints: ["writable: rbp-0x40", "rax == NULL || {rax, [rbp-0x38], NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r12)")
OneGadget::Gadget.add(build_id, 847272,
                      constraints: ["writable: rbp-0x40", "rax == NULL || {rax, [rbp-0x38], NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r12)")
OneGadget::Gadget.add(build_id, 847276,
                      constraints: ["writable: r13+0x10", "writable: rbp-0x40", "[r13] == NULL || r13 == NULL || r13 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r13, r12)")
OneGadget::Gadget.add(build_id, 847280,
                      constraints: ["writable: r13+0x10", "[r13] == NULL || r13 == NULL || r13 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r13, r12)")
OneGadget::Gadget.add(build_id, 971216,
                      constraints: ["rax == 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[rsp+0x40] == NULL || (s32)[[rsp+0x40]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", [rsp+0x40], 0, rsp+0x70, environ)")
OneGadget::Gadget.add(build_id, 971447,
                      constraints: ["[rsp+0xe8] != 0xffffffffffffffff", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[[rsp+0xf0]] == NULL || [rsp+0xf0] == NULL || [rsp+0xf0] is a valid envp", "[rsp+0x40] == NULL || (s32)[[rsp+0x40]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", [rsp+0x40], 0, rsp+0x70, [rsp+0xf0])")
OneGadget::Gadget.add(build_id, 971458,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[[rsp+0xf0]] == NULL || [rsp+0xf0] == NULL || [rsp+0xf0] is a valid envp", "[rsp+0x40] == NULL || (s32)[[rsp+0x40]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", [rsp+0x40], 0, rsp+0x70, [rsp+0xf0])")
OneGadget::Gadget.add(build_id, 971466,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[r9] == NULL || r9 == NULL || r9 is a valid envp", "[rsp+0x40] == NULL || (s32)[[rsp+0x40]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", [rsp+0x40], 0, rsp+0x70, r9)")
OneGadget::Gadget.add(build_id, 971471,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[r9] == NULL || r9 == NULL || r9 is a valid envp", "rdx == NULL || (s32)[rdx+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", rdx, 0, rsp+0x70, r9)")
OneGadget::Gadget.add(build_id, 971476,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[r9] == NULL || r9 == NULL || r9 is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, 0, rsp+0x70, r9)")
OneGadget::Gadget.add(build_id, 971481,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "[r9] == NULL || r9 == NULL || r9 is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, 0, r8, r9)")
OneGadget::Gadget.add(build_id, 971483,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "[r9] == NULL || r9 == NULL || r9 is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, r9)")
OneGadget::Gadget.add(build_id, 972797,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[rsp+0x40] == NULL || (s32)[[rsp+0x40]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", [rsp+0x40], 0, rsp+0x70, environ)")
OneGadget::Gadget.add(build_id, 972804,
                      constraints: ["readable: rax", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp", "[rsp+0x40] == NULL || (s32)[[rsp+0x40]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", [rsp+0x40], 0, rsp+0x70, [rax])")
OneGadget::Gadget.add(build_id, 972807,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[r9] == NULL || r9 == NULL || r9 is a valid envp", "[rsp+0x40] == NULL || (s32)[[rsp+0x40]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", [rsp+0x40], 0, rsp+0x70, r9)")
OneGadget::Gadget.add(build_id, 972879,
                      constraints: ["[rsp+0xe8] != 0xffffffffffffffff", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[[rsp+0xf0]] == NULL || [rsp+0xf0] == NULL || [rsp+0xf0] is a valid envp", "[rsp+0x40] == NULL || (s32)[[rsp+0x40]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", [rsp+0x40], 0, rsp+0x70, [rsp+0xf0])")

