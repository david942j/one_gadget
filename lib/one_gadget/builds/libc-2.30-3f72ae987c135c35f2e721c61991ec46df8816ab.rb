require 'one_gadget/gadget'
# https://snapshot.debian.org/archive/debian-ports/20200325T232204Z/pool-x32/main/g/glibc/libc6-amd64_2.30-4_x32.deb
# 
# Advanced Micro Devices X86-64 processor
# 
# GNU C Library (Debian GLIBC 2.30-4) stable release version 2.30.
# Copyright (C) 2019 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 9.3.0.
# libc ABIs: UNIQUE IFUNC ABSOLUTE
# For bug reporting instructions, please see:
# <http://www.debian.org/Bugs/>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 295976,
                      constraints: ["[$base+0x1bf200] == 0x1", "[$base+0x1bf2a0] == 0x1", "readable: r12", "readable: rbp", "rsi == NULL", "rsp+0x168 == rbp", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 295981,
                      constraints: ["[$base+0x1bf200] == 0x1", "[$base+0x1bf2a0] == 0x1", "readable: r12", "readable: rbp", "rsp+0x168 == rbp", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 295989,
                      constraints: ["[$base+0x1bf200] == 0x1", "[$base+0x1bf2a0] == 0x1", "rax == rbp", "readable: r12", "readable: rbp", "writable: rax", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 295992,
                      constraints: ["[$base+0x1bf200] == 0x1", "[$base+0x1bf2a0] == 0x1", "rax == rbp", "readable: r12", "readable: rbp", "writable: rax", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 295995,
                      constraints: ["[$base+0x1bf200] == 0x1", "[$base+0x1bf2a0] == 0x1", "rdx == rbp", "readable: r12", "readable: rbp", "writable: rax", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 296002,
                      constraints: ["[$base+0x1bf200] == 0x1", "[$base+0x1bf2a0] == 0x1", "rdx == rbp", "readable: r12", "readable: rbp", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 296006,
                      constraints: ["[$base+0x1bf200] == 0x1", "[$base+0x1bf2a0] == 0x1", "rdx == rbp", "readable: r12", "readable: rbp", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 296011,
                      constraints: ["[$base+0x1bf200] == 0x1", "[$base+0x1bf2a0] == 0x1", "readable: r12", "readable: rbp", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 296030,
                      constraints: ["[$base+0x1bf200] == 0x1", "readable: r12", "readable: rbp", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 296049,
                      constraints: ["readable: r12", "readable: rbp", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 296057,
                      constraints: ["readable: r12", "readable: rbp", "writable: r13", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 296060,
                      constraints: ["readable: r12", "readable: rbp", "writable: r13", "writable: rdi", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 296065,
                      constraints: ["readable: r12", "readable: rbp", "writable: r13", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 296068,
                      constraints: ["readable: rbp", "readable: rsi", "writable: r13", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 296071,
                      constraints: ["readable: rbp", "readable: rsi", "writable: r13", "writable: rdi", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 296076,
                      constraints: ["readable: rbp", "writable: r13", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 296079,
                      constraints: ["readable: rsi", "writable: r13", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 296082,
                      constraints: ["readable: rsi", "writable: r13", "writable: rdi", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 296087,
                      constraints: ["writable: r13", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 296092,
                      constraints: ["writable: r13", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 296095,
                      constraints: ["writable: rdi", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "r13 == NULL || (u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 296100,
                      constraints: ["{\"sh\", \"-c\", rbx, NULL} is a valid argv", "r13 == NULL || (u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 296105,
                      constraints: ["{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rdi == NULL || writable: rdi", "r13 == NULL || (u16)[r13] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 296107,
                      constraints: ["{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "r13 == NULL || (u16)[r13] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 296110,
                      constraints: ["{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 296117,
                      constraints: ["rax == NULL || {rax, \"-c\", rbx, NULL} is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 296122,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 296127,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 296132,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 296139,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 482535,
                      constraints: ["r14 == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 482535,
                      constraints: ["[r14+0xe8] == 0x0", "r13d == [r14+0x70]", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 482540,
                      constraints: ["[r14+0xe8] == 0x0", "r13d == [r14+0x70]", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 482544,
                      constraints: ["[r14+0xe8] == 0x0", "r13d == [r14+0x70]", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 482548,
                      constraints: ["[r14+0xe8] == 0x0", "r13d == esi", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 482561,
                      constraints: ["[r14+0xe8] == 0x0", "eax == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 482569,
                      constraints: ["[r14+0xe8] == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 482576,
                      constraints: ["r14 == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 482581,
                      constraints: ["{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 482586,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, r8, environ)")
OneGadget::Gadget.add(build_id, 482588,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 482591,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 482596,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 482603,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 482610,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 482612,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 482621,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 482626,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 482633,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 833280,
                      constraints: ["[rsi] == 0x0", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsp-0x48, rdx)")
OneGadget::Gadget.add(build_id, 833281,
                      constraints: ["[rsi] == 0x0", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsp-0x40, rdx)")
OneGadget::Gadget.add(build_id, 833284,
                      constraints: ["[rsi] == 0x0", "writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, rdx)")
OneGadget::Gadget.add(build_id, 833286,
                      constraints: ["[rsi] == 0x0", "writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, rdx)")
OneGadget::Gadget.add(build_id, 833289,
                      constraints: ["[rsi] == 0x0", "writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r13)")
OneGadget::Gadget.add(build_id, 833291,
                      constraints: ["[rsi] == 0x0", "writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r13)")
OneGadget::Gadget.add(build_id, 833292,
                      constraints: ["[rsi] == 0x0", "writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r13)")
OneGadget::Gadget.add(build_id, 833296,
                      constraints: ["[rsi] == 0x0", "writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r13)")
OneGadget::Gadget.add(build_id, 833305,
                      constraints: ["[rsi] == 0x0", "writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r13)")
OneGadget::Gadget.add(build_id, 833309,
                      constraints: ["[rsi] == 0x0", "writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r13)")
OneGadget::Gadget.add(build_id, 833311,
                      constraints: ["[rsi] == 0x0", "writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r13)")
OneGadget::Gadget.add(build_id, 833317,
                      constraints: ["writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r13)")
OneGadget::Gadget.add(build_id, 833419,
                      constraints: ["rax == 0x1", "writable: r12+0x10", "[r12] == NULL || r12 == NULL || r12 is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r12, r13)")
OneGadget::Gadget.add(build_id, 833425,
                      constraints: ["writable: r12+0x10", "[r12] == NULL || r12 == NULL || r12 is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r12, r13)")
OneGadget::Gadget.add(build_id, 833434,
                      constraints: ["[r12] == NULL || r12 == NULL || r12 is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r12, r13)")
OneGadget::Gadget.add(build_id, 833437,
                      constraints: ["[r12] == NULL || r12 == NULL || r12 is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", r12, rdx)")
OneGadget::Gadget.add(build_id, 833440,
                      constraints: ["[rsi] == NULL || rsi == NULL || rsi is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, rdx)")
OneGadget::Gadget.add(build_id, 833505,
                      constraints: ["[r12] == NULL || r12 == NULL || r12 is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r12, r13)")
OneGadget::Gadget.add(build_id, 833523,
                      constraints: ["writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r13)")
OneGadget::Gadget.add(build_id, 833530,
                      constraints: ["writable: rbp-0x40", "rax == NULL || {rax, rdi, NULL} is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r13)")
OneGadget::Gadget.add(build_id, 833534,
                      constraints: ["writable: rbp-0x40", "rax == NULL || {rax, [rbp-0x38], NULL} is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r13)")
OneGadget::Gadget.add(build_id, 833537,
                      constraints: ["writable: rbp-0x40", "rax == NULL || {rax, [rbp-0x38], NULL} is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r13)")
OneGadget::Gadget.add(build_id, 833541,
                      constraints: ["writable: r12+0x10", "writable: rbp-0x40", "[r12] == NULL || r12 == NULL || r12 is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r12, r13)")
OneGadget::Gadget.add(build_id, 833545,
                      constraints: ["writable: r12+0x10", "[r12] == NULL || r12 == NULL || r12 is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r12, r13)")
OneGadget::Gadget.add(build_id, 954692,
                      constraints: ["ebp != 0x0", "[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x5c]", "[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 954696,
                      constraints: ["ebp != 0x0", "[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["rdi", "[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 954701,
                      constraints: ["ebp != 0x0", "[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 954791,
                      constraints: ["([rsp+0x98] & 0xf000) == 0x2000", "[rsp+0xa8] == 0x103", "eax == 0x0", "[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 954795,
                      constraints: ["([rsp+0x98] & 0xf000) == 0x2000", "[rsp+0xa8] == 0x103", "[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 954802,
                      constraints: ["(eax & 0xf000) == 0x2000", "[rsp+0xa8] == 0x103", "[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 954807,
                      constraints: ["[rsp+0xa8] == 0x103", "eax == 0x2000", "[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 954814,
                      constraints: ["[rsp+0xa8] == 0x103", "[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 954956,
                      constraints: ["ebp != 0x0", "[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 954966,
                      constraints: ["[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 954978,
                      constraints: ["[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 954982,
                      constraints: ["[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["rdi"])
OneGadget::Gadget.add(build_id, 954987,
                      constraints: ["[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 954994,
                      constraints: ["readable: rax", "[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, [rax])")
OneGadget::Gadget.add(build_id, 954999,
                      constraints: ["readable: rax", "[rsi] == NULL || rsi == NULL || rsi is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, [rax])")

