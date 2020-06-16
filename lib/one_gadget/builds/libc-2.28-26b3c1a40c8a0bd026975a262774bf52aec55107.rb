require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc6_2.28-0ubuntu1_arm64/lib/aarch64-linux-gnu/libc-2.28.so
# 
# AArch64
# 
# GNU C Library (Ubuntu GLIBC 2.28-0ubuntu1) stable release version 2.28.
# Copyright (C) 2018 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 8.2.0.
# libc ABIs: UNIQUE ABSOLUTE
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 258256,
                      constraints: ["writable: x20+0x360", "x4+0x430 == NULL"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 258264,
                      constraints: ["writable: x20+0x360", "x4 == NULL"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 258328,
                      constraints: ["writable: x19+0x4", "writable: x20+0x360", "[x21] == NULL || x21 == NULL"],
                      effect: "execve(\"/bin/sh\", x21, environ)")
OneGadget::Gadget.add(build_id, 409712,
                      constraints: ["x2+0x438 == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", x2+0x438)")
OneGadget::Gadget.add(build_id, 409720,
                      constraints: ["x1+0x430 == NULL"],
                      effect: "execl(\"/bin/sh\", x1+0x430)")
OneGadget::Gadget.add(build_id, 409728,
                      constraints: ["x1 == NULL"],
                      effect: "execl(\"/bin/sh\", x1)")

