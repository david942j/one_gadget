require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc6_2.24-9ubuntu2.2_arm64/lib/aarch64-linux-gnu/libc-2.24.so
# 
# ARM 64-bit architecture
# 
# GNU C Library (Ubuntu GLIBC 2.24-9ubuntu2.2) stable release version 2.24, by Roland McGrath et al.
# Copyright (C) 2016 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 6.3.0 20170406.
# Available extensions:
# 	crypt add-on version 2.1 by Michael Glad and others
# 	GNU Libidn by Simon Josefsson
# 	Native POSIX Threads Library by Ulrich Drepper et al
# 	BIND-8.2.3-T5B
# libc ABIs: UNIQUE
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 247628,
                      constraints: ["(u64)x0 <= 0xfffffffffffff000", "w0 == 0x0", "writable: x19+0x258", "x22 == NULL", "{\"sh\", \"-c\", x24, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x68, environ)")
OneGadget::Gadget.add(build_id, 247632,
                      constraints: ["(u64)x0 <= 0xfffffffffffff000", "w0 == 0x0", "writable: x19+0x258", "x22 == NULL", "{\"sh\", \"-c\", x24, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x68, environ)")
OneGadget::Gadget.add(build_id, 247640,
                      constraints: ["w0 == 0x0", "writable: x19+0x258", "x22 == NULL", "{\"sh\", \"-c\", x24, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x68, environ)")
OneGadget::Gadget.add(build_id, 247644,
                      constraints: ["w0 == 0x0", "writable: x19+0x258", "x22 == NULL", "{\"sh\", \"-c\", x24, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x68, environ)")
OneGadget::Gadget.add(build_id, 248396,
                      constraints: ["writable: x19+0x258", "x22 == NULL", "{\"sh\", \"-c\", x24, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x68, environ)")
OneGadget::Gadget.add(build_id, 248400,
                      constraints: ["writable: x19+0x258", "x22 == NULL", "x3+0xbb8 == NULL || {x3+0xbb8, \"-c\", x24, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x68, environ)")
OneGadget::Gadget.add(build_id, 248404,
                      constraints: ["writable: x19+0x258", "x22 == NULL", "x3 == NULL || {x3, \"-c\", x24, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x68, environ)")
OneGadget::Gadget.add(build_id, 248408,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x22 == NULL", "x3 == NULL || {x3, \"-c\", x24, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x68, environ)")
OneGadget::Gadget.add(build_id, 248412,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x22 == NULL", "x3 == NULL || {x3, x0+0xbc0, x24, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x68, environ)")
OneGadget::Gadget.add(build_id, 248416,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x22 == NULL", "x3 == NULL || {x3, x0, x24, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x68, environ)")
OneGadget::Gadget.add(build_id, 248420,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x2 == NULL", "x22 == NULL", "x3 == NULL || {x3, x0, x24, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x68, environ)")
OneGadget::Gadget.add(build_id, 248424,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x2 == NULL", "x22 == NULL", "[sp+0x68] == NULL || {[sp+0x68], [sp+0x70], x24, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x68, environ)")
OneGadget::Gadget.add(build_id, 248428,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x1 == NULL", "x2 == NULL", "x22 == NULL", "[sp+0x68] == NULL || {[sp+0x68], [sp+0x70], x24, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x68, environ)")
OneGadget::Gadget.add(build_id, 248432,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x1 == NULL", "x2 == NULL", "x22 == NULL", "[sp+0x68] == NULL || {[sp+0x68], [sp+0x70], [sp+0x78], [sp+0x80], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x68, environ)")
OneGadget::Gadget.add(build_id, 248436,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x1 == NULL", "x2 == NULL", "x22 == NULL", "[sp+0x68] == NULL || {[sp+0x68], [sp+0x70], [sp+0x78], [sp+0x80], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x68, environ)")
OneGadget::Gadget.add(build_id, 248440,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x22 == NULL", "[sp+0x68] == NULL || {[sp+0x68], [sp+0x70], [sp+0x78], [sp+0x80], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x68, environ)")
OneGadget::Gadget.add(build_id, 248444,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x22 == NULL", "[x21] == NULL || x21 == NULL || x21 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x21, environ)")
OneGadget::Gadget.add(build_id, 248448,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x2 == NULL", "x22 == NULL", "[x21] == NULL || x21 == NULL || x21 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x21, environ)")
OneGadget::Gadget.add(build_id, 248452,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x1 == NULL", "x2 == NULL", "x22 == NULL", "[x21] == NULL || x21 == NULL || x21 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x21, environ)")
OneGadget::Gadget.add(build_id, 248456,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x1 == NULL", "x2 == NULL", "x22 == NULL", "[x21] == NULL || x21 == NULL || x21 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x21, environ)")
OneGadget::Gadget.add(build_id, 248460,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x22 == NULL", "[x21] == NULL || x21 == NULL || x21 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x21, environ)")
OneGadget::Gadget.add(build_id, 248464,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x22 == NULL", "[x21] == NULL || x21 == NULL || x21 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x21, environ)")
OneGadget::Gadget.add(build_id, 248468,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x1 == NULL", "[x21] == NULL || x21 == NULL || x21 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x21, environ)")
OneGadget::Gadget.add(build_id, 248472,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x1 == NULL", "[x21] == NULL || x21 == NULL || x21 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x21, environ)")
OneGadget::Gadget.add(build_id, 248476,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "[x21] == NULL || x21 == NULL || x21 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x21, environ)")
OneGadget::Gadget.add(build_id, 398984,
                      constraints: ["x2+0xbc0 == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", x2+0xbc0)")
OneGadget::Gadget.add(build_id, 398988,
                      constraints: ["x1+0xbb8 == NULL"],
                      effect: "execl(\"/bin/sh\", x1+0xbb8)")
OneGadget::Gadget.add(build_id, 398992,
                      constraints: ["x1+0xbb8 == NULL"],
                      effect: "execl(\"/bin/sh\", x1+0xbb8)")
OneGadget::Gadget.add(build_id, 398996,
                      constraints: ["x1+0xbb8 == NULL"],
                      effect: "execl(\"/bin/sh\", x1+0xbb8)")
OneGadget::Gadget.add(build_id, 399000,
                      constraints: ["x1 == NULL"],
                      effect: "execl(\"/bin/sh\", x1)")
OneGadget::Gadget.add(build_id, 399004,
                      constraints: ["x1 == NULL"],
                      effect: "execl(\"/bin/sh\", x1)")
OneGadget::Gadget.add(build_id, 643640,
                      constraints: ["[x1] == 0x0", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x50, x2)")

