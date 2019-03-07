require 'one_gadget/gadget'
# spec/data/aarch64-libc-2.27.so
# 
# AArch64
# 
# GNU C Library (Ubuntu GLIBC 2.27-3ubuntu1) stable release version 2.27.
# Copyright (C) 2018 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 7.3.0.
# libc ABIs: UNIQUE
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 258396,
                      constraints: ["writable: x20+0x338", "x3+0x7c0 == NULL"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 258400,
                      constraints: ["writable: x20+0x338", "x3 == NULL"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 258436,
                      constraints: ["writable: x19+0x4", "writable: x20+0x338", "[sp+0x70] == NULL"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 258472,
                      constraints: ["writable: x19+0x4", "writable: x20+0x338", "[x21] == NULL || x21 == NULL"],
                      effect: "execve(\"/bin/sh\", x21, environ)")
OneGadget::Gadget.add(build_id, 409212,
                      constraints: ["x2+0x7c8 == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", x2+0x7c8)")
OneGadget::Gadget.add(build_id, 409224,
                      constraints: ["x1+0x7c0 == NULL"],
                      effect: "execl(\"/bin/sh\", x1+0x7c0)")
OneGadget::Gadget.add(build_id, 409232,
                      constraints: ["x1 == NULL"],
                      effect: "execl(\"/bin/sh\", x1)")

