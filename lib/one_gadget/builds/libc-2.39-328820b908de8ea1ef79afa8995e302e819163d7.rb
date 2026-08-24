require 'one_gadget/gadget'
# http://archive.ubuntu.com/ubuntu/pool/main/g/glibc/libc6_2.39-0ubuntu8.8_amd64.deb
# 
# Advanced Micro Devices X86-64
# 
# GNU C Library (Ubuntu GLIBC 2.39-0ubuntu8.8) stable release version 2.39.
# Copyright (C) 2024 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 13.3.0.
# libc ABIs: UNIQUE IFUNC ABSOLUTE
# Minimum supported kernel: 3.2.0
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 361359,
                      constraints: ["[$base+0x205500] == 0x1", "readable: rbp", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", \"--\", r12, ...} is a valid argv", "rsp+0x220 == NULL || (u16)[rsp+0x220] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x220, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 361381,
                      constraints: ["readable: rbp", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", \"--\", r12, ...} is a valid argv", "rsp+0x220 == NULL || (u16)[rsp+0x220] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x220, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 361389,
                      constraints: ["readable: rbp", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", \"--\", r12, ...} is a valid argv", "rsp+0x220 == NULL || (u16)[rsp+0x220] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rsp+0x220, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 361397,
                      constraints: ["readable: rbp", "rsp & 0xf == 0x0", "writable: rbx", "{\"sh\", \"-c\", \"--\", r12, ...} is a valid argv", "(u16)[rbx] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rbx, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 361400,
                      constraints: ["readable: rbp", "rsp & 0xf == 0x0", "writable: rbx", "writable: rdi", "{\"sh\", \"-c\", \"--\", r12, ...} is a valid argv", "(u16)[rbx] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rbx, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 361405,
                      constraints: ["readable: rbp", "rsp & 0xf == 0x0", "writable: rbx", "{\"sh\", \"-c\", \"--\", r12, ...} is a valid argv", "(u16)[rbx] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rbx, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 361408,
                      constraints: ["readable: rsi", "rsp & 0xf == 0x0", "writable: rbx", "{\"sh\", \"-c\", \"--\", r12, ...} is a valid argv", "(u16)[rbx] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rbx, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 361411,
                      constraints: ["readable: rsi", "rsp & 0xf == 0x0", "writable: rbx", "writable: rdi", "{\"sh\", \"-c\", \"--\", r12, ...} is a valid argv", "(u16)[rbx] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rbx, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 361416,
                      constraints: ["rsp & 0xf == 0x0", "writable: rbx", "{\"sh\", \"-c\", \"--\", r12, ...} is a valid argv", "(u16)[rbx] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rbx, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 361424,
                      constraints: ["readable: rsi", "rsp & 0xf == 0x0", "writable: rbx", "{\"sh\", \"-c\", \"--\", r12, ...} is a valid argv", "(u16)[rbx] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rbx, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 361427,
                      constraints: ["readable: rsi", "rsp & 0xf == 0x0", "writable: rbx", "writable: rdi", "{\"sh\", \"-c\", \"--\", r12, ...} is a valid argv", "(u16)[rbx] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rbx, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 361432,
                      constraints: ["rsp & 0xf == 0x0", "writable: rbx", "{\"sh\", \"-c\", \"--\", r12, ...} is a valid argv", "(u16)[rbx] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rbx, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 361437,
                      constraints: ["rsp & 0xf == 0x0", "writable: rbx", "{\"sh\", \"-c\", \"--\", r12, ...} is a valid argv", "(u16)[rbx] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rbx, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 361440,
                      constraints: ["rsp & 0xf == 0x0", "writable: rdi", "{\"sh\", \"-c\", \"--\", r12, ...} is a valid argv", "rbx == NULL || (u16)[rbx] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rbx, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 361445,
                      constraints: ["rsp & 0xf == 0x0", "{\"sh\", \"-c\", \"--\", r12, ...} is a valid argv", "rbx == NULL || (u16)[rbx] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rbx, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 361452,
                      constraints: ["rsp & 0xf == 0x0", "rax == NULL || {\"sh\", rax, $base+0x1cb42c, r12, ...} is a valid argv", "rbx == NULL || (u16)[rbx] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rbx, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 361459,
                      constraints: ["rsp & 0xf == 0x0", "rcx == NULL || {rcx, rax, \"--\", r12, ...} is a valid argv", "rbx == NULL || (u16)[rbx] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", 0, rbx, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 361461,
                      constraints: ["rsp & 0xf == 0x0", "rcx == NULL || {rcx, rax, \"--\", r12, ...} is a valid argv", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rbx == NULL || (u16)[rbx] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", rdx, rbx, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 361466,
                      constraints: ["rsp & 0xf == 0x0", "rcx == NULL || {rcx, (u64)xmm1, \"--\", r12, ...} is a valid argv", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rbx == NULL || (u16)[rbx] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", rdx, rbx, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 361471,
                      constraints: ["rsp & 0xf == 0x0", "(u64)xmm0 == NULL || {(u64)xmm0, (u64)xmm1, \"--\", r12, ...} is a valid argv", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rbx == NULL || (u16)[rbx] == 0x0"],
                      effect: "posix_spawn(rsp+0xc, \"/bin/sh\", rdx, rbx, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 361476,
                      constraints: ["rsp & 0xf == 0x0", "(u64)xmm0 == NULL || {(u64)xmm0, (u64)xmm1, \"--\", r12, ...} is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rbx == NULL || (u16)[rbx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rbx, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 361479,
                      constraints: ["rsp & 0xf == 0x0", "(u64)xmm0 == NULL || {(u64)xmm0, (u64)xmm1, \"--\", r12, ...} is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 361486,
                      constraints: ["rsp & 0xf == 0x0", "(u64)xmm0 == NULL || {(u64)xmm0, (u64)xmm1, rax, r12, ...} is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 361490,
                      constraints: ["rsp & 0xf == 0x0", "(u64)xmm0 == NULL || {(u64)xmm0, (u64)(xmm0 >> 64), rax, r12, ...} is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 361495,
                      constraints: ["rsp & 0xf == 0x0", "[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 361500,
                      constraints: ["rsp & 0xf == 0x0", "[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 361505,
                      constraints: ["rsp & 0xf == 0x0", "[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 361512,
                      constraints: ["readable: rax", "rsp & 0xf == 0x0", "[r8] == NULL || r8 is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, [rax])")
OneGadget::Gadget.add(build_id, 979603,
                      constraints: ["[r15] == 0x0", "writable: rbp-0x50", "rbx == NULL || {\"/bin/sh\", rbx, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 979608,
                      constraints: ["[r15] == 0x0", "writable: rbp-0x50", "rbx == NULL || {\"/bin/sh\", rbx, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 979610,
                      constraints: ["[r15] == 0x0", "writable: rbp-0x50", "rbx == NULL || {\"/bin/sh\", rbx, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 979619,
                      constraints: ["writable: rbp-0x50", "rbx == NULL || {\"/bin/sh\", rbx, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 979920,
                      constraints: ["[r15] == 0x0", "eax == 0x8", "writable: rbp-0x80", "[rbp-0x60] == NULL || {\"/bin/sh\", [rbp-0x60], NULL} is a valid argv", "[[rbp-0x78]] == NULL || [rbp-0x78] == NULL || [rbp-0x78] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, [rbp-0x78])")
OneGadget::Gadget.add(build_id, 980088,
                      constraints: ["[r15] == 0x0", "writable: rbp-0x80", "[rbp-0x60] == NULL || {\"/bin/sh\", [rbp-0x60], NULL} is a valid argv", "[[rbp-0x78]] == NULL || [rbp-0x78] == NULL || [rbp-0x78] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, [rbp-0x78])")
OneGadget::Gadget.add(build_id, 980096,
                      constraints: ["[r15] == 0x0", "writable: rbp-0x80", "[rbp-0x60] == NULL || {\"/bin/sh\", [rbp-0x60], NULL} is a valid argv", "[[rbp-0x78]] == NULL || [rbp-0x78] == NULL || [rbp-0x78] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, [rbp-0x78])")
OneGadget::Gadget.add(build_id, 980098,
                      constraints: ["[r15] == 0x0", "writable: rbp-0x80", "[rbp-0x60] == NULL || {\"/bin/sh\", [rbp-0x60], NULL} is a valid argv", "[[rbp-0x78]] == NULL || [rbp-0x78] == NULL || [rbp-0x78] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, [rbp-0x78])")
OneGadget::Gadget.add(build_id, 980108,
                      constraints: ["writable: rbp-0x50", "[rbp-0x60] == NULL || {\"/bin/sh\", [rbp-0x60], NULL} is a valid argv", "[[rbp-0x78]] == NULL || [rbp-0x78] == NULL || [rbp-0x78] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, [rbp-0x78])")
OneGadget::Gadget.add(build_id, 980430,
                      constraints: ["writable: rbp-0x50", "rbx == NULL || {\"/bin/sh\", rbx, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 980519,
                      constraints: ["writable: rbp-0x50", "[rbp-0x60] == NULL || {\"/bin/sh\", [rbp-0x60], NULL} is a valid argv", "[[rbp-0x78]] == NULL || [rbp-0x78] == NULL || [rbp-0x78] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, [rbp-0x78])")
OneGadget::Gadget.add(build_id, 980523,
                      constraints: ["writable: rbp-0x50", "rax == NULL || {\"/bin/sh\", rax, NULL} is a valid argv", "[[rbp-0x78]] == NULL || [rbp-0x78] == NULL || [rbp-0x78] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, [rbp-0x78])")
OneGadget::Gadget.add(build_id, 1118706,
                      constraints: ["rax == 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[rsp+0x48] == NULL || (s32)[[rsp+0x48]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", [rsp+0x48], 0, rsp+0x70, environ)")
OneGadget::Gadget.add(build_id, 1118927,
                      constraints: ["[rsp+0xe8] != 0xffffffffffffffff", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[[rsp+0xf0]] == NULL || [rsp+0xf0] == NULL || [rsp+0xf0] is a valid envp", "[rsp+0x48] == NULL || (s32)[[rsp+0x48]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", [rsp+0x48], 0, rsp+0x70, [rsp+0xf0])")
OneGadget::Gadget.add(build_id, 1118938,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[[rsp+0xf0]] == NULL || [rsp+0xf0] == NULL || [rsp+0xf0] is a valid envp", "[rsp+0x48] == NULL || (s32)[[rsp+0x48]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", [rsp+0x48], 0, rsp+0x70, [rsp+0xf0])")
OneGadget::Gadget.add(build_id, 1118946,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[r9] == NULL || r9 == NULL || r9 is a valid envp", "[rsp+0x48] == NULL || (s32)[[rsp+0x48]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", [rsp+0x48], 0, rsp+0x70, r9)")
OneGadget::Gadget.add(build_id, 1118951,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[r9] == NULL || r9 == NULL || r9 is a valid envp", "rdx == NULL || (s32)[rdx+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", rdx, 0, rsp+0x70, r9)")
OneGadget::Gadget.add(build_id, 1118956,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[r9] == NULL || r9 == NULL || r9 is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, 0, rsp+0x70, r9)")
OneGadget::Gadget.add(build_id, 1118961,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "[r9] == NULL || r9 == NULL || r9 is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, 0, r8, r9)")
OneGadget::Gadget.add(build_id, 1118963,
                      constraints: ["[r8] == NULL || r8 is a valid argv", "[r9] == NULL || r9 == NULL || r9 is a valid envp", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, r9)")
OneGadget::Gadget.add(build_id, 1120858,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[rsp+0x48] == NULL || (s32)[[rsp+0x48]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", [rsp+0x48], 0, rsp+0x70, environ)")
OneGadget::Gadget.add(build_id, 1120865,
                      constraints: ["readable: rax", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp", "[rsp+0x48] == NULL || (s32)[[rsp+0x48]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", [rsp+0x48], 0, rsp+0x70, [rax])")
OneGadget::Gadget.add(build_id, 1120868,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[r9] == NULL || r9 == NULL || r9 is a valid envp", "[rsp+0x48] == NULL || (s32)[[rsp+0x48]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", [rsp+0x48], 0, rsp+0x70, r9)")
OneGadget::Gadget.add(build_id, 1121021,
                      constraints: ["[rsp+0xe8] != 0xffffffffffffffff", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[[rsp+0xf0]] == NULL || [rsp+0xf0] == NULL || [rsp+0xf0] is a valid envp", "[rsp+0x48] == NULL || (s32)[[rsp+0x48]+0x4] <= 0x0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", [rsp+0x48], 0, rsp+0x70, [rsp+0xf0])")

