require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc6_2.29-0ubuntu2_amd64/lib/x86_64-linux-gnu/libc-2.29.so
# 
# Advanced Micro Devices X86-64
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
OneGadget::Gadget.add(build_id, 339051,
                      constraints: ["rsp & 0xf == 0", "writable: rsp+0x70", "{\"sh\", \"-c\", r12, NULL} is a valid argv", "rbx == NULL || (u16)[rbx] == NULL"],
                      effect: "posix_spawn(rsp+0x1c, \"/bin/sh\", 0, rbx, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 339058,
                      constraints: ["rsp & 0xf == 0", "writable: rsp+0x70", "rax == NULL || {\"sh\", rax, r12, NULL} is a valid argv", "rbx == NULL || (u16)[rbx] == NULL"],
                      effect: "posix_spawn(rsp+0x1c, \"/bin/sh\", 0, rbx, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 339072,
                      constraints: ["rsp & 0xf == 0", "writable: rsp+0x70", "rcx == NULL || {rcx, rax, r12, NULL} is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0", "rbx == NULL || (u16)[rbx] == NULL"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rbx, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 339077,
                      constraints: ["rsp & 0xf == 0", "writable: rsp+0x70", "[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0", "rbx == NULL || (u16)[rbx] == NULL"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rbx, r8, environ)")
OneGadget::Gadget.add(build_id, 339093,
                      constraints: ["rsp & 0xf == 0", "writable: rsp+0x8", "[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0", "rbx == NULL || (u16)[rbx] == NULL"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rbx, r8, environ)")
OneGadget::Gadget.add(build_id, 339096,
                      constraints: ["rsp & 0xf == 0", "writable: rsp+0x8", "[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0", "rcx == NULL || (u16)[rcx] == NULL"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 539133,
                      constraints: ["rsp & 0xf == 0", "writable: rsp+0x70", "{\"sh\", \"-c\", rbp, NULL} is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 539140,
                      constraints: ["rsp & 0xf == 0", "writable: rsp+0x70", "[r8] == NULL || r8 is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0", "rcx == NULL || (u16)[rcx] == NULL"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 539143,
                      constraints: ["rsp & 0xf == 0", "writable: rsp+0x70", "[r8] == NULL || r8 is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0", "rcx == NULL || (u16)[rcx] == NULL"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 539162,
                      constraints: ["rsp & 0xf == 0", "writable: rsp+0x78", "[r8] == NULL || r8 is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0", "rcx == NULL || (u16)[rcx] == NULL"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 539182,
                      constraints: ["rsp & 0xf == 0", "writable: rsp+0x28", "[r8] == NULL || r8 is a valid argv", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0", "rcx == NULL || (u16)[rcx] == NULL"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 539189,
                      constraints: ["rsp & 0xf == 0", "writable: rsp+0x28", "[r8] == NULL || r8 is a valid argv", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0", "rcx == NULL || (u16)[rcx] == NULL"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 926158,
                      constraints: ["[r15] == NULL || r15 == NULL || r15 is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r15, r13)")
OneGadget::Gadget.add(build_id, 926161,
                      constraints: ["[r15] == NULL || r15 == NULL || r15 is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", r15, rdx)")
OneGadget::Gadget.add(build_id, 926164,
                      constraints: ["[rsi] == NULL || rsi == NULL || rsi is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, rdx)")
OneGadget::Gadget.add(build_id, 926591,
                      constraints: ["[rcx] == NULL || rcx == NULL || rcx is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rcx, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 926595,
                      constraints: ["[rcx] == NULL || rcx == NULL || rcx is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rcx, rdx)")
OneGadget::Gadget.add(build_id, 926667,
                      constraints: ["writable: rbp-0x48", "rbx == NULL || {\"/bin/sh\", rbx, NULL} is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r13)")
OneGadget::Gadget.add(build_id, 926677,
                      constraints: ["writable: rbp-0x48", "rax == NULL || {rax, rbx, NULL} is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r13)")
OneGadget::Gadget.add(build_id, 926681,
                      constraints: ["writable: rbp-0x50", "rax == NULL || {rax, [rbp-0x48], NULL} is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r13)")
OneGadget::Gadget.add(build_id, 1076984,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)")
OneGadget::Gadget.add(build_id, 1076996,
                      constraints: ["[rsi] == NULL || rsi == NULL || rsi is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, [rax])")

