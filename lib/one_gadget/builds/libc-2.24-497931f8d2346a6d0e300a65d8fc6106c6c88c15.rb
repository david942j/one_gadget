require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc6_2.24-3ubuntu2.2_arm64/lib/aarch64-linux-gnu/libc-2.24.so
# 
# ARM 64-bit architecture
# 
# GNU C Library (Ubuntu GLIBC 2.24-3ubuntu2.2) stable release version 2.24, by Roland McGrath et al.
# Copyright (C) 2016 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 6.2.0 20161005.
# Available extensions:
# 	crypt add-on version 2.1 by Michael Glad and others
# 	GNU Libidn by Simon Josefsson
# 	Native POSIX Threads Library by Ulrich Drepper et al
# 	BIND-8.2.3-T5B
# libc ABIs: UNIQUE
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 247528,
                      constraints: ["(u64)x0 <= 0xfffffffffffff000", "w0 == 0x0", "writable: x19+0x258", "x21 == NULL", "{\"sh\", \"-c\", x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 247536,
                      constraints: ["w0 == 0x0", "writable: x19+0x258", "x21 == NULL", "{\"sh\", \"-c\", x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 248276,
                      constraints: ["writable: x19+0x258", "x21 == NULL", "{\"sh\", \"-c\", x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 248280,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x21 == NULL", "{\"sh\", \"-c\", x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 248284,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x21 == NULL", "x4+0x3a8 == NULL || {x4+0x3a8, \"-c\", x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 248288,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x21 == NULL", "x4+0x3a8 == NULL || {x4+0x3a8, x3+0x3b0, x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 248292,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x21 == NULL", "x4 == NULL || {x4, x3+0x3b0, x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 248296,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x21 == NULL", "x4 == NULL || {x4, x3, x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 248300,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x1 == NULL", "x21 == NULL", "x4 == NULL || {x4, x3, x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 248304,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x1 == NULL", "x2 == NULL", "x21 == NULL", "x4 == NULL || {x4, x3, x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 248308,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x1 == NULL", "x2 == NULL", "x21 == NULL", "x4 == NULL || {x4, x3, x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 248312,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x1 == NULL", "x2 == NULL", "x21 == NULL", "[sp+0x58] == NULL || {[sp+0x58], [sp+0x60], x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 248316,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x1 == NULL", "x2 == NULL", "x21 == NULL", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 248320,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x1 == NULL", "x2 == NULL", "x21 == NULL", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 248324,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x21 == NULL", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 248328,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x1 == NULL", "x21 == NULL", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 248332,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x1 == NULL", "x2 == NULL", "x21 == NULL", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 248336,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x1 == NULL", "x2 == NULL", "x21 == NULL", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 248340,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x21 == NULL", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 248344,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x1 == NULL", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 248348,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x1 == NULL", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 248352,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x1 == NULL", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 248356,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 248360,
                      constraints: ["writable: x20+0x4", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 398708,
                      constraints: ["x2+0x3b0 == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", x2+0x3b0)")
OneGadget::Gadget.add(build_id, 398712,
                      constraints: ["x1+0x3a8 == NULL"],
                      effect: "execl(\"/bin/sh\", x1+0x3a8)")
OneGadget::Gadget.add(build_id, 643672,
                      constraints: ["[x1] == 0x0", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x50, x2)")
OneGadget::Gadget.add(build_id, 643676,
                      constraints: ["[x4] == 0x0", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x50, x2)")

