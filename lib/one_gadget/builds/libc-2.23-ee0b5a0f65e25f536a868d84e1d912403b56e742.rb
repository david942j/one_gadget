require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc6-amd64-2.23-5/lib64/libc-2.23.so
# 
# Advanced Micro Devices X86-64 processor
# 
# GNU C Library (Debian GLIBC 2.23-5) stable release version 2.23, by Roland McGrath et al.
# Copyright (C) 2016 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 5.4.1 20160803.
# Available extensions:
# 	crypt add-on version 2.1 by Michael Glad and others
# 	GNU Libidn by Simon Josefsson
# 	Native POSIX Threads Library by Ulrich Drepper et al
# 	BIND-8.2.3-T5B
# libc ABIs: UNIQUE IFUNC
# For bug reporting instructions, please see:
# <http://www.debian.org/Bugs/>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 258266,
                      constraints: ["(u64)rax <= 0xfffffffffffff000", "eax == 0x0", "r12 == NULL", "{\"sh\", \"-c\", rbx, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 258278,
                      constraints: ["eax == 0x0", "r12 == NULL", "{\"sh\", \"-c\", rbx, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 258927,
                      constraints: ["r12 == NULL", "{\"sh\", \"-c\", rbx, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 258934,
                      constraints: ["r12 == NULL", "rax == NULL || {rax, \"-c\", rbx, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 258941,
                      constraints: ["r12 == NULL", "rsi == NULL", "rax == NULL || {rax, \"-c\", rbx, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 258943,
                      constraints: ["r12 == NULL", "rdx == NULL", "rsi == NULL", "rax == NULL || {rax, \"-c\", rbx, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 258948,
                      constraints: ["r12 == NULL", "rdx == NULL", "rsi == NULL", "rax == NULL || {rax, \"-c\", rbx, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 258953,
                      constraints: ["r12 == NULL", "rdx == NULL", "rsi == NULL", "rax == NULL || {rax, \"-c\", [rsp+0x40], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 258962,
                      constraints: ["r12 == NULL", "rdx == NULL", "rsi == NULL", "rax == NULL || {rax, \"-c\", [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 258967,
                      constraints: ["r12 == NULL", "rdx == NULL", "rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], \"-c\", [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 258974,
                      constraints: ["r12 == NULL", "rdx == NULL", "rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], rax, [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 258979,
                      constraints: ["r12 == NULL", "rdx == NULL", "rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 258984,
                      constraints: ["r12 == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 258991,
                      constraints: ["r12 == NULL", "rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 258993,
                      constraints: ["r12 == NULL", "rdx == NULL", "rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 258998,
                      constraints: ["r12 == NULL", "rdx == NULL", "rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 259003,
                      constraints: ["r12 == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 259005,
                      constraints: ["r12 == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 259008,
                      constraints: ["rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 259013,
                      constraints: ["rsi == NULL", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 259018,
                      constraints: ["[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 259025,
                      constraints: ["readable: rax", "[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, [rax])")
OneGadget::Gadget.add(build_id, 751749,
                      constraints: ["r13d == 0x1", "writable: (rsp+0xf & 0xfffffffffffffff0)", "r14 == NULL || {\"sh\", r14, [(rsp+0xf & 0xfffffffffffffff0)+0x10], [(rsp+0xf & 0xfffffffffffffff0)+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", (rsp+0xf & 0xfffffffffffffff0), r12)")
OneGadget::Gadget.add(build_id, 751752,
                      constraints: ["r13d == 0x1", "writable: (rsp+0xf & 0xfffffffffffffff0)", "r14 == NULL || {\"sh\", r14, [(rsp+0xf & 0xfffffffffffffff0)+0x10], [(rsp+0xf & 0xfffffffffffffff0)+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", (rsp+0xf & 0xfffffffffffffff0), r12)")
OneGadget::Gadget.add(build_id, 751757,
                      constraints: ["r13d == 0x1", "writable: (rsi & 0xfffffffffffffff0)", "r14 == NULL || {\"sh\", r14, [(rsi & 0xfffffffffffffff0)+0x10], [(rsi & 0xfffffffffffffff0)+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", (rsi & 0xfffffffffffffff0), r12)")
OneGadget::Gadget.add(build_id, 751761,
                      constraints: ["r13d == 0x1", "writable: rsi", "r14 == NULL || {\"sh\", r14, [rsi+0x10], [rsi+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, r12)")
OneGadget::Gadget.add(build_id, 751768,
                      constraints: ["r13d == 0x1", "writable: rsi", "rax == NULL || {rax, r14, [rsi+0x10], [rsi+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, r12)")
OneGadget::Gadget.add(build_id, 752332,
                      constraints: ["r13d == 0x1", "writable: (rsp+0xf & 0xfffffffffffffff0)", "writable: rbp-0x40", "r15 == NULL || {\"sh\", r15, [(rsp+0xf & 0xfffffffffffffff0)+0x10], [(rsp+0xf & 0xfffffffffffffff0)+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", (rsp+0xf & 0xfffffffffffffff0), r12)")
OneGadget::Gadget.add(build_id, 752337,
                      constraints: ["r13d == 0x1", "writable: (rax & 0xfffffffffffffff0)", "writable: rbp-0x40", "r15 == NULL || {\"sh\", r15, [(rax & 0xfffffffffffffff0)+0x10], [(rax & 0xfffffffffffffff0)+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", (rax & 0xfffffffffffffff0), r12)")
OneGadget::Gadget.add(build_id, 752341,
                      constraints: ["r13d == 0x1", "writable: rax", "writable: rbp-0x40", "r15 == NULL || {\"sh\", r15, [rax+0x10], [rax+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rax, r12)")
OneGadget::Gadget.add(build_id, 752345,
                      constraints: ["r13d == 0x1", "writable: [rbp-0x40]", "r15 == NULL || {\"sh\", r15, [[rbp-0x40]+0x10], [[rbp-0x40]+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x40], r12)")
OneGadget::Gadget.add(build_id, 752349,
                      constraints: ["r13d == 0x1", "readable: rbp-0x40", "writable: rax", "[[rbp-0x40]] == NULL || [rbp-0x40] == NULL || [rbp-0x40] is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x40], r12)")
OneGadget::Gadget.add(build_id, 752356,
                      constraints: ["r13d == 0x1", "readable: rbp-0x40", "writable: rax", "[[rbp-0x40]] == NULL || [rbp-0x40] == NULL || [rbp-0x40] is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x40], r12)")
OneGadget::Gadget.add(build_id, 752451,
                      constraints: ["r13d == 0x1", "writable: rax", "r14 == NULL || {\"sh\", r14, [rax+0x10], [rax+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rax, r12)")
OneGadget::Gadget.add(build_id, 752471,
                      constraints: ["[rsi] == NULL || rsi == NULL || rsi is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, r12)")
OneGadget::Gadget.add(build_id, 752662,
                      constraints: ["r13d == 0x1", "writable: rax", "writable: rbp-0x60", "r15 == NULL || {\"sh\", r15, [rax+0x10], [rax+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rax, r12)")
OneGadget::Gadget.add(build_id, 752671,
                      constraints: ["r13d == 0x1", "writable: [rbp-0x40]", "writable: rbp-0x60", "r15 == NULL || {\"sh\", r15, [[rbp-0x40]+0x10], [[rbp-0x40]+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x40], r12)")
OneGadget::Gadget.add(build_id, 752675,
                      constraints: ["r13d == 0x1", "writable: [rbp-0x40]", "r15 == NULL || {\"sh\", r15, [[rbp-0x40]+0x10], [[rbp-0x40]+0x18], ...} is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x40], r12)")
OneGadget::Gadget.add(build_id, 752680,
                      constraints: ["readable: rbp-0x40", "[[rbp-0x40]] == NULL || [rbp-0x40] == NULL || [rbp-0x40] is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x40], r12)")
OneGadget::Gadget.add(build_id, 873482,
                      constraints: ["[rsp+0x1c] != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x64]", "[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 873486,
                      constraints: ["[rsp+0x1c] != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["rdi", "[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 873491,
                      constraints: ["[rsp+0x1c] != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 873495,
                      constraints: ["ecx != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 873585,
                      constraints: ["([rsp+0x128] & 0xf000) == 0x2000", "[rsp+0x138] == 0x103", "eax == 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 873589,
                      constraints: ["([rsp+0x128] & 0xf000) == 0x2000", "[rsp+0x138] == 0x103", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 873596,
                      constraints: ["(eax & 0xf000) == 0x2000", "[rsp+0x138] == 0x103", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 873601,
                      constraints: ["[rsp+0x138] == 0x103", "eax == 0x2000", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 873608,
                      constraints: ["[rsp+0x138] == 0x103", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 873778,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 873790,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 873794,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["rdi"])
OneGadget::Gadget.add(build_id, 873799,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)")
OneGadget::Gadget.add(build_id, 873806,
                      constraints: ["readable: rax", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, [rax])")
OneGadget::Gadget.add(build_id, 873811,
                      constraints: ["readable: rax", "[rsi] == NULL || rsi == NULL || rsi is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, [rax])")
OneGadget::Gadget.add(build_id, 873896,
                      constraints: ["[rsp+0x1c] != 0x0", "[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)",
                      closed_fds: ["[rsp+0x60]"])
OneGadget::Gadget.add(build_id, 888561,
                      constraints: ["[r9] == NULL || r9 == NULL || r9 is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", r9, rdx)")

