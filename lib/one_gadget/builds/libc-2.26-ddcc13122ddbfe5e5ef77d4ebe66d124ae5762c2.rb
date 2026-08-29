require 'one_gadget/gadget'
# spec/data/libc-2.26-ddcc13122ddbfe5e5ef77d4ebe66d124ae5762c2.so
# 
# Advanced Micro Devices X86-64 processor
# 
# GNU C Library (Ubuntu GLIBC 2.26-0ubuntu2.1) stable release version 2.26, by Roland McGrath et al.
# Copyright (C) 2017 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 6.4.0 20171010.
# Available extensions:
# 	crypt add-on version 2.1 by Michael Glad and others
# 	GNU Libidn by Simon Josefsson
# 	Native POSIX Threads Library by Ulrich Drepper et al
# 	BIND-8.2.3-T5B
# libc ABIs: UNIQUE IFUNC
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 293259,
                      constraints: ["(u64)rax <= 0xfffffffffffff000", "eax == 0x0", "r12 == NULL", "{\"sh\", \"-c\", rbx, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 293271,
                      constraints: ["eax == 0x0", "r12 == NULL", "{\"sh\", \"-c\", rbx, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 293951,
                      constraints: ["r12 == NULL", "{\"sh\", \"-c\", rbx, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 293958,
                      constraints: ["r12 == NULL", "rax == NULL || {rax, \"-c\", rbx, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 293965,
                      constraints: ["r12 == NULL", "rsi == NULL", "rax == NULL || {rax, \"-c\", rbx, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 293967,
                      constraints: ["r12 == NULL", "rdx == NULL", "rsi == NULL", "rax == NULL || {rax, \"-c\", rbx, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 293972,
                      constraints: ["r12 == NULL", "rdx == NULL", "rsi == NULL", "rax == NULL || {rax, \"-c\", rbx, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 293977,
                      constraints: ["r12 == NULL", "rdx == NULL", "rsi == NULL", "rax == NULL || {rax, \"-c\", [rsp+0x40], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 293986,
                      constraints: ["r12 == NULL", "rdx == NULL", "rsi == NULL", "rax == NULL || {rax, \"-c\", [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 293991,
                      constraints: ["r12 == NULL", "rdx == NULL", "rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], \"-c\", [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 293998,
                      constraints: ["r12 == NULL", "rdx == NULL", "rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], rax, [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 294003,
                      constraints: ["r12 == NULL", "rdx == NULL", "rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 294008,
                      constraints: ["r12 == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 294015,
                      constraints: ["r12 == NULL", "rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 294017,
                      constraints: ["r12 == NULL", "rdx == NULL", "rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 294022,
                      constraints: ["r12 == NULL", "rdx == NULL", "rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 294027,
                      constraints: ["r12 == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 294029,
                      constraints: ["r12 == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 294032,
                      constraints: ["rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 294037,
                      constraints: ["rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 294042,
                      constraints: ["[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 294049,
                      constraints: ["readable: rax", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, [rax])")
OneGadget::Gadget.add(build_id, 890584,
                      constraints: ["[r15] == 0x0", "writable: rbp-0x50", "r14 == NULL || {\"/bin/sh\", r14, NULL} is a valid argv", "[rbx] == NULL || rbx == NULL || rbx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, rbx)")
OneGadget::Gadget.add(build_id, 890592,
                      constraints: ["[r15] == 0x0", "writable: rbp-0x50", "r14 == NULL || {\"/bin/sh\", r14, NULL} is a valid argv", "[rbx] == NULL || rbx == NULL || rbx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, rbx)")
OneGadget::Gadget.add(build_id, 890594,
                      constraints: ["[r15] == 0x0", "writable: rbp-0x50", "r14 == NULL || {\"/bin/sh\", r14, NULL} is a valid argv", "[rbx] == NULL || rbx == NULL || rbx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, rbx)")
OneGadget::Gadget.add(build_id, 890600,
                      constraints: ["writable: rbp-0x50", "r14 == NULL || {\"/bin/sh\", r14, NULL} is a valid argv", "[rbx] == NULL || rbx == NULL || rbx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, rbx)")
OneGadget::Gadget.add(build_id, 890642,
                      constraints: ["rax == 0x1", "writable: rbp-0x50", "r14 == NULL || {\"/bin/sh\", r14, NULL} is a valid argv", "[rbx] == NULL || rbx == NULL || rbx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, rbx)")
OneGadget::Gadget.add(build_id, 890723,
                      constraints: ["[r13] == NULL || r13 == NULL || r13 is a valid argv", "[rbx] == NULL || rbx == NULL || rbx is a valid envp"],
                      effect: "execve(\"/bin/sh\", r13, rbx)")
OneGadget::Gadget.add(build_id, 891005,
                      constraints: ["writable: rbp-0x50", "r14 == NULL || {\"/bin/sh\", r14, NULL} is a valid argv", "[rbx] == NULL || rbx == NULL || rbx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, rbx)")
OneGadget::Gadget.add(build_id, 891008,
                      constraints: ["writable: rbp-0x50", "r14 == NULL || {\"/bin/sh\", r14, NULL} is a valid argv", "[rbx] == NULL || rbx == NULL || rbx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, rbx)")
OneGadget::Gadget.add(build_id, 891015,
                      constraints: ["writable: rbp-0x50", "rax == NULL || {rax, r14, NULL} is a valid argv", "[rbx] == NULL || rbx == NULL || rbx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, rbx)")
OneGadget::Gadget.add(build_id, 891018,
                      constraints: ["writable: rbp-0x50", "rax == NULL || {rax, r14, NULL} is a valid argv", "[rbx] == NULL || rbx == NULL || rbx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, rbx)")
OneGadget::Gadget.add(build_id, 891022,
                      constraints: ["writable: rbp-0x50", "rax == NULL || {rax, [rbp-0x48], NULL} is a valid argv", "[rbx] == NULL || rbx == NULL || rbx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, rbx)")
OneGadget::Gadget.add(build_id, 891030,
                      constraints: ["writable: rbp-0x50", "rax == NULL || {rax, [rbp-0x48], [rbp-0x40], [rbp-0x38], ...} is a valid argv", "[rbx] == NULL || rbx == NULL || rbx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, rbx)")
OneGadget::Gadget.add(build_id, 891034,
                      constraints: ["writable: rbp-0x50", "[r13] == NULL || r13 == NULL || r13 is a valid argv", "[rbx] == NULL || rbx == NULL || rbx is a valid envp"],
                      effect: "execve(\"/bin/sh\", r13, rbx)")
OneGadget::Gadget.add(build_id, 891038,
                      constraints: ["[r13] == NULL || r13 == NULL || r13 is a valid argv", "[rbx] == NULL || rbx == NULL || rbx is a valid envp"],
                      effect: "execve(\"/bin/sh\", r13, rbx)")
OneGadget::Gadget.add(build_id, 891143,
                      constraints: ["[r15] == 0x0", "eax == 0x8", "writable: rbp-0x98", "[[rbp-0x90]] == NULL || [rbp-0x90] == NULL || [rbp-0x90] is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x90], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 891290,
                      constraints: ["[r15] == 0x0", "writable: rbp-0x98", "[[rbp-0x90]] == NULL || [rbp-0x90] == NULL || [rbp-0x90] is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x90], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 891292,
                      constraints: ["[r15] == 0x0", "writable: rbp-0x98", "[[rbp-0x90]] == NULL || [rbp-0x90] == NULL || [rbp-0x90] is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x90], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 891298,
                      constraints: ["writable: rbp-0x98", "[[rbp-0x90]] == NULL || [rbp-0x90] == NULL || [rbp-0x90] is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x90], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 891342,
                      constraints: ["rax == 0x1", "writable: rbp-0x98", "[[rbp-0x90]] == NULL || [rbp-0x90] == NULL || [rbp-0x90] is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x90], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 891441,
                      constraints: ["readable: rbp-0xa0", "[[rbp-0xa0]] == NULL || [rbp-0xa0] == NULL || [rbp-0xa0] is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0xa0], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 891448,
                      constraints: ["readable: rbp-0x70", "[rcx] == NULL || rcx == NULL || rcx is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rcx, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 891452,
                      constraints: ["[rcx] == NULL || rcx == NULL || rcx is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rcx, rdx)")
OneGadget::Gadget.add(build_id, 891484,
                      constraints: ["writable: rbp-0x98", "[[rbp-0x90]] == NULL || [rbp-0x90] == NULL || [rbp-0x90] is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x90], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 891491,
                      constraints: ["writable: rbp-0x98", "[[rbp-0x90]] == NULL || [rbp-0x90] == NULL || [rbp-0x90] is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x90], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 891498,
                      constraints: ["writable: rbp-0x50", "[[rbp-0x90]] == NULL || [rbp-0x90] == NULL || [rbp-0x90] is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x90], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 891506,
                      constraints: ["writable: rbp-0x50", "[[rbp-0x90]] == NULL || [rbp-0x90] == NULL || [rbp-0x90] is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x90], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 891513,
                      constraints: ["writable: rbp-0x50", "[rcx] == NULL || rcx == NULL || rcx is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rcx, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 891517,
                      constraints: ["writable: rbp-0x48", "[rcx] == NULL || rcx == NULL || rcx is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rcx, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 891521,
                      constraints: ["writable: rbp-0x48", "[rcx] == NULL || rcx == NULL || rcx is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rcx, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 891525,
                      constraints: ["readable: rbp-0x70", "[rcx] == NULL || rcx == NULL || rcx is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rcx, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 1035233,
                      constraints: ["[rsp+0x28] != 0x0", "[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)",
                      closed_fds: ["[rsp+0x3c]", "[rsp+0x38]"])
OneGadget::Gadget.add(build_id, 1035237,
                      constraints: ["[rsp+0x28] != 0x0", "[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)",
                      closed_fds: ["rdi", "[rsp+0x38]"])
OneGadget::Gadget.add(build_id, 1035242,
                      constraints: ["[rsp+0x28] != 0x0", "[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)",
                      closed_fds: ["[rsp+0x38]"])
OneGadget::Gadget.add(build_id, 1035246,
                      constraints: ["ecx != 0x0", "[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)",
                      closed_fds: ["[rsp+0x38]"])
OneGadget::Gadget.add(build_id, 1035318,
                      constraints: ["([rsp+0x78] & 0xf000) == 0x2000", "[rsp+0x88] == 0x103", "eax == 0x0", "[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)",
                      closed_fds: ["[rsp+0x38]"])
OneGadget::Gadget.add(build_id, 1035322,
                      constraints: ["([rsp+0x78] & 0xf000) == 0x2000", "[rsp+0x88] == 0x103", "[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)",
                      closed_fds: ["[rsp+0x38]"])
OneGadget::Gadget.add(build_id, 1035326,
                      constraints: ["(eax & 0xf000) == 0x2000", "[rsp+0x88] == 0x103", "[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)",
                      closed_fds: ["[rsp+0x38]"])
OneGadget::Gadget.add(build_id, 1035331,
                      constraints: ["[rsp+0x88] == 0x103", "eax == 0x2000", "[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)",
                      closed_fds: ["[rsp+0x38]"])
OneGadget::Gadget.add(build_id, 1035338,
                      constraints: ["[rsp+0x88] == 0x103", "[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)",
                      closed_fds: ["[rsp+0x38]"])
OneGadget::Gadget.add(build_id, 1035460,
                      constraints: ["[rsp+0x28] != 0x0", "[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)",
                      closed_fds: ["[rsp+0x38]"])
OneGadget::Gadget.add(build_id, 1035465,
                      constraints: ["[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)",
                      closed_fds: ["[rsp+0x38]"])
OneGadget::Gadget.add(build_id, 1035477,
                      constraints: ["[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)",
                      closed_fds: ["[rsp+0x38]"])
OneGadget::Gadget.add(build_id, 1035481,
                      constraints: ["[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)",
                      closed_fds: ["rdi"])
OneGadget::Gadget.add(build_id, 1035486,
                      constraints: ["[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 1035493,
                      constraints: ["readable: rax", "[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, [rax])")
OneGadget::Gadget.add(build_id, 1035498,
                      constraints: ["readable: rax", "[rsi] == NULL || rsi == NULL || rsi is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, [rax])")
OneGadget::Gadget.add(build_id, 1039021,
                      constraints: ["[rsp+0x34] != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x6c]", "[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1039025,
                      constraints: ["[rsp+0x34] != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["rdi", "[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1039030,
                      constraints: ["[rsp+0x34] != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1039034,
                      constraints: ["ecx != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1039124,
                      constraints: ["([rsp+0xa8] & 0xf000) == 0x2000", "[rsp+0xb8] == 0x103", "eax == 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1039128,
                      constraints: ["([rsp+0xa8] & 0xf000) == 0x2000", "[rsp+0xb8] == 0x103", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1039135,
                      constraints: ["(eax & 0xf000) == 0x2000", "[rsp+0xb8] == 0x103", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1039140,
                      constraints: ["[rsp+0xb8] == 0x103", "eax == 0x2000", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1039147,
                      constraints: ["[rsp+0xb8] == 0x103", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1039225,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1039237,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])
OneGadget::Gadget.add(build_id, 1039241,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["rdi"])
OneGadget::Gadget.add(build_id, 1039246,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)")
OneGadget::Gadget.add(build_id, 1039253,
                      constraints: ["readable: rax", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, [rax])")
OneGadget::Gadget.add(build_id, 1039258,
                      constraints: ["readable: rax", "[rsi] == NULL || rsi == NULL || rsi is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, [rax])")
OneGadget::Gadget.add(build_id, 1039351,
                      constraints: ["[rsp+0x34] != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x68]"])

