require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc0.1-2.24-12/lib/x86_64-kfreebsd-gnu/libc-2.24.so
# 
# Advanced Micro Devices X86-64 processor
# 
# GNU C Library (Debian GLIBC 2.24-12) stable release version 2.24, by Roland McGrath et al.
# Copyright (C) 2016 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 6.3.0 20170516.
# Available extensions:
# 	crypt add-on version 2.1 by Michael Glad and others
# 	Native POSIX Threads Library by Ulrich Drepper et al
# 	GNU Libidn by Simon Josefsson
# 	BIND-8.2.3-T5B
# libc ABIs: UNIQUE
# For bug reporting instructions, please see:
# <http://www.debian.org/Bugs/>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 253866,
                      constraints: ["eax == 0x0", "{\"sh\", \"-c\", r12, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 253869,
                      constraints: ["ebx == 0x0", "{\"sh\", \"-c\", r12, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 254482,
                      constraints: ["{\"sh\", \"-c\", r12, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 254489,
                      constraints: ["rax == NULL || {rax, \"-c\", r12, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 254496,
                      constraints: ["rsi == NULL", "rax == NULL || {rax, \"-c\", r12, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 254498,
                      constraints: ["rdx == NULL", "rsi == NULL", "rax == NULL || {rax, \"-c\", r12, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 254503,
                      constraints: ["rdx == NULL", "rsi == NULL", "rax == NULL || {rax, \"-c\", r12, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 254508,
                      constraints: ["rdx == NULL", "rsi == NULL", "rax == NULL || {rax, \"-c\", [rsp+0x40], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 254517,
                      constraints: ["rdx == NULL", "rsi == NULL", "rax == NULL || {rax, \"-c\", [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 254522,
                      constraints: ["rdx == NULL", "rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], \"-c\", [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 254529,
                      constraints: ["rdx == NULL", "rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], rax, [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 254534,
                      constraints: ["rdx == NULL", "rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 254539,
                      constraints: ["[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 254546,
                      constraints: ["rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 254548,
                      constraints: ["rdx == NULL", "rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 254553,
                      constraints: ["rdx == NULL", "rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 254558,
                      constraints: ["[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 254560,
                      constraints: ["[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 254563,
                      constraints: ["rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 254568,
                      constraints: ["rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 254573,
                      constraints: ["[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 254580,
                      constraints: ["readable: rax", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, [rax])")
OneGadget::Gadget.add(build_id, 707343,
                      constraints: ["[r13] == NULL || r13 == NULL || r13 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r13, r12)")
OneGadget::Gadget.add(build_id, 707388,
                      constraints: ["[r13] == NULL || r13 == NULL || r13 is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r13, r12)")
OneGadget::Gadget.add(build_id, 836268,
                      constraints: ["([rsp+0x4c] & 0x10) != 0x0", "(s64)[$base+0x3631e4] <= 0x0", "[rsp+0x5c] == 0x1", "ebx == 0x0", "{\"sh\", \"-c\", [rsp+0x40], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 836276,
                      constraints: ["([rsp+0x4c] & 0x10) != 0x0", "(s64)[$base+0x3631e4] <= 0x0", "[rsp+0x5c] == 0x1", "{\"sh\", \"-c\", [rsp+0x40], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 836280,
                      constraints: ["(eax & 0x10) != 0x0", "(s64)[$base+0x3631e4] <= 0x0", "[rsp+0x5c] == 0x1", "{\"sh\", \"-c\", [rsp+0x40], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 836289,
                      constraints: ["(eax & 0x10) != 0x0", "(s64)[$base+0x3631e4] <= 0x0", "[rsp+0x5c] == 0x1", "{\"sh\", \"-c\", [rsp+0x40], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 836292,
                      constraints: ["(s64)[$base+0x3631e4] <= 0x0", "[rsp+0x5c] == 0x1", "eax != 0x0", "{\"sh\", \"-c\", [rsp+0x40], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 836296,
                      constraints: ["(s64)[$base+0x3631e4] <= 0x0", "[rsp+0x1c] != 0x0", "[rsp+0x5c] == 0x1", "{\"sh\", \"-c\", [rsp+0x40], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 836303,
                      constraints: ["(s64)[$base+0x3631e4] <= 0x0", "[rsp+0x1c] != 0x0", "[rsp+0x5c] == 0x1", "rax == NULL || {rax, \"-c\", [rsp+0x40], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 836308,
                      constraints: ["(s64)[$base+0x3631e4] <= 0x0", "[rsp+0x1c] != 0x0", "[rsp+0x5c] == 0x1", "[rsp+0x60] == NULL || {[rsp+0x60], \"-c\", [rsp+0x40], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 836315,
                      constraints: ["(s64)[$base+0x3631e4] <= 0x0", "[rsp+0x1c] != 0x0", "[rsp+0x5c] == 0x1", "[rsp+0x60] == NULL || {[rsp+0x60], rax, [rsp+0x40], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 836320,
                      constraints: ["(s64)[$base+0x3631e4] <= 0x0", "[rsp+0x1c] != 0x0", "[rsp+0x5c] == 0x1", "[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x40], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 836325,
                      constraints: ["(s64)[$base+0x3631e4] <= 0x0", "[rsp+0x1c] != 0x0", "[rsp+0x5c] == 0x1", "[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], rax, [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 836330,
                      constraints: ["(s64)[$base+0x3631e4] <= 0x0", "[rsp+0x1c] != 0x0", "[rsp+0x5c] == 0x1", "[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 836334,
                      constraints: ["(s64)[$base+0x3631e4] <= 0x0", "[rsp+0x1c] != 0x0", "edi == 0x1", "[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 836353,
                      constraints: ["[rsp+0x1c] != 0x0", "[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x5c]", "[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 836357,
                      constraints: ["[rsp+0x1c] != 0x0", "[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["rdi", "[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 836362,
                      constraints: ["[rsp+0x1c] != 0x0", "[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 836366,
                      constraints: ["ecx != 0x0", "[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 836472,
                      constraints: ["ax == 0x2000", "[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 836482,
                      constraints: ["[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 836494,
                      constraints: ["[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 836498,
                      constraints: ["[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["rdi"])
OneGadget::Gadget.add(build_id, 836503,
                      constraints: ["[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 836510,
                      constraints: ["readable: rax", "[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, [rax])")
OneGadget::Gadget.add(build_id, 836515,
                      constraints: ["readable: rax", "[rsi] == NULL || rsi == NULL || rsi is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, [rax])")
OneGadget::Gadget.add(build_id, 836666,
                      constraints: ["(s64)[$base+0x3631e4] <= 0x0", "[rsp+0x1c] != 0x0", "[rsp+0x5c] == 0x1", "[rsp+0x60] == NULL || {[rsp+0x60], rax, [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 836671,
                      constraints: ["(s64)[$base+0x3631e4] <= 0x0", "[rsp+0x1c] != 0x0", "[rsp+0x5c] == 0x1", "[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 836732,
                      constraints: ["(s64)[$base+0x3631e4] <= 0x0", "[rsp+0x1c] != 0x0", "[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])
OneGadget::Gadget.add(build_id, 836764,
                      constraints: ["[rsp+0x1c] != 0x0", "[rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)",
                      closed_fds: ["[rsp+0x58]"])

