require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc6-amd64-2.19-18+deb8u5/lib64/libc-2.19.so
# 
# Advanced Micro Devices X86-64
# 
# GNU C Library (Debian GLIBC 2.19-18+deb8u5) stable release version 2.19, by Roland McGrath et al.
# Copyright (C) 2014 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 4.8.4.
# Compiled on a Linux 3.16.7 system on 2016-07-17.
# Available extensions:
# 	crypt add-on version 2.1 by Michael Glad and others
# 	GNU Libidn by Simon Josefsson
# 	Native POSIX Threads Library by Ulrich Drepper et al
# 	BIND-8.2.3-T5B
# libc ABIs: UNIQUE IFUNC
# For bug reporting instructions, please see:
# <http://www.debian.org/Bugs/>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 266992,
                      constraints: ["rax == NULL"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 267076,
                      constraints: ["[rsp+0x30] == NULL"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 765005,
                      constraints: ["[rsi] == NULL || rsi == NULL", "[r12] == NULL || r12 == NULL"],
                      effect: "execve(\"/bin/sh\", rsi, r12)")
OneGadget::Gadget.add(build_id, 765084,
                      constraints: ["[[rbp-0x48]] == NULL || [rbp-0x48] == NULL", "[r12] == NULL || r12 == NULL"],
                      effect: "execve(\"/bin/sh\", [rbp-0x48], r12)")
OneGadget::Gadget.add(build_id, 880199,
                      constraints: ["[rsp+0x70] == NULL"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)")
OneGadget::Gadget.add(build_id, 880211,
                      constraints: ["[rsi] == NULL || rsi == NULL", "[[rax]] == NULL || [rax] == NULL"],
                      effect: "execve(\"/bin/sh\", rsi, [rax])")
OneGadget::Gadget.add(build_id, 895520,
                      constraints: ["[r9] == NULL || r9 == NULL", "[rdx] == NULL || rdx == NULL"],
                      effect: "execve(\"/bin/sh\", r9, rdx)")

