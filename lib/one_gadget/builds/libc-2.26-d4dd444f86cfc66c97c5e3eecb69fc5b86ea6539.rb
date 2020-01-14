require 'one_gadget/gadget'
# https://gitlab.com/libcdb/libcdb/blob/master/libc/libc6_2.26-0ubuntu2.1_arm64/lib/aarch64-linux-gnu/libc-2.26.so
# 
# AArch64
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
# libc ABIs: UNIQUE
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 255552,
                      constraints: ["writable: x20+0x318", "x3+0xcc0 == NULL"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 255556,
                      constraints: ["writable: x20+0x318", "x3 == NULL"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 255592,
                      constraints: ["writable: x19+0x4", "writable: x20+0x318", "[sp+0x70] == NULL"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 255628,
                      constraints: ["writable: x19+0x4", "writable: x20+0x318", "[x21] == NULL || x21 == NULL"],
                      effect: "execve(\"/bin/sh\", x21, environ)")
OneGadget::Gadget.add(build_id, 409132,
                      constraints: ["x2+0xcc8 == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", x2+0xcc8)")
OneGadget::Gadget.add(build_id, 409144,
                      constraints: ["x1+0xcc0 == NULL"],
                      effect: "execl(\"/bin/sh\", x1+0xcc0)")
OneGadget::Gadget.add(build_id, 409152,
                      constraints: ["x1 == NULL"],
                      effect: "execl(\"/bin/sh\", x1)")

