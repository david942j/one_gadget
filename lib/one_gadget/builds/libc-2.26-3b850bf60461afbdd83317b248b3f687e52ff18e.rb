require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc6_2.26-0ubuntu2_arm64/lib/aarch64-linux-gnu/libc-2.26.so
# 
# ARM 64-bit architecture
# 
# GNU C Library (Ubuntu GLIBC 2.26-0ubuntu2) stable release version 2.26, by Roland McGrath et al.
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
OneGadget::Gadget.add(build_id, 254784,
                      constraints: ["(u64)x0 <= 0xfffffffffffff000", "w0 == 0x0", "writable: x20+0x318", "x23 == NULL", "{\"sh\", \"-c\", x25, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 254788,
                      constraints: ["(u64)x0 <= 0xfffffffffffff000", "w0 == 0x0", "writable: x20+0x318", "x23 == NULL", "{\"sh\", \"-c\", x25, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 254796,
                      constraints: ["w0 == 0x0", "writable: x20+0x318", "x23 == NULL", "{\"sh\", \"-c\", x25, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 254800,
                      constraints: ["w0 == 0x0", "writable: x20+0x318", "x23 == NULL", "{\"sh\", \"-c\", x25, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 255548,
                      constraints: ["writable: x20+0x318", "x23 == NULL", "{\"sh\", \"-c\", x25, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 255552,
                      constraints: ["writable: x20+0x318", "x23 == NULL", "x3+0xca0 == NULL || {x3+0xca0, \"-c\", x25, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 255556,
                      constraints: ["writable: x20+0x318", "x23 == NULL", "x3 == NULL || {x3, \"-c\", x25, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 255560,
                      constraints: ["writable: x19+0x4", "writable: x20+0x318", "x23 == NULL", "x3 == NULL || {x3, \"-c\", x25, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 255564,
                      constraints: ["writable: x19+0x4", "writable: x20+0x318", "x23 == NULL", "x3 == NULL || {x3, x0+0xca8, x25, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 255568,
                      constraints: ["writable: x19+0x4", "writable: x20+0x318", "x23 == NULL", "x3 == NULL || {x3, x0, x25, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 255572,
                      constraints: ["writable: x19+0x4", "writable: x20+0x318", "x2 == NULL", "x23 == NULL", "x3 == NULL || {x3, x0, x25, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 255576,
                      constraints: ["writable: x19+0x4", "writable: x20+0x318", "x2 == NULL", "x23 == NULL", "[sp+0x70] == NULL || {[sp+0x70], [sp+0x78], x25, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 255580,
                      constraints: ["writable: x19+0x4", "writable: x20+0x318", "x1 == NULL", "x2 == NULL", "x23 == NULL", "[sp+0x70] == NULL || {[sp+0x70], [sp+0x78], x25, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 255584,
                      constraints: ["writable: x19+0x4", "writable: x20+0x318", "x1 == NULL", "x2 == NULL", "x23 == NULL", "[sp+0x70] == NULL || {[sp+0x70], [sp+0x78], [sp+0x80], [sp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 255588,
                      constraints: ["writable: x19+0x4", "writable: x20+0x318", "x1 == NULL", "x2 == NULL", "x23 == NULL", "[sp+0x70] == NULL || {[sp+0x70], [sp+0x78], [sp+0x80], [sp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 255592,
                      constraints: ["writable: x19+0x4", "writable: x20+0x318", "x23 == NULL", "[sp+0x70] == NULL || {[sp+0x70], [sp+0x78], [sp+0x80], [sp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 255596,
                      constraints: ["writable: x19+0x4", "writable: x20+0x318", "x23 == NULL", "[x21] == NULL || x21 == NULL || x21 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x21, environ)")
OneGadget::Gadget.add(build_id, 255600,
                      constraints: ["writable: x19+0x4", "writable: x20+0x318", "x2 == NULL", "x23 == NULL", "[x21] == NULL || x21 == NULL || x21 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x21, environ)")
OneGadget::Gadget.add(build_id, 255604,
                      constraints: ["writable: x19+0x4", "writable: x20+0x318", "x1 == NULL", "x2 == NULL", "x23 == NULL", "[x21] == NULL || x21 == NULL || x21 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x21, environ)")
OneGadget::Gadget.add(build_id, 255608,
                      constraints: ["writable: x19+0x4", "writable: x20+0x318", "x1 == NULL", "x2 == NULL", "x23 == NULL", "[x21] == NULL || x21 == NULL || x21 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x21, environ)")
OneGadget::Gadget.add(build_id, 255612,
                      constraints: ["writable: x19+0x4", "writable: x20+0x318", "x23 == NULL", "[x21] == NULL || x21 == NULL || x21 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x21, environ)")
OneGadget::Gadget.add(build_id, 255616,
                      constraints: ["writable: x19+0x4", "writable: x20+0x318", "x23 == NULL", "[x21] == NULL || x21 == NULL || x21 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x21, environ)")
OneGadget::Gadget.add(build_id, 255620,
                      constraints: ["writable: x19+0x4", "writable: x20+0x318", "x1 == NULL", "[x21] == NULL || x21 == NULL || x21 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x21, environ)")
OneGadget::Gadget.add(build_id, 255624,
                      constraints: ["writable: x19+0x4", "writable: x20+0x318", "x1 == NULL", "[x21] == NULL || x21 == NULL || x21 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x21, environ)")
OneGadget::Gadget.add(build_id, 255628,
                      constraints: ["writable: x19+0x4", "writable: x20+0x318", "[x21] == NULL || x21 == NULL || x21 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x21, environ)")
OneGadget::Gadget.add(build_id, 409132,
                      constraints: ["x2+0xca8 == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", x2+0xca8)")
OneGadget::Gadget.add(build_id, 409136,
                      constraints: ["x1+0xca0 == NULL"],
                      effect: "execl(\"/bin/sh\", x1+0xca0)")
OneGadget::Gadget.add(build_id, 409140,
                      constraints: ["x1+0xca0 == NULL"],
                      effect: "execl(\"/bin/sh\", x1+0xca0)")
OneGadget::Gadget.add(build_id, 409144,
                      constraints: ["x1+0xca0 == NULL"],
                      effect: "execl(\"/bin/sh\", x1+0xca0)")
OneGadget::Gadget.add(build_id, 409148,
                      constraints: ["x1 == NULL"],
                      effect: "execl(\"/bin/sh\", x1)")
OneGadget::Gadget.add(build_id, 409152,
                      constraints: ["x1 == NULL"],
                      effect: "execl(\"/bin/sh\", x1)")
OneGadget::Gadget.add(build_id, 665776,
                      constraints: ["[x1] == 0x0", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, x2)")
OneGadget::Gadget.add(build_id, 665780,
                      constraints: ["[x1] == 0x0", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp+0x40, x2)")
OneGadget::Gadget.add(build_id, 665784,
                      constraints: ["[x1] == 0x0", "x6 == NULL || {\"/bin/sh\", x6, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp+0x40, x2)")
OneGadget::Gadget.add(build_id, 665788,
                      constraints: ["[x1] == 0x0", "x6 == NULL || {\"/bin/sh\", x6, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp+0x40, x2)")
OneGadget::Gadget.add(build_id, 665792,
                      constraints: ["[x1] == 0x0", "x6 == NULL || {\"/bin/sh\", x6, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp+0x40, x2)")
OneGadget::Gadget.add(build_id, 665796,
                      constraints: ["[x1] == 0x0", "writable: x29+0x40", "x6 == NULL || {\"/bin/sh\", x6, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x2)")
OneGadget::Gadget.add(build_id, 665800,
                      constraints: ["[x1] == 0x0", "writable: x29+0x40", "x6 == NULL || {\"/bin/sh\", x6, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x2)")
OneGadget::Gadget.add(build_id, 665804,
                      constraints: ["[x1] == 0x0", "readable: [x19+0xec0]", "writable: x29+0x40", "x6 == NULL || {\"/bin/sh\", x6, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x2)")
OneGadget::Gadget.add(build_id, 665808,
                      constraints: ["readable: [x19+0xec0]", "writable: x29+0x40", "x0 == 0x0", "x6 == NULL || {\"/bin/sh\", x6, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x2)")
OneGadget::Gadget.add(build_id, 665812,
                      constraints: ["readable: [x19+0xec0]", "writable: x29+0x40", "x0 == 0x0", "x6 == NULL || {\"/bin/sh\", x6, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x2)")
OneGadget::Gadget.add(build_id, 665816,
                      constraints: ["readable: [x19+0xec0]", "writable: x29+0x40", "x0 == 0x0", "x6 == NULL || {\"/bin/sh\", x6, NULL} is a valid argv", "[x23] == NULL || x23 == NULL || x23 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x23)")
OneGadget::Gadget.add(build_id, 665820,
                      constraints: ["readable: x2", "writable: x29+0x40", "x0 == 0x0", "x6 == NULL || {\"/bin/sh\", x6, NULL} is a valid argv", "[x23] == NULL || x23 == NULL || x23 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x23)")
OneGadget::Gadget.add(build_id, 665824,
                      constraints: ["readable: x2", "writable: x29+0x40", "x0 == 0x0", "x6 == NULL || {\"/bin/sh\", x6, NULL} is a valid argv", "[x23] == NULL || x23 == NULL || x23 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x23)")
OneGadget::Gadget.add(build_id, 665828,
                      constraints: ["writable: x29+0x40", "x0 == 0x0", "x6 == NULL || {\"/bin/sh\", x6, NULL} is a valid argv", "[x23] == NULL || x23 == NULL || x23 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x23)")
OneGadget::Gadget.add(build_id, 665832,
                      constraints: ["writable: x29+0x40", "x0 == 0x0", "x6 == NULL || {\"/bin/sh\", x6, NULL} is a valid argv", "[x23] == NULL || x23 == NULL || x23 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x23)")
OneGadget::Gadget.add(build_id, 665836,
                      constraints: ["writable: x29+0x40", "x0 == 0x0", "x6 == NULL || {\"/bin/sh\", x6, NULL} is a valid argv", "[x23] == NULL || x23 == NULL || x23 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x23)")
OneGadget::Gadget.add(build_id, 665840,
                      constraints: ["writable: x29+0x40", "x6 == NULL || {\"/bin/sh\", x6, NULL} is a valid argv", "[x23] == NULL || x23 == NULL || x23 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x23)")
OneGadget::Gadget.add(build_id, 665872,
                      constraints: ["writable: x29+0x40", "x0 == 0x1", "x4 == 0x0", "x6 == NULL || {\"/bin/sh\", x6, NULL} is a valid argv", "[x23] == NULL || x23 == NULL || x23 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x23)")
OneGadget::Gadget.add(build_id, 665876,
                      constraints: ["writable: x29+0x40", "x0 == 0x1", "x6 == NULL || {\"/bin/sh\", x6, NULL} is a valid argv", "[x23] == NULL || x23 == NULL || x23 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x23)")
OneGadget::Gadget.add(build_id, 665996,
                      constraints: ["writable: x29+0x40", "x6 == NULL || {\"/bin/sh\", x6, NULL} is a valid argv", "[x23] == NULL || x23 == NULL || x23 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x23)")
OneGadget::Gadget.add(build_id, 666000,
                      constraints: ["writable: x29+0x40", "x6 == NULL || {\"/bin/sh\", x6, NULL} is a valid argv", "[x23] == NULL || x23 == NULL || x23 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x23)")

