require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc6_2.23-0ubuntu11.3_amd64/lib/x86_64-linux-gnu/libc-2.23.so
# 
# Advanced Micro Devices X86-64 processor
# 
# GNU C Library (Ubuntu GLIBC 2.23-0ubuntu11.3) stable release version 2.23, by Roland McGrath et al.
# Copyright (C) 2016 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 5.4.0 20160609.
# Available extensions:
# 	crypt add-on version 2.1 by Michael Glad and others
# 	GNU Libidn by Simon Josefsson
# 	Native POSIX Threads Library by Ulrich Drepper et al
# 	BIND-8.2.3-T5B
# libc ABIs: UNIQUE IFUNC
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 282506,
                      constraints: ["(u64)rax <= 0xfffffffffffff000", "eax == 0x0", "r12 == NULL", "{\"sh\", \"-c\", rbx, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 282518,
                      constraints: ["eax == 0x0", "r12 == NULL", "{\"sh\", \"-c\", rbx, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 283167,
                      constraints: ["r12 == NULL", "{\"sh\", \"-c\", rbx, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 283174,
                      constraints: ["r12 == NULL", "rax == NULL || {rax, \"-c\", rbx, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 283181,
                      constraints: ["r12 == NULL", "rsi == NULL", "rax == NULL || {rax, \"-c\", rbx, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 283183,
                      constraints: ["r12 == NULL", "rdx == NULL", "rsi == NULL", "rax == NULL || {rax, \"-c\", rbx, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 283188,
                      constraints: ["r12 == NULL", "rdx == NULL", "rsi == NULL", "rax == NULL || {rax, \"-c\", rbx, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 283193,
                      constraints: ["r12 == NULL", "rdx == NULL", "rsi == NULL", "rax == NULL || {rax, \"-c\", [rsp+0x40], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 283202,
                      constraints: ["r12 == NULL", "rdx == NULL", "rsi == NULL", "rax == NULL || {rax, \"-c\", [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 283207,
                      constraints: ["r12 == NULL", "rdx == NULL", "rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], \"-c\", [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 283214,
                      constraints: ["r12 == NULL", "rdx == NULL", "rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], rax, [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 283219,
                      constraints: ["r12 == NULL", "rdx == NULL", "rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 283224,
                      constraints: ["r12 == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 283231,
                      constraints: ["r12 == NULL", "rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 283233,
                      constraints: ["r12 == NULL", "rdx == NULL", "rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 283238,
                      constraints: ["r12 == NULL", "rdx == NULL", "rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 283243,
                      constraints: ["r12 == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 283245,
                      constraints: ["r12 == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 283248,
                      constraints: ["rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 283253,
                      constraints: ["rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 283258,
                      constraints: ["[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 283265,
                      constraints: ["readable: rax", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, [rax])")
OneGadget::Gadget.add(build_id, 839333,
                      constraints: ["r15d == 0x1", "writable: (rsp+0xf & 0xfffffffffffffff0)", "r14 == NULL || {\"sh\", r14, [(rsp+0xf & 0xfffffffffffffff0)+0x10], [(rsp+0xf & 0xfffffffffffffff0)+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", (rsp+0xf & 0xfffffffffffffff0), r12)")
OneGadget::Gadget.add(build_id, 839336,
                      constraints: ["r15d == 0x1", "writable: (rsp+0xf & 0xfffffffffffffff0)", "r14 == NULL || {\"sh\", r14, [(rsp+0xf & 0xfffffffffffffff0)+0x10], [(rsp+0xf & 0xfffffffffffffff0)+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", (rsp+0xf & 0xfffffffffffffff0), r12)")
OneGadget::Gadget.add(build_id, 839341,
                      constraints: ["r15d == 0x1", "writable: (rcx & 0xfffffffffffffff0)", "r14 == NULL || {\"sh\", r14, [(rcx & 0xfffffffffffffff0)+0x10], [(rcx & 0xfffffffffffffff0)+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", (rcx & 0xfffffffffffffff0), r12)")
OneGadget::Gadget.add(build_id, 839345,
                      constraints: ["r15d == 0x1", "writable: rcx", "r14 == NULL || {\"sh\", r14, [rcx+0x10], [rcx+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rcx, r12)")
OneGadget::Gadget.add(build_id, 839352,
                      constraints: ["r15d == 0x1", "writable: rcx", "rax == NULL || {rax, r14, [rcx+0x10], [rcx+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rcx, r12)")
OneGadget::Gadget.add(build_id, 839915,
                      constraints: ["esi == 0x1", "writable: (rsp+0xf & 0xfffffffffffffff0)", "writable: rbp-0x40", "r15 == NULL || {\"sh\", r15, [(rsp+0xf & 0xfffffffffffffff0)+0x10], [(rsp+0xf & 0xfffffffffffffff0)+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", (rsp+0xf & 0xfffffffffffffff0), r12)")
OneGadget::Gadget.add(build_id, 839920,
                      constraints: ["esi == 0x1", "writable: (rax & 0xfffffffffffffff0)", "writable: rbp-0x40", "r15 == NULL || {\"sh\", r15, [(rax & 0xfffffffffffffff0)+0x10], [(rax & 0xfffffffffffffff0)+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", (rax & 0xfffffffffffffff0), r12)")
OneGadget::Gadget.add(build_id, 839924,
                      constraints: ["esi == 0x1", "writable: rax", "writable: rbp-0x40", "r15 == NULL || {\"sh\", r15, [rax+0x10], [rax+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rax, r12)")
OneGadget::Gadget.add(build_id, 839928,
                      constraints: ["esi == 0x1", "writable: rax", "r15 == NULL || {\"sh\", r15, [rax+0x10], [rax+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rax, r12)")
OneGadget::Gadget.add(build_id, 839935,
                      constraints: ["esi == 0x1", "writable: rax", "rcx == NULL || {rcx, r15, [rax+0x10], [rax+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rax, r12)")
OneGadget::Gadget.add(build_id, 840031,
                      constraints: ["r15d == 0x1", "writable: rax", "r14 == NULL || {\"sh\", r14, [rax+0x10], [rax+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rax, r12)")
OneGadget::Gadget.add(build_id, 840051,
                      constraints: ["[rcx] == NULL || rcx == NULL || rcx is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rcx, r12)")
OneGadget::Gadget.add(build_id, 840243,
                      constraints: ["[rbp-0x50] == 0x1", "writable: rax", "writable: rbp-0x60", "r15 == NULL || {\"sh\", r15, [rax+0x10], [rax+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rax, r12)")
OneGadget::Gadget.add(build_id, 840252,
                      constraints: ["[rbp-0x50] == 0x1", "writable: rax", "writable: rbp-0x60", "r15 == NULL || {\"sh\", r15, [rax+0x10], [rax+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rax, r12)")
OneGadget::Gadget.add(build_id, 840256,
                      constraints: ["[rbp-0x50] == 0x1", "writable: rax", "r15 == NULL || {\"sh\", r15, [rax+0x10], [rax+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rax, r12)")
OneGadget::Gadget.add(build_id, 840259,
                      constraints: ["esi == 0x1", "writable: rax", "r15 == NULL || {\"sh\", r15, [rax+0x10], [rax+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rax, r12)")
OneGadget::Gadget.add(build_id, 840264,
                      constraints: ["[rax] == NULL || rax == NULL || rax is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rax, r12)")
OneGadget::Gadget.add(build_id, 983785,
                      constraints: ["[rsp+0x28] != 0x0", "[rsp+0x50] == NULL || {[rsp+0x50], [rsp+0x58], [rsp+0x60], [rsp+0x68], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x50, environ)",
                      closed_fds: ["[rsp+0x44]", "[rsp+0x40]"])
OneGadget::Gadget.add(build_id, 983789,
                      constraints: ["[rsp+0x28] != 0x0", "[rsp+0x50] == NULL || {[rsp+0x50], [rsp+0x58], [rsp+0x60], [rsp+0x68], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x50, environ)",
                      closed_fds: ["rdi", "[rsp+0x40]"])
OneGadget::Gadget.add(build_id, 983794,
                      constraints: ["[rsp+0x28] != 0x0", "[rsp+0x50] == NULL || {[rsp+0x50], [rsp+0x58], [rsp+0x60], [rsp+0x68], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x50, environ)",
                      closed_fds: ["[rsp+0x40]"])
OneGadget::Gadget.add(build_id, 983798,
                      constraints: ["ecx != 0x0", "[rsp+0x50] == NULL || {[rsp+0x50], [rsp+0x58], [rsp+0x60], [rsp+0x68], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x50, environ)",
                      closed_fds: ["[rsp+0x40]"])
OneGadget::Gadget.add(build_id, 983873,
                      constraints: ["([rsp+0x108] & 0xf000) == 0x2000", "[rsp+0x118] == 0x103", "eax == 0x0", "[rsp+0x50] == NULL || {[rsp+0x50], [rsp+0x58], [rsp+0x60], [rsp+0x68], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x50, environ)",
                      closed_fds: ["[rsp+0x40]"])
OneGadget::Gadget.add(build_id, 983877,
                      constraints: ["([rsp+0x108] & 0xf000) == 0x2000", "[rsp+0x118] == 0x103", "[rsp+0x50] == NULL || {[rsp+0x50], [rsp+0x58], [rsp+0x60], [rsp+0x68], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x50, environ)",
                      closed_fds: ["[rsp+0x40]"])
OneGadget::Gadget.add(build_id, 983884,
                      constraints: ["(eax & 0xf000) == 0x2000", "[rsp+0x118] == 0x103", "[rsp+0x50] == NULL || {[rsp+0x50], [rsp+0x58], [rsp+0x60], [rsp+0x68], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x50, environ)",
                      closed_fds: ["[rsp+0x40]"])
OneGadget::Gadget.add(build_id, 983889,
                      constraints: ["[rsp+0x118] == 0x103", "eax == 0x2000", "[rsp+0x50] == NULL || {[rsp+0x50], [rsp+0x58], [rsp+0x60], [rsp+0x68], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x50, environ)",
                      closed_fds: ["[rsp+0x40]"])
OneGadget::Gadget.add(build_id, 983896,
                      constraints: ["[rsp+0x118] == 0x103", "[rsp+0x50] == NULL || {[rsp+0x50], [rsp+0x58], [rsp+0x60], [rsp+0x68], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x50, environ)",
                      closed_fds: ["[rsp+0x40]"])
OneGadget::Gadget.add(build_id, 983951,
                      constraints: ["[rsp+0x50] == NULL || {[rsp+0x50], [rsp+0x58], [rsp+0x60], [rsp+0x68], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x50, environ)",
                      closed_fds: ["[rsp+0x40]"])
OneGadget::Gadget.add(build_id, 983963,
                      constraints: ["[rsp+0x50] == NULL || {[rsp+0x50], [rsp+0x58], [rsp+0x60], [rsp+0x68], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x50, environ)",
                      closed_fds: ["[rsp+0x40]"])
OneGadget::Gadget.add(build_id, 983967,
                      constraints: ["[rsp+0x50] == NULL || {[rsp+0x50], [rsp+0x58], [rsp+0x60], [rsp+0x68], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x50, environ)",
                      closed_fds: ["rdi"])
OneGadget::Gadget.add(build_id, 983972,
                      constraints: ["[rsp+0x50] == NULL || {[rsp+0x50], [rsp+0x58], [rsp+0x60], [rsp+0x68], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 983979,
                      constraints: ["readable: rax", "[rsp+0x50] == NULL || {[rsp+0x50], [rsp+0x58], [rsp+0x60], [rsp+0x68], ...} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsp+0x50, [rax])")
OneGadget::Gadget.add(build_id, 983984,
                      constraints: ["readable: rax", "[rsi] == NULL || rsi == NULL || rsi is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, [rax])")
OneGadget::Gadget.add(build_id, 984100,
                      constraints: ["[rsp+0x28] != 0x0", "[rsp+0x50] == NULL || {[rsp+0x50], [rsp+0x58], [rsp+0x60], [rsp+0x68], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x50, environ)",
                      closed_fds: ["[rsp+0x40]"])
OneGadget::Gadget.add(build_id, 987400,
                      constraints: ["[rsp+0x2c] != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x64]", "[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 987404,
                      constraints: ["[rsp+0x2c] != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["rdi", "[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 987409,
                      constraints: ["[rsp+0x2c] != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 987413,
                      constraints: ["ecx != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 987503,
                      constraints: ["([rsp+0x128] & 0xf000) == 0x2000", "[rsp+0x138] == 0x103", "eax == 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 987507,
                      constraints: ["([rsp+0x128] & 0xf000) == 0x2000", "[rsp+0x138] == 0x103", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 987514,
                      constraints: ["(eax & 0xf000) == 0x2000", "[rsp+0x138] == 0x103", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 987519,
                      constraints: ["[rsp+0x138] == 0x103", "eax == 0x2000", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 987526,
                      constraints: ["[rsp+0x138] == 0x103", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 987698,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 987710,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 987714,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["rdi"])
OneGadget::Gadget.add(build_id, 987719,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)")
OneGadget::Gadget.add(build_id, 987726,
                      constraints: ["readable: rax", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, [rax])")
OneGadget::Gadget.add(build_id, 987731,
                      constraints: ["readable: rax", "[rsi] == NULL || rsi == NULL || rsi is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, [rax])")
OneGadget::Gadget.add(build_id, 987815,
                      constraints: ["[rsp+0x2c] != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 1009646,
                      constraints: ["readable: rbp-0xf8", "[rcx] == NULL || rcx == NULL || rcx is a valid argv", "[[rbp-0xf8]] == NULL || [rbp-0xf8] == NULL || [rbp-0xf8] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rcx, [rbp-0xf8])")
OneGadget::Gadget.add(build_id, 1009648,
                      constraints: ["readable: rbp-0xf8", "[rcx] == NULL || rcx == NULL || rcx is a valid argv", "[[rbp-0xf8]] == NULL || [rbp-0xf8] == NULL || [rbp-0xf8] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rcx, [rbp-0xf8])")

