require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc6-amd64_2.19-0ubuntu6.7_i386/lib64/libc-2.19.so
# 
# Advanced Micro Devices X86-64
# 
# GNU C Library (Ubuntu EGLIBC 2.19-0ubuntu6.7) stable release version 2.19, by Roland McGrath et al.
# Copyright (C) 2014 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 4.8.2.
# Compiled on a Linux 3.13.11 system on 2016-02-16.
# Available extensions:
# 	crypt add-on version 2.1 by Michael Glad and others
# 	GNU Libidn by Simon Josefsson
# 	Native POSIX Threads Library by Ulrich Drepper et al
# 	BIND-8.2.3-T5B
# libc ABIs: UNIQUE IFUNC
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/eglibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 274313,
                      constraints: ["writable: rsp+0x40", "{\"sh\", \"-c\", rbx, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 274320,
                      constraints: ["writable: rsp+0x40", "rax == NULL || {rax, \"-c\", rbx, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 274404,
                      constraints: ["[rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 753661,
                      constraints: ["[rsi] == NULL || rsi == NULL || rsi is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, r12)")
OneGadget::Gadget.add(build_id, 753740,
                      constraints: ["[[rbp-0x48]] == NULL || [rbp-0x48] == NULL || [rbp-0x48] is a valid argv", "[r12] == NULL || r12 == NULL || r12 is a valid envp"],
                      effect: "execve(\"/bin/sh\", [rbp-0x48], r12)")
OneGadget::Gadget.add(build_id, 868944,
                      constraints: ["[r9] == NULL || r9 == NULL || r9 is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", r9, rdx)")
OneGadget::Gadget.add(build_id, 873688,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)")
OneGadget::Gadget.add(build_id, 873700,
                      constraints: ["[rsi] == NULL || rsi == NULL || rsi is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, [rax])")

