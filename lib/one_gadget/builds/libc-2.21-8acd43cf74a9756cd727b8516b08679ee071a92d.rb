require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc6_2.21-0ubuntu4_amd64/lib/x86_64-linux-gnu/libc-2.21.so
# 
# Advanced Micro Devices X86-64 processor
# 
# GNU C Library (Ubuntu GLIBC 2.21-0ubuntu4) stable release version 2.21, by Roland McGrath et al.
# Copyright (C) 2015 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 4.9.2.
# Available extensions:
# 	crypt add-on version 2.1 by Michael Glad and others
# 	GNU Libidn by Simon Josefsson
# 	Native POSIX Threads Library by Ulrich Drepper et al
# 	BIND-8.2.3-T5B
# libc ABIs: UNIQUE IFUNC
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 278458,
                      constraints: ["(u64)rax <= 0xfffffffffffff000", "eax == 0x0", "r12 == NULL", "{\"sh\", \"-c\", rbx, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 278470,
                      constraints: ["eax == 0x0", "r12 == NULL", "{\"sh\", \"-c\", rbx, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 279119,
                      constraints: ["r12 == NULL", "{\"sh\", \"-c\", rbx, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 279126,
                      constraints: ["r12 == NULL", "rax == NULL || {rax, \"-c\", rbx, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 279133,
                      constraints: ["r12 == NULL", "rsi == NULL", "rax == NULL || {rax, \"-c\", rbx, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 279135,
                      constraints: ["r12 == NULL", "rdx == NULL", "rsi == NULL", "rax == NULL || {rax, \"-c\", rbx, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 279140,
                      constraints: ["r12 == NULL", "rdx == NULL", "rsi == NULL", "rax == NULL || {rax, \"-c\", rbx, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 279145,
                      constraints: ["r12 == NULL", "rdx == NULL", "rsi == NULL", "rax == NULL || {rax, \"-c\", [rsp+0x40], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 279154,
                      constraints: ["r12 == NULL", "rdx == NULL", "rsi == NULL", "rax == NULL || {rax, \"-c\", [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 279159,
                      constraints: ["r12 == NULL", "rdx == NULL", "rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], \"-c\", [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 279166,
                      constraints: ["r12 == NULL", "rdx == NULL", "rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], rax, [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 279171,
                      constraints: ["r12 == NULL", "rdx == NULL", "rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 279176,
                      constraints: ["r12 == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 279183,
                      constraints: ["r12 == NULL", "rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 279185,
                      constraints: ["r12 == NULL", "rdx == NULL", "rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 279190,
                      constraints: ["r12 == NULL", "rdx == NULL", "rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 279195,
                      constraints: ["r12 == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 279197,
                      constraints: ["r12 == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 279200,
                      constraints: ["rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 279205,
                      constraints: ["rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 279210,
                      constraints: ["[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 279217,
                      constraints: ["readable: rax", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, [rax])")
OneGadget::Gadget.add(build_id, 833253,
                      constraints: ["r15d == 0x1", "writable: (rsp+0xf & 0xfffffffffffffff0)", "r13 == NULL || {\"sh\", r13, [(rsp+0xf & 0xfffffffffffffff0)+0x10], [(rsp+0xf & 0xfffffffffffffff0)+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", (rsp+0xf & 0xfffffffffffffff0), r12)")
OneGadget::Gadget.add(build_id, 833256,
                      constraints: ["r15d == 0x1", "writable: (rsp+0xf & 0xfffffffffffffff0)", "r13 == NULL || {\"sh\", r13, [(rsp+0xf & 0xfffffffffffffff0)+0x10], [(rsp+0xf & 0xfffffffffffffff0)+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", (rsp+0xf & 0xfffffffffffffff0), r12)")
OneGadget::Gadget.add(build_id, 833261,
                      constraints: ["r15d == 0x1", "writable: (rcx & 0xfffffffffffffff0)", "r13 == NULL || {\"sh\", r13, [(rcx & 0xfffffffffffffff0)+0x10], [(rcx & 0xfffffffffffffff0)+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", (rcx & 0xfffffffffffffff0), r12)")
OneGadget::Gadget.add(build_id, 833265,
                      constraints: ["r15d == 0x1", "writable: rcx", "r13 == NULL || {\"sh\", r13, [rcx+0x10], [rcx+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rcx, r12)")
OneGadget::Gadget.add(build_id, 833272,
                      constraints: ["r15d == 0x1", "writable: rcx", "rax == NULL || {rax, r13, [rcx+0x10], [rcx+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rcx, r12)")
OneGadget::Gadget.add(build_id, 833845,
                      constraints: ["ecx == 0x1", "writable: (rsp+0xf & 0xfffffffffffffff0)", "writable: rbp-0x40", "r14 == NULL || {\"sh\", r14, [(rsp+0xf & 0xfffffffffffffff0)+0x10], [(rsp+0xf & 0xfffffffffffffff0)+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", (rsp+0xf & 0xfffffffffffffff0), r12)")
OneGadget::Gadget.add(build_id, 833850,
                      constraints: ["ecx == 0x1", "writable: (r15 & 0xfffffffffffffff0)", "writable: rbp-0x40", "r14 == NULL || {\"sh\", r14, [(r15 & 0xfffffffffffffff0)+0x10], [(r15 & 0xfffffffffffffff0)+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", (r15 & 0xfffffffffffffff0), r12)")
OneGadget::Gadget.add(build_id, 833854,
                      constraints: ["ecx == 0x1", "writable: r15", "writable: rbp-0x40", "r14 == NULL || {\"sh\", r14, [r15+0x10], [r15+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r15, r12)")
OneGadget::Gadget.add(build_id, 833858,
                      constraints: ["ecx == 0x1", "readable: rbp-0x40", "writable: r15", "[[rbp-0x40]] == NULL || [rbp-0x40] == NULL || [rbp-0x40] is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x40], r12)")
OneGadget::Gadget.add(build_id, 833861,
                      constraints: ["ecx == 0x1", "readable: rbp-0x40", "writable: rax", "[[rbp-0x40]] == NULL || [rbp-0x40] == NULL || [rbp-0x40] is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x40], r12)")
OneGadget::Gadget.add(build_id, 833868,
                      constraints: ["ecx == 0x1", "readable: rbp-0x40", "writable: rax", "[[rbp-0x40]] == NULL || [rbp-0x40] == NULL || [rbp-0x40] is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x40], r12)")
OneGadget::Gadget.add(build_id, 833963,
                      constraints: ["r15d == 0x1", "writable: rax", "r13 == NULL || {\"sh\", r13, [rax+0x10], [rax+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rax, r12)")
OneGadget::Gadget.add(build_id, 833983,
                      constraints: ["[rcx] == NULL || rcx == NULL || rcx is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rcx, r12)")
OneGadget::Gadget.add(build_id, 833984,
                      constraints: ["[rcx] == NULL || rcx == NULL || rcx is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rcx, r12)")
OneGadget::Gadget.add(build_id, 834183,
                      constraints: ["[rbp-0x64] == 0x1", "writable: rax", "writable: rbp-0x60", "r14 == NULL || {\"sh\", r14, [rax+0x10], [rax+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rax, r12)")
OneGadget::Gadget.add(build_id, 834192,
                      constraints: ["[rbp-0x64] == 0x1", "writable: [rbp-0x40]", "writable: rbp-0x60", "r14 == NULL || {\"sh\", r14, [[rbp-0x40]+0x10], [[rbp-0x40]+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x40], r12)")
OneGadget::Gadget.add(build_id, 834196,
                      constraints: ["[rbp-0x64] == 0x1", "writable: [rbp-0x40]", "r14 == NULL || {\"sh\", r14, [[rbp-0x40]+0x10], [[rbp-0x40]+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x40], r12)")
OneGadget::Gadget.add(build_id, 834199,
                      constraints: ["ecx == 0x1", "writable: [rbp-0x40]", "r14 == NULL || {\"sh\", r14, [[rbp-0x40]+0x10], [[rbp-0x40]+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x40], r12)")
OneGadget::Gadget.add(build_id, 834203,
                      constraints: ["ecx == 0x1", "readable: rbp-0x40", "writable: rax", "[[rbp-0x40]] == NULL || [rbp-0x40] == NULL || [rbp-0x40] is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x40], r12)")
OneGadget::Gadget.add(build_id, 834208,
                      constraints: ["readable: rbp-0x40", "[[rbp-0x40]] == NULL || [rbp-0x40] == NULL || [rbp-0x40] is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x40], r12)")
OneGadget::Gadget.add(build_id, 984965,
                      constraints: ["[rsp+0x28] != 0x0", "[rsp+0x50] == NULL || {[rsp+0x50], [rsp+0x58], [rsp+0x60], [rsp+0x68], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x50, environ)",
                      closed_fds: ["[rsp+0x44]", "[rsp+0x40]"])
OneGadget::Gadget.add(build_id, 984969,
                      constraints: ["[rsp+0x28] != 0x0", "[rsp+0x50] == NULL || {[rsp+0x50], [rsp+0x58], [rsp+0x60], [rsp+0x68], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x50, environ)",
                      closed_fds: ["rdi", "[rsp+0x40]"])
OneGadget::Gadget.add(build_id, 984974,
                      constraints: ["[rsp+0x28] != 0x0", "[rsp+0x50] == NULL || {[rsp+0x50], [rsp+0x58], [rsp+0x60], [rsp+0x68], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x50, environ)",
                      closed_fds: ["[rsp+0x40]"])
OneGadget::Gadget.add(build_id, 984978,
                      constraints: ["edx != 0x0", "[rsp+0x50] == NULL || {[rsp+0x50], [rsp+0x58], [rsp+0x60], [rsp+0x68], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x50, environ)",
                      closed_fds: ["[rsp+0x40]"])
OneGadget::Gadget.add(build_id, 985053,
                      constraints: ["([rsp+0x108] & 0xf000) == 0x2000", "[rsp+0x118] == 0x103", "eax == 0x0", "[rsp+0x50] == NULL || {[rsp+0x50], [rsp+0x58], [rsp+0x60], [rsp+0x68], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x50, environ)",
                      closed_fds: ["[rsp+0x40]"])
OneGadget::Gadget.add(build_id, 985057,
                      constraints: ["([rsp+0x108] & 0xf000) == 0x2000", "[rsp+0x118] == 0x103", "[rsp+0x50] == NULL || {[rsp+0x50], [rsp+0x58], [rsp+0x60], [rsp+0x68], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x50, environ)",
                      closed_fds: ["[rsp+0x40]"])
OneGadget::Gadget.add(build_id, 985064,
                      constraints: ["(eax & 0xf000) == 0x2000", "[rsp+0x118] == 0x103", "[rsp+0x50] == NULL || {[rsp+0x50], [rsp+0x58], [rsp+0x60], [rsp+0x68], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x50, environ)",
                      closed_fds: ["[rsp+0x40]"])
OneGadget::Gadget.add(build_id, 985069,
                      constraints: ["[rsp+0x118] == 0x103", "eax == 0x2000", "[rsp+0x50] == NULL || {[rsp+0x50], [rsp+0x58], [rsp+0x60], [rsp+0x68], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x50, environ)",
                      closed_fds: ["[rsp+0x40]"])
OneGadget::Gadget.add(build_id, 985076,
                      constraints: ["[rsp+0x118] == 0x103", "[rsp+0x50] == NULL || {[rsp+0x50], [rsp+0x58], [rsp+0x60], [rsp+0x68], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x50, environ)",
                      closed_fds: ["[rsp+0x40]"])
OneGadget::Gadget.add(build_id, 985131,
                      constraints: ["[rsp+0x50] == NULL || {[rsp+0x50], [rsp+0x58], [rsp+0x60], [rsp+0x68], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x50, environ)",
                      closed_fds: ["[rsp+0x40]"])
OneGadget::Gadget.add(build_id, 985143,
                      constraints: ["[rsp+0x50] == NULL || {[rsp+0x50], [rsp+0x58], [rsp+0x60], [rsp+0x68], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x50, environ)",
                      closed_fds: ["[rsp+0x40]"])
OneGadget::Gadget.add(build_id, 985147,
                      constraints: ["[rsp+0x50] == NULL || {[rsp+0x50], [rsp+0x58], [rsp+0x60], [rsp+0x68], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x50, environ)",
                      closed_fds: ["rdi"])
OneGadget::Gadget.add(build_id, 985152,
                      constraints: ["[rsp+0x50] == NULL || {[rsp+0x50], [rsp+0x58], [rsp+0x60], [rsp+0x68], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 985159,
                      constraints: ["readable: rax", "[rsp+0x50] == NULL || {[rsp+0x50], [rsp+0x58], [rsp+0x60], [rsp+0x68], ...} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsp+0x50, [rax])")
OneGadget::Gadget.add(build_id, 985164,
                      constraints: ["readable: rax", "[rsi] == NULL || rsi == NULL || rsi is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, [rax])")
OneGadget::Gadget.add(build_id, 985280,
                      constraints: ["[rsp+0x28] != 0x0", "[rsp+0x50] == NULL || {[rsp+0x50], [rsp+0x58], [rsp+0x60], [rsp+0x68], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x50, environ)",
                      closed_fds: ["[rsp+0x40]"])
OneGadget::Gadget.add(build_id, 988617,
                      constraints: ["[rsp+0x2c] != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x64]", "[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 988621,
                      constraints: ["[rsp+0x2c] != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["rdi", "[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 988626,
                      constraints: ["[rsp+0x2c] != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 988630,
                      constraints: ["edx != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 988720,
                      constraints: ["([rsp+0x128] & 0xf000) == 0x2000", "[rsp+0x138] == 0x103", "eax == 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 988724,
                      constraints: ["([rsp+0x128] & 0xf000) == 0x2000", "[rsp+0x138] == 0x103", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 988731,
                      constraints: ["(eax & 0xf000) == 0x2000", "[rsp+0x138] == 0x103", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 988736,
                      constraints: ["[rsp+0x138] == 0x103", "eax == 0x2000", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 988743,
                      constraints: ["[rsp+0x138] == 0x103", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 988920,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 988932,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 988936,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["rdi"])
OneGadget::Gadget.add(build_id, 988941,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)")
OneGadget::Gadget.add(build_id, 988948,
                      constraints: ["readable: rax", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, [rax])")
OneGadget::Gadget.add(build_id, 988953,
                      constraints: ["readable: rax", "[rsi] == NULL || rsi == NULL || rsi is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, [rax])")
OneGadget::Gadget.add(build_id, 989042,
                      constraints: ["[rsp+0x2c] != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 1009998,
                      constraints: ["readable: rbp-0xf8", "[r8] == NULL || r8 == NULL || r8 is a valid argv", "[[rbp-0xf8]] == NULL || [rbp-0xf8] == NULL || [rbp-0xf8] is a valid envp"],
                      effect: "execve(\"/bin/sh\", r8, [rbp-0xf8])")
OneGadget::Gadget.add(build_id, 1010000,
                      constraints: ["readable: rbp-0xf8", "[r8] == NULL || r8 == NULL || r8 is a valid argv", "[[rbp-0xf8]] == NULL || [rbp-0xf8] == NULL || [rbp-0xf8] is a valid envp"],
                      effect: "execve(\"/bin/sh\", r8, [rbp-0xf8])")

