require 'one_gadget/gadget'
# spec/data/libc-2.43-90ebd03ae9d9f42b23b4eb82fdf70352cf744198.so
# 
# Advanced Micro Devices X86-64
# 
# GNU C Library (Ubuntu GLIBC 2.43-2ubuntu2) stable release version 2.43.
# Copyright (C) 2026 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 15.2.0.
# libc ABIs: UNIQUE IFUNC ABSOLUTE
# Minimum supported kernel: 3.2.0
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 377358,
                      constraints: ["readable: rax", "rsp & 0xf == 0x0", "(u64)xmm0 == NULL || {(u64)xmm0, (u64)xmm3, (u64)xmm4, (u64)(xmm4 >> 64), ...} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rsp+0x230 == NULL || (u16)[rsp+0x230] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rsp+0x230, rsp+0x60, [rax])")
OneGadget::Gadget.add(build_id, 377363,
                      constraints: ["readable: rax", "rsp & 0xf == 0x0", "[r8] == NULL || r8 is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rsp+0x230 == NULL || (u16)[rsp+0x230] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rsp+0x230, r8, [rax])")
OneGadget::Gadget.add(build_id, 377371,
                      constraints: ["readable: rax", "rsp & 0xf == 0x0", "[r8] == NULL || r8 is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, [rax])")
OneGadget::Gadget.add(build_id, 377383,
                      constraints: ["readable: rax", "rsp & 0xf == 0x0", "[r8] == NULL || r8 is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, [rax])")
OneGadget::Gadget.add(build_id, 377386,
                      constraints: ["rsp & 0xf == 0x0", "[r8] == NULL || r8 is a valid argv", "[r9] == NULL || r9 == NULL || r9 is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, r9)")
OneGadget::Gadget.add(build_id, 377390,
                      constraints: ["rsp & 0xf == 0x0", "[r8] == NULL || r8 is a valid argv", "[r9] == NULL || r9 == NULL || r9 is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, r9)")
OneGadget::Gadget.add(build_id, 377395,
                      constraints: ["rsp & 0xf == 0x0", "[r8] == NULL || r8 is a valid argv", "[r9] == NULL || r9 == NULL || r9 is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, r9)")
OneGadget::Gadget.add(build_id, 1017027,
                      constraints: ["[rbx] == 0x0", "eax == 0x8", "writable: rbp-0x80", "r14 == NULL || {\"/bin/sh\", r14, NULL} is a valid argv", "[r15] == NULL || r15 == NULL || r15 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r15)")
OneGadget::Gadget.add(build_id, 1017405,
                      constraints: ["[rbx] == 0x0", "writable: rbp-0x80", "r14 == NULL || {\"/bin/sh\", r14, NULL} is a valid argv", "[r15] == NULL || r15 == NULL || r15 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r15)")
OneGadget::Gadget.add(build_id, 1017408,
                      constraints: ["[rbx] == 0x0", "writable: rbp-0x80", "r14 == NULL || {\"/bin/sh\", r14, NULL} is a valid argv", "[r15] == NULL || r15 == NULL || r15 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r15)")
OneGadget::Gadget.add(build_id, 1017412,
                      constraints: ["[rbx] == 0x0", "writable: rbp-0x50", "r14 == NULL || {\"/bin/sh\", r14, NULL} is a valid argv", "[r15] == NULL || r15 == NULL || r15 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r15)")
OneGadget::Gadget.add(build_id, 1017414,
                      constraints: ["[rbx] == 0x0", "writable: rbp-0x50", "r14 == NULL || {\"/bin/sh\", r14, NULL} is a valid argv", "[r15] == NULL || r15 == NULL || r15 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r15)")
OneGadget::Gadget.add(build_id, 1017420,
                      constraints: ["writable: rbp-0x50", "r14 == NULL || {\"/bin/sh\", r14, NULL} is a valid argv", "[r15] == NULL || r15 == NULL || r15 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r15)")
OneGadget::Gadget.add(build_id, 1017763,
                      constraints: ["writable: rbp-0x50", "r14 == NULL || {\"/bin/sh\", r14, NULL} is a valid argv", "[r15] == NULL || r15 == NULL || r15 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r15)")
OneGadget::Gadget.add(build_id, 1169093,
                      constraints: ["rax == 0x0", "[rsp+0x80] == NULL || {[rsp+0x80], [rsp+0x88], [rsp+0x90], [rsp+0x98], ...} is a valid argv", "[rsp+0x48] == NULL || (s32)[[rsp+0x48]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x74, \"/bin/sh\", [rsp+0x48], 0, rsp+0x80, environ)")
OneGadget::Gadget.add(build_id, 1169100,
                      constraints: ["rax == 0x0", "readable: rdx", "[rsp+0x80] == NULL || {[rsp+0x80], [rsp+0x88], [rsp+0x90], [rsp+0x98], ...} is a valid argv", "[[rdx]] == NULL || [rdx] == NULL || [rdx] is a valid envp", "[rsp+0x48] == NULL || (s32)[[rsp+0x48]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x74, \"/bin/sh\", [rsp+0x48], 0, rsp+0x80, [rdx])")
OneGadget::Gadget.add(build_id, 1169103,
                      constraints: ["rax == 0x0", "[rsp+0x80] == NULL || {[rsp+0x80], [rsp+0x88], [rsp+0x90], [rsp+0x98], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp", "[rsp+0x48] == NULL || (s32)[[rsp+0x48]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x74, \"/bin/sh\", [rsp+0x48], 0, rsp+0x80, r12)")
OneGadget::Gadget.add(build_id, 1169311,
                      constraints: ["[rsp+0xf8] != 0xffffffffffffffff", "[rsp+0x80] == NULL || {[rsp+0x80], [rsp+0x88], [rsp+0x90], [rsp+0x98], ...} is a valid argv", "[[rsp+0x100]] == NULL || [rsp+0x100] == NULL || [rsp+0x100] is a valid envp", "[rsp+0x48] == NULL || (s32)[[rsp+0x48]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x74, \"/bin/sh\", [rsp+0x48], 0, rsp+0x80, [rsp+0x100])")
OneGadget::Gadget.add(build_id, 1169322,
                      constraints: ["[rsp+0x80] == NULL || {[rsp+0x80], [rsp+0x88], [rsp+0x90], [rsp+0x98], ...} is a valid argv", "[[rsp+0x100]] == NULL || [rsp+0x100] == NULL || [rsp+0x100] is a valid envp", "[rsp+0x48] == NULL || (s32)[[rsp+0x48]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x74, \"/bin/sh\", [rsp+0x48], 0, rsp+0x80, [rsp+0x100])")
OneGadget::Gadget.add(build_id, 1169330,
                      constraints: ["[rsp+0x80] == NULL || {[rsp+0x80], [rsp+0x88], [rsp+0x90], [rsp+0x98], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp", "[rsp+0x48] == NULL || (s32)[[rsp+0x48]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x74, \"/bin/sh\", [rsp+0x48], 0, rsp+0x80, r12)")
OneGadget::Gadget.add(build_id, 1169335,
                      constraints: ["[rsp+0x80] == NULL || {[rsp+0x80], [rsp+0x88], [rsp+0x90], [rsp+0x98], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp", "rdx == NULL || (s32)[rdx+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x74, \"/bin/sh\", rdx, 0, rsp+0x80, r12)")
OneGadget::Gadget.add(build_id, 1169340,
                      constraints: ["[rsp+0x80] == NULL || {[rsp+0x80], [rsp+0x88], [rsp+0x90], [rsp+0x98], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, 0, rsp+0x80, r12)")
OneGadget::Gadget.add(build_id, 1169343,
                      constraints: ["[rsp+0x80] == NULL || {[rsp+0x80], [rsp+0x88], [rsp+0x90], [rsp+0x98], ...} is a valid argv", "[r9] == NULL || r9 == NULL || r9 is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, 0, rsp+0x80, r9)")
OneGadget::Gadget.add(build_id, 1169345,
                      constraints: ["[rsp+0x80] == NULL || {[rsp+0x80], [rsp+0x88], [rsp+0x90], [rsp+0x98], ...} is a valid argv", "[r9] == NULL || r9 == NULL || r9 is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, rsp+0x80, r9)")
OneGadget::Gadget.add(build_id, 1169353,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "[r9] == NULL || r9 == NULL || r9 is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, r9)")
OneGadget::Gadget.add(build_id, 1171509,
                      constraints: ["[rsp+0xf8] != 0xffffffffffffffff", "[rsp+0x80] == NULL || {[rsp+0x80], [rsp+0x88], [rsp+0x90], [rsp+0x98], ...} is a valid argv", "[[rsp+0x100]] == NULL || [rsp+0x100] == NULL || [rsp+0x100] is a valid envp", "[rsp+0x48] == NULL || (s32)[[rsp+0x48]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x74, \"/bin/sh\", [rsp+0x48], 0, rsp+0x80, [rsp+0x100])")

