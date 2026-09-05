require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc6_2.19-10ubuntu2_arm64/lib/aarch64-linux-gnu/libc-2.19.so
# 
# ARM 64-bit architecture
# 
# GNU C Library (Ubuntu GLIBC 2.19-10ubuntu2) stable release version 2.19, by Roland McGrath et al.
# Copyright (C) 2014 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 4.8.3.
# Compiled on a Linux 3.16.3 system on 2014-09-30.
# Available extensions:
# 	crypt add-on version 2.1 by Michael Glad and others
# 	GNU Libidn by Simon Josefsson
# 	Native POSIX Threads Library by Ulrich Drepper et al
# 	BIND-8.2.3-T5B
# libc ABIs: UNIQUE
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 260960,
                      constraints: ["(u64)x0 <= 0xfffffffffffff000", "w0 == 0x0", "writable: x2", "writable: x21+0x2e0", "x23 == NULL", "{\"sh\", \"-c\", x22, x1, ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x68, environ)")
OneGadget::Gadget.add(build_id, 260972,
                      constraints: ["w0 == 0x0", "writable: x2", "writable: x21+0x2e0", "x23 == NULL", "{\"sh\", \"-c\", x22, x1, ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x68, environ)")
OneGadget::Gadget.add(build_id, 260976,
                      constraints: ["w0 == 0x0", "writable: x21+0x2e0", "x23 == NULL", "{\"sh\", \"-c\", x22, x1, ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x68, environ)")
OneGadget::Gadget.add(build_id, 261720,
                      constraints: ["writable: x21+0x2e0", "x23 == NULL", "{\"sh\", \"-c\", x22, x1, ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x68, environ)")
OneGadget::Gadget.add(build_id, 261724,
                      constraints: ["writable: x21+0x2e0", "x23 == NULL", "x3+0x9e0 == NULL || {x3+0x9e0, \"-c\", x22, x1, ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x68, environ)")
OneGadget::Gadget.add(build_id, 261728,
                      constraints: ["writable: x20", "writable: x21+0x2e0", "x23 == NULL", "x3+0x9e0 == NULL || {x3+0x9e0, \"-c\", x22, x1, ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", x20, environ)")
OneGadget::Gadget.add(build_id, 261732,
                      constraints: ["writable: x20", "writable: x21+0x2e0", "x23 == NULL", "x3 == NULL || {x3, \"-c\", x22, x1, ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", x20, environ)")
OneGadget::Gadget.add(build_id, 261736,
                      constraints: ["writable: x20", "writable: x21+0x2e0", "writable: x24+0x4", "x23 == NULL", "x3 == NULL || {x3, \"-c\", x22, x1, ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", x20, environ)")
OneGadget::Gadget.add(build_id, 261740,
                      constraints: ["writable: x20+0x8", "writable: x21+0x2e0", "writable: x24+0x4", "x23 == NULL", "[x20] == NULL || x20 == NULL || x20 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x20, environ)")
OneGadget::Gadget.add(build_id, 261744,
                      constraints: ["writable: x20+0x8", "writable: x21+0x2e0", "writable: x24+0x4", "x23 == NULL", "[x20] == NULL || x20 == NULL || x20 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x20, environ)")
OneGadget::Gadget.add(build_id, 261748,
                      constraints: ["writable: x20+0x8", "writable: x21+0x2e0", "writable: x24+0x4", "x23 == NULL", "[x20] == NULL || x20 == NULL || x20 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x20, environ)")
OneGadget::Gadget.add(build_id, 261752,
                      constraints: ["writable: x20+0x8", "writable: x21+0x2e0", "writable: x24+0x4", "x23 == NULL", "[x20] == NULL || x20 == NULL || x20 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x20, environ)")
OneGadget::Gadget.add(build_id, 261756,
                      constraints: ["writable: x20+0x8", "writable: x21+0x2e0", "writable: x24+0x4", "x2 == NULL", "x23 == NULL", "[x20] == NULL || x20 == NULL || x20 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x20, environ)")
OneGadget::Gadget.add(build_id, 261760,
                      constraints: ["writable: x20+0x8", "writable: x21+0x2e0", "writable: x24+0x4", "x1 == NULL", "x2 == NULL", "x23 == NULL", "[x20] == NULL || x20 == NULL || x20 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x20, environ)")
OneGadget::Gadget.add(build_id, 261764,
                      constraints: ["writable: x20+0x8", "writable: x21+0x2e0", "writable: x24+0x4", "x1 == NULL", "x2 == NULL", "x23 == NULL", "[x20] == NULL || x20 == NULL || x20 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x20, environ)")
OneGadget::Gadget.add(build_id, 261768,
                      constraints: ["writable: x20+0x10", "writable: x21+0x2e0", "writable: x24+0x4", "x1 == NULL", "x2 == NULL", "x23 == NULL", "[x20] == NULL || x20 == NULL || x20 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x20, environ)")
OneGadget::Gadget.add(build_id, 261772,
                      constraints: ["writable: x21+0x2e0", "writable: x24+0x4", "x1 == NULL", "x2 == NULL", "x23 == NULL", "[x20] == NULL || x20 == NULL || x20 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x20, environ)")
OneGadget::Gadget.add(build_id, 261776,
                      constraints: ["writable: x21+0x2e0", "writable: x24+0x4", "x23 == NULL", "[x20] == NULL || x20 == NULL || x20 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x20, environ)")
OneGadget::Gadget.add(build_id, 261780,
                      constraints: ["writable: x21+0x2e0", "writable: x24+0x4", "x1 == NULL", "x23 == NULL", "[x20] == NULL || x20 == NULL || x20 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x20, environ)")
OneGadget::Gadget.add(build_id, 261784,
                      constraints: ["writable: x21+0x2e0", "writable: x24+0x4", "x1 == NULL", "x2 == NULL", "x23 == NULL", "[x20] == NULL || x20 == NULL || x20 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x20, environ)")
OneGadget::Gadget.add(build_id, 261788,
                      constraints: ["writable: x21+0x2e0", "writable: x24+0x4", "x1 == NULL", "x2 == NULL", "x23 == NULL", "[x20] == NULL || x20 == NULL || x20 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x20, environ)")
OneGadget::Gadget.add(build_id, 261792,
                      constraints: ["writable: x21+0x2e0", "writable: x24+0x4", "x23 == NULL", "[x20] == NULL || x20 == NULL || x20 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x20, environ)")
OneGadget::Gadget.add(build_id, 261796,
                      constraints: ["writable: x21+0x2e0", "writable: x24+0x4", "x1 == NULL", "[x20] == NULL || x20 == NULL || x20 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x20, environ)")
OneGadget::Gadget.add(build_id, 261800,
                      constraints: ["writable: x21+0x2e0", "writable: x24+0x4", "x1 == NULL", "[x20] == NULL || x20 == NULL || x20 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x20, environ)")
OneGadget::Gadget.add(build_id, 261804,
                      constraints: ["writable: x21+0x2e0", "writable: x24+0x4", "x1 == NULL", "[x20] == NULL || x20 == NULL || x20 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x20, environ)")
OneGadget::Gadget.add(build_id, 261808,
                      constraints: ["writable: x21+0x2e0", "writable: x24+0x4", "[x20] == NULL || x20 == NULL || x20 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x20, environ)")
OneGadget::Gadget.add(build_id, 261816,
                      constraints: ["readable: x0", "writable: x21+0x2e0", "writable: x24+0x4", "[x20] == NULL || x20 == NULL || x20 is a valid argv", "[[x0]] == NULL || [x0] == NULL || [x0] is a valid envp"],
                      effect: "execve(\"/bin/sh\", x20, [x0])")
OneGadget::Gadget.add(build_id, 261820,
                      constraints: ["readable: x0", "writable: x21+0x2e0", "writable: x24+0x4", "[x1] == NULL || x1 == NULL || x1 is a valid argv", "[[x0]] == NULL || [x0] == NULL || [x0] is a valid envp"],
                      effect: "execve(\"/bin/sh\", x1, [x0])")
OneGadget::Gadget.add(build_id, 261824,
                      constraints: ["writable: x21+0x2e0", "writable: x24+0x4", "[x1] == NULL || x1 == NULL || x1 is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x1, x2)")
OneGadget::Gadget.add(build_id, 651740,
                      constraints: ["w19 == 0x1", "x20 == NULL || {\"sh\", x20, [sp+0x10], [sp+0x18], ...} is a valid argv", "[x22] == NULL || x22 == NULL || x22 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp, x22)")
OneGadget::Gadget.add(build_id, 651744,
                      constraints: ["w19 == 0x1", "writable: x1", "x20 == NULL || {\"sh\", x20, [x1+0x10], [x1+0x18], ...} is a valid argv", "[x22] == NULL || x22 == NULL || x22 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x1, x22)")
OneGadget::Gadget.add(build_id, 651748,
                      constraints: ["w19 == 0x1", "writable: x1", "x20 == NULL || {\"sh\", x20, [x1+0x10], [x1+0x18], ...} is a valid argv", "[x22] == NULL || x22 == NULL || x22 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x1, x22)")
OneGadget::Gadget.add(build_id, 652492,
                      constraints: ["w19 == 0x1", "writable: x0", "x20 == NULL || {\"sh\", x20, [x0+0x10], [x0+0x18], ...} is a valid argv", "[x22] == NULL || x22 == NULL || x22 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x0, x22)")
OneGadget::Gadget.add(build_id, 652496,
                      constraints: ["w19 == 0x1", "writable: x0", "x20 == NULL || {\"sh\", x20, [x0+0x10], [x0+0x18], ...} is a valid argv", "[x22] == NULL || x22 == NULL || x22 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x0, x22)")
OneGadget::Gadget.add(build_id, 652500,
                      constraints: ["w19 == 0x1", "writable: x1", "x0 != 0x0", "x20 == NULL || {\"sh\", x20, [x1+0x10], [x1+0x18], ...} is a valid argv", "[x22] == NULL || x22 == NULL || x22 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x1, x22)")

