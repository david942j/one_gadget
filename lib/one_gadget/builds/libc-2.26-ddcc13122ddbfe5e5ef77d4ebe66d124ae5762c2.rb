require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc6_2.26-0ubuntu2.1_amd64/lib/x86_64-linux-gnu/libc-2.26.so
# 
# Advanced Micro Devices X86-64
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
OneGadget::Gadget.add(build_id, 293951,
                      constraints: ["writable: rsp+0x40", "{\"sh\", \"-c\", rbx, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 293958,
                      constraints: ["writable: rsp+0x40", "rax == NULL || {rax, \"-c\", rbx, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 294042,
                      constraints: ["[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 890723,
                      constraints: ["[r13] == NULL || r13 == NULL || r13 is a valid argv", "[rbx] == NULL || rbx == NULL || rbx is a valid envp"],
                      effect: "execve(\"/bin/sh\", r13, rbx)")
OneGadget::Gadget.add(build_id, 891008,
                      constraints: ["writable: rbp-0x48", "r14 == NULL || {\"/bin/sh\", r14, NULL} is a valid argv", "[rbx] == NULL || rbx == NULL || rbx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, rbx)")
OneGadget::Gadget.add(build_id, 891018,
                      constraints: ["writable: rbp-0x48", "rax == NULL || {rax, r14, NULL} is a valid argv", "[rbx] == NULL || rbx == NULL || rbx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, rbx)")
OneGadget::Gadget.add(build_id, 891022,
                      constraints: ["writable: rbp-0x40", "rax == NULL || {rax, [rbp-0x48], NULL} is a valid argv", "[rbx] == NULL || rbx == NULL || rbx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, rbx)")
OneGadget::Gadget.add(build_id, 891030,
                      constraints: ["writable: rbp-0x50", "rax == NULL || {rax, [rbp-0x48], [rbp-0x40], [rbp-0x38], ...} is a valid argv", "[rbx] == NULL || rbx == NULL || rbx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, rbx)")
OneGadget::Gadget.add(build_id, 891441,
                      constraints: ["[[rbp-0xa0]] == NULL || [rbp-0xa0] == NULL || [rbp-0xa0] is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0xa0], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 891448,
                      constraints: ["[rcx] == NULL || rcx == NULL || rcx is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rcx, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 891452,
                      constraints: ["[rcx] == NULL || rcx == NULL || rcx is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rcx, rdx)")
OneGadget::Gadget.add(build_id, 1035486,
                      constraints: ["[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 1035498,
                      constraints: ["[rsi] == NULL || rsi == NULL || rsi is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, [rax])")
OneGadget::Gadget.add(build_id, 1039246,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)")

