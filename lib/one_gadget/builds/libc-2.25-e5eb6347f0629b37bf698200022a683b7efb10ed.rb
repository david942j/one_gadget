require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/aarch64-linux-gnu-glibc-2.25-1-any.pkg.tar/usr/aarch64-linux-gnu/lib/libc-2.25.so
# 
# ARM 64-bit architecture
# 
# GNU C Library (GNU libc) stable release version 2.25, by Roland McGrath et al.
# Copyright (C) 2017 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 6.3.0.
# Available extensions:
# 	crypt add-on version 2.1 by Michael Glad and others
# 	GNU Libidn by Simon Josefsson
# 	Native POSIX Threads Library by Ulrich Drepper et al
# 	BIND-8.2.3-T5B
# libc ABIs: UNIQUE
# For bug reporting instructions, please see:
# <https://bugs.archlinux.org/>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 249832,
                      constraints: ["(u64)x0 <= 0xfffffffffffff000", "w0 == 0x0", "writable: x19+0x258", "x21 == NULL", "{\"sh\", \"-c\", x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 249840,
                      constraints: ["w0 == 0x0", "writable: x19+0x258", "x21 == NULL", "{\"sh\", \"-c\", x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 250588,
                      constraints: ["writable: x19+0x258", "x21 == NULL", "{\"sh\", \"-c\", x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 250592,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x21 == NULL", "{\"sh\", \"-c\", x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 250596,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x21 == NULL", "x4+0x7e0 == NULL || {x4+0x7e0, \"-c\", x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 250600,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x21 == NULL", "x4+0x7e0 == NULL || {x4+0x7e0, x3+0x7e8, x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 250604,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x21 == NULL", "x4 == NULL || {x4, x3+0x7e8, x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 250608,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x21 == NULL", "x4 == NULL || {x4, x3, x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 250612,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x1 == NULL", "x21 == NULL", "x4 == NULL || {x4, x3, x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 250616,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x1 == NULL", "x2 == NULL", "x21 == NULL", "x4 == NULL || {x4, x3, x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 250620,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x1 == NULL", "x2 == NULL", "x21 == NULL", "x4 == NULL || {x4, x3, x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 250624,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x1 == NULL", "x2 == NULL", "x21 == NULL", "[sp+0x58] == NULL || {[sp+0x58], [sp+0x60], x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 250628,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x1 == NULL", "x2 == NULL", "x21 == NULL", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 250632,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x1 == NULL", "x2 == NULL", "x21 == NULL", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 250636,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x21 == NULL", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 250640,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x1 == NULL", "x21 == NULL", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 250644,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x1 == NULL", "x2 == NULL", "x21 == NULL", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 250648,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x1 == NULL", "x2 == NULL", "x21 == NULL", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 250652,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x21 == NULL", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 250656,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x1 == NULL", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 250660,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x1 == NULL", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 250664,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "x1 == NULL", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 250668,
                      constraints: ["writable: x19+0x258", "writable: x20+0x4", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 250672,
                      constraints: ["writable: x20+0x4", "[x22] == NULL || x22 == NULL || x22 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x22, environ)")
OneGadget::Gadget.add(build_id, 400676,
                      constraints: ["x2+0x7e8 == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", x2+0x7e8)")
OneGadget::Gadget.add(build_id, 400680,
                      constraints: ["x1+0x7e0 == NULL"],
                      effect: "execl(\"/bin/sh\", x1+0x7e0)")
OneGadget::Gadget.add(build_id, 644488,
                      constraints: ["[x1] == 0x0", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x18, x2)")
OneGadget::Gadget.add(build_id, 644492,
                      constraints: ["[x1] == 0x0", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp+0x38, x2)")
OneGadget::Gadget.add(build_id, 644496,
                      constraints: ["[x1] == 0x0", "x6 == NULL || {\"/bin/sh\", x6, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp+0x38, x2)")
OneGadget::Gadget.add(build_id, 644500,
                      constraints: ["[x1] == 0x0", "x6 == NULL || {\"/bin/sh\", x6, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp+0x38, x2)")
OneGadget::Gadget.add(build_id, 644504,
                      constraints: ["[x1] == 0x0", "x6 == NULL || {\"/bin/sh\", x6, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp+0x38, x2)")
OneGadget::Gadget.add(build_id, 644508,
                      constraints: ["[x1] == 0x0", "writable: x29+0x38", "x6 == NULL || {\"/bin/sh\", x6, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x38, x2)")
OneGadget::Gadget.add(build_id, 644512,
                      constraints: ["writable: x29+0x38", "x0 == 0x0", "x6 == NULL || {\"/bin/sh\", x6, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x38, x2)")
OneGadget::Gadget.add(build_id, 644516,
                      constraints: ["writable: x29+0x38", "x0 == 0x0", "x6 == NULL || {\"/bin/sh\", x6, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x38, x2)")
OneGadget::Gadget.add(build_id, 644520,
                      constraints: ["writable: x29+0x38", "x0 == 0x0", "x6 == NULL || {\"/bin/sh\", x6, NULL} is a valid argv", "[x21] == NULL || x21 == NULL || x21 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x38, x21)")
OneGadget::Gadget.add(build_id, 644524,
                      constraints: ["writable: x29+0x38", "x0 == 0x0", "x6 == NULL || {\"/bin/sh\", x6, NULL} is a valid argv", "[x21] == NULL || x21 == NULL || x21 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x38, x21)")
OneGadget::Gadget.add(build_id, 644528,
                      constraints: ["writable: x29+0x38", "x6 == NULL || {\"/bin/sh\", x6, NULL} is a valid argv", "[x21] == NULL || x21 == NULL || x21 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x38, x21)")
OneGadget::Gadget.add(build_id, 644556,
                      constraints: ["writable: x29+0x38", "x0 == 0x1", "x4 == 0x0", "x6 == NULL || {\"/bin/sh\", x6, NULL} is a valid argv", "[x21] == NULL || x21 == NULL || x21 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x38, x21)")
OneGadget::Gadget.add(build_id, 644560,
                      constraints: ["writable: x29+0x38", "x0 == 0x1", "x4 == 0x0", "x6 == NULL || {\"/bin/sh\", x6, NULL} is a valid argv", "[x21] == NULL || x21 == NULL || x21 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x38, x21)")
OneGadget::Gadget.add(build_id, 644564,
                      constraints: ["writable: x29+0x38", "x0 == 0x1", "x6 == NULL || {\"/bin/sh\", x6, NULL} is a valid argv", "[x21] == NULL || x21 == NULL || x21 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x38, x21)")
OneGadget::Gadget.add(build_id, 644660,
                      constraints: ["writable: x29+0x38", "x6 == NULL || {\"/bin/sh\", x6, NULL} is a valid argv", "[x21] == NULL || x21 == NULL || x21 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x38, x21)")
OneGadget::Gadget.add(build_id, 644664,
                      constraints: ["writable: x29+0x38", "x6 == NULL || {\"/bin/sh\", x6, NULL} is a valid argv", "[x21] == NULL || x21 == NULL || x21 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x38, x21)")

