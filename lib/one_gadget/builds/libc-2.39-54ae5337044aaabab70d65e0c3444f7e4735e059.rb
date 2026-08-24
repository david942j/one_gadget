require 'one_gadget/gadget'
# http://ports.ubuntu.com/ubuntu-ports/pool/main/g/glibc/libc6_2.39-0ubuntu8.8_arm64.deb
# 
# AArch64
# 
# GNU C Library (Ubuntu GLIBC 2.39-0ubuntu8.8) stable release version 2.39.
# Copyright (C) 2024 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 13.3.0.
# libc ABIs: UNIQUE ABSOLUTE
# Minimum supported kernel: 3.7.0
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 463984,
                      constraints: ["[x22+0x510] == 0x0", "[x22+0x518] == 0x0", "w0 != 0x0", "writable: x22+0x508", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 463984,
                      constraints: ["[x22+0x518] == 0x0", "w0 == 0x0", "writable: x22+0x50c", "x24 == [x22+0x510]", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 463984,
                      constraints: ["[x22+0x510] != 0x0", "[x22+0x518] == 0x0", "w0 != 0x0", "writable: x22+0x50c", "x24 == [x22+0x510]", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 463988,
                      constraints: ["[x22+0x518] == 0x0", "writable: x22+0x50c", "x24 == [x22+0x510]", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 463988,
                      constraints: ["[[x22+0x518]+0xe8] == 0x0", "w27 == [[x22+0x518]+0x70]", "writable: x22+0x50c", "x24 == [x22+0x510]", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 463992,
                      constraints: ["[x22+0x518] == 0x0", "writable: x22+0x50c", "x24 == [x0+0x8]", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 463992,
                      constraints: ["[[x22+0x518]+0xe8] == 0x0", "w27 == [[x22+0x518]+0x70]", "writable: x22+0x50c", "x24 == [x0+0x8]", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 463996,
                      constraints: ["[x22+0x518] == 0x0", "writable: x22+0x50c", "x24 == x0", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 463996,
                      constraints: ["[[x22+0x518]+0xe8] == 0x0", "w27 == [[x22+0x518]+0x70]", "writable: x22+0x50c", "x24 == x0", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464024,
                      constraints: ["[x22+0x518] == 0x0", "w0 == 0x0", "writable: x22+0x510", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464024,
                      constraints: ["[[x22+0x518]+0xe8] == 0x0", "w0 == 0x0", "w27 == [[x22+0x518]+0x70]", "writable: x22+0x510", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464028,
                      constraints: ["[x22+0x518] == 0x0", "writable: x22+0x510", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464028,
                      constraints: ["[[x22+0x518]+0xe8] == 0x0", "w27 == [[x22+0x518]+0x70]", "writable: x22+0x510", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464032,
                      constraints: ["[x22+0x518] == 0x0", "writable: x0+0x8", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464032,
                      constraints: ["[[x22+0x518]+0xe8] == 0x0", "w27 == [[x22+0x518]+0x70]", "writable: x0+0x8", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464036,
                      constraints: ["[x22+0x518] == 0x0", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464036,
                      constraints: ["[[x22+0x518]+0xe8] == 0x0", "w27 == [[x22+0x518]+0x70]", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464040,
                      constraints: ["[x0+0x10] == 0x0", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464040,
                      constraints: ["[[x0+0x10]+0xe8] == 0x0", "w27 == [[x0+0x10]+0x70]", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464044,
                      constraints: ["x26 == 0x0", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464044,
                      constraints: ["[x26+0xe8] == 0x0", "w27 == [x26+0x70]", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464048,
                      constraints: ["[x26+0xe8] == 0x0", "w27 == [x26+0x70]", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464052,
                      constraints: ["[x26+0xe8] == 0x0", "w27 == w1", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464068,
                      constraints: ["[x26+0xe8] == 0x0", "w0 == 0x0", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464072,
                      constraints: ["[x26+0xe8] == 0x0", "w0 == 0x0", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464076,
                      constraints: ["[x26+0xe8] == 0x0", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464080,
                      constraints: ["x26 == 0x0", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464084,
                      constraints: ["{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464092,
                      constraints: ["readable: x1", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "[[x1]] == NULL || [x1] == NULL || [x1] is a valid envp", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, [x1])")
OneGadget::Gadget.add(build_id, 464096,
                      constraints: ["readable: x1", "x8+0xf70 == NULL || {\"sh\", x8+0xf70, $base+0x15cf78, x20, ...} is a valid argv", "[[x1]] == NULL || [x1] == NULL || [x1] is a valid envp", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, [x1])")
OneGadget::Gadget.add(build_id, 464100,
                      constraints: ["readable: x1", "x8+0xf70 == NULL || {\"sh\", x8+0xf70, x7+0xf78, x20, ...} is a valid argv", "[[x1]] == NULL || [x1] == NULL || [x1] is a valid envp", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, [x1])")
OneGadget::Gadget.add(build_id, 464104,
                      constraints: ["readable: x1", "x8 == NULL || {\"sh\", x8, x7+0xf78, x20, ...} is a valid argv", "[[x1]] == NULL || [x1] == NULL || [x1] is a valid envp", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, [x1])")
OneGadget::Gadget.add(build_id, 464108,
                      constraints: ["readable: x1", "x8 == NULL || {\"sh\", x8, x7, x20, ...} is a valid argv", "[[x1]] == NULL || [x1] == NULL || [x1] is a valid envp", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, [x1])")
OneGadget::Gadget.add(build_id, 464112,
                      constraints: ["readable: x1", "x0+0xf68 == NULL || {x0+0xf68, x8, x7, x20, ...} is a valid argv", "[[x1]] == NULL || [x1] == NULL || [x1] is a valid envp", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, [x1])")
OneGadget::Gadget.add(build_id, 464116,
                      constraints: ["x0+0xf68 == NULL || {x0+0xf68, x8, x7, x20, ...} is a valid argv", "[x5] == NULL || x5 == NULL || x5 is a valid envp", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, x5)")
OneGadget::Gadget.add(build_id, 464120,
                      constraints: ["x0 == NULL || {x0, x8, x7, x20, ...} is a valid argv", "[x5] == NULL || x5 == NULL || x5 is a valid envp", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, x5)")
OneGadget::Gadget.add(build_id, 464124,
                      constraints: ["[x4] == NULL || x4 is a valid argv", "[x5] == NULL || x5 == NULL || x5 is a valid envp", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, x4, x5)")
OneGadget::Gadget.add(build_id, 464128,
                      constraints: ["[x4] == NULL || x4 is a valid argv", "[x5] == NULL || x5 == NULL || x5 is a valid envp", "x19+0xe0 == NULL || writable: x19+0xe0", "x2 == NULL || (s32)[x2+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x2, 0, x4, x5)")
OneGadget::Gadget.add(build_id, 464132,
                      constraints: ["[x4] == NULL || x4 is a valid argv", "[x5] == NULL || x5 == NULL || x5 is a valid envp", "x19+0xe0 == NULL || writable: x19+0xe0", "x2 == NULL || (s32)[x2+0x4] <= 0x0", "x3 == NULL || (u16)[x3] == 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x2, x3, x4, x5)")
OneGadget::Gadget.add(build_id, 464336,
                      constraints: ["[x22+0x510] == 0x0", "[x22+0x518] == 0x0", "writable: x22+0x508", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464336,
                      constraints: ["[[x22+0x518]+0xe8] == 0x0", "[x22+0x510] == 0x0", "w27 == [[x22+0x518]+0x70]", "writable: x22+0x508", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464336,
                      constraints: ["[x22+0x510] != 0x0", "[x22+0x518] == 0x0", "writable: x22+0x50c", "x24 == [x22+0x510]", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464340,
                      constraints: ["[x1+0x8] == 0x0", "[x22+0x518] == 0x0", "writable: x1+0x8", "writable: x22+0x508", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464340,
                      constraints: ["[x1+0x8] != 0x0", "[x22+0x518] == 0x0", "writable: x22+0x50c", "x24 == [x1+0x8]", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464340,
                      constraints: ["[[x22+0x518]+0xe8] == 0x0", "[x1+0x8] == 0x0", "w27 == [[x22+0x518]+0x70]", "writable: x1+0x8", "writable: x22+0x508", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464344,
                      constraints: ["[x22+0x518] == 0x0", "writable: x1+0x8", "writable: x22+0x508", "x0 == 0x0", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464344,
                      constraints: ["[x22+0x518] == 0x0", "writable: x22+0x50c", "x0 != 0x0", "x24 == x0", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464344,
                      constraints: ["[[x22+0x518]+0xe8] == 0x0", "w27 == [[x22+0x518]+0x70]", "writable: x1+0x8", "writable: x22+0x508", "x0 == 0x0", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464348,
                      constraints: ["[x22+0x518] == 0x0", "writable: x1+0x8", "writable: x22+0x508", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464348,
                      constraints: ["[[x22+0x518]+0xe8] == 0x0", "w27 == [[x22+0x518]+0x70]", "writable: x1+0x8", "writable: x22+0x508", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464352,
                      constraints: ["[x22+0x518] == 0x0", "writable: x1+0x8", "writable: x22+0x508", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464352,
                      constraints: ["[[x22+0x518]+0xe8] == 0x0", "w27 == [[x22+0x518]+0x70]", "writable: x1+0x8", "writable: x22+0x508", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464356,
                      constraints: ["[x22+0x518] == 0x0", "writable: x1+0x8", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464356,
                      constraints: ["[[x22+0x518]+0xe8] == 0x0", "w27 == [[x22+0x518]+0x70]", "writable: x1+0x8", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464360,
                      constraints: ["[x22+0x518] == 0x0", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464360,
                      constraints: ["[[x22+0x518]+0xe8] == 0x0", "w27 == [[x22+0x518]+0x70]", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464512,
                      constraints: ["[x22+0x518] == 0x0", "writable: x22+0x50c", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464512,
                      constraints: ["[[x22+0x518]+0xe8] == 0x0", "w27 == [[x22+0x518]+0x70]", "writable: x22+0x50c", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464516,
                      constraints: ["[x22+0x518] == 0x0", "writable: x1+0x4", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464516,
                      constraints: ["[[x22+0x518]+0xe8] == 0x0", "w27 == [[x22+0x518]+0x70]", "writable: x1+0x4", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464520,
                      constraints: ["[x22+0x518] == 0x0", "writable: x1+0x4", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464520,
                      constraints: ["[[x22+0x518]+0xe8] == 0x0", "w27 == [[x22+0x518]+0x70]", "writable: x1+0x4", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464524,
                      constraints: ["[x22+0x518] == 0x0", "writable: x1+0x4", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464524,
                      constraints: ["[[x22+0x518]+0xe8] == 0x0", "w27 == [[x22+0x518]+0x70]", "writable: x1+0x4", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464528,
                      constraints: ["[x22+0x518] == 0x0", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464528,
                      constraints: ["[[x22+0x518]+0xe8] == 0x0", "w27 == [[x22+0x518]+0x70]", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464560,
                      constraints: ["[x22+0x518] == 0x0", "writable: x22+0x510", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 464560,
                      constraints: ["[[x22+0x518]+0xe8] == 0x0", "w27 == [[x22+0x518]+0x70]", "writable: x22+0x510", "{\"sh\", \"-c\", \"--\", x20, ...} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 777588,
                      constraints: ["writable: x29-0x20", "x5 == 0x0", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x20] == NULL || x20 == NULL || x20 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29-0x20, x20)")
OneGadget::Gadget.add(build_id, 777592,
                      constraints: ["writable: x29-0x20", "x5 == 0x0", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x20] == NULL || x20 == NULL || x20 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29-0x20, x20)")
OneGadget::Gadget.add(build_id, 777596,
                      constraints: ["writable: x29-0x20", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x20] == NULL || x20 == NULL || x20 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29-0x20, x20)")
OneGadget::Gadget.add(build_id, 777680,
                      constraints: ["(u64)x5 < 0x400", "x4 == 0x1", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x20] == NULL || x20 == NULL || x20 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp+0x10, x20)")
OneGadget::Gadget.add(build_id, 777680,
                      constraints: ["(u64)x5 >= 0x400", "x4 == 0x1", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x20] == NULL || x20 == NULL || x20 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp+0x10, x20)")
OneGadget::Gadget.add(build_id, 777684,
                      constraints: ["(u64)x5 < 0x400", "x4 == 0x1", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x20] == NULL || x20 == NULL || x20 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp+0x10, x20)")
OneGadget::Gadget.add(build_id, 777684,
                      constraints: ["(u64)x5 >= 0x400", "x4 == 0x1", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x20] == NULL || x20 == NULL || x20 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp+0x10, x20)")
OneGadget::Gadget.add(build_id, 777692,
                      constraints: ["x4 == 0x1", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x20] == NULL || x20 == NULL || x20 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp+0x10, x20)")
OneGadget::Gadget.add(build_id, 777696,
                      constraints: ["writable: x21", "x4 == 0x1", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x20] == NULL || x20 == NULL || x20 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x21, x20)")
OneGadget::Gadget.add(build_id, 777812,
                      constraints: ["x4 == 0x1", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x20] == NULL || x20 == NULL || x20 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp+0x10, x20)")
OneGadget::Gadget.add(build_id, 777816,
                      constraints: ["x4 == 0x1", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x20] == NULL || x20 == NULL || x20 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp+0x10, x20)")
OneGadget::Gadget.add(build_id, 777820,
                      constraints: ["writable: x21", "x4 == 0x1", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x20] == NULL || x20 == NULL || x20 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x21, x20)")
OneGadget::Gadget.add(build_id, 777872,
                      constraints: ["writable: x29-0x20", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x20] == NULL || x20 == NULL || x20 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29-0x20, x20)")
OneGadget::Gadget.add(build_id, 885848,
                      constraints: ["x0 == 0x0", "[[sp+0x38]] == NULL || [sp+0x38] is a valid argv", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x28], 0, [sp+0x38], environ)")
OneGadget::Gadget.add(build_id, 886012,
                      constraints: ["([sp+0xc8] + 0x1) != 0x0", "[[sp+0x38]] == NULL || [sp+0x38] is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x28], 0, [sp+0x38], [sp+0xd0])")
OneGadget::Gadget.add(build_id, 886016,
                      constraints: ["(x0 + 0x1) != 0x0", "[[sp+0x38]] == NULL || [sp+0x38] is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x28], 0, [sp+0x38], [sp+0xd0])")
OneGadget::Gadget.add(build_id, 886024,
                      constraints: ["[[sp+0x38]] == NULL || [sp+0x38] is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x28], 0, [sp+0x38], [sp+0xd0])")
OneGadget::Gadget.add(build_id, 886028,
                      constraints: ["[[sp+0x38]] == NULL || [sp+0x38] is a valid argv", "[x5] == NULL || x5 == NULL || x5 is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x28], 0, [sp+0x38], x5)")
OneGadget::Gadget.add(build_id, 886032,
                      constraints: ["[[sp+0x38]] == NULL || [sp+0x38] is a valid argv", "[x5] == NULL || x5 == NULL || x5 is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x28], 0, [sp+0x38], x5)")
OneGadget::Gadget.add(build_id, 887300,
                      constraints: ["[[sp+0x38]] == NULL || [sp+0x38] is a valid argv", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x28], 0, [sp+0x38], environ)")
OneGadget::Gadget.add(build_id, 887308,
                      constraints: ["readable: x0", "[[sp+0x38]] == NULL || [sp+0x38] is a valid argv", "[[x0]] == NULL || [x0] == NULL || [x0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x28], 0, [sp+0x38], [x0])")
OneGadget::Gadget.add(build_id, 887312,
                      constraints: ["[[sp+0x38]] == NULL || [sp+0x38] is a valid argv", "[x5] == NULL || x5 == NULL || x5 is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x28], 0, [sp+0x38], x5)")
OneGadget::Gadget.add(build_id, 887384,
                      constraints: ["([sp+0xc8] + 0x1) != 0x0", "[[sp+0x38]] == NULL || [sp+0x38] is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x28], 0, [sp+0x38], [sp+0xd0])")

