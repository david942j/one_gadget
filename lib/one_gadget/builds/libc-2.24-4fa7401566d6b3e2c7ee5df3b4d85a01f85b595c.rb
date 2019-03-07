require 'one_gadget/gadget'
# https://gitlab.com/libcdb/libcdb/blob/master/libc/libc6_2.24-3ubuntu1_arm64/lib/aarch64-linux-gnu/libc-2.24.so
# 
# AArch64
# 
# GNU C Library (Ubuntu GLIBC 2.24-3ubuntu1) stable release version 2.24, by Roland McGrath et al.
# Copyright (C) 2016 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 6.2.0 20160927.
# Available extensions:
# 	crypt add-on version 2.1 by Michael Glad and others
# 	GNU Libidn by Simon Josefsson
# 	Native POSIX Threads Library by Ulrich Drepper et al
# 	BIND-8.2.3-T5B
# libc ABIs: UNIQUE
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 248480,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x4+0xc48 == NULL"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 248492,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x4 == NULL"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 248552,
                      constraints: ["writable: x20+0x4", "[x22] == NULL || x22 == NULL"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 399116,
                      constraints: ["x2+0xc50 == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", x2+0xc50)")
OneGadget::Gadget.add(build_id, 399120,
                      constraints: ["x1+0xc48 == NULL"],
                      effect: "execl(\"/bin/sh\", x1+0xc48)")

