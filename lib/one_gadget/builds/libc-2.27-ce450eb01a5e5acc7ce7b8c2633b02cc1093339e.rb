require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc6_2.27-3ubuntu1.4_amd64/lib/x86_64-linux-gnu/libc-2.27.so
# 
# Advanced Micro Devices X86-64 processor
# 
# GNU C Library (Ubuntu GLIBC 2.27-3ubuntu1.4) stable release version 2.27.
# Copyright (C) 2018 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 7.5.0.
# libc ABIs: UNIQUE IFUNC
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 323900,
                      constraints: ["(u64)rax <= 0xfffffffffffff000", "eax == 0x0", "rbp == NULL", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", r12, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 323912,
                      constraints: ["eax == 0x0", "rbp == NULL", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", r12, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324551,
                      constraints: ["rbp == NULL", "rsp & 0xf == 0x0", "{\"sh\", \"-c\", r12, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324558,
                      constraints: ["rbp == NULL", "rsp & 0xf == 0x0", "rcx == NULL || {rcx, \"-c\", r12, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324565,
                      constraints: ["rbp == NULL", "rsp & 0xf == 0x0", "rcx == NULL || {rcx, rax, r12, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324572,
                      constraints: ["rbp == NULL", "rsi == NULL", "rsp & 0xf == 0x0", "rcx == NULL || {rcx, rax, r12, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324574,
                      constraints: ["rbp == NULL", "rdx == NULL", "rsi == NULL", "rsp & 0xf == 0x0", "rcx == NULL || {rcx, rax, r12, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324579,
                      constraints: ["rbp == NULL", "rdx == NULL", "rsi == NULL", "rsp & 0xf == 0x0", "rcx == NULL || {rcx, rax, r12, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324584,
                      constraints: ["rbp == NULL", "rdx == NULL", "rsi == NULL", "rsp & 0xf == 0x0", "rcx == NULL || {rcx, rax, [rsp+0x50], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324589,
                      constraints: ["rbp == NULL", "rdx == NULL", "rsi == NULL", "rsp & 0xf == 0x0", "[rsp+0x8] == NULL || {[rsp+0x8], rax, [rsp+0x50], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324598,
                      constraints: ["rbp == NULL", "rdx == NULL", "rsi == NULL", "rsp & 0xf == 0x0", "[rsp+0x8] == NULL || {[rsp+0x8], rax, [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324604,
                      constraints: ["rbp == NULL", "rdx == NULL", "rsi == NULL", "rsp & 0xf == 0x0", "(u64)xmm0 == NULL || {(u64)xmm0, rax, [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324609,
                      constraints: ["rbp == NULL", "rdx == NULL", "rsi == NULL", "rsp & 0xf == 0x0", "(u64)xmm0 == NULL || {(u64)xmm0, [rsp+0x8], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324614,
                      constraints: ["rbp == NULL", "rdx == NULL", "rsi == NULL", "rsp & 0xf == 0x0", "(u64)xmm0 == NULL || {(u64)xmm0, (u64)(xmm0 >> 64), [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324619,
                      constraints: ["rbp == NULL", "rdx == NULL", "rsi == NULL", "[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324624,
                      constraints: ["rbp == NULL", "[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324631,
                      constraints: ["rbp == NULL", "rsi == NULL", "[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324633,
                      constraints: ["rbp == NULL", "rdx == NULL", "rsi == NULL", "[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324638,
                      constraints: ["rbp == NULL", "rdx == NULL", "rsi == NULL", "[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324643,
                      constraints: ["rbp == NULL", "[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324645,
                      constraints: ["rbp == NULL", "[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324648,
                      constraints: ["rsi == NULL", "[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324653,
                      constraints: ["rsi == NULL", "[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324658,
                      constraints: ["[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 324665,
                      constraints: ["readable: rax", "[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, [rax])")
OneGadget::Gadget.add(build_id, 938987,
                      constraints: ["[r15] == 0x0", "writable: rbp-0x50", "r14 == NULL || {\"/bin/sh\", r14, NULL} is a valid argv", "[rbx] == NULL || rbx == NULL || rbx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, rbx)")
OneGadget::Gadget.add(build_id, 938992,
                      constraints: ["[r15] == 0x0", "writable: rbp-0x50", "r14 == NULL || {\"/bin/sh\", r14, NULL} is a valid argv", "[rbx] == NULL || rbx == NULL || rbx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, rbx)")
OneGadget::Gadget.add(build_id, 938994,
                      constraints: ["[r15] == 0x0", "writable: rbp-0x50", "r14 == NULL || {\"/bin/sh\", r14, NULL} is a valid argv", "[rbx] == NULL || rbx == NULL || rbx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, rbx)")
OneGadget::Gadget.add(build_id, 939000,
                      constraints: ["writable: rbp-0x50", "r14 == NULL || {\"/bin/sh\", r14, NULL} is a valid argv", "[rbx] == NULL || rbx == NULL || rbx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, rbx)")
OneGadget::Gadget.add(build_id, 939119,
                      constraints: ["[r13] == NULL || r13 == NULL || r13 is a valid argv", "[rbx] == NULL || rbx == NULL || rbx is a valid envp"],
                      effect: "execve(\"/bin/sh\", r13, rbx)")
OneGadget::Gadget.add(build_id, 939145,
                      constraints: ["writable: rbp-0x50", "r14 == NULL || {\"/bin/sh\", r14, NULL} is a valid argv", "[rbx] == NULL || rbx == NULL || rbx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, rbx)")
OneGadget::Gadget.add(build_id, 939152,
                      constraints: ["writable: rbp-0x50", "rax == NULL || {rax, r14, NULL} is a valid argv", "[rbx] == NULL || rbx == NULL || rbx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, rbx)")
OneGadget::Gadget.add(build_id, 939156,
                      constraints: ["writable: r13+0x10", "writable: rbp-0x50", "[r13] == NULL || r13 == NULL || r13 is a valid argv", "[rbx] == NULL || rbx == NULL || rbx is a valid envp"],
                      effect: "execve(\"/bin/sh\", r13, rbx)")
OneGadget::Gadget.add(build_id, 939159,
                      constraints: ["writable: r13+0x10", "writable: rbp-0x50", "[r13] == NULL || r13 == NULL || r13 is a valid argv", "[rbx] == NULL || rbx == NULL || rbx is a valid envp"],
                      effect: "execve(\"/bin/sh\", r13, rbx)")
OneGadget::Gadget.add(build_id, 939163,
                      constraints: ["writable: r13+0x10", "writable: rbp-0x50", "[r13] == NULL || r13 == NULL || r13 is a valid argv", "[rbx] == NULL || rbx == NULL || rbx is a valid envp"],
                      effect: "execve(\"/bin/sh\", r13, rbx)")
OneGadget::Gadget.add(build_id, 939167,
                      constraints: ["writable: r13+0x10", "[r13] == NULL || r13 == NULL || r13 is a valid argv", "[rbx] == NULL || rbx == NULL || rbx is a valid envp"],
                      effect: "execve(\"/bin/sh\", r13, rbx)")
OneGadget::Gadget.add(build_id, 939168,
                      constraints: ["writable: r13+0x10", "[r13] == NULL || r13 == NULL || r13 is a valid argv", "[rbx] == NULL || rbx == NULL || rbx is a valid envp"],
                      effect: "execve(\"/bin/sh\", r13, rbx)")
OneGadget::Gadget.add(build_id, 939176,
                      constraints: ["[r13] == NULL || r13 == NULL || r13 is a valid argv", "[rbx] == NULL || rbx == NULL || rbx is a valid envp"],
                      effect: "execve(\"/bin/sh\", r13, rbx)")
OneGadget::Gadget.add(build_id, 939275,
                      constraints: ["[r15] == 0x0", "eax == 0x8", "writable: [rbp-0x78]+0x10", "writable: rbp-0x80", "[[rbp-0x78]] == NULL || [rbp-0x78] == NULL || [rbp-0x78] is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x78], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 939402,
                      constraints: ["[r15] == 0x0", "writable: [rbp-0x78]+0x10", "writable: rbp-0x80", "[[rbp-0x78]] == NULL || [rbp-0x78] == NULL || [rbp-0x78] is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x78], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 939404,
                      constraints: ["[r15] == 0x0", "writable: [rbp-0x78]+0x10", "writable: rbp-0x80", "[[rbp-0x78]] == NULL || [rbp-0x78] == NULL || [rbp-0x78] is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x78], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 939410,
                      constraints: ["writable: [rbp-0x78]+0x10", "writable: rbp-0x80", "[[rbp-0x78]] == NULL || [rbp-0x78] == NULL || [rbp-0x78] is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x78], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 939543,
                      constraints: ["readable: rbp-0x88", "[[rbp-0x88]] == NULL || [rbp-0x88] == NULL || [rbp-0x88] is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x88], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 939550,
                      constraints: ["readable: rbp-0x70", "[rcx] == NULL || rcx == NULL || rcx is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rcx, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 939554,
                      constraints: ["[rcx] == NULL || rcx == NULL || rcx is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rcx, rdx)")
OneGadget::Gadget.add(build_id, 939606,
                      constraints: ["writable: [rbp-0x78]+0x10", "writable: rbp-0x80", "[[rbp-0x78]] == NULL || [rbp-0x78] == NULL || [rbp-0x78] is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x78], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 939613,
                      constraints: ["writable: [rbp-0x78]+0x10", "writable: rbp-0x80", "[[rbp-0x78]] == NULL || [rbp-0x78] == NULL || [rbp-0x78] is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x78], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 939617,
                      constraints: ["writable: rbp-0x80", "writable: rcx+0x10", "[rcx] == NULL || rcx == NULL || rcx is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rcx, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 939621,
                      constraints: ["writable: rbp-0x50", "writable: rcx+0x10", "[rcx] == NULL || rcx == NULL || rcx is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rcx, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 939625,
                      constraints: ["writable: rbp-0x48", "writable: rcx+0x10", "[rcx] == NULL || rcx == NULL || rcx is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rcx, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 939629,
                      constraints: ["writable: rbp-0x48", "writable: rcx+0x10", "[rcx] == NULL || rcx == NULL || rcx is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rcx, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 939633,
                      constraints: ["readable: rbp-0x70", "writable: rcx+0x10", "[rcx] == NULL || rcx == NULL || rcx is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rcx, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 939641,
                      constraints: ["readable: rbp-0x70", "[rcx] == NULL || rcx == NULL || rcx is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rcx, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 1090254,
                      constraints: ["[rsp+0x48] != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x6c]", "[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1090258,
                      constraints: ["[rsp+0x48] != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["rdi", "[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1090263,
                      constraints: ["[rsp+0x48] != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1090267,
                      constraints: ["ecx != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1090357,
                      constraints: ["([rsp+0xa8] & 0xf000) == 0x2000", "[rsp+0xb8] == 0x103", "eax == 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1090361,
                      constraints: ["([rsp+0xa8] & 0xf000) == 0x2000", "[rsp+0xb8] == 0x103", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1090368,
                      constraints: ["(eax & 0xf000) == 0x2000", "[rsp+0xb8] == 0x103", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1090373,
                      constraints: ["[rsp+0xb8] == 0x103", "eax == 0x2000", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1090380,
                      constraints: ["[rsp+0xb8] == 0x103", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1090567,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1090579,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1090583,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["rdi"])
OneGadget::Gadget.add(build_id, 1090588,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)")
OneGadget::Gadget.add(build_id, 1090595,
                      constraints: ["readable: rax", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, [rax])")
OneGadget::Gadget.add(build_id, 1090600,
                      constraints: ["readable: rax", "[rsi] == NULL || rsi == NULL || rsi is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, [rax])")
OneGadget::Gadget.add(build_id, 1090644,
                      constraints: ["[rsp+0x48] != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])

