require 'one_gadget/gadget'
# https://gitlab.com/libcdb/libcdb/blob/master/libc/libc6_2.21-0ubuntu4.3_arm64/lib/aarch64-linux-gnu/libc-2.21.so
# 
# AArch64
# 
# GNU C Library (Ubuntu GLIBC 2.21-0ubuntu4.3) stable release version 2.21, by Roland McGrath et al.
# Copyright (C) 2015 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 4.9.3.
# Available extensions:
# 	crypt add-on version 2.1 by Michael Glad and others
# 	GNU Libidn by Simon Josefsson
# 	Native POSIX Threads Library by Ulrich Drepper et al
# 	BIND-8.2.3-T5B
# libc ABIs: UNIQUE
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 252900,
                      constraints: ["writable: x19+0x2a0", "writable: x20+0x4", "x4+0x5d8 == NULL"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 252908,
                      constraints: ["writable: x19+0x2a0", "writable: x20+0x4", "x4 == NULL"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 252976,
                      constraints: ["writable: x20+0x4", "[sp+0x58] == NULL"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 408388,
                      constraints: ["x2+0x5e0 == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", x2+0x5e0)")
OneGadget::Gadget.add(build_id, 408392,
                      constraints: ["x1+0x5d8 == NULL"],
                      effect: "execl(\"/bin/sh\", x1+0x5d8)")

