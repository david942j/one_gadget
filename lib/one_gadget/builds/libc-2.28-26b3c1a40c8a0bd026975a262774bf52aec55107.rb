require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc6_2.28-0ubuntu1_arm64/lib/aarch64-linux-gnu/libc-2.28.so
# 
# ARM 64-bit architecture
# 
# GNU C Library (Ubuntu GLIBC 2.28-0ubuntu1) stable release version 2.28.
# Copyright (C) 2018 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 8.2.0.
# libc ABIs: UNIQUE ABSOLUTE
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 257536,
                      constraints: ["(u64)x0 <= 0xfffffffffffff000", "w0 == 0x0", "writable: x20+0x360", "x22 == NULL", "{\"sh\", \"-c\", x24, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 257544,
                      constraints: ["w0 == 0x0", "writable: x20+0x360", "x22 == NULL", "{\"sh\", \"-c\", x24, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 257548,
                      constraints: ["w0 == 0x0", "writable: x20+0x360", "x22 == NULL", "{\"sh\", \"-c\", x24, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 258248,
                      constraints: ["writable: x20+0x360", "x22 == NULL", "{\"sh\", \"-c\", x24, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 258252,
                      constraints: ["writable: x20+0x360", "x22 == NULL", "x4+0x430 == NULL || {x4+0x430, \"-c\", x24, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 258256,
                      constraints: ["writable: x20+0x360", "x22 == NULL", "x4+0x430 == NULL || {x4+0x430, x3+0x438, x24, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 258260,
                      constraints: ["writable: x20+0x360", "x22 == NULL", "x4 == NULL || {x4, x3+0x438, x24, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 258264,
                      constraints: ["writable: x20+0x360", "x22 == NULL", "x4 == NULL || {x4, x3, x24, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 258268,
                      constraints: ["writable: x19+0x4", "writable: x20+0x360", "x22 == NULL", "x4 == NULL || {x4, x3, x24, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 258272,
                      constraints: ["writable: x19+0x4", "writable: x20+0x360", "x2 == NULL", "x22 == NULL", "x4 == NULL || {x4, x3, x24, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 258276,
                      constraints: ["writable: x19+0x4", "writable: x20+0x360", "x1 == NULL", "x2 == NULL", "x22 == NULL", "x4 == NULL || {x4, x3, x24, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 258280,
                      constraints: ["writable: x19+0x4", "writable: x20+0x360", "x1 == NULL", "x2 == NULL", "x22 == NULL", "x4 == NULL || {x4, x3, x24, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 258284,
                      constraints: ["writable: x19+0x4", "writable: x20+0x360", "x1 == NULL", "x2 == NULL", "x22 == NULL", "[sp+0x70] == NULL || {[sp+0x70], [sp+0x78], x24, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 258288,
                      constraints: ["writable: x19+0x4", "writable: x20+0x360", "x1 == NULL", "x2 == NULL", "x22 == NULL", "[x21] == NULL || x21 == NULL || x21 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x21, environ)")
OneGadget::Gadget.add(build_id, 258292,
                      constraints: ["writable: x19+0x4", "writable: x20+0x360", "x1 == NULL", "x2 == NULL", "x22 == NULL", "[x21] == NULL || x21 == NULL || x21 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x21, environ)")
OneGadget::Gadget.add(build_id, 258296,
                      constraints: ["writable: x19+0x4", "writable: x20+0x360", "x22 == NULL", "[x21] == NULL || x21 == NULL || x21 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x21, environ)")
OneGadget::Gadget.add(build_id, 258300,
                      constraints: ["writable: x19+0x4", "writable: x20+0x360", "x1 == NULL", "x22 == NULL", "[x21] == NULL || x21 == NULL || x21 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x21, environ)")
OneGadget::Gadget.add(build_id, 258304,
                      constraints: ["writable: x19+0x4", "writable: x20+0x360", "x1 == NULL", "x2 == NULL", "x22 == NULL", "[x21] == NULL || x21 == NULL || x21 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x21, environ)")
OneGadget::Gadget.add(build_id, 258308,
                      constraints: ["writable: x19+0x4", "writable: x20+0x360", "x1 == NULL", "x2 == NULL", "x22 == NULL", "[x21] == NULL || x21 == NULL || x21 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x21, environ)")
OneGadget::Gadget.add(build_id, 258312,
                      constraints: ["writable: x19+0x4", "writable: x20+0x360", "x22 == NULL", "[x21] == NULL || x21 == NULL || x21 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x21, environ)")
OneGadget::Gadget.add(build_id, 258316,
                      constraints: ["writable: x19+0x4", "writable: x20+0x360", "x1 == NULL", "[x21] == NULL || x21 == NULL || x21 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x21, environ)")
OneGadget::Gadget.add(build_id, 258320,
                      constraints: ["writable: x19+0x4", "writable: x20+0x360", "x1 == NULL", "[x21] == NULL || x21 == NULL || x21 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x21, environ)")
OneGadget::Gadget.add(build_id, 258324,
                      constraints: ["writable: x19+0x4", "writable: x20+0x360", "x1 == NULL", "[x21] == NULL || x21 == NULL || x21 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x21, environ)")
OneGadget::Gadget.add(build_id, 258328,
                      constraints: ["writable: x19+0x4", "writable: x20+0x360", "[x21] == NULL || x21 == NULL || x21 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x21, environ)")
OneGadget::Gadget.add(build_id, 409712,
                      constraints: ["x2+0x438 == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", x2+0x438)")
OneGadget::Gadget.add(build_id, 409716,
                      constraints: ["x1+0x430 == NULL"],
                      effect: "execl(\"/bin/sh\", x1+0x430)")
OneGadget::Gadget.add(build_id, 409720,
                      constraints: ["x1+0x430 == NULL"],
                      effect: "execl(\"/bin/sh\", x1+0x430)")
OneGadget::Gadget.add(build_id, 409724,
                      constraints: ["x1 == NULL"],
                      effect: "execl(\"/bin/sh\", x1)")
OneGadget::Gadget.add(build_id, 409728,
                      constraints: ["x1 == NULL"],
                      effect: "execl(\"/bin/sh\", x1)")
OneGadget::Gadget.add(build_id, 666964,
                      constraints: ["[x1] == 0x0", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, x2)")
OneGadget::Gadget.add(build_id, 666968,
                      constraints: ["[x1] == 0x0", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, x2)")
OneGadget::Gadget.add(build_id, 666972,
                      constraints: ["[x1] == 0x0", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp+0x40, x2)")
OneGadget::Gadget.add(build_id, 666976,
                      constraints: ["[x1] == 0x0", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp+0x40, x2)")
OneGadget::Gadget.add(build_id, 666980,
                      constraints: ["[x1] == 0x0", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp+0x40, x2)")
OneGadget::Gadget.add(build_id, 666984,
                      constraints: ["[x1] == 0x0", "writable: x29+0x40", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x2)")
OneGadget::Gadget.add(build_id, 666988,
                      constraints: ["[x1] == 0x0", "writable: x29+0x40", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x2)")
OneGadget::Gadget.add(build_id, 666992,
                      constraints: ["[x1] == 0x0", "readable: [x19+0xed8]", "writable: x29+0x40", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x2)")
OneGadget::Gadget.add(build_id, 666996,
                      constraints: ["[x1] == 0x0", "readable: x3", "writable: x29+0x40", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x2)")
OneGadget::Gadget.add(build_id, 667000,
                      constraints: ["[x1] == 0x0", "readable: x3", "writable: x29+0x40", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x2)")
OneGadget::Gadget.add(build_id, 667004,
                      constraints: ["[x1] == 0x0", "readable: x3", "writable: x29+0x40", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x2)")
OneGadget::Gadget.add(build_id, 667008,
                      constraints: ["[x1] == 0x0", "readable: x3", "writable: x29+0x40", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x23] == NULL || x23 == NULL || x23 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x23)")
OneGadget::Gadget.add(build_id, 667012,
                      constraints: ["readable: x3", "writable: x29+0x40", "x2 == 0x0", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x23] == NULL || x23 == NULL || x23 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x23)")
OneGadget::Gadget.add(build_id, 667016,
                      constraints: ["writable: x29+0x40", "x2 == 0x0", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x23] == NULL || x23 == NULL || x23 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x23)")
OneGadget::Gadget.add(build_id, 667020,
                      constraints: ["writable: x29+0x40", "x2 == 0x0", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x23] == NULL || x23 == NULL || x23 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x23)")
OneGadget::Gadget.add(build_id, 667024,
                      constraints: ["writable: x29+0x40", "x2 == 0x0", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x23] == NULL || x23 == NULL || x23 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x23)")
OneGadget::Gadget.add(build_id, 667028,
                      constraints: ["writable: x29+0x40", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x23] == NULL || x23 == NULL || x23 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x23)")
OneGadget::Gadget.add(build_id, 667212,
                      constraints: ["writable: x29+0x40", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x23] == NULL || x23 == NULL || x23 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x23)")

