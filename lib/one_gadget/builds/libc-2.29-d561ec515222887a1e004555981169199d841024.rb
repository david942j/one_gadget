require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc6_2.29-0ubuntu2_amd64/lib/x86_64-linux-gnu/libc-2.29.so
# 
# Advanced Micro Devices X86-64 processor
# 
# GNU C Library (Ubuntu GLIBC 2.29-0ubuntu2) stable release version 2.29.
# Copyright (C) 2019 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 8.3.0.
# libc ABIs: UNIQUE IFUNC ABSOLUTE
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 338962,
                      constraints: ["[$base+0x1e72c0] == 0x1", "[$base+0x1e7360] == 0x1", "readable: r13", "readable: rbp", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", r12, NULL} is a valid argv", "rsp+0x220 == NULL || (u16)[rsp+0x220] == 0x0"],
                      effect: "posix_spawn(rsp+0x1c, \"/bin/sh\", 0, rsp+0x220, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 338981,
                      constraints: ["[$base+0x1e72c0] == 0x1", "readable: r13", "readable: rbp", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", r12, NULL} is a valid argv", "rsp+0x220 == NULL || (u16)[rsp+0x220] == 0x0"],
                      effect: "posix_spawn(rsp+0x1c, \"/bin/sh\", 0, rsp+0x220, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 339000,
                      constraints: ["readable: r13", "readable: rbp", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", r12, NULL} is a valid argv", "rsp+0x220 == NULL || (u16)[rsp+0x220] == 0x0"],
                      effect: "posix_spawn(rsp+0x1c, \"/bin/sh\", 0, rsp+0x220, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 339008,
                      constraints: ["readable: r13", "readable: rbp", "rsp & 0xf == 0x0", "writable: rbx", "{\"sh\", \"-c\", r12, NULL} is a valid argv", "(u16)[rbx] == 0x0"],
                      effect: "posix_spawn(rsp+0x1c, \"/bin/sh\", 0, rbx, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 339011,
                      constraints: ["readable: r13", "readable: rbp", "rsp & 0xf == 0x0", "writable: rbx", "writable: rdi", "{\"sh\", \"-c\", r12, NULL} is a valid argv", "(u16)[rbx] == 0x0"],
                      effect: "posix_spawn(rsp+0x1c, \"/bin/sh\", 0, rbx, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 339016,
                      constraints: ["readable: r13", "readable: rbp", "rsp & 0xf == 0x0", "writable: rbx", "{\"sh\", \"-c\", r12, NULL} is a valid argv", "(u16)[rbx] == 0x0"],
                      effect: "posix_spawn(rsp+0x1c, \"/bin/sh\", 0, rbx, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 339019,
                      constraints: ["readable: r13", "readable: rsi", "rsp & 0xf == 0x0", "writable: rbx", "{\"sh\", \"-c\", r12, NULL} is a valid argv", "(u16)[rbx] == 0x0"],
                      effect: "posix_spawn(rsp+0x1c, \"/bin/sh\", 0, rbx, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 339022,
                      constraints: ["readable: r13", "readable: rsi", "rsp & 0xf == 0x0", "writable: rbx", "writable: rdi", "{\"sh\", \"-c\", r12, NULL} is a valid argv", "(u16)[rbx] == 0x0"],
                      effect: "posix_spawn(rsp+0x1c, \"/bin/sh\", 0, rbx, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 339027,
                      constraints: ["readable: r13", "rsp & 0xf == 0x0", "writable: rbx", "{\"sh\", \"-c\", r12, NULL} is a valid argv", "(u16)[rbx] == 0x0"],
                      effect: "posix_spawn(rsp+0x1c, \"/bin/sh\", 0, rbx, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 339030,
                      constraints: ["readable: rsi", "rsp & 0xf == 0x0", "writable: rbx", "{\"sh\", \"-c\", r12, NULL} is a valid argv", "(u16)[rbx] == 0x0"],
                      effect: "posix_spawn(rsp+0x1c, \"/bin/sh\", 0, rbx, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 339033,
                      constraints: ["readable: rsi", "rsp & 0xf == 0x0", "writable: rbx", "writable: rdi", "{\"sh\", \"-c\", r12, NULL} is a valid argv", "(u16)[rbx] == 0x0"],
                      effect: "posix_spawn(rsp+0x1c, \"/bin/sh\", 0, rbx, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 339038,
                      constraints: ["rsp & 0xf == 0x0", "writable: rbx", "{\"sh\", \"-c\", r12, NULL} is a valid argv", "(u16)[rbx] == 0x0"],
                      effect: "posix_spawn(rsp+0x1c, \"/bin/sh\", 0, rbx, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 339043,
                      constraints: ["rsp & 0xf == 0x0", "writable: rbx", "{\"sh\", \"-c\", r12, NULL} is a valid argv", "(u16)[rbx] == 0x0"],
                      effect: "posix_spawn(rsp+0x1c, \"/bin/sh\", 0, rbx, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 339046,
                      constraints: ["rsp & 0xf == 0x0", "writable: rdi", "{\"sh\", \"-c\", r12, NULL} is a valid argv", "rbx == NULL || (u16)[rbx] == 0x0"],
                      effect: "posix_spawn(rsp+0x1c, \"/bin/sh\", 0, rbx, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 339051,
                      constraints: ["rsp & 0xf == 0x0", "{\"sh\", \"-c\", r12, NULL} is a valid argv", "rbx == NULL || (u16)[rbx] == 0x0"],
                      effect: "posix_spawn(rsp+0x1c, \"/bin/sh\", 0, rbx, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 339058,
                      constraints: ["rsp & 0xf == 0x0", "rax == NULL || {\"sh\", rax, r12, NULL} is a valid argv", "rbx == NULL || (u16)[rbx] == 0x0"],
                      effect: "posix_spawn(rsp+0x1c, \"/bin/sh\", 0, rbx, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 339063,
                      constraints: ["rsp & 0xf == 0x0", "rax == NULL || {\"sh\", rax, r12, NULL} is a valid argv", "rdi == NULL || writable: rdi", "rbx == NULL || (u16)[rbx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", 0, rbx, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 339065,
                      constraints: ["rsp & 0xf == 0x0", "rax == NULL || {\"sh\", rax, r12, NULL} is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rbx == NULL || (u16)[rbx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rbx, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 339072,
                      constraints: ["rsp & 0xf == 0x0", "rcx == NULL || {rcx, rax, r12, NULL} is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rbx == NULL || (u16)[rbx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rbx, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 339077,
                      constraints: ["rsp & 0xf == 0x0", "[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rbx == NULL || (u16)[rbx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rbx, r8, environ)")
OneGadget::Gadget.add(build_id, 339082,
                      constraints: ["rsp & 0xf == 0x0", "[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rbx == NULL || (u16)[rbx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rbx, r8, environ)")
OneGadget::Gadget.add(build_id, 339087,
                      constraints: ["rsp & 0xf == 0x0", "[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rbx == NULL || (u16)[rbx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rbx, r8, environ)")
OneGadget::Gadget.add(build_id, 339093,
                      constraints: ["rsp & 0xf == 0x0", "[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rbx == NULL || (u16)[rbx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rbx, r8, environ)")
OneGadget::Gadget.add(build_id, 339096,
                      constraints: ["rsp & 0xf == 0x0", "[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 539088,
                      constraints: ["r14 == 0x0", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 539088,
                      constraints: ["[r14+0xe8] == 0x0", "r13d == [r14+0x70]", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 539093,
                      constraints: ["[r14+0xe8] == 0x0", "r13d == [r14+0x70]", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 539096,
                      constraints: ["[r14+0xe8] == 0x0", "r13d == [r14+0x70]", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 539100,
                      constraints: ["[r14+0xe8] == 0x0", "r13d == esi", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 539113,
                      constraints: ["[r14+0xe8] == 0x0", "eax == 0x0", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 539121,
                      constraints: ["[r14+0xe8] == 0x0", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 539128,
                      constraints: ["r14 == 0x0", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 539133,
                      constraints: ["rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 539135,
                      constraints: ["rsp & 0xf == 0x0", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, rcx, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 539140,
                      constraints: ["rsp & 0xf == 0x0", "[r8] == NULL || r8 is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 539143,
                      constraints: ["rsp & 0xf == 0x0", "[r8] == NULL || r8 is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 539148,
                      constraints: ["rsp & 0xf == 0x0", "[r8] == NULL || r8 is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 539155,
                      constraints: ["rsp & 0xf == 0x0", "[r8] == NULL || r8 is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 539162,
                      constraints: ["rsp & 0xf == 0x0", "[r8] == NULL || r8 is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 539171,
                      constraints: ["rsp & 0xf == 0x0", "[r8] == NULL || r8 is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 539176,
                      constraints: ["rsp & 0xf == 0x0", "[r8] == NULL || r8 is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 539182,
                      constraints: ["rsp & 0xf == 0x0", "[r8] == NULL || r8 is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 539189,
                      constraints: ["rsp & 0xf == 0x0", "[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0x0", "rcx == NULL || (u16)[rcx] == 0x0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 926027,
                      constraints: ["[r12] == 0x0", "writable: rbp-0x50", "rbx == NULL || {\"/bin/sh\", rbx, NULL} is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r13)")
OneGadget::Gadget.add(build_id, 926032,
                      constraints: ["[r12] == 0x0", "writable: rbp-0x50", "rbx == NULL || {\"/bin/sh\", rbx, NULL} is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r13)")
OneGadget::Gadget.add(build_id, 926034,
                      constraints: ["[r12] == 0x0", "writable: rbp-0x50", "rbx == NULL || {\"/bin/sh\", rbx, NULL} is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r13)")
OneGadget::Gadget.add(build_id, 926041,
                      constraints: ["writable: rbp-0x50", "rbx == NULL || {\"/bin/sh\", rbx, NULL} is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r13)")
OneGadget::Gadget.add(build_id, 926140,
                      constraints: ["rax == 0x1", "writable: r15+0x10", "[r15] == NULL || r15 == NULL || r15 is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r15, r13)")
OneGadget::Gadget.add(build_id, 926150,
                      constraints: ["writable: r15+0x10", "[r15] == NULL || r15 == NULL || r15 is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r15, r13)")
OneGadget::Gadget.add(build_id, 926158,
                      constraints: ["[r15] == NULL || r15 == NULL || r15 is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r15, r13)")
OneGadget::Gadget.add(build_id, 926161,
                      constraints: ["[r15] == NULL || r15 == NULL || r15 is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", r15, rdx)")
OneGadget::Gadget.add(build_id, 926164,
                      constraints: ["[rsi] == NULL || rsi == NULL || rsi is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, rdx)")
OneGadget::Gadget.add(build_id, 926278,
                      constraints: ["[r12] == 0x0", "eax == 0x8", "writable: [rbp-0x78]+0x10", "writable: rbp-0x80", "[[rbp-0x78]] == NULL || [rbp-0x78] == NULL || [rbp-0x78] is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x78], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 926446,
                      constraints: ["[r15] == NULL || r15 == NULL || r15 is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r15, r13)")
OneGadget::Gadget.add(build_id, 926451,
                      constraints: ["[r12] == 0x0", "writable: [rbp-0x78]+0x10", "writable: rbp-0x80", "[[rbp-0x78]] == NULL || [rbp-0x78] == NULL || [rbp-0x78] is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x78], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 926456,
                      constraints: ["[r12] == 0x0", "writable: [rbp-0x78]+0x10", "writable: rbp-0x80", "[[rbp-0x78]] == NULL || [rbp-0x78] == NULL || [rbp-0x78] is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x78], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 926458,
                      constraints: ["[r12] == 0x0", "writable: [rbp-0x78]+0x10", "writable: rbp-0x80", "[[rbp-0x78]] == NULL || [rbp-0x78] == NULL || [rbp-0x78] is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x78], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 926465,
                      constraints: ["writable: [rbp-0x78]+0x10", "writable: rbp-0x80", "[[rbp-0x78]] == NULL || [rbp-0x78] == NULL || [rbp-0x78] is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x78], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 926577,
                      constraints: ["rax == 0x1", "readable: rbp-0x70", "writable: rcx+0x10", "[rcx] == NULL || rcx == NULL || rcx is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rcx, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 926583,
                      constraints: ["readable: rbp-0x70", "writable: rcx+0x10", "[rcx] == NULL || rcx == NULL || rcx is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rcx, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 926591,
                      constraints: ["readable: rbp-0x70", "[rcx] == NULL || rcx == NULL || rcx is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rcx, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 926595,
                      constraints: ["[rcx] == NULL || rcx == NULL || rcx is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rcx, rdx)")
OneGadget::Gadget.add(build_id, 926598,
                      constraints: ["[rsi] == NULL || rsi == NULL || rsi is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, rdx)")
OneGadget::Gadget.add(build_id, 926658,
                      constraints: ["readable: rbp-0x88", "[[rbp-0x88]] == NULL || [rbp-0x88] == NULL || [rbp-0x88] is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x88], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 926665,
                      constraints: ["readable: rbp-0x70", "[rcx] == NULL || rcx == NULL || rcx is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rcx, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 926667,
                      constraints: ["writable: rbp-0x50", "rbx == NULL || {\"/bin/sh\", rbx, NULL} is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r13)")
OneGadget::Gadget.add(build_id, 926674,
                      constraints: ["writable: rbp-0x50", "rax == NULL || {rax, rbx, NULL} is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r13)")
OneGadget::Gadget.add(build_id, 926677,
                      constraints: ["writable: rbp-0x50", "rax == NULL || {rax, rbx, NULL} is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r13)")
OneGadget::Gadget.add(build_id, 926681,
                      constraints: ["writable: rbp-0x50", "rax == NULL || {rax, [rbp-0x48], NULL} is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r13)")
OneGadget::Gadget.add(build_id, 926685,
                      constraints: ["writable: r15+0x10", "writable: rbp-0x50", "[r15] == NULL || r15 == NULL || r15 is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r15, r13)")
OneGadget::Gadget.add(build_id, 926689,
                      constraints: ["writable: r15+0x10", "[r15] == NULL || r15 == NULL || r15 is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r15, r13)")
OneGadget::Gadget.add(build_id, 926732,
                      constraints: ["writable: [rbp-0x78]+0x10", "writable: rbp-0x80", "[[rbp-0x78]] == NULL || [rbp-0x78] == NULL || [rbp-0x78] is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x78], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 926739,
                      constraints: ["writable: [rbp-0x78]+0x10", "writable: rbp-0x80", "[[rbp-0x78]] == NULL || [rbp-0x78] == NULL || [rbp-0x78] is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x78], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 926743,
                      constraints: ["writable: [rbp-0x78]+0x10", "writable: rbp-0x50", "[[rbp-0x78]] == NULL || [rbp-0x78] == NULL || [rbp-0x78] is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x78], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 926747,
                      constraints: ["writable: rbp-0x50", "writable: rcx+0x10", "[rcx] == NULL || rcx == NULL || rcx is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rcx, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 926751,
                      constraints: ["writable: rbp-0x48", "writable: rcx+0x10", "[rcx] == NULL || rcx == NULL || rcx is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rcx, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 926755,
                      constraints: ["writable: rbp-0x48", "writable: rcx+0x10", "[rcx] == NULL || rcx == NULL || rcx is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rcx, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 926759,
                      constraints: ["readable: rbp-0x70", "writable: rcx+0x10", "[rcx] == NULL || rcx == NULL || rcx is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rcx, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 1076670,
                      constraints: ["ebx != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x6c]", "[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1076674,
                      constraints: ["ebx != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["rdi", "[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1076679,
                      constraints: ["ebx != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1076769,
                      constraints: ["([rsp+0xa8] & 0xf000) == 0x2000", "[rsp+0xb8] == 0x103", "eax == 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1076773,
                      constraints: ["([rsp+0xa8] & 0xf000) == 0x2000", "[rsp+0xb8] == 0x103", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1076780,
                      constraints: ["(eax & 0xf000) == 0x2000", "[rsp+0xb8] == 0x103", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1076785,
                      constraints: ["[rsp+0xb8] == 0x103", "eax == 0x2000", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1076792,
                      constraints: ["[rsp+0xb8] == 0x103", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1076953,
                      constraints: ["ebx != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1076963,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1076975,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1076979,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["rdi"])
OneGadget::Gadget.add(build_id, 1076984,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)")
OneGadget::Gadget.add(build_id, 1076991,
                      constraints: ["readable: rax", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, [rax])")
OneGadget::Gadget.add(build_id, 1076996,
                      constraints: ["readable: rax", "[rsi] == NULL || rsi == NULL || rsi is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, [rax])")

