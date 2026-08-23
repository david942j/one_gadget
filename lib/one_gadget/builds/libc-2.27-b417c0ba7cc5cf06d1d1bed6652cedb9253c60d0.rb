require 'one_gadget/gadget'
# spec/data/libc-2.27-b417c0ba7cc5cf06d1d1bed6652cedb9253c60d0.so
# 
# Advanced Micro Devices X86-64
# 
# GNU C Library (Ubuntu GLIBC 2.27-3ubuntu1) stable release version 2.27.
# Copyright (C) 2018 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 7.3.0.
# libc ABIs: UNIQUE IFUNC
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 323628,
                      constraints: ["(u64)rax <= 0xfffffffffffff000", "eax == 0x0", "rbp == NULL", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", r12, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 323640,
                      constraints: ["eax == 0x0", "rbp == NULL", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", r12, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324279,
                      constraints: ["rbp == NULL", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", r12, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324286,
                      constraints: ["rbp == NULL", "rsp & 0xf == 0x0", "rcx == NULL || {rcx, \"-c\", r12, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324293,
                      constraints: ["rbp == NULL", "rsp & 0xf == 0x0", "rcx == NULL || {rcx, rax, r12, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324300,
                      constraints: ["rbp == NULL", "rsi == NULL", "rsp & 0xf == 0x0", "rcx == NULL || {rcx, rax, r12, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324302,
                      constraints: ["rbp == NULL", "rdx == NULL", "rsi == NULL", "rsp & 0xf == 0x0", "rcx == NULL || {rcx, rax, r12, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324307,
                      constraints: ["rbp == NULL", "rdx == NULL", "rsi == NULL", "rsp & 0xf == 0x0", "rcx == NULL || {rcx, rax, r12, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324312,
                      constraints: ["rbp == NULL", "rdx == NULL", "rsi == NULL", "rsp & 0xf == 0x0", "rcx == NULL || {rcx, rax, [rsp+0x50], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324317,
                      constraints: ["rbp == NULL", "rdx == NULL", "rsi == NULL", "rsp & 0xf == 0x0", "[rsp+0x8] == NULL || {[rsp+0x8], rax, [rsp+0x50], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324326,
                      constraints: ["rbp == NULL", "rdx == NULL", "rsi == NULL", "rsp & 0xf == 0x0", "[rsp+0x8] == NULL || {[rsp+0x8], rax, [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324332,
                      constraints: ["rbp == NULL", "rdx == NULL", "rsi == NULL", "rsp & 0xf == 0x0", "(u64)xmm0 == NULL || {(u64)xmm0, rax, [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324337,
                      constraints: ["rbp == NULL", "rdx == NULL", "rsi == NULL", "rsp & 0xf == 0x0", "(u64)xmm0 == NULL || {(u64)xmm0, [rsp+0x8], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324342,
                      constraints: ["rbp == NULL", "rdx == NULL", "rsi == NULL", "rsp & 0xf == 0x0", "(u64)xmm0 == NULL || {(u64)xmm0, (u64)(xmm0 >> 64), [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324347,
                      constraints: ["rbp == NULL", "rdx == NULL", "rsi == NULL", "[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324352,
                      constraints: ["rbp == NULL", "[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324359,
                      constraints: ["rbp == NULL", "rsi == NULL", "[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324361,
                      constraints: ["rbp == NULL", "rdx == NULL", "rsi == NULL", "[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324366,
                      constraints: ["rbp == NULL", "rdx == NULL", "rsi == NULL", "[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324371,
                      constraints: ["rbp == NULL", "[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324373,
                      constraints: ["rbp == NULL", "[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324376,
                      constraints: ["rsi == NULL", "[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324381,
                      constraints: ["rsi == NULL", "[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324386,
                      constraints: ["[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324393,
                      constraints: ["readable: rax", "[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, [rax])")
OneGadget::Gadget.add(build_id, 939547,
                      constraints: ["[rbx] == 0x0", "writable: rbp-0x50", "r15 == NULL || {\"/bin/sh\", r15, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 939552,
                      constraints: ["[rbx] == 0x0", "writable: rbp-0x50", "r15 == NULL || {\"/bin/sh\", r15, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 939554,
                      constraints: ["[rbx] == 0x0", "writable: rbp-0x50", "r15 == NULL || {\"/bin/sh\", r15, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 939560,
                      constraints: ["writable: rbp-0x50", "r15 == NULL || {\"/bin/sh\", r15, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 939679,
                      constraints: ["[r14] == NULL || r14 == NULL || r14 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r14, r12)")
OneGadget::Gadget.add(build_id, 939705,
                      constraints: ["writable: rbp-0x50", "r15 == NULL || {\"/bin/sh\", r15, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 939712,
                      constraints: ["writable: rbp-0x50", "rax == NULL || {rax, r15, NULL} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r12)")
OneGadget::Gadget.add(build_id, 939716,
                      constraints: ["writable: r14+0x10", "writable: rbp-0x50", "[r14] == NULL || r14 == NULL || r14 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r14, r12)")
OneGadget::Gadget.add(build_id, 939719,
                      constraints: ["writable: r14+0x10", "writable: rbp-0x50", "[r14] == NULL || r14 == NULL || r14 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r14, r12)")
OneGadget::Gadget.add(build_id, 939723,
                      constraints: ["writable: r14+0x10", "writable: rbp-0x50", "[r14] == NULL || r14 == NULL || r14 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r14, r12)")
OneGadget::Gadget.add(build_id, 939727,
                      constraints: ["writable: r14+0x10", "[r14] == NULL || r14 == NULL || r14 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r14, r12)")
OneGadget::Gadget.add(build_id, 939728,
                      constraints: ["writable: r14+0x10", "[r14] == NULL || r14 == NULL || r14 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r14, r12)")
OneGadget::Gadget.add(build_id, 939736,
                      constraints: ["[r14] == NULL || r14 == NULL || r14 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r14, r12)")
OneGadget::Gadget.add(build_id, 939839,
                      constraints: ["[rbx] == 0x0", "eax == 0x8", "writable: [rbp-0x78]+0x10", "writable: rbp-0x80", "[[rbp-0x78]] == NULL || [rbp-0x78] == NULL || [rbp-0x78] is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x78], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 939986,
                      constraints: ["[rbx] == 0x0", "writable: [rbp-0x78]+0x10", "writable: rbp-0x80", "[[rbp-0x78]] == NULL || [rbp-0x78] == NULL || [rbp-0x78] is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x78], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 939988,
                      constraints: ["[rbx] == 0x0", "writable: [rbp-0x78]+0x10", "writable: rbp-0x80", "[[rbp-0x78]] == NULL || [rbp-0x78] == NULL || [rbp-0x78] is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x78], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 939994,
                      constraints: ["writable: [rbp-0x78]+0x10", "writable: rbp-0x80", "[[rbp-0x78]] == NULL || [rbp-0x78] == NULL || [rbp-0x78] is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x78], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 940120,
                      constraints: ["readable: rbp-0x88", "[[rbp-0x88]] == NULL || [rbp-0x88] == NULL || [rbp-0x88] is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x88], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 940127,
                      constraints: ["readable: rbp-0x70", "[r10] == NULL || r10 == NULL || r10 is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", r10, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 940131,
                      constraints: ["[r10] == NULL || r10 == NULL || r10 is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", r10, rdx)")
OneGadget::Gadget.add(build_id, 940160,
                      constraints: ["writable: [rbp-0x78]+0x10", "writable: rbp-0x80", "[[rbp-0x78]] == NULL || [rbp-0x78] == NULL || [rbp-0x78] is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x78], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 940167,
                      constraints: ["writable: [rbp-0x78]+0x10", "writable: rbp-0x80", "[[rbp-0x78]] == NULL || [rbp-0x78] == NULL || [rbp-0x78] is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x78], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 940171,
                      constraints: ["writable: r10+0x10", "writable: rbp-0x80", "[r10] == NULL || r10 == NULL || r10 is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", r10, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 940175,
                      constraints: ["writable: r10+0x10", "writable: rbp-0x50", "[r10] == NULL || r10 == NULL || r10 is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", r10, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 940179,
                      constraints: ["writable: r10+0x10", "writable: rbp-0x48", "[r10] == NULL || r10 == NULL || r10 is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", r10, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 940183,
                      constraints: ["writable: r10+0x10", "writable: rbp-0x48", "[r10] == NULL || r10 == NULL || r10 is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", r10, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 940187,
                      constraints: ["readable: rbp-0x70", "writable: r10+0x10", "[r10] == NULL || r10 == NULL || r10 is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", r10, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 940195,
                      constraints: ["readable: rbp-0x70", "[r10] == NULL || r10 == NULL || r10 is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", r10, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 1090110,
                      constraints: ["[rsp+0x48] != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x6c]", "[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1090114,
                      constraints: ["[rsp+0x48] != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["rdi", "[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1090119,
                      constraints: ["[rsp+0x48] != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1090123,
                      constraints: ["ecx != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1090213,
                      constraints: ["([rsp+0xa8] & 0xf000) == 0x2000", "[rsp+0xb8] == 0x103", "eax == 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1090217,
                      constraints: ["([rsp+0xa8] & 0xf000) == 0x2000", "[rsp+0xb8] == 0x103", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1090224,
                      constraints: ["(eax & 0xf000) == 0x2000", "[rsp+0xb8] == 0x103", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1090229,
                      constraints: ["[rsp+0xb8] == 0x103", "eax == 0x2000", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1090236,
                      constraints: ["[rsp+0xb8] == 0x103", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1090423,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1090435,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1090439,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["rdi"])
OneGadget::Gadget.add(build_id, 1090444,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)")
OneGadget::Gadget.add(build_id, 1090451,
                      constraints: ["readable: rax", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, [rax])")
OneGadget::Gadget.add(build_id, 1090456,
                      constraints: ["readable: rax", "[rsi] == NULL || rsi == NULL || rsi is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, [rax])")
OneGadget::Gadget.add(build_id, 1090500,
                      constraints: ["[rsp+0x48] != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])

