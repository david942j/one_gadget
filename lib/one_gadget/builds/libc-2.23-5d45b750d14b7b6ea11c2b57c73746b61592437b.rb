require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc0.1-2.23-0experimental4/lib/x86_64-kfreebsd-gnu/libc-2.23.so
# 
# Advanced Micro Devices X86-64 processor
# 
# GNU C Library (Debian GLIBC 2.23-0experimental4) stable release version 2.23, by Roland McGrath et al.
# Copyright (C) 2016 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 5.4.0 20160609.
# Available extensions:
# 	crypt add-on version 2.1 by Michael Glad and others
# 	Native POSIX Threads Library by Ulrich Drepper et al
# 	GNU Libidn by Simon Josefsson
# 	BIND-8.2.3-T5B
# libc ABIs: UNIQUE
# For bug reporting instructions, please see:
# <http://www.debian.org/Bugs/>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 253914,
                      constraints: ["eax == 0x0", "{\"sh\", \"-c\", r12, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 253917,
                      constraints: ["ebx == 0x0", "{\"sh\", \"-c\", r12, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 254530,
                      constraints: ["{\"sh\", \"-c\", r12, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 254537,
                      constraints: ["rax == NULL || {rax, \"-c\", r12, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 254544,
                      constraints: ["rsi == NULL", "rax == NULL || {rax, \"-c\", r12, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 254546,
                      constraints: ["rdx == NULL", "rsi == NULL", "rax == NULL || {rax, \"-c\", r12, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 254551,
                      constraints: ["rdx == NULL", "rsi == NULL", "rax == NULL || {rax, \"-c\", r12, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 254556,
                      constraints: ["rdx == NULL", "rsi == NULL", "rax == NULL || {rax, \"-c\", [rsp+0x40], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 254565,
                      constraints: ["rdx == NULL", "rsi == NULL", "rax == NULL || {rax, \"-c\", [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 254570,
                      constraints: ["rdx == NULL", "rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], \"-c\", [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 254577,
                      constraints: ["rdx == NULL", "rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], rax, [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 254582,
                      constraints: ["rdx == NULL", "rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 254587,
                      constraints: ["[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 254594,
                      constraints: ["rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 254596,
                      constraints: ["rdx == NULL", "rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 254601,
                      constraints: ["rdx == NULL", "rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 254606,
                      constraints: ["[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 254608,
                      constraints: ["[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 254611,
                      constraints: ["rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 254616,
                      constraints: ["rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 254621,
                      constraints: ["[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 254628,
                      constraints: ["readable: rax", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, [rax])")
OneGadget::Gadget.add(build_id, 694709,
                      constraints: ["r13d == 0x1", "writable: (rsp+0xf & 0xfffffffffffffff0)", "r14 == NULL || {\"sh\", r14, [(rsp+0xf & 0xfffffffffffffff0)+0x10], [(rsp+0xf & 0xfffffffffffffff0)+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", (rsp+0xf & 0xfffffffffffffff0), r12)")
OneGadget::Gadget.add(build_id, 694712,
                      constraints: ["r13d == 0x1", "writable: (rsp+0xf & 0xfffffffffffffff0)", "r14 == NULL || {\"sh\", r14, [(rsp+0xf & 0xfffffffffffffff0)+0x10], [(rsp+0xf & 0xfffffffffffffff0)+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", (rsp+0xf & 0xfffffffffffffff0), r12)")
OneGadget::Gadget.add(build_id, 694717,
                      constraints: ["r13d == 0x1", "writable: (rsi & 0xfffffffffffffff0)", "r14 == NULL || {\"sh\", r14, [(rsi & 0xfffffffffffffff0)+0x10], [(rsi & 0xfffffffffffffff0)+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", (rsi & 0xfffffffffffffff0), r12)")
OneGadget::Gadget.add(build_id, 694721,
                      constraints: ["r13d == 0x1", "writable: rsi", "r14 == NULL || {\"sh\", r14, [rsi+0x10], [rsi+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, r12)")
OneGadget::Gadget.add(build_id, 694728,
                      constraints: ["r13d == 0x1", "writable: rsi", "rax == NULL || {rax, r14, [rsi+0x10], [rsi+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, r12)")
OneGadget::Gadget.add(build_id, 695292,
                      constraints: ["r13d == 0x1", "writable: (rsp+0xf & 0xfffffffffffffff0)", "writable: rbp-0x40", "r15 == NULL || {\"sh\", r15, [(rsp+0xf & 0xfffffffffffffff0)+0x10], [(rsp+0xf & 0xfffffffffffffff0)+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", (rsp+0xf & 0xfffffffffffffff0), r12)")
OneGadget::Gadget.add(build_id, 695297,
                      constraints: ["r13d == 0x1", "writable: (rax & 0xfffffffffffffff0)", "writable: rbp-0x40", "r15 == NULL || {\"sh\", r15, [(rax & 0xfffffffffffffff0)+0x10], [(rax & 0xfffffffffffffff0)+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", (rax & 0xfffffffffffffff0), r12)")
OneGadget::Gadget.add(build_id, 695301,
                      constraints: ["r13d == 0x1", "writable: rax", "writable: rbp-0x40", "r15 == NULL || {\"sh\", r15, [rax+0x10], [rax+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rax, r12)")
OneGadget::Gadget.add(build_id, 695305,
                      constraints: ["r13d == 0x1", "writable: [rbp-0x40]", "r15 == NULL || {\"sh\", r15, [[rbp-0x40]+0x10], [[rbp-0x40]+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x40], r12)")
OneGadget::Gadget.add(build_id, 695309,
                      constraints: ["r13d == 0x1", "readable: rbp-0x40", "writable: rax", "[[rbp-0x40]] == NULL || [rbp-0x40] == NULL || [rbp-0x40] is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x40], r12)")
OneGadget::Gadget.add(build_id, 695316,
                      constraints: ["r13d == 0x1", "readable: rbp-0x40", "writable: rax", "[[rbp-0x40]] == NULL || [rbp-0x40] == NULL || [rbp-0x40] is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x40], r12)")
OneGadget::Gadget.add(build_id, 695411,
                      constraints: ["r13d == 0x1", "writable: rax", "r14 == NULL || {\"sh\", r14, [rax+0x10], [rax+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rax, r12)")
OneGadget::Gadget.add(build_id, 695431,
                      constraints: ["[rsi] == NULL || rsi == NULL || rsi is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, r12)")
OneGadget::Gadget.add(build_id, 695622,
                      constraints: ["r13d == 0x1", "writable: rax", "writable: rbp-0x60", "r15 == NULL || {\"sh\", r15, [rax+0x10], [rax+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rax, r12)")
OneGadget::Gadget.add(build_id, 695631,
                      constraints: ["r13d == 0x1", "writable: [rbp-0x40]", "writable: rbp-0x60", "r15 == NULL || {\"sh\", r15, [[rbp-0x40]+0x10], [[rbp-0x40]+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x40], r12)")
OneGadget::Gadget.add(build_id, 695635,
                      constraints: ["r13d == 0x1", "writable: [rbp-0x40]", "r15 == NULL || {\"sh\", r15, [[rbp-0x40]+0x10], [[rbp-0x40]+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x40], r12)")
OneGadget::Gadget.add(build_id, 695640,
                      constraints: ["readable: rbp-0x40", "[[rbp-0x40]] == NULL || [rbp-0x40] == NULL || [rbp-0x40] is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x40], r12)")
OneGadget::Gadget.add(build_id, 823432,
                      constraints: ["[rsp+0x1c] != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x64]", "[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 823436,
                      constraints: ["[rsp+0x1c] != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["rdi", "[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 823441,
                      constraints: ["[rsp+0x1c] != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 823445,
                      constraints: ["ecx != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 823551,
                      constraints: ["ax == 0x2000", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 823758,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 823770,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 823774,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["rdi"])
OneGadget::Gadget.add(build_id, 823779,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)")
OneGadget::Gadget.add(build_id, 823786,
                      constraints: ["readable: rax", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, [rax])")
OneGadget::Gadget.add(build_id, 823791,
                      constraints: ["readable: rax", "[rsi] == NULL || rsi == NULL || rsi is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, [rax])")
OneGadget::Gadget.add(build_id, 823844,
                      constraints: ["[rsp+0x1c] != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 838257,
                      constraints: ["[r9] == NULL || r9 == NULL || r9 is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", r9, rdx)")

