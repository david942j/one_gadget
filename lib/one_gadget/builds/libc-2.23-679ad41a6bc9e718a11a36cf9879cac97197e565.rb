require 'one_gadget/gadget'
# spec/data/aarch64-libc-2.23.so
# 
# ARM 64-bit architecture
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
OneGadget::Gadget.add(build_id, 250840,
                      constraints: ["(u64)x0 <= 0xfffffffffffff000", "w0 == 0x0", "writable: x19+0x260", "x21 == NULL", "{\"sh\", \"-c\", x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 250848,
                      constraints: ["w0 == 0x0", "writable: x19+0x260", "x21 == NULL", "{\"sh\", \"-c\", x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 251588,
                      constraints: ["writable: x19+0x260", "x21 == NULL", "{\"sh\", \"-c\", x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 251592,
                      constraints: ["writable: x19+0x260", "writable: x20+0x4", "x21 == NULL", "{\"sh\", \"-c\", x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 251596,
                      constraints: ["writable: x19+0x260", "writable: x20+0x4", "x21 == NULL", "x4+0x990 == NULL || {x4+0x990, \"-c\", x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 251600,
                      constraints: ["writable: x19+0x260", "writable: x20+0x4", "x21 == NULL", "x4+0x990 == NULL || {x4+0x990, x3+0x998, x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 251604,
                      constraints: ["writable: x19+0x260", "writable: x20+0x4", "x21 == NULL", "x4 == NULL || {x4, x3+0x998, x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 251608,
                      constraints: ["writable: x19+0x260", "writable: x20+0x4", "x21 == NULL", "x4 == NULL || {x4, x3, x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 251612,
                      constraints: ["writable: x19+0x260", "writable: x20+0x4", "x1 == NULL", "x21 == NULL", "x4 == NULL || {x4, x3, x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 251616,
                      constraints: ["writable: x19+0x260", "writable: x20+0x4", "x1 == NULL", "x2 == NULL", "x21 == NULL", "x4 == NULL || {x4, x3, x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 251620,
                      constraints: ["writable: x19+0x260", "writable: x20+0x4", "x1 == NULL", "x2 == NULL", "x21 == NULL", "x4 == NULL || {x4, x3, x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 251624,
                      constraints: ["writable: x19+0x260", "writable: x20+0x4", "x1 == NULL", "x2 == NULL", "x21 == NULL", "[sp+0x58] == NULL || {[sp+0x58], [sp+0x60], x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 251628,
                      constraints: ["writable: x19+0x260", "writable: x20+0x4", "x1 == NULL", "x2 == NULL", "x21 == NULL", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 251632,
                      constraints: ["writable: x19+0x260", "writable: x20+0x4", "x1 == NULL", "x2 == NULL", "x21 == NULL", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 251636,
                      constraints: ["writable: x19+0x260", "writable: x20+0x4", "x21 == NULL", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 251640,
                      constraints: ["writable: x19+0x260", "writable: x20+0x4", "x1 == NULL", "x21 == NULL", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 251644,
                      constraints: ["writable: x19+0x260", "writable: x20+0x4", "x1 == NULL", "x2 == NULL", "x21 == NULL", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 251648,
                      constraints: ["writable: x19+0x260", "writable: x20+0x4", "x1 == NULL", "x2 == NULL", "x21 == NULL", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 251652,
                      constraints: ["writable: x19+0x260", "writable: x20+0x4", "x21 == NULL", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 251656,
                      constraints: ["writable: x19+0x260", "writable: x20+0x4", "x1 == NULL", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 251660,
                      constraints: ["writable: x19+0x260", "writable: x20+0x4", "x1 == NULL", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 251664,
                      constraints: ["writable: x19+0x260", "writable: x20+0x4", "x1 == NULL", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 251668,
                      constraints: ["writable: x19+0x260", "writable: x20+0x4", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 251672,
                      constraints: ["writable: x20+0x4", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 396316,
                      constraints: ["x2+0x998 == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", x2+0x998)")
OneGadget::Gadget.add(build_id, 396320,
                      constraints: ["x1+0x990 == NULL"],
                      effect: "execl(\"/bin/sh\", x1+0x990)")
OneGadget::Gadget.add(build_id, 637408,
                      constraints: ["w21 == 0x1", "x23 == NULL || {\"sh\", x23, [sp+0x10], [sp+0x18], ...} is a valid argv", "[x20] == NULL || x20 == NULL || x20 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp, x20)")
OneGadget::Gadget.add(build_id, 637412,
                      constraints: ["w21 == 0x1", "writable: x1", "x23 == NULL || {\"sh\", x23, [x1+0x10], [x1+0x18], ...} is a valid argv", "[x20] == NULL || x20 == NULL || x20 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x1, x20)")
OneGadget::Gadget.add(build_id, 638040,
                      constraints: ["w21 == 0x1", "writable: x0", "x23 == NULL || {\"sh\", x23, [x0+0x10], [x0+0x18], ...} is a valid argv", "[x20] == NULL || x20 == NULL || x20 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x0, x20)")
OneGadget::Gadget.add(build_id, 638044,
                      constraints: ["w21 == 0x1", "writable: x0", "x23 == NULL || {\"sh\", x23, [x0+0x10], [x0+0x18], ...} is a valid argv", "[x20] == NULL || x20 == NULL || x20 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x0, x20)")
OneGadget::Gadget.add(build_id, 638048,
                      constraints: ["w21 == 0x1", "writable: x1", "x0 != 0x0", "x23 == NULL || {\"sh\", x23, [x1+0x10], [x1+0x18], ...} is a valid argv", "[x20] == NULL || x20 == NULL || x20 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x1, x20)")

