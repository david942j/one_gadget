require 'one_gadget/gadget'
# https://gitlab.com/libcdb/libcdb/blob/master/libc/libc6_2.24-9ubuntu2_arm64/lib/aarch64-linux-gnu/libc-2.24.so
# 
# AArch64
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
# libc ABIs: UNIQUE
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 248400,
                      constraints: ["writable: x19+0x258", "x3+0x9f8 == NULL"],
                      effect: "execve(\"/bin/sh\", sp+0x68, environ)")
OneGadget::Gadget.add(build_id, 248404,
                      constraints: ["writable: x19+0x258", "x3 == NULL"],
                      effect: "execve(\"/bin/sh\", sp+0x68, environ)")
OneGadget::Gadget.add(build_id, 248440,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "[sp+0x68] == NULL"],
                      effect: "execve(\"/bin/sh\", sp+0x68, environ)")
OneGadget::Gadget.add(build_id, 248476,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "[x21] == NULL || x21 == NULL"],
                      effect: "execve(\"/bin/sh\", x21, environ)")
OneGadget::Gadget.add(build_id, 398984,
                      constraints: ["x2+0xa00 == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", x2+0xa00)")
OneGadget::Gadget.add(build_id, 398996,
                      constraints: ["x1+0x9f8 == NULL"],
                      effect: "execl(\"/bin/sh\", x1+0x9f8)")
OneGadget::Gadget.add(build_id, 399004,
                      constraints: ["x1 == NULL"],
                      effect: "execl(\"/bin/sh\", x1)")

