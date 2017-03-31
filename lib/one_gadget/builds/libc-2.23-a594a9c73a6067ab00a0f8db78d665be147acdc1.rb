require 'one_gadget/gadget'
# Advanced Micro Devices X86-64
# 
# GNU C Library (Ubuntu GLIBC 2.23-0ubuntu4) stable release version 2.23, by Roland McGrath et al.
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
OneGadget::Gadget.add(build_id, 283242,
                      constraints: ["[rsp+0x30] == NULL"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 836931,
                      constraints: ["[rcx] == NULL || rcx == NULL", "[r12] == NULL || r12 == NULL"],
                      effect: "execve(\"/bin/sh\", rcx, r12)")
OneGadget::Gadget.add(build_id, 837144,
                      constraints: ["[rax] == NULL || rax == NULL", "[r12] == NULL || r12 == NULL"],
                      effect: "execve(\"/bin/sh\", rax, r12)")
OneGadget::Gadget.add(build_id, 980676,
                      constraints: ["[rsp+0x50] == NULL"],
                      effect: "execve(\"/bin/sh\", rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 984423,
                      constraints: ["[rsp+0x70] == NULL"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)")
OneGadget::Gadget.add(build_id, 1006352,
                      constraints: ["[rcx] == NULL || rcx == NULL", "[[rbp-0xf8]] == NULL || [rbp-0xf8] == NULL"],
                      effect: "execve(\"/bin/sh\", rcx, [rbp-0xf8])")

