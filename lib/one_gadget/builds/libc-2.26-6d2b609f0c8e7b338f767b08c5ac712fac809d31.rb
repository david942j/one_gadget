require 'one_gadget/gadget'
# https://gitlab.com/libcdb/libcdb/blob/master/libc/libc6_2.26-0ubuntu2_amd64/lib/x86_64-linux-gnu/libc-2.26.so
# 
# Advanced Micro Devices X86-64
# 
# GNU C Library (Ubuntu GLIBC 2.26-0ubuntu2) stable release version 2.26, by Roland McGrath et al.
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
OneGadget::Gadget.add(build_id, 293958,
                      constraints: ["rax == NULL"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 294042,
                      constraints: ["[rsp+0x30] == NULL"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 890627,
                      constraints: ["[r13] == NULL || r13 == NULL", "[rbx] == NULL || rbx == NULL"],
                      effect: "execve(\"/bin/sh\", r13, rbx)")
OneGadget::Gadget.add(build_id, 891345,
                      constraints: ["[[rbp-0xa0]] == NULL || [rbp-0xa0] == NULL", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL"],
                      effect: "execve(\"/bin/sh\", [rbp-0xa0], [rbp-0x70])")
OneGadget::Gadget.add(build_id, 891352,
                      constraints: ["[rcx] == NULL || rcx == NULL", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL"],
                      effect: "execve(\"/bin/sh\", rcx, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 891356,
                      constraints: ["[rcx] == NULL || rcx == NULL", "[rdx] == NULL || rdx == NULL"],
                      effect: "execve(\"/bin/sh\", rcx, rdx)")
OneGadget::Gadget.add(build_id, 1035374,
                      constraints: ["[rsp+0x40] == NULL"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 1035386,
                      constraints: ["[rsi] == NULL || rsi == NULL", "[[rax]] == NULL || [rax] == NULL"],
                      effect: "execve(\"/bin/sh\", rsi, [rax])")
OneGadget::Gadget.add(build_id, 1039134,
                      constraints: ["[rsp+0x70] == NULL"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)")

