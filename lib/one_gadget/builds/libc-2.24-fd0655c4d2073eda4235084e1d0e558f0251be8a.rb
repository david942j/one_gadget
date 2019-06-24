require 'one_gadget/gadget'
# https://gitlab.com/libcdb/libcdb/blob/master/libc/aarch64-linux-gnu-glibc-2.24-1-any.pkg.tar/usr/aarch64-linux-gnu/lib/libc-2.24.so
# 
# AArch64
# 
# GNU C Library (GNU libc) stable release version 2.24, by Roland McGrath et al.
# Copyright (C) 2016 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 6.1.1 20161110.
# Available extensions:
# 	crypt add-on version 2.1 by Michael Glad and others
# 	GNU Libidn by Simon Josefsson
# 	Native POSIX Threads Library by Ulrich Drepper et al
# 	BIND-8.2.3-T5B
# libc ABIs: UNIQUE
# For bug reporting instructions, please see:
# <https://bugs.archlinux.org/>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 248104,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x4+0xad0 == NULL"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 248116,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x4 == NULL"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 248176,
                      constraints: ["writable: x20+0x4", "[x22] == NULL || x22 == NULL"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 398468,
                      constraints: ["x2+0xad8 == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", x2+0xad8)")
OneGadget::Gadget.add(build_id, 398472,
                      constraints: ["x1+0xad0 == NULL"],
                      effect: "execl(\"/bin/sh\", x1+0xad0)")

