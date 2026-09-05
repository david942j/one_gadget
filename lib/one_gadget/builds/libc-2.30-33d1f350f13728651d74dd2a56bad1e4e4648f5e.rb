require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/glibc-2.30-3-x86_64.pkg.tar/usr/lib/libc-2.30.so
# 
# Advanced Micro Devices X86-64 processor
# 
# GNU C Library (GNU libc) stable release version 2.30.
# Copyright (C) 2019 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 9.2.0.
# libc ABIs: UNIQUE IFUNC ABSOLUTE
# For bug reporting instructions, please see:
# <https://bugs.archlinux.org/>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 298352,
                      constraints: ["[$base+0x1c3060] == 0x1", "[$base+0x1c3100] == 0x1", "readable: r12", "readable: rbp", "rsi == NULL", "rsp+0x168 == rbp", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 298357,
                      constraints: ["[$base+0x1c3060] == 0x1", "[$base+0x1c3100] == 0x1", "readable: r12", "readable: rbp", "rsp+0x168 == rbp", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 298365,
                      constraints: ["[$base+0x1c3060] == 0x1", "[$base+0x1c3100] == 0x1", "rax == rbp", "readable: r12", "readable: rbp", "writable: rax", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 298368,
                      constraints: ["[$base+0x1c3060] == 0x1", "[$base+0x1c3100] == 0x1", "rax == rbp", "readable: r12", "readable: rbp", "writable: rax", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 298371,
                      constraints: ["[$base+0x1c3060] == 0x1", "[$base+0x1c3100] == 0x1", "rdx == rbp", "readable: r12", "readable: rbp", "writable: rax", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 298378,
                      constraints: ["[$base+0x1c3060] == 0x1", "[$base+0x1c3100] == 0x1", "rdx == rbp", "readable: r12", "readable: rbp", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 298382,
                      constraints: ["[$base+0x1c3060] == 0x1", "[$base+0x1c3100] == 0x1", "rdx == rbp", "readable: r12", "readable: rbp", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 298387,
                      constraints: ["[$base+0x1c3060] == 0x1", "[$base+0x1c3100] == 0x1", "readable: r12", "readable: rbp", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 298406,
                      constraints: ["[$base+0x1c3060] == 0x1", "readable: r12", "readable: rbp", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 298425,
                      constraints: ["readable: r12", "readable: rbp", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 298433,
                      constraints: ["readable: r12", "readable: rbp", "writable: r13", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 298436,
                      constraints: ["readable: r12", "readable: rbp", "writable: r13", "writable: rdi", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 298441,
                      constraints: ["readable: r12", "readable: rbp", "writable: r13", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 298444,
                      constraints: ["readable: rbp", "readable: rsi", "writable: r13", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 298447,
                      constraints: ["readable: rbp", "readable: rsi", "writable: r13", "writable: rdi", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 298452,
                      constraints: ["readable: rbp", "writable: r13", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 298455,
                      constraints: ["readable: rsi", "writable: r13", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 298458,
                      constraints: ["readable: rsi", "writable: r13", "writable: rdi", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 298463,
                      constraints: ["writable: r13", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 298468,
                      constraints: ["writable: r13", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 298471,
                      constraints: ["writable: rdi", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "r13 == NULL || (u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 298476,
                      constraints: ["{\"sh\", \"-c\", rbx, NULL} is a valid argv", "r13 == NULL || (u16)[r13] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 298481,
                      constraints: ["{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rdi == NULL || writable: rdi", "r13 == NULL || (u16)[r13] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", 0, r13, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 298484,
                      constraints: ["{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rdi == NULL || writable: rdi", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", 0, rcx, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 298486,
                      constraints: ["{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 298493,
                      constraints: ["rax == NULL || {rax, \"-c\", rbx, NULL} is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 298498,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 298503,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 298508,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 298515,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 486759,
                      constraints: ["r14 == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 486759,
                      constraints: ["[r14+0xe8] == 0x0", "r13d == [r14+0x70]", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 486764,
                      constraints: ["[r14+0xe8] == 0x0", "r13d == [r14+0x70]", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 486768,
                      constraints: ["[r14+0xe8] == 0x0", "r13d == [r14+0x70]", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 486772,
                      constraints: ["[r14+0xe8] == 0x0", "r13d == esi", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 486785,
                      constraints: ["[r14+0xe8] == 0x0", "eax == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 486793,
                      constraints: ["[r14+0xe8] == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 486800,
                      constraints: ["r14 == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 486805,
                      constraints: ["{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 486810,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, r8, environ)")
OneGadget::Gadget.add(build_id, 486812,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 486815,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 486820,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 486827,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 486834,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 486836,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 486845,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 486850,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 486857,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 840456,
                      constraints: ["[rsi] == 0x0", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsp-0x48, rdx)")
OneGadget::Gadget.add(build_id, 840464,
                      constraints: ["[rsi] == 0x0", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsp-0x48, rdx)")
OneGadget::Gadget.add(build_id, 840465,
                      constraints: ["[rsi] == 0x0", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsp-0x40, rdx)")
OneGadget::Gadget.add(build_id, 840468,
                      constraints: ["[rsi] == 0x0", "writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, rdx)")
OneGadget::Gadget.add(build_id, 840470,
                      constraints: ["[rsi] == 0x0", "writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, rdx)")
OneGadget::Gadget.add(build_id, 840473,
                      constraints: ["[rsi] == 0x0", "writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r13)")
OneGadget::Gadget.add(build_id, 840475,
                      constraints: ["[rsi] == 0x0", "writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r13)")
OneGadget::Gadget.add(build_id, 840476,
                      constraints: ["[rsi] == 0x0", "writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r13)")
OneGadget::Gadget.add(build_id, 840480,
                      constraints: ["[rsi] == 0x0", "writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r13)")
OneGadget::Gadget.add(build_id, 840489,
                      constraints: ["[rsi] == 0x0", "writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r13)")
OneGadget::Gadget.add(build_id, 840493,
                      constraints: ["[rsi] == 0x0", "writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r13)")
OneGadget::Gadget.add(build_id, 840495,
                      constraints: ["[rsi] == 0x0", "writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r13)")
OneGadget::Gadget.add(build_id, 840501,
                      constraints: ["writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r13)")
OneGadget::Gadget.add(build_id, 840603,
                      constraints: ["rax == 0x1", "writable: r12+0x10", "[r12] == NULL || r12 == NULL || r12 is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r12, r13)")
OneGadget::Gadget.add(build_id, 840609,
                      constraints: ["writable: r12+0x10", "[r12] == NULL || r12 == NULL || r12 is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r12, r13)")
OneGadget::Gadget.add(build_id, 840618,
                      constraints: ["[r12] == NULL || r12 == NULL || r12 is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r12, r13)")
OneGadget::Gadget.add(build_id, 840621,
                      constraints: ["[r12] == NULL || r12 == NULL || r12 is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", r12, rdx)")
OneGadget::Gadget.add(build_id, 840624,
                      constraints: ["[rsi] == NULL || rsi == NULL || rsi is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, rdx)")
OneGadget::Gadget.add(build_id, 840689,
                      constraints: ["[r12] == NULL || r12 == NULL || r12 is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r12, r13)")
OneGadget::Gadget.add(build_id, 840707,
                      constraints: ["writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r13)")
OneGadget::Gadget.add(build_id, 840714,
                      constraints: ["writable: rbp-0x40", "rax == NULL || {rax, rdi, NULL} is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r13)")
OneGadget::Gadget.add(build_id, 840718,
                      constraints: ["writable: rbp-0x40", "rax == NULL || {rax, [rbp-0x38], NULL} is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r13)")
OneGadget::Gadget.add(build_id, 840721,
                      constraints: ["writable: rbp-0x40", "rax == NULL || {rax, [rbp-0x38], NULL} is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r13)")
OneGadget::Gadget.add(build_id, 840725,
                      constraints: ["writable: r12+0x10", "writable: rbp-0x40", "[r12] == NULL || r12 == NULL || r12 is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r12, r13)")
OneGadget::Gadget.add(build_id, 840729,
                      constraints: ["writable: r12+0x10", "[r12] == NULL || r12 == NULL || r12 is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r12, r13)")
OneGadget::Gadget.add(build_id, 962180,
                      constraints: ["ebp != 0x0", "[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x5c]", "[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 962184,
                      constraints: ["ebp != 0x0", "[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["rdi", "[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 962189,
                      constraints: ["ebp != 0x0", "[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 962279,
                      constraints: ["([rsp+0x98] & 0xf000) == 0x2000", "[rsp+0xa8] == 0x103", "eax == 0x0", "[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 962283,
                      constraints: ["([rsp+0x98] & 0xf000) == 0x2000", "[rsp+0xa8] == 0x103", "[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 962290,
                      constraints: ["(eax & 0xf000) == 0x2000", "[rsp+0xa8] == 0x103", "[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 962295,
                      constraints: ["[rsp+0xa8] == 0x103", "eax == 0x2000", "[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 962302,
                      constraints: ["[rsp+0xa8] == 0x103", "[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 962444,
                      constraints: ["ebp != 0x0", "[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 962454,
                      constraints: ["[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 962466,
                      constraints: ["[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 962470,
                      constraints: ["[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["rdi"])
OneGadget::Gadget.add(build_id, 962475,
                      constraints: ["[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 962482,
                      constraints: ["readable: rax", "[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, [rax])")
OneGadget::Gadget.add(build_id, 962487,
                      constraints: ["readable: rax", "[rsi] == NULL || rsi == NULL || rsi is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, [rax])")

