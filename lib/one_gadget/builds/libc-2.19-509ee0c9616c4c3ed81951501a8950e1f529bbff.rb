require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc6-2.19-12/lib/aarch64-linux-gnu/libc-2.19.so
# 
# ARM 64-bit architecture
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
OneGadget::Gadget.add(build_id, 260768,
                      constraints: ["(u64)x0 <= 0xfffffffffffff000", "w0 == 0x0", "writable: x2", "writable: x21+0x2d8", "x23 == NULL", "{\"sh\", \"-c\", x22, x1, ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x68, environ)")
OneGadget::Gadget.add(build_id, 260780,
                      constraints: ["w0 == 0x0", "writable: x2", "writable: x21+0x2d8", "x23 == NULL", "{\"sh\", \"-c\", x22, x1, ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x68, environ)")
OneGadget::Gadget.add(build_id, 260784,
                      constraints: ["w0 == 0x0", "writable: x21+0x2d8", "x23 == NULL", "{\"sh\", \"-c\", x22, x1, ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x68, environ)")
OneGadget::Gadget.add(build_id, 261528,
                      constraints: ["writable: x21+0x2d8", "x23 == NULL", "{\"sh\", \"-c\", x22, x1, ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x68, environ)")
OneGadget::Gadget.add(build_id, 261532,
                      constraints: ["writable: x21+0x2d8", "x23 == NULL", "x3+0x6c0 == NULL || {x3+0x6c0, \"-c\", x22, x1, ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x68, environ)")
OneGadget::Gadget.add(build_id, 261536,
                      constraints: ["writable: x20", "writable: x21+0x2d8", "x23 == NULL", "x3+0x6c0 == NULL || {x3+0x6c0, \"-c\", x22, x1, ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", x20, environ)")
OneGadget::Gadget.add(build_id, 261540,
                      constraints: ["writable: x20", "writable: x21+0x2d8", "x23 == NULL", "x3 == NULL || {x3, \"-c\", x22, x1, ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", x20, environ)")
OneGadget::Gadget.add(build_id, 261544,
                      constraints: ["writable: x20", "writable: x21+0x2d8", "writable: x24+0x4", "x23 == NULL", "x3 == NULL || {x3, \"-c\", x22, x1, ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", x20, environ)")
OneGadget::Gadget.add(build_id, 261548,
                      constraints: ["writable: x20+0x8", "writable: x21+0x2d8", "writable: x24+0x4", "x23 == NULL", "[x20] == NULL || x20 == NULL || x20 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x20, environ)")
OneGadget::Gadget.add(build_id, 261552,
                      constraints: ["writable: x20+0x8", "writable: x21+0x2d8", "writable: x24+0x4", "x23 == NULL", "[x20] == NULL || x20 == NULL || x20 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x20, environ)")
OneGadget::Gadget.add(build_id, 261556,
                      constraints: ["writable: x20+0x8", "writable: x21+0x2d8", "writable: x24+0x4", "x23 == NULL", "[x20] == NULL || x20 == NULL || x20 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x20, environ)")
OneGadget::Gadget.add(build_id, 261560,
                      constraints: ["writable: x20+0x8", "writable: x21+0x2d8", "writable: x24+0x4", "x23 == NULL", "[x20] == NULL || x20 == NULL || x20 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x20, environ)")
OneGadget::Gadget.add(build_id, 261564,
                      constraints: ["writable: x20+0x8", "writable: x21+0x2d8", "writable: x24+0x4", "x2 == NULL", "x23 == NULL", "[x20] == NULL || x20 == NULL || x20 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x20, environ)")
OneGadget::Gadget.add(build_id, 261568,
                      constraints: ["writable: x20+0x8", "writable: x21+0x2d8", "writable: x24+0x4", "x1 == NULL", "x2 == NULL", "x23 == NULL", "[x20] == NULL || x20 == NULL || x20 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x20, environ)")
OneGadget::Gadget.add(build_id, 261572,
                      constraints: ["writable: x20+0x8", "writable: x21+0x2d8", "writable: x24+0x4", "x1 == NULL", "x2 == NULL", "x23 == NULL", "[x20] == NULL || x20 == NULL || x20 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x20, environ)")
OneGadget::Gadget.add(build_id, 261576,
                      constraints: ["writable: x20+0x10", "writable: x21+0x2d8", "writable: x24+0x4", "x1 == NULL", "x2 == NULL", "x23 == NULL", "[x20] == NULL || x20 == NULL || x20 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x20, environ)")
OneGadget::Gadget.add(build_id, 261580,
                      constraints: ["writable: x21+0x2d8", "writable: x24+0x4", "x1 == NULL", "x2 == NULL", "x23 == NULL", "[x20] == NULL || x20 == NULL || x20 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x20, environ)")
OneGadget::Gadget.add(build_id, 261584,
                      constraints: ["writable: x21+0x2d8", "writable: x24+0x4", "x23 == NULL", "[x20] == NULL || x20 == NULL || x20 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x20, environ)")
OneGadget::Gadget.add(build_id, 261588,
                      constraints: ["writable: x21+0x2d8", "writable: x24+0x4", "x1 == NULL", "x23 == NULL", "[x20] == NULL || x20 == NULL || x20 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x20, environ)")
OneGadget::Gadget.add(build_id, 261592,
                      constraints: ["writable: x21+0x2d8", "writable: x24+0x4", "x1 == NULL", "x2 == NULL", "x23 == NULL", "[x20] == NULL || x20 == NULL || x20 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x20, environ)")
OneGadget::Gadget.add(build_id, 261596,
                      constraints: ["writable: x21+0x2d8", "writable: x24+0x4", "x1 == NULL", "x2 == NULL", "x23 == NULL", "[x20] == NULL || x20 == NULL || x20 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x20, environ)")
OneGadget::Gadget.add(build_id, 261600,
                      constraints: ["writable: x21+0x2d8", "writable: x24+0x4", "x23 == NULL", "[x20] == NULL || x20 == NULL || x20 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x20, environ)")
OneGadget::Gadget.add(build_id, 261604,
                      constraints: ["writable: x21+0x2d8", "writable: x24+0x4", "x1 == NULL", "[x20] == NULL || x20 == NULL || x20 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x20, environ)")
OneGadget::Gadget.add(build_id, 261608,
                      constraints: ["writable: x21+0x2d8", "writable: x24+0x4", "x1 == NULL", "[x20] == NULL || x20 == NULL || x20 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x20, environ)")
OneGadget::Gadget.add(build_id, 261612,
                      constraints: ["writable: x21+0x2d8", "writable: x24+0x4", "x1 == NULL", "[x20] == NULL || x20 == NULL || x20 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x20, environ)")
OneGadget::Gadget.add(build_id, 261616,
                      constraints: ["writable: x21+0x2d8", "writable: x24+0x4", "[x20] == NULL || x20 == NULL || x20 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x20, environ)")
OneGadget::Gadget.add(build_id, 261624,
                      constraints: ["readable: x0", "writable: x21+0x2d8", "writable: x24+0x4", "[x20] == NULL || x20 == NULL || x20 is a valid argv", "[[x0]] == NULL || [x0] == NULL || [x0] is a valid envp"],
                      effect: "execve(\"/bin/sh\", x20, [x0])")
OneGadget::Gadget.add(build_id, 261628,
                      constraints: ["readable: x0", "writable: x21+0x2d8", "writable: x24+0x4", "[x1] == NULL || x1 == NULL || x1 is a valid argv", "[[x0]] == NULL || [x0] == NULL || [x0] is a valid envp"],
                      effect: "execve(\"/bin/sh\", x1, [x0])")
OneGadget::Gadget.add(build_id, 261632,
                      constraints: ["writable: x21+0x2d8", "writable: x24+0x4", "[x1] == NULL || x1 == NULL || x1 is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x1, x2)")
OneGadget::Gadget.add(build_id, 651036,
                      constraints: ["w19 == 0x1", "x20 == NULL || {\"sh\", x20, [sp+0x10], [sp+0x18], ...} is a valid argv", "[x22] == NULL || x22 == NULL || x22 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp, x22)")
OneGadget::Gadget.add(build_id, 651040,
                      constraints: ["w19 == 0x1", "writable: x1", "x20 == NULL || {\"sh\", x20, [x1+0x10], [x1+0x18], ...} is a valid argv", "[x22] == NULL || x22 == NULL || x22 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x1, x22)")
OneGadget::Gadget.add(build_id, 651044,
                      constraints: ["w19 == 0x1", "writable: x1", "x20 == NULL || {\"sh\", x20, [x1+0x10], [x1+0x18], ...} is a valid argv", "[x22] == NULL || x22 == NULL || x22 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x1, x22)")
OneGadget::Gadget.add(build_id, 651788,
                      constraints: ["w19 == 0x1", "writable: x0", "x20 == NULL || {\"sh\", x20, [x0+0x10], [x0+0x18], ...} is a valid argv", "[x22] == NULL || x22 == NULL || x22 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x0, x22)")
OneGadget::Gadget.add(build_id, 651792,
                      constraints: ["w19 == 0x1", "writable: x0", "x20 == NULL || {\"sh\", x20, [x0+0x10], [x0+0x18], ...} is a valid argv", "[x22] == NULL || x22 == NULL || x22 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x0, x22)")
OneGadget::Gadget.add(build_id, 651796,
                      constraints: ["w19 == 0x1", "writable: x1", "x0 != 0x0", "x20 == NULL || {\"sh\", x20, [x1+0x10], [x1+0x18], ...} is a valid argv", "[x22] == NULL || x22 == NULL || x22 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x1, x22)")

