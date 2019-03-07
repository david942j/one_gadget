require 'one_gadget/gadget'
# https://gitlab.com/libcdb/libcdb/blob/master/libc/libc6_2.24-9ubuntu2_amd64/lib/x86_64-linux-gnu/libc-2.24.so
# 
# Advanced Micro Devices X86-64
# 
# GNU C Library (Ubuntu GLIBC 2.24-9ubuntu2) stable release version 2.24, by Roland McGrath et al.
# Copyright (C) 2016 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 6.3.0 20170321.
# Available extensions:
# 	crypt add-on version 2.1 by Michael Glad and others
# 	GNU Libidn by Simon Josefsson
# 	Native POSIX Threads Library by Ulrich Drepper et al
# 	BIND-8.2.3-T5B
# libc ABIs: UNIQUE IFUNC
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 283942,
                      constraints: ["rax == NULL"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 284026,
                      constraints: ["[rsp+0x30] == NULL"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 840257,
                      constraints: ["[r15] == NULL || r15 == NULL", "[r13] == NULL || r13 == NULL"],
                      effect: "execve(\"/bin/sh\", r15, r13)")
OneGadget::Gadget.add(build_id, 840929,
                      constraints: ["[[rbp-0x78]] == NULL || [rbp-0x78] == NULL", "[[rbp-0x50]] == NULL || [rbp-0x50] == NULL"],
                      effect: "execve(\"/bin/sh\", [rbp-0x78], [rbp-0x50])")
OneGadget::Gadget.add(build_id, 840933,
                      constraints: ["[r9] == NULL || r9 == NULL", "[[rbp-0x50]] == NULL || [rbp-0x50] == NULL"],
                      effect: "execve(\"/bin/sh\", r9, [rbp-0x50])")
OneGadget::Gadget.add(build_id, 840937,
                      constraints: ["[r9] == NULL || r9 == NULL", "[rdx] == NULL || rdx == NULL"],
                      effect: "execve(\"/bin/sh\", r9, rdx)")
OneGadget::Gadget.add(build_id, 985681,
                      constraints: ["[rsp+0x40] == NULL"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 985693,
                      constraints: ["[rsi] == NULL || rsi == NULL", "[[rax]] == NULL || [rax] == NULL"],
                      effect: "execve(\"/bin/sh\", rsi, [rax])")
OneGadget::Gadget.add(build_id, 989387,
                      constraints: ["[rsp+0x60] == NULL"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)")

