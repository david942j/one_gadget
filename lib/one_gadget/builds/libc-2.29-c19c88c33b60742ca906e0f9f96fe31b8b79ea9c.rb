require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/glibc-2.29-1-x86_64.pkg.tar/usr/lib/libc-2.29.so
# 
# Advanced Micro Devices X86-64 processor
# 
# GNU C Library (GNU libc) stable release version 2.29.
# Copyright (C) 2019 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 8.2.1 20181127.
# libc ABIs: UNIQUE IFUNC ABSOLUTE
# For bug reporting instructions, please see:
# <https://bugs.archlinux.org/>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 281111,
                      constraints: ["[$base+0x1c1440] == 0x1", "[$base+0x1c14e0] == 0x1", "rax == rbx", "readable: r12", "readable: rbx", "writable: rax", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 281113,
                      constraints: ["[$base+0x1c1440] == 0x1", "[$base+0x1c14e0] == 0x1", "rdx == rbx", "readable: r12", "readable: rbx", "writable: rdx", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 281120,
                      constraints: ["[$base+0x1c1440] == 0x1", "[$base+0x1c14e0] == 0x1", "rdx == rbx", "readable: r12", "readable: rbx", "writable: rdx", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 281123,
                      constraints: ["[$base+0x1c1440] == 0x1", "[$base+0x1c14e0] == 0x1", "rax == rbx", "readable: r12", "readable: rbx", "writable: rax", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 281130,
                      constraints: ["[$base+0x1c1440] == 0x1", "[$base+0x1c14e0] == 0x1", "rax == rbx", "readable: r12", "readable: rbx", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 281134,
                      constraints: ["[$base+0x1c1440] == 0x1", "[$base+0x1c14e0] == 0x1", "rax == rbx", "readable: r12", "readable: rbx", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 281139,
                      constraints: ["[$base+0x1c1440] == 0x1", "[$base+0x1c14e0] == 0x1", "readable: r12", "readable: rbx", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 281158,
                      constraints: ["[$base+0x1c1440] == 0x1", "readable: r12", "readable: rbx", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 281177,
                      constraints: ["readable: r12", "readable: rbx", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 281185,
                      constraints: ["readable: r12", "readable: rbx", "writable: r13", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "(u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 281188,
                      constraints: ["readable: r12", "readable: rbx", "writable: r13", "writable: rdi", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "(u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 281193,
                      constraints: ["readable: r12", "readable: rbx", "writable: r13", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "(u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 281196,
                      constraints: ["readable: rbx", "readable: rsi", "writable: r13", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "(u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 281199,
                      constraints: ["readable: rbx", "readable: rsi", "writable: r13", "writable: rdi", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "(u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 281204,
                      constraints: ["readable: rbx", "writable: r13", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "(u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 281207,
                      constraints: ["readable: rsi", "writable: r13", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "(u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 281210,
                      constraints: ["readable: rsi", "writable: r13", "writable: rdi", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "(u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 281215,
                      constraints: ["writable: r13", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "(u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 281220,
                      constraints: ["writable: r13", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "(u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 281223,
                      constraints: ["writable: rdi", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "r13 == NULL || (u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 281228,
                      constraints: ["{\"sh\", \"-c\", rbp, NULL} is a valid argv", "r13 == NULL || (u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 281233,
                      constraints: ["{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rdi == NULL || writable: rdi", "r13 == NULL || (u16)[r13] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 281236,
                      constraints: ["{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rdi == NULL || writable: rdi", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", 0, rcx, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 281238,
                      constraints: ["{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 281245,
                      constraints: ["rax == NULL || {rax, \"-c\", rbp, NULL} is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 281250,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 281255,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 281260,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 281267,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 465917,
                      constraints: ["r15 == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 465917,
                      constraints: ["[r15+0xe8] == 0x0", "r13d == [r15+0x70]", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 465922,
                      constraints: ["[r15+0xe8] == 0x0", "r13d == [r15+0x70]", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 465928,
                      constraints: ["[r15+0xe8] == 0x0", "r13d == [r15+0x70]", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 465932,
                      constraints: ["[r15+0xe8] == 0x0", "r13d == esi", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 465945,
                      constraints: ["[r15+0xe8] == 0x0", "eax == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 465953,
                      constraints: ["[r15+0xe8] == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 465960,
                      constraints: ["r15 == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 465965,
                      constraints: ["{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 465967,
                      constraints: ["{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, rcx, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 465972,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 465975,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 465980,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 465987,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 465994,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 466003,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 466008,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 466015,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 819748,
                      constraints: ["[rsi] == 0x0", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsp-0x48, rdx)")
OneGadget::Gadget.add(build_id, 819758,
                      constraints: ["[rsi] == 0x0", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsp-0x48, rdx)")
OneGadget::Gadget.add(build_id, 819760,
                      constraints: ["[rsi] == 0x0", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsp-0x48, rdx)")
OneGadget::Gadget.add(build_id, 819761,
                      constraints: ["[rsi] == 0x0", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsp-0x40, rdx)")
OneGadget::Gadget.add(build_id, 819763,
                      constraints: ["[rsi] == 0x0", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsp-0x40, rdx)")
OneGadget::Gadget.add(build_id, 819766,
                      constraints: ["[rsi] == 0x0", "writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, rdx)")
OneGadget::Gadget.add(build_id, 819768,
                      constraints: ["[rsi] == 0x0", "writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, rdx)")
OneGadget::Gadget.add(build_id, 819770,
                      constraints: ["[rsi] == 0x0", "writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, rdx)")
OneGadget::Gadget.add(build_id, 819773,
                      constraints: ["[rsi] == 0x0", "writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r12)")
OneGadget::Gadget.add(build_id, 819774,
                      constraints: ["[rsi] == 0x0", "writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r12)")
OneGadget::Gadget.add(build_id, 819778,
                      constraints: ["[rsi] == 0x0", "writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r12)")
OneGadget::Gadget.add(build_id, 819787,
                      constraints: ["[rsi] == 0x0", "writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r12)")
OneGadget::Gadget.add(build_id, 819791,
                      constraints: ["[rsi] == 0x0", "writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r12)")
OneGadget::Gadget.add(build_id, 819793,
                      constraints: ["[rsi] == 0x0", "writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r12)")
OneGadget::Gadget.add(build_id, 819799,
                      constraints: ["writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r12)")
OneGadget::Gadget.add(build_id, 819900,
                      constraints: ["rax == 0x1", "writable: r13+0x10", "[r13] == NULL || r13 == NULL || r13 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r13, r12)")
OneGadget::Gadget.add(build_id, 819906,
                      constraints: ["writable: r13+0x10", "[r13] == NULL || r13 == NULL || r13 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r13, r12)")
OneGadget::Gadget.add(build_id, 819914,
                      constraints: ["[r13] == NULL || r13 == NULL || r13 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r13, r12)")
OneGadget::Gadget.add(build_id, 819917,
                      constraints: ["[r13] == NULL || r13 == NULL || r13 is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", r13, rdx)")
OneGadget::Gadget.add(build_id, 819920,
                      constraints: ["[rsi] == NULL || rsi == NULL || rsi is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, rdx)")
OneGadget::Gadget.add(build_id, 819982,
                      constraints: ["[r13] == NULL || r13 == NULL || r13 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r13, r12)")
OneGadget::Gadget.add(build_id, 820000,
                      constraints: ["writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r12)")
OneGadget::Gadget.add(build_id, 820007,
                      constraints: ["writable: rbp-0x40", "rax == NULL || {rax, rdi, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r12)")
OneGadget::Gadget.add(build_id, 820010,
                      constraints: ["writable: rbp-0x40", "rax == NULL || {rax, rdi, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r12)")
OneGadget::Gadget.add(build_id, 820014,
                      constraints: ["writable: rbp-0x40", "rax == NULL || {rax, [rbp-0x38], NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r12)")
OneGadget::Gadget.add(build_id, 820018,
                      constraints: ["writable: r13+0x10", "writable: rbp-0x40", "[r13] == NULL || r13 == NULL || r13 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r13, r12)")
OneGadget::Gadget.add(build_id, 820022,
                      constraints: ["writable: r13+0x10", "[r13] == NULL || r13 == NULL || r13 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r13, r12)")
OneGadget::Gadget.add(build_id, 944095,
                      constraints: ["[rsp+0x34] != 0x0", "[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x5c]", "[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 944099,
                      constraints: ["[rsp+0x34] != 0x0", "[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["rdi", "[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 944104,
                      constraints: ["[rsp+0x34] != 0x0", "[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 944108,
                      constraints: ["ecx != 0x0", "[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 944198,
                      constraints: ["([rsp+0x98] & 0xf000) == 0x2000", "[rsp+0xa8] == 0x103", "eax == 0x0", "[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 944202,
                      constraints: ["([rsp+0x98] & 0xf000) == 0x2000", "[rsp+0xa8] == 0x103", "[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 944209,
                      constraints: ["(eax & 0xf000) == 0x2000", "[rsp+0xa8] == 0x103", "[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 944214,
                      constraints: ["[rsp+0xa8] == 0x103", "eax == 0x2000", "[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 944221,
                      constraints: ["[rsp+0xa8] == 0x103", "[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 944368,
                      constraints: ["[rsp+0x34] != 0x0", "[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 944379,
                      constraints: ["[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 944391,
                      constraints: ["[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 944395,
                      constraints: ["[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["rdi"])
OneGadget::Gadget.add(build_id, 944400,
                      constraints: ["[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 944407,
                      constraints: ["readable: rax", "[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, [rax])")
OneGadget::Gadget.add(build_id, 944412,
                      constraints: ["readable: rax", "[rsi] == NULL || rsi == NULL || rsi is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, [rax])")

