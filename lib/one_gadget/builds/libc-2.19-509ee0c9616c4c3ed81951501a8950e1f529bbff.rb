require 'one_gadget/gadget'
# https://gitlab.com/libcdb/libcdb/blob/master/libc/libc6-2.19-12/lib/aarch64-linux-gnu/libc-2.19.so
# 
# AArch64
# 
# GNU C Library (Debian GLIBC 2.19-12) stable release version 2.19, by Roland McGrath et al.
# Copyright (C) 2014 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 4.8.3.
# Compiled on a Linux 3.16.5 system on 2014-10-25.
# Available extensions:
# 	crypt add-on version 2.1 by Michael Glad and others
# 	GNU Libidn by Simon Josefsson
# 	Native POSIX Threads Library by Ulrich Drepper et al
# 	BIND-8.2.3-T5B
# libc ABIs: UNIQUE
# For bug reporting instructions, please see:
# <http://www.debian.org/Bugs/>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 261532,
                      constraints: ["writable: x21+0x2d8", "x3+0x6c0 == NULL"],
                      effect: "execve(\"/bin/sh\", sp+0x68, environ)")
OneGadget::Gadget.add(build_id, 261540,
                      constraints: ["writable: x20", "writable: x21+0x2d8", "[x20] == NULL || x20 == NULL"],
                      effect: "execve(\"/bin/sh\", x20, environ)")
OneGadget::Gadget.add(build_id, 261616,
                      constraints: ["writable: x21+0x2d8", "writable: x24+0x4", "[x20] == NULL || x20 == NULL"],
                      effect: "execve(\"/bin/sh\", x20, environ)")
OneGadget::Gadget.add(build_id, 261628,
                      constraints: ["writable: x21+0x2d8", "writable: x24+0x4", "[x1] == NULL || x1 == NULL", "[[x0]] == NULL || [x0] == NULL"],
                      effect: "execve(\"/bin/sh\", x1, [x0])")
OneGadget::Gadget.add(build_id, 261632,
                      constraints: ["writable: x21+0x2d8", "writable: x24+0x4", "[x1] == NULL || x1 == NULL", "[x2] == NULL || x2 == NULL"],
                      effect: "execve(\"/bin/sh\", x1, x2)")

