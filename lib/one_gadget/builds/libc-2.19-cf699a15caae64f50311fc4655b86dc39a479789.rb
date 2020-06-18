require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc6_2.19-0ubuntu6.9_amd64/lib/x86_64-linux-gnu/libc-2.19.so
# 
# Advanced Micro Devices X86-64
# 
# GNU C Library (Ubuntu EGLIBC 2.19-0ubuntu6.9) stable release version 2.19, by Roland McGrath et al.
# Copyright (C) 2014 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 4.8.4.
# Compiled on a Linux 3.13.11 system on 2016-05-26.
# Available extensions:
# 	crypt add-on version 2.1 by Michael Glad and others
# 	GNU Libidn by Simon Josefsson
# 	Native POSIX Threads Library by Ulrich Drepper et al
# 	BIND-8.2.3-T5B
# libc ABIs: UNIQUE IFUNC
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/eglibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 287784,
                      constraints: ["rax == NULL"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 287868,
                      constraints: ["[rsp+0x30] == NULL"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 793507,
                      constraints: ["[rsi] == NULL || rsi == NULL", "[r12] == NULL || r12 == NULL"],
                      effect: "execve(\"/bin/sh\", rsi, r12)")
OneGadget::Gadget.add(build_id, 793586,
                      constraints: ["[[rbp-0x48]] == NULL || [rbp-0x48] == NULL", "[r12] == NULL || r12 == NULL"],
                      effect: "execve(\"/bin/sh\", [rbp-0x48], r12)")
OneGadget::Gadget.add(build_id, 936296,
                      constraints: ["[rsi] == NULL || rsi == NULL", "[[rbp-0xf0]] == NULL || [rbp-0xf0] == NULL"],
                      effect: "execve(\"/bin/sh\", rsi, [rbp-0xf0])")
OneGadget::Gadget.add(build_id, 939877,
                      constraints: ["[rsp+0x50] == NULL"],
                      effect: "execve(\"/bin/sh\", rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 939889,
                      constraints: ["[rsi] == NULL || rsi == NULL", "[[rax]] == NULL || [rax] == NULL"],
                      effect: "execve(\"/bin/sh\", rsi, [rax])")
OneGadget::Gadget.add(build_id, 943805,
                      constraints: ["[rsp+0x70] == NULL"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)")

