require 'one_gadget/gadget'
# spec/data/aarch64-libc-2.27.so
# 
# AArch64
# 
# GNU C Library (Ubuntu GLIBC 2.27-3ubuntu1) stable release version 2.27.
# Copyright (C) 2018 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 7.3.0.
# libc ABIs: UNIQUE
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 257764,
                      constraints: ["(u64)x0 <= 0xfffffffffffff000", "w0 == 0x0", "writable: x20+0x338", "x22 == NULL", "{\"sh\", \"-c\", x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 257772,
                      constraints: ["w0 == 0x0", "writable: x20+0x338", "x22 == NULL", "{\"sh\", \"-c\", x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 257776,
                      constraints: ["w0 == 0x0", "writable: x20+0x338", "x22 == NULL", "{\"sh\", \"-c\", x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 257780,
                      constraints: ["w0 == 0x0", "writable: x20+0x338", "x22 == NULL", "{\"sh\", \"-c\", x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 258392,
                      constraints: ["writable: x20+0x338", "x22 == NULL", "{\"sh\", \"-c\", x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 258396,
                      constraints: ["writable: x20+0x338", "x22 == NULL", "x3+0x7c0 == NULL || {x3+0x7c0, \"-c\", x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 258400,
                      constraints: ["writable: x20+0x338", "x22 == NULL", "x3 == NULL || {x3, \"-c\", x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 258404,
                      constraints: ["writable: x19+0x4", "writable: x20+0x338", "x22 == NULL", "x3 == NULL || {x3, \"-c\", x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 258408,
                      constraints: ["writable: x19+0x4", "writable: x20+0x338", "x22 == NULL", "x3 == NULL || {x3, x0+0x7c8, x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 258412,
                      constraints: ["writable: x19+0x4", "writable: x20+0x338", "x22 == NULL", "x3 == NULL || {x3, x0, x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 258416,
                      constraints: ["writable: x19+0x4", "writable: x20+0x338", "x2 == NULL", "x22 == NULL", "x3 == NULL || {x3, x0, x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 258420,
                      constraints: ["writable: x19+0x4", "writable: x20+0x338", "x2 == NULL", "x22 == NULL", "[sp+0x70] == NULL || {[sp+0x70], [sp+0x78], x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 258424,
                      constraints: ["writable: x19+0x4", "writable: x20+0x338", "x1 == NULL", "x2 == NULL", "x22 == NULL", "[sp+0x70] == NULL || {[sp+0x70], [sp+0x78], x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 258428,
                      constraints: ["writable: x19+0x4", "writable: x20+0x338", "x1 == NULL", "x2 == NULL", "x22 == NULL", "[sp+0x70] == NULL || {[sp+0x70], [sp+0x78], [sp+0x80], [sp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 258432,
                      constraints: ["writable: x19+0x4", "writable: x20+0x338", "x1 == NULL", "x2 == NULL", "x22 == NULL", "[sp+0x70] == NULL || {[sp+0x70], [sp+0x78], [sp+0x80], [sp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 258436,
                      constraints: ["writable: x19+0x4", "writable: x20+0x338", "x22 == NULL", "[sp+0x70] == NULL || {[sp+0x70], [sp+0x78], [sp+0x80], [sp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x70, environ)")
OneGadget::Gadget.add(build_id, 258440,
                      constraints: ["writable: x19+0x4", "writable: x20+0x338", "x22 == NULL", "[x21] == NULL || x21 == NULL || x21 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x21, environ)")
OneGadget::Gadget.add(build_id, 258444,
                      constraints: ["writable: x19+0x4", "writable: x20+0x338", "x2 == NULL", "x22 == NULL", "[x21] == NULL || x21 == NULL || x21 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x21, environ)")
OneGadget::Gadget.add(build_id, 258448,
                      constraints: ["writable: x19+0x4", "writable: x20+0x338", "x1 == NULL", "x2 == NULL", "x22 == NULL", "[x21] == NULL || x21 == NULL || x21 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x21, environ)")
OneGadget::Gadget.add(build_id, 258452,
                      constraints: ["writable: x19+0x4", "writable: x20+0x338", "x1 == NULL", "x2 == NULL", "x22 == NULL", "[x21] == NULL || x21 == NULL || x21 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x21, environ)")
OneGadget::Gadget.add(build_id, 258456,
                      constraints: ["writable: x19+0x4", "writable: x20+0x338", "x22 == NULL", "[x21] == NULL || x21 == NULL || x21 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x21, environ)")
OneGadget::Gadget.add(build_id, 258460,
                      constraints: ["writable: x19+0x4", "writable: x20+0x338", "x22 == NULL", "[x21] == NULL || x21 == NULL || x21 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x21, environ)")
OneGadget::Gadget.add(build_id, 258464,
                      constraints: ["writable: x19+0x4", "writable: x20+0x338", "x1 == NULL", "[x21] == NULL || x21 == NULL || x21 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x21, environ)")
OneGadget::Gadget.add(build_id, 258468,
                      constraints: ["writable: x19+0x4", "writable: x20+0x338", "x1 == NULL", "[x21] == NULL || x21 == NULL || x21 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x21, environ)")
OneGadget::Gadget.add(build_id, 258472,
                      constraints: ["writable: x19+0x4", "writable: x20+0x338", "[x21] == NULL || x21 == NULL || x21 is a valid argv"],
                      effect: "execve(\"/bin/sh\", x21, environ)")
OneGadget::Gadget.add(build_id, 409212,
                      constraints: ["x2+0x7c8 == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", x2+0x7c8)")
OneGadget::Gadget.add(build_id, 409216,
                      constraints: ["x1+0x7c0 == NULL"],
                      effect: "execl(\"/bin/sh\", x1+0x7c0)")
OneGadget::Gadget.add(build_id, 409220,
                      constraints: ["x1+0x7c0 == NULL"],
                      effect: "execl(\"/bin/sh\", x1+0x7c0)")
OneGadget::Gadget.add(build_id, 409224,
                      constraints: ["x1+0x7c0 == NULL"],
                      effect: "execl(\"/bin/sh\", x1+0x7c0)")
OneGadget::Gadget.add(build_id, 409228,
                      constraints: ["x1 == NULL"],
                      effect: "execl(\"/bin/sh\", x1)")
OneGadget::Gadget.add(build_id, 409232,
                      constraints: ["x1 == NULL"],
                      effect: "execl(\"/bin/sh\", x1)")
OneGadget::Gadget.add(build_id, 668176,
                      constraints: ["[x1] == 0x0", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, x2)")
OneGadget::Gadget.add(build_id, 668180,
                      constraints: ["[x1] == 0x0", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp+0x40, x2)")
OneGadget::Gadget.add(build_id, 668184,
                      constraints: ["[x1] == 0x0", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp+0x40, x2)")
OneGadget::Gadget.add(build_id, 668188,
                      constraints: ["[x1] == 0x0", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp+0x40, x2)")
OneGadget::Gadget.add(build_id, 668192,
                      constraints: ["[x1] == 0x0", "writable: x29+0x40", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x2)")
OneGadget::Gadget.add(build_id, 668196,
                      constraints: ["[x1] == 0x0", "writable: x29+0x40", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x2)")
OneGadget::Gadget.add(build_id, 668200,
                      constraints: ["[x1] == 0x0", "readable: [x19+0xed8]", "writable: x29+0x40", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x2)")
OneGadget::Gadget.add(build_id, 668204,
                      constraints: ["[x1] == 0x0", "readable: [x19+0xed8]", "writable: x29+0x40", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x2)")
OneGadget::Gadget.add(build_id, 668208,
                      constraints: ["[x1] == 0x0", "readable: x3", "writable: x29+0x40", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x2)")
OneGadget::Gadget.add(build_id, 668212,
                      constraints: ["[x1] == 0x0", "readable: x3", "writable: x29+0x40", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x2)")
OneGadget::Gadget.add(build_id, 668216,
                      constraints: ["[x1] == 0x0", "readable: x3", "writable: x29+0x40", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x23] == NULL || x23 == NULL || x23 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x23)")
OneGadget::Gadget.add(build_id, 668220,
                      constraints: ["readable: x3", "writable: x29+0x40", "x2 == 0x0", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x23] == NULL || x23 == NULL || x23 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x23)")
OneGadget::Gadget.add(build_id, 668224,
                      constraints: ["writable: x29+0x40", "x2 == 0x0", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x23] == NULL || x23 == NULL || x23 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x23)")
OneGadget::Gadget.add(build_id, 668228,
                      constraints: ["writable: x29+0x40", "x2 == 0x0", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x23] == NULL || x23 == NULL || x23 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x23)")
OneGadget::Gadget.add(build_id, 668232,
                      constraints: ["writable: x29+0x40", "x2 == 0x0", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x23] == NULL || x23 == NULL || x23 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x23)")
OneGadget::Gadget.add(build_id, 668236,
                      constraints: ["writable: x29+0x40", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x23] == NULL || x23 == NULL || x23 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x23)")
OneGadget::Gadget.add(build_id, 668388,
                      constraints: ["writable: x29+0x40", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x23] == NULL || x23 == NULL || x23 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x23)")
OneGadget::Gadget.add(build_id, 668392,
                      constraints: ["writable: x29+0x40", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x23] == NULL || x23 == NULL || x23 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x23)")
OneGadget::Gadget.add(build_id, 668396,
                      constraints: ["writable: x20+0x10", "writable: x29+0x40", "[x20] == NULL || x20 == NULL || x20 is a valid argv", "[x23] == NULL || x23 == NULL || x23 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x20, x23)")

