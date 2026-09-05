require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc6_2.27-3ubuntu1.5_amd64/lib/x86_64-linux-gnu/libc-2.27.so
# 
# Advanced Micro Devices X86-64 processor
# 
# GNU C Library (Ubuntu GLIBC 2.27-3ubuntu1.5) stable release version 2.27.
# Copyright (C) 2018 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 7.5.0.
# libc ABIs: UNIQUE IFUNC
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 323596,
                      constraints: ["(u64)rax <= 0xfffffffffffff000", "eax == 0x0", "rbp == NULL", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", r12, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 323608,
                      constraints: ["eax == 0x0", "rbp == NULL", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", r12, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324247,
                      constraints: ["rbp == NULL", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", r12, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324254,
                      constraints: ["rbp == NULL", "rsp & 0xf == 0x0", "rcx == NULL || {rcx, \"-c\", r12, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324261,
                      constraints: ["rbp == NULL", "rsp & 0xf == 0x0", "rcx == NULL || {rcx, rax, r12, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324268,
                      constraints: ["rbp == NULL", "rsi == NULL", "rsp & 0xf == 0x0", "rcx == NULL || {rcx, rax, r12, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324270,
                      constraints: ["rbp == NULL", "rdx == NULL", "rsi == NULL", "rsp & 0xf == 0x0", "rcx == NULL || {rcx, rax, r12, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324275,
                      constraints: ["rbp == NULL", "rdx == NULL", "rsi == NULL", "rsp & 0xf == 0x0", "rcx == NULL || {rcx, rax, r12, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324280,
                      constraints: ["rbp == NULL", "rdx == NULL", "rsi == NULL", "rsp & 0xf == 0x0", "rcx == NULL || {rcx, rax, [rsp+0x50], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324285,
                      constraints: ["rbp == NULL", "rdx == NULL", "rsi == NULL", "rsp & 0xf == 0x0", "[rsp+0x8] == NULL || {[rsp+0x8], rax, [rsp+0x50], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324294,
                      constraints: ["rbp == NULL", "rdx == NULL", "rsi == NULL", "rsp & 0xf == 0x0", "[rsp+0x8] == NULL || {[rsp+0x8], rax, [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324300,
                      constraints: ["rbp == NULL", "rdx == NULL", "rsi == NULL", "rsp & 0xf == 0x0", "(u64)xmm0 == NULL || {(u64)xmm0, rax, [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324305,
                      constraints: ["rbp == NULL", "rdx == NULL", "rsi == NULL", "rsp & 0xf == 0x0", "(u64)xmm0 == NULL || {(u64)xmm0, [rsp+0x8], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324310,
                      constraints: ["rbp == NULL", "rdx == NULL", "rsi == NULL", "rsp & 0xf == 0x0", "(u64)xmm0 == NULL || {(u64)xmm0, (u64)(xmm0 >> 64), [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324315,
                      constraints: ["rbp == NULL", "rdx == NULL", "rsi == NULL", "[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324320,
                      constraints: ["rbp == NULL", "[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324327,
                      constraints: ["rbp == NULL", "rsi == NULL", "[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324329,
                      constraints: ["rbp == NULL", "rdx == NULL", "rsi == NULL", "[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324334,
                      constraints: ["rbp == NULL", "rdx == NULL", "rsi == NULL", "[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324339,
                      constraints: ["rbp == NULL", "[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324341,
                      constraints: ["rbp == NULL", "[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324344,
                      constraints: ["rsi == NULL", "[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324349,
                      constraints: ["rsi == NULL", "[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324354,
                      constraints: ["[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324361,
                      constraints: ["readable: rax", "[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, [rax])")
OneGadget::Gadget.add(build_id, 938699,
                      constraints: ["[r15] == 0x0", "writable: rbp-0x50", "r14 == NULL || {\"/bin/sh\", r14, NULL} is a valid argv", "[rbx] == NULL || rbx == NULL || rbx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, rbx)")
OneGadget::Gadget.add(build_id, 938704,
                      constraints: ["[r15] == 0x0", "writable: rbp-0x50", "r14 == NULL || {\"/bin/sh\", r14, NULL} is a valid argv", "[rbx] == NULL || rbx == NULL || rbx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, rbx)")
OneGadget::Gadget.add(build_id, 938706,
                      constraints: ["[r15] == 0x0", "writable: rbp-0x50", "r14 == NULL || {\"/bin/sh\", r14, NULL} is a valid argv", "[rbx] == NULL || rbx == NULL || rbx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, rbx)")
OneGadget::Gadget.add(build_id, 938712,
                      constraints: ["writable: rbp-0x50", "r14 == NULL || {\"/bin/sh\", r14, NULL} is a valid argv", "[rbx] == NULL || rbx == NULL || rbx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, rbx)")
OneGadget::Gadget.add(build_id, 938831,
                      constraints: ["[r13] == NULL || r13 == NULL || r13 is a valid argv", "[rbx] == NULL || rbx == NULL || rbx is a valid envp"],
                      effect: "execve(\"/bin/sh\", r13, rbx)")
OneGadget::Gadget.add(build_id, 938857,
                      constraints: ["writable: rbp-0x50", "r14 == NULL || {\"/bin/sh\", r14, NULL} is a valid argv", "[rbx] == NULL || rbx == NULL || rbx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, rbx)")
OneGadget::Gadget.add(build_id, 938864,
                      constraints: ["writable: rbp-0x50", "rax == NULL || {rax, r14, NULL} is a valid argv", "[rbx] == NULL || rbx == NULL || rbx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, rbx)")
OneGadget::Gadget.add(build_id, 938868,
                      constraints: ["writable: r13+0x10", "writable: rbp-0x50", "[r13] == NULL || r13 == NULL || r13 is a valid argv", "[rbx] == NULL || rbx == NULL || rbx is a valid envp"],
                      effect: "execve(\"/bin/sh\", r13, rbx)")
OneGadget::Gadget.add(build_id, 938871,
                      constraints: ["writable: r13+0x10", "writable: rbp-0x50", "[r13] == NULL || r13 == NULL || r13 is a valid argv", "[rbx] == NULL || rbx == NULL || rbx is a valid envp"],
                      effect: "execve(\"/bin/sh\", r13, rbx)")
OneGadget::Gadget.add(build_id, 938875,
                      constraints: ["writable: r13+0x10", "writable: rbp-0x50", "[r13] == NULL || r13 == NULL || r13 is a valid argv", "[rbx] == NULL || rbx == NULL || rbx is a valid envp"],
                      effect: "execve(\"/bin/sh\", r13, rbx)")
OneGadget::Gadget.add(build_id, 938879,
                      constraints: ["writable: r13+0x10", "[r13] == NULL || r13 == NULL || r13 is a valid argv", "[rbx] == NULL || rbx == NULL || rbx is a valid envp"],
                      effect: "execve(\"/bin/sh\", r13, rbx)")
OneGadget::Gadget.add(build_id, 938880,
                      constraints: ["writable: r13+0x10", "[r13] == NULL || r13 == NULL || r13 is a valid argv", "[rbx] == NULL || rbx == NULL || rbx is a valid envp"],
                      effect: "execve(\"/bin/sh\", r13, rbx)")
OneGadget::Gadget.add(build_id, 938888,
                      constraints: ["[r13] == NULL || r13 == NULL || r13 is a valid argv", "[rbx] == NULL || rbx == NULL || rbx is a valid envp"],
                      effect: "execve(\"/bin/sh\", r13, rbx)")
OneGadget::Gadget.add(build_id, 938987,
                      constraints: ["[r15] == 0x0", "eax == 0x8", "writable: [rbp-0x78]+0x10", "writable: rbp-0x80", "[[rbp-0x78]] == NULL || [rbp-0x78] == NULL || [rbp-0x78] is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x78], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 939114,
                      constraints: ["[r15] == 0x0", "writable: [rbp-0x78]+0x10", "writable: rbp-0x80", "[[rbp-0x78]] == NULL || [rbp-0x78] == NULL || [rbp-0x78] is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x78], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 939116,
                      constraints: ["[r15] == 0x0", "writable: [rbp-0x78]+0x10", "writable: rbp-0x80", "[[rbp-0x78]] == NULL || [rbp-0x78] == NULL || [rbp-0x78] is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x78], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 939122,
                      constraints: ["writable: [rbp-0x78]+0x10", "writable: rbp-0x80", "[[rbp-0x78]] == NULL || [rbp-0x78] == NULL || [rbp-0x78] is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x78], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 939255,
                      constraints: ["readable: rbp-0x88", "[[rbp-0x88]] == NULL || [rbp-0x88] == NULL || [rbp-0x88] is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x88], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 939262,
                      constraints: ["readable: rbp-0x70", "[rcx] == NULL || rcx == NULL || rcx is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rcx, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 939266,
                      constraints: ["[rcx] == NULL || rcx == NULL || rcx is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rcx, rdx)")
OneGadget::Gadget.add(build_id, 939318,
                      constraints: ["writable: [rbp-0x78]+0x10", "writable: rbp-0x80", "[[rbp-0x78]] == NULL || [rbp-0x78] == NULL || [rbp-0x78] is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x78], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 939325,
                      constraints: ["writable: [rbp-0x78]+0x10", "writable: rbp-0x80", "[[rbp-0x78]] == NULL || [rbp-0x78] == NULL || [rbp-0x78] is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x78], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 939329,
                      constraints: ["writable: rbp-0x80", "writable: rcx+0x10", "[rcx] == NULL || rcx == NULL || rcx is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rcx, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 939333,
                      constraints: ["writable: rbp-0x50", "writable: rcx+0x10", "[rcx] == NULL || rcx == NULL || rcx is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rcx, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 939337,
                      constraints: ["writable: rbp-0x48", "writable: rcx+0x10", "[rcx] == NULL || rcx == NULL || rcx is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rcx, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 939341,
                      constraints: ["writable: rbp-0x48", "writable: rcx+0x10", "[rcx] == NULL || rcx == NULL || rcx is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rcx, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 939345,
                      constraints: ["readable: rbp-0x70", "writable: rcx+0x10", "[rcx] == NULL || rcx == NULL || rcx is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rcx, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 939353,
                      constraints: ["readable: rbp-0x70", "[rcx] == NULL || rcx == NULL || rcx is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rcx, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 1089966,
                      constraints: ["[rsp+0x48] != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x6c]", "[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1089970,
                      constraints: ["[rsp+0x48] != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["rdi", "[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1089975,
                      constraints: ["[rsp+0x48] != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1089979,
                      constraints: ["ecx != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1090069,
                      constraints: ["([rsp+0xa8] & 0xf000) == 0x2000", "[rsp+0xb8] == 0x103", "eax == 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1090073,
                      constraints: ["([rsp+0xa8] & 0xf000) == 0x2000", "[rsp+0xb8] == 0x103", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1090080,
                      constraints: ["(eax & 0xf000) == 0x2000", "[rsp+0xb8] == 0x103", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1090085,
                      constraints: ["[rsp+0xb8] == 0x103", "eax == 0x2000", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1090092,
                      constraints: ["[rsp+0xb8] == 0x103", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1090279,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1090291,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1090295,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["rdi"])
OneGadget::Gadget.add(build_id, 1090300,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)")
OneGadget::Gadget.add(build_id, 1090307,
                      constraints: ["readable: rax", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, [rax])")
OneGadget::Gadget.add(build_id, 1090312,
                      constraints: ["readable: rax", "[rsi] == NULL || rsi == NULL || rsi is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, [rax])")
OneGadget::Gadget.add(build_id, 1090356,
                      constraints: ["[rsp+0x48] != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])

