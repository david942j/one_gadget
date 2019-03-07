require 'one_gadget/gadget'
# spec/data/aarch64-libc-2.23.so
# 
# AArch64
# 
# GNU C Library (Ubuntu GLIBC 2.23-0ubuntu10) stable release version 2.23, by Roland McGrath et al.
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
# libc ABIs: UNIQUE
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 251600,
                      constraints: ["writable: x19+0x260", "writable: x20+0x4", "x4+0x990 == NULL"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 251612,
                      constraints: ["writable: x19+0x260", "writable: x20+0x4", "x4 == NULL"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 251672,
                      constraints: ["writable: x20+0x4", "[x22] == NULL || x22 == NULL"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 396316,
                      constraints: ["x2+0x998 == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", x2+0x998)")
OneGadget::Gadget.add(build_id, 396320,
                      constraints: ["x1+0x990 == NULL"],
                      effect: "execl(\"/bin/sh\", x1+0x990)")

