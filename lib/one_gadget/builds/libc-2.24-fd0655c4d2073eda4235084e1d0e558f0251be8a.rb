require 'one_gadget/gadget'
# spec/data/aarch64-libc-2.24.so
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
OneGadget::Gadget.add(build_id, 247344,
                      constraints: ["(u64)x0 <= 0xfffffffffffff000", "w0 == 0x0", "writable: x19+0x258", "x21 == NULL", "{\"sh\", \"-c\", x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 247352,
                      constraints: ["w0 == 0x0", "writable: x19+0x258", "x21 == NULL", "{\"sh\", \"-c\", x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 248092,
                      constraints: ["writable: x19+0x258", "x21 == NULL", "{\"sh\", \"-c\", x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 248096,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x21 == NULL", "{\"sh\", \"-c\", x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 248100,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x21 == NULL", "x4+0xad0 == NULL || {x4+0xad0, \"-c\", x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 248104,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x21 == NULL", "x4+0xad0 == NULL || {x4+0xad0, x3+0xad8, x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 248108,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x21 == NULL", "x4 == NULL || {x4, x3+0xad8, x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 248112,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x21 == NULL", "x4 == NULL || {x4, x3, x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 248116,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x1 == NULL", "x21 == NULL", "x4 == NULL || {x4, x3, x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 248120,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x1 == NULL", "x2 == NULL", "x21 == NULL", "x4 == NULL || {x4, x3, x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 248124,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x1 == NULL", "x2 == NULL", "x21 == NULL", "x4 == NULL || {x4, x3, x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 248128,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x1 == NULL", "x2 == NULL", "x21 == NULL", "[sp+0x58] == NULL || {[sp+0x58], [sp+0x60], x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 248132,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x1 == NULL", "x2 == NULL", "x21 == NULL", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 248136,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x1 == NULL", "x2 == NULL", "x21 == NULL", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 248140,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x21 == NULL", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 248144,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x1 == NULL", "x21 == NULL", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 248148,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x1 == NULL", "x2 == NULL", "x21 == NULL", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 248152,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x1 == NULL", "x2 == NULL", "x21 == NULL", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 248156,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x21 == NULL", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 248160,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x1 == NULL", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 248164,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x1 == NULL", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 248168,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x1 == NULL", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 248172,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 248176,
                      constraints: ["writable: x20+0x4", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 398468,
                      constraints: ["x2+0xad8 == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", x2+0xad8)")
OneGadget::Gadget.add(build_id, 398472,
                      constraints: ["x1+0xad0 == NULL"],
                      effect: "execl(\"/bin/sh\", x1+0xad0)")
OneGadget::Gadget.add(build_id, 642760,
                      constraints: ["[x1] == 0x0", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x50, x2)")
OneGadget::Gadget.add(build_id, 642764,
                      constraints: ["[x4] == 0x0", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x50, x2)")

