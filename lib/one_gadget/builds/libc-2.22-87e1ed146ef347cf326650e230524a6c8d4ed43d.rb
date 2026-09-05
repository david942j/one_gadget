require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc6-amd64-2.22-0experimental0/lib64/libc-2.22.so
# 
# Advanced Micro Devices X86-64 processor
# 
# GNU C Library (Debian GLIBC 2.22-0experimental0) stable release version 2.22, by Roland McGrath et al.
# Copyright (C) 2015 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 4.9.3.
# Available extensions:
# 	crypt add-on version 2.1 by Michael Glad and others
# 	GNU Libidn by Simon Josefsson
# 	Native POSIX Threads Library by Ulrich Drepper et al
# 	BIND-8.2.3-T5B
# libc ABIs: UNIQUE IFUNC
# For bug reporting instructions, please see:
# <http://www.debian.org/Bugs/>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 259642,
                      constraints: ["(u64)rax <= 0xfffffffffffff000", "eax == 0x0", "r12 == NULL", "{\"sh\", \"-c\", rbx, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 259654,
                      constraints: ["eax == 0x0", "r12 == NULL", "{\"sh\", \"-c\", rbx, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 260303,
                      constraints: ["r12 == NULL", "{\"sh\", \"-c\", rbx, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 260310,
                      constraints: ["r12 == NULL", "rax == NULL || {rax, \"-c\", rbx, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 260317,
                      constraints: ["r12 == NULL", "rsi == NULL", "rax == NULL || {rax, \"-c\", rbx, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 260319,
                      constraints: ["r12 == NULL", "rdx == NULL", "rsi == NULL", "rax == NULL || {rax, \"-c\", rbx, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 260324,
                      constraints: ["r12 == NULL", "rdx == NULL", "rsi == NULL", "rax == NULL || {rax, \"-c\", rbx, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 260329,
                      constraints: ["r12 == NULL", "rdx == NULL", "rsi == NULL", "rax == NULL || {rax, \"-c\", [rsp+0x40], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 260338,
                      constraints: ["r12 == NULL", "rdx == NULL", "rsi == NULL", "rax == NULL || {rax, \"-c\", [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 260343,
                      constraints: ["r12 == NULL", "rdx == NULL", "rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], \"-c\", [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 260350,
                      constraints: ["r12 == NULL", "rdx == NULL", "rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], rax, [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 260355,
                      constraints: ["r12 == NULL", "rdx == NULL", "rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 260360,
                      constraints: ["r12 == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 260367,
                      constraints: ["r12 == NULL", "rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 260369,
                      constraints: ["r12 == NULL", "rdx == NULL", "rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 260374,
                      constraints: ["r12 == NULL", "rdx == NULL", "rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 260379,
                      constraints: ["r12 == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 260381,
                      constraints: ["r12 == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 260384,
                      constraints: ["rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 260389,
                      constraints: ["rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 260394,
                      constraints: ["[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 260401,
                      constraints: ["readable: rax", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, [rax])")
OneGadget::Gadget.add(build_id, 760005,
                      constraints: ["r15d == 0x1", "writable: (rsp+0xf & 0xfffffffffffffff0)", "r13 == NULL || {\"sh\", r13, [(rsp+0xf & 0xfffffffffffffff0)+0x10], [(rsp+0xf & 0xfffffffffffffff0)+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", (rsp+0xf & 0xfffffffffffffff0), r12)")
OneGadget::Gadget.add(build_id, 760008,
                      constraints: ["r15d == 0x1", "writable: (rsp+0xf & 0xfffffffffffffff0)", "r13 == NULL || {\"sh\", r13, [(rsp+0xf & 0xfffffffffffffff0)+0x10], [(rsp+0xf & 0xfffffffffffffff0)+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", (rsp+0xf & 0xfffffffffffffff0), r12)")
OneGadget::Gadget.add(build_id, 760013,
                      constraints: ["r15d == 0x1", "writable: (rsi & 0xfffffffffffffff0)", "r13 == NULL || {\"sh\", r13, [(rsi & 0xfffffffffffffff0)+0x10], [(rsi & 0xfffffffffffffff0)+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", (rsi & 0xfffffffffffffff0), r12)")
OneGadget::Gadget.add(build_id, 760017,
                      constraints: ["r15d == 0x1", "writable: rsi", "r13 == NULL || {\"sh\", r13, [rsi+0x10], [rsi+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, r12)")
OneGadget::Gadget.add(build_id, 760024,
                      constraints: ["r15d == 0x1", "writable: rsi", "rax == NULL || {rax, r13, [rsi+0x10], [rsi+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, r12)")
OneGadget::Gadget.add(build_id, 760596,
                      constraints: ["ecx == 0x1", "writable: (rsp+0xf & 0xfffffffffffffff0)", "writable: rbp-0x40", "r14 == NULL || {\"sh\", r14, [(rsp+0xf & 0xfffffffffffffff0)+0x10], [(rsp+0xf & 0xfffffffffffffff0)+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", (rsp+0xf & 0xfffffffffffffff0), r12)")
OneGadget::Gadget.add(build_id, 760601,
                      constraints: ["ecx == 0x1", "writable: (rbx & 0xfffffffffffffff0)", "writable: rbp-0x40", "r14 == NULL || {\"sh\", r14, [(rbx & 0xfffffffffffffff0)+0x10], [(rbx & 0xfffffffffffffff0)+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", (rbx & 0xfffffffffffffff0), r12)")
OneGadget::Gadget.add(build_id, 760605,
                      constraints: ["ecx == 0x1", "writable: rbp-0x40", "writable: rbx", "r14 == NULL || {\"sh\", r14, [rbx+0x10], [rbx+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbx, r12)")
OneGadget::Gadget.add(build_id, 760609,
                      constraints: ["ecx == 0x1", "writable: [rbp-0x40]", "r14 == NULL || {\"sh\", r14, [[rbp-0x40]+0x10], [[rbp-0x40]+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x40], r12)")
OneGadget::Gadget.add(build_id, 760613,
                      constraints: ["ecx == 0x1", "readable: rbp-0x40", "writable: rax", "[[rbp-0x40]] == NULL || [rbp-0x40] == NULL || [rbp-0x40] is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x40], r12)")
OneGadget::Gadget.add(build_id, 760620,
                      constraints: ["ecx == 0x1", "readable: rbp-0x40", "writable: rax", "[[rbp-0x40]] == NULL || [rbp-0x40] == NULL || [rbp-0x40] is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x40], r12)")
OneGadget::Gadget.add(build_id, 760723,
                      constraints: ["r15d == 0x1", "writable: rax", "r13 == NULL || {\"sh\", r13, [rax+0x10], [rax+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rax, r12)")
OneGadget::Gadget.add(build_id, 760743,
                      constraints: ["[rsi] == NULL || rsi == NULL || rsi is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, r12)")
OneGadget::Gadget.add(build_id, 760752,
                      constraints: ["[rsi] == NULL || rsi == NULL || rsi is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, r12)")
OneGadget::Gadget.add(build_id, 760951,
                      constraints: ["[rbp-0x64] == 0x1", "writable: rax", "writable: rbp-0x60", "r14 == NULL || {\"sh\", r14, [rax+0x10], [rax+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rax, r12)")
OneGadget::Gadget.add(build_id, 760960,
                      constraints: ["[rbp-0x64] == 0x1", "writable: [rbp-0x40]", "writable: rbp-0x60", "r14 == NULL || {\"sh\", r14, [[rbp-0x40]+0x10], [[rbp-0x40]+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x40], r12)")
OneGadget::Gadget.add(build_id, 760964,
                      constraints: ["[rbp-0x64] == 0x1", "writable: [rbp-0x40]", "r14 == NULL || {\"sh\", r14, [[rbp-0x40]+0x10], [[rbp-0x40]+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x40], r12)")
OneGadget::Gadget.add(build_id, 760967,
                      constraints: ["ecx == 0x1", "writable: [rbp-0x40]", "r14 == NULL || {\"sh\", r14, [[rbp-0x40]+0x10], [[rbp-0x40]+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x40], r12)")
OneGadget::Gadget.add(build_id, 760972,
                      constraints: ["readable: rbp-0x40", "[[rbp-0x40]] == NULL || [rbp-0x40] == NULL || [rbp-0x40] is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x40], r12)")
OneGadget::Gadget.add(build_id, 882602,
                      constraints: ["[rsp+0x1c] != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x64]", "[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 882606,
                      constraints: ["[rsp+0x1c] != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["rdi", "[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 882611,
                      constraints: ["[rsp+0x1c] != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 882615,
                      constraints: ["edx != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 882705,
                      constraints: ["([rsp+0x128] & 0xf000) == 0x2000", "[rsp+0x138] == 0x103", "eax == 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 882709,
                      constraints: ["([rsp+0x128] & 0xf000) == 0x2000", "[rsp+0x138] == 0x103", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 882716,
                      constraints: ["(eax & 0xf000) == 0x2000", "[rsp+0x138] == 0x103", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 882721,
                      constraints: ["[rsp+0x138] == 0x103", "eax == 0x2000", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 882728,
                      constraints: ["[rsp+0x138] == 0x103", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 882904,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 882916,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 882920,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["rdi"])
OneGadget::Gadget.add(build_id, 882925,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)")
OneGadget::Gadget.add(build_id, 882932,
                      constraints: ["readable: rax", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, [rax])")
OneGadget::Gadget.add(build_id, 882937,
                      constraints: ["readable: rax", "[rsi] == NULL || rsi == NULL || rsi is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, [rax])")
OneGadget::Gadget.add(build_id, 883022,
                      constraints: ["[rsp+0x1c] != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 898257,
                      constraints: ["[r9] == NULL || r9 == NULL || r9 is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", r9, rdx)")

