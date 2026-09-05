require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc6-amd64_2.33-0ubuntu2_i386/lib64/libc-2.33.so
# 
# Advanced Micro Devices X86-64 processor
# 
# GNU C Library (Ubuntu GLIBC 2.33-0ubuntu2) release release version 2.33.
# Copyright (C) 2021 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 10.2.1 20210130.
# libc ABIs: UNIQUE IFUNC ABSOLUTE
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 303587,
                      constraints: ["[$base+0x1c63a0] == 0x1", "[$base+0x1c6440] != 0x1", "readable: r12", "rsi == NULL", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 303587,
                      constraints: ["[$base+0x1c63a0] == 0x1", "[$base+0x1c6440] == 0x1", "readable: r12", "rsi == NULL", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 303590,
                      constraints: ["[$base+0x1c63a0] == 0x1", "[$base+0x1c6440] != 0x1", "readable: r12", "rsi == NULL", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 303590,
                      constraints: ["[$base+0x1c63a0] == 0x1", "[$base+0x1c6440] == 0x1", "readable: r12", "rsi == NULL", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 303595,
                      constraints: ["[$base+0x1c63a0] == 0x1", "[$base+0x1c6440] != 0x1", "readable: r12", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 303595,
                      constraints: ["[$base+0x1c63a0] == 0x1", "[$base+0x1c6440] == 0x1", "readable: r12", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 303617,
                      constraints: ["[$base+0x1c63a0] == 0x1", "readable: r12", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 303629,
                      constraints: ["[$base+0x1c63a0] == 0x1", "readable: r12", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 303648,
                      constraints: ["readable: r12", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x210, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 303656,
                      constraints: ["readable: r12", "writable: rbp", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rbp, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 303659,
                      constraints: ["readable: r12", "writable: rbp", "writable: rdi", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rbp, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 303664,
                      constraints: ["readable: r12", "writable: rbp", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rbp, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 303667,
                      constraints: ["readable: rsi", "writable: rbp", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rbp, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 303670,
                      constraints: ["readable: rsi", "writable: rbp", "writable: rdi", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rbp, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 303675,
                      constraints: ["writable: rbp", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rbp, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 303683,
                      constraints: ["readable: rsi", "writable: rbp", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rbp, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 303686,
                      constraints: ["readable: rsi", "writable: rbp", "writable: rdi", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rbp, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 303691,
                      constraints: ["writable: rbp", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rbp, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 303696,
                      constraints: ["writable: rbp", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "(u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rbp, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 303699,
                      constraints: ["writable: rdi", "{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rbp == NULL || (u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rbp, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 303704,
                      constraints: ["{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rbp == NULL || (u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rbp, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 303709,
                      constraints: ["{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rdi == NULL || writable: rdi", "rbp == NULL || (u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", 0, rbp, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 303711,
                      constraints: ["{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rbp == NULL || (u16)[rbp] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rbp, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 303714,
                      constraints: ["{\"sh\", \"-c\", rbx, NULL} is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 303721,
                      constraints: ["rax == NULL || {rax, \"-c\", rbx, NULL} is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 303726,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 303731,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 303736,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 303743,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 488903,
                      constraints: ["r14 == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 488903,
                      constraints: ["[r14+0xe8] == 0x0", "r13d == [r14+0x70]", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 488908,
                      constraints: ["[r14+0xe8] == 0x0", "r13d == [r14+0x70]", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 488912,
                      constraints: ["[r14+0xe8] == 0x0", "r13d == [r14+0x70]", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 488916,
                      constraints: ["[r14+0xe8] == 0x0", "r13d == esi", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 488929,
                      constraints: ["[r14+0xe8] == 0x0", "eax == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 488937,
                      constraints: ["[r14+0xe8] == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 488944,
                      constraints: ["r14 == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 488949,
                      constraints: ["{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 488954,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, r8, environ)")
OneGadget::Gadget.add(build_id, 488956,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 488959,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 488964,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 488971,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 488978,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 488980,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 488989,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 488994,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 489001,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 842019,
                      constraints: ["[rsi] == 0x0", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsp-0x48, rdx)")
OneGadget::Gadget.add(build_id, 842029,
                      constraints: ["[rsi] == 0x0", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsp-0x48, rdx)")
OneGadget::Gadget.add(build_id, 842032,
                      constraints: ["[rsi] == 0x0", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsp-0x48, rdx)")
OneGadget::Gadget.add(build_id, 842033,
                      constraints: ["[rsi] == 0x0", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsp-0x40, rdx)")
OneGadget::Gadget.add(build_id, 842036,
                      constraints: ["[rsi] == 0x0", "writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, rdx)")
OneGadget::Gadget.add(build_id, 842038,
                      constraints: ["[rsi] == 0x0", "writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, rdx)")
OneGadget::Gadget.add(build_id, 842040,
                      constraints: ["[rsi] == 0x0", "writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, rdx)")
OneGadget::Gadget.add(build_id, 842043,
                      constraints: ["[rsi] == 0x0", "writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r12)")
OneGadget::Gadget.add(build_id, 842044,
                      constraints: ["[rsi] == 0x0", "writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r12)")
OneGadget::Gadget.add(build_id, 842048,
                      constraints: ["[rsi] == 0x0", "writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r12)")
OneGadget::Gadget.add(build_id, 842057,
                      constraints: ["[rsi] == 0x0", "writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r12)")
OneGadget::Gadget.add(build_id, 842061,
                      constraints: ["[rsi] == 0x0", "writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r12)")
OneGadget::Gadget.add(build_id, 842063,
                      constraints: ["[rsi] == 0x0", "writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r12)")
OneGadget::Gadget.add(build_id, 842069,
                      constraints: ["writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r12)")
OneGadget::Gadget.add(build_id, 842224,
                      constraints: ["rax == 0x1", "writable: r13+0x10", "[r13] == NULL || r13 == NULL || r13 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r13, r12)")
OneGadget::Gadget.add(build_id, 842230,
                      constraints: ["writable: r13+0x10", "[r13] == NULL || r13 == NULL || r13 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r13, r12)")
OneGadget::Gadget.add(build_id, 842238,
                      constraints: ["[r13] == NULL || r13 == NULL || r13 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r13, r12)")
OneGadget::Gadget.add(build_id, 842241,
                      constraints: ["[r13] == NULL || r13 == NULL || r13 is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", r13, rdx)")
OneGadget::Gadget.add(build_id, 842244,
                      constraints: ["[rsi] == NULL || rsi == NULL || rsi is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, rdx)")
OneGadget::Gadget.add(build_id, 842301,
                      constraints: ["[r13] == NULL || r13 == NULL || r13 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r13, r12)")
OneGadget::Gadget.add(build_id, 842327,
                      constraints: ["writable: rbp-0x40", "rdi == NULL || {\"/bin/sh\", rdi, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r12)")
OneGadget::Gadget.add(build_id, 842334,
                      constraints: ["writable: rbp-0x40", "rax == NULL || {rax, rdi, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r12)")
OneGadget::Gadget.add(build_id, 842338,
                      constraints: ["writable: rbp-0x40", "rax == NULL || {rax, [rbp-0x38], NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r12)")
OneGadget::Gadget.add(build_id, 842341,
                      constraints: ["writable: rbp-0x40", "rax == NULL || {rax, [rbp-0x38], NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r12)")
OneGadget::Gadget.add(build_id, 842345,
                      constraints: ["writable: r13+0x10", "writable: rbp-0x40", "[r13] == NULL || r13 == NULL || r13 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r13, r12)")
OneGadget::Gadget.add(build_id, 842349,
                      constraints: ["writable: r13+0x10", "[r13] == NULL || r13 == NULL || r13 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r13, r12)")
OneGadget::Gadget.add(build_id, 964460,
                      constraints: ["rax == 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[rsp+0x40] == NULL || (s32)[[rsp+0x40]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", [rsp+0x40], 0, rsp+0x70, environ)")
OneGadget::Gadget.add(build_id, 964687,
                      constraints: ["[rsp+0xe8] != 0xffffffffffffffff", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[[rsp+0xf0]] == NULL || [rsp+0xf0] == NULL || [rsp+0xf0] is a valid envp", "[rsp+0x40] == NULL || (s32)[[rsp+0x40]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", [rsp+0x40], 0, rsp+0x70, [rsp+0xf0])")
OneGadget::Gadget.add(build_id, 964698,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[[rsp+0xf0]] == NULL || [rsp+0xf0] == NULL || [rsp+0xf0] is a valid envp", "[rsp+0x40] == NULL || (s32)[[rsp+0x40]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", [rsp+0x40], 0, rsp+0x70, [rsp+0xf0])")
OneGadget::Gadget.add(build_id, 964706,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[r9] == NULL || r9 == NULL || r9 is a valid envp", "[rsp+0x40] == NULL || (s32)[[rsp+0x40]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", [rsp+0x40], 0, rsp+0x70, r9)")
OneGadget::Gadget.add(build_id, 964711,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[r9] == NULL || r9 == NULL || r9 is a valid envp", "rdx == NULL || (s32)[rdx+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", rdx, 0, rsp+0x70, r9)")
OneGadget::Gadget.add(build_id, 964716,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[r9] == NULL || r9 == NULL || r9 is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, 0, rsp+0x70, r9)")
OneGadget::Gadget.add(build_id, 964721,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "[r9] == NULL || r9 == NULL || r9 is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, 0, r8, r9)")
OneGadget::Gadget.add(build_id, 964723,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "[r9] == NULL || r9 == NULL || r9 is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, r9)")
OneGadget::Gadget.add(build_id, 966029,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[rsp+0x40] == NULL || (s32)[[rsp+0x40]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", [rsp+0x40], 0, rsp+0x70, environ)")
OneGadget::Gadget.add(build_id, 966036,
                      constraints: ["readable: rax", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp", "[rsp+0x40] == NULL || (s32)[[rsp+0x40]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", [rsp+0x40], 0, rsp+0x70, [rax])")
OneGadget::Gadget.add(build_id, 966039,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[r9] == NULL || r9 == NULL || r9 is a valid envp", "[rsp+0x40] == NULL || (s32)[[rsp+0x40]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", [rsp+0x40], 0, rsp+0x70, r9)")
OneGadget::Gadget.add(build_id, 966111,
                      constraints: ["[rsp+0xe8] != 0xffffffffffffffff", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[[rsp+0xf0]] == NULL || [rsp+0xf0] == NULL || [rsp+0xf0] is a valid envp", "[rsp+0x40] == NULL || (s32)[[rsp+0x40]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", [rsp+0x40], 0, rsp+0x70, [rsp+0xf0])")

