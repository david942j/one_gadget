require 'one_gadget/gadget'
# spec/data/aarch64-libc-2.43.so
# 
# ARM 64-bit architecture
# 
# GNU C Library (Ubuntu GLIBC 2.43-2ubuntu2) stable release version 2.43.
# Copyright (C) 2026 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 15.2.0.
# libc ABIs: UNIQUE ABSOLUTE
# Minimum supported kernel: 3.7.0
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 310192,
                      constraints: ["readable: x22", "x0 != 0x1", "{\"sh\", \"-c\", \"--\", x21, ...} is a valid argv", "sp+0x218 == NULL || (u16)[sp+0x218] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x218, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 310192,
                      constraints: ["readable: x22", "x0 == 0x1", "{\"sh\", \"-c\", \"--\", x21, ...} is a valid argv", "sp+0x218 == NULL || (u16)[sp+0x218] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x218, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 310196,
                      constraints: ["readable: x22", "x0 != 0x1", "{\"sh\", \"-c\", \"--\", x21, ...} is a valid argv", "sp+0x218 == NULL || (u16)[sp+0x218] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x218, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 310196,
                      constraints: ["readable: x22", "x0 == 0x1", "{\"sh\", \"-c\", \"--\", x21, ...} is a valid argv", "sp+0x218 == NULL || (u16)[sp+0x218] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x218, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 310200,
                      constraints: ["readable: x22", "x0 != 0x1", "{\"sh\", \"-c\", \"--\", x21, ...} is a valid argv", "sp+0x218 == NULL || (u16)[sp+0x218] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x218, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 310200,
                      constraints: ["readable: x22", "x0 == 0x1", "{\"sh\", \"-c\", \"--\", x21, ...} is a valid argv", "sp+0x218 == NULL || (u16)[sp+0x218] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x218, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 310208,
                      constraints: ["readable: x22", "{\"sh\", \"-c\", \"--\", x21, ...} is a valid argv", "sp+0x218 == NULL || (u16)[sp+0x218] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x218, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 310212,
                      constraints: ["readable: x22", "{\"sh\", \"-c\", \"--\", x21, ...} is a valid argv", "sp+0x218 == NULL || (u16)[sp+0x218] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x218, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 310216,
                      constraints: ["readable: x22", "{\"sh\", \"-c\", \"--\", x21, ...} is a valid argv", "sp+0x218 == NULL || (u16)[sp+0x218] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x218, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 310220,
                      constraints: ["readable: x22", "writable: x0", "{\"sh\", \"-c\", \"--\", x21, ...} is a valid argv", "sp+0x218 == NULL || (u16)[sp+0x218] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x218, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 310224,
                      constraints: ["readable: x22", "{\"sh\", \"-c\", \"--\", x21, ...} is a valid argv", "sp+0x218 == NULL || (u16)[sp+0x218] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x218, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 310228,
                      constraints: ["readable: x1", "{\"sh\", \"-c\", \"--\", x21, ...} is a valid argv", "sp+0x218 == NULL || (u16)[sp+0x218] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x218, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 310232,
                      constraints: ["readable: x1", "writable: x0", "{\"sh\", \"-c\", \"--\", x21, ...} is a valid argv", "sp+0x218 == NULL || (u16)[sp+0x218] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x218, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 310236,
                      constraints: ["{\"sh\", \"-c\", \"--\", x21, ...} is a valid argv", "sp+0x218 == NULL || (u16)[sp+0x218] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x218, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 310240,
                      constraints: ["readable: x1", "{\"sh\", \"-c\", \"--\", x21, ...} is a valid argv", "sp+0x218 == NULL || (u16)[sp+0x218] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x218, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 310244,
                      constraints: ["readable: x1", "writable: x0", "{\"sh\", \"-c\", \"--\", x21, ...} is a valid argv", "sp+0x218 == NULL || (u16)[sp+0x218] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x218, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 310248,
                      constraints: ["{\"sh\", \"-c\", \"--\", x21, ...} is a valid argv", "sp+0x218 == NULL || (u16)[sp+0x218] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x218, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 310252,
                      constraints: ["{\"sh\", \"-c\", \"--\", x21, ...} is a valid argv", "sp+0x218 == NULL || (u16)[sp+0x218] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x218, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 310256,
                      constraints: ["writable: x0", "{\"sh\", \"-c\", \"--\", x21, ...} is a valid argv", "sp+0x218 == NULL || (u16)[sp+0x218] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x218, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 310260,
                      constraints: ["{\"sh\", \"-c\", \"--\", x21, ...} is a valid argv", "sp+0x218 == NULL || (u16)[sp+0x218] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x218, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 310264,
                      constraints: ["{\"sh\", \"-c\", \"--\", x21, ...} is a valid argv", "sp+0x218 == NULL || (u16)[sp+0x218] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x218, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 310268,
                      constraints: ["x0+0x240 == NULL || {x0+0x240, \"-c\", \"--\", x21, ...} is a valid argv", "sp+0x218 == NULL || (u16)[sp+0x218] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x218, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 310272,
                      constraints: ["x0 == NULL || {x0, \"-c\", \"--\", x21, ...} is a valid argv", "sp+0x218 == NULL || (u16)[sp+0x218] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x218, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 310276,
                      constraints: ["[sp+0x50] == NULL || {[sp+0x50], \"-c\", \"--\", x21, ...} is a valid argv", "sp+0x218 == NULL || (u16)[sp+0x218] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x218, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 310280,
                      constraints: ["[sp+0x50] == NULL || {[sp+0x50], x0+0x248, \"--\", x21, ...} is a valid argv", "sp+0x218 == NULL || (u16)[sp+0x218] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x218, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 310284,
                      constraints: ["[sp+0x50] == NULL || {[sp+0x50], x0, \"--\", x21, ...} is a valid argv", "sp+0x218 == NULL || (u16)[sp+0x218] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x218, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 310288,
                      constraints: ["[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], \"--\", x21, ...} is a valid argv", "sp+0x218 == NULL || (u16)[sp+0x218] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x218, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 310292,
                      constraints: ["[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], x0+0x250, x21, ...} is a valid argv", "sp+0x218 == NULL || (u16)[sp+0x218] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x218, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 310296,
                      constraints: ["[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], x0, x21, ...} is a valid argv", "sp+0x218 == NULL || (u16)[sp+0x218] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x218, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 310300,
                      constraints: ["[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "sp+0x218 == NULL || (u16)[sp+0x218] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x218, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 310304,
                      constraints: ["[x4] == NULL || x4 is a valid argv", "sp+0x218 == NULL || (u16)[sp+0x218] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x218, x4, environ)")
OneGadget::Gadget.add(build_id, 310308,
                      constraints: ["[x4] == NULL || x4 is a valid argv", "x3 == NULL || (u16)[x3] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, x3, x4, environ)")
OneGadget::Gadget.add(build_id, 310316,
                      constraints: ["readable: x0", "[x4] == NULL || x4 is a valid argv", "[[x0]] == NULL || [x0] == NULL || [x0] is a valid envp", "x3 == NULL || (u16)[x3] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, x3, x4, [x0])")
OneGadget::Gadget.add(build_id, 484796,
                      constraints: ["[$base+0x1c2430] == 0x0", "[$base+0x1c2438] == 0x0", "w2 != 0x0", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484796,
                      constraints: ["[$base+0x1c2438] == 0x0", "w2 == 0x0", "x3 == [$base+0x1c2430]", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484796,
                      constraints: ["[$base+0x1c2430] != 0x0", "[$base+0x1c2438] == 0x0", "w2 != 0x0", "x3 == [$base+0x1c2430]", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484800,
                      constraints: ["[$base+0x1c2438] == 0x0", "w2 == 0x0", "x3 == [x0+0x430]", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484800,
                      constraints: ["[$base+0x1c2438] == 0x0", "[x0+0x430] == 0x0", "w2 != 0x0", "writable: x0+0x430", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484800,
                      constraints: ["[$base+0x1c2438] == 0x0", "[x0+0x430] != 0x0", "w2 != 0x0", "x3 == [x0+0x430]", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484804,
                      constraints: ["[$base+0x1c2438] == 0x0", "w2 == 0x0", "x3 == [x1+0x8]", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484804,
                      constraints: ["[$base+0x1c2438] == 0x0", "[x1+0x8] == 0x0", "w2 != 0x0", "writable: x1+0x8", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484804,
                      constraints: ["[$base+0x1c2438] == 0x0", "[x1+0x8] != 0x0", "w2 != 0x0", "x3 == [x1+0x8]", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484808,
                      constraints: ["[$base+0x1c2438] == 0x0", "w2 == 0x0", "x3 == [x1+0x8]", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484808,
                      constraints: ["[$base+0x1c2438] == 0x0", "[x1+0x8] == 0x0", "w2 != 0x0", "writable: x1+0x8", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484808,
                      constraints: ["[$base+0x1c2438] == 0x0", "[x1+0x8] != 0x0", "w2 != 0x0", "x3 == [x1+0x8]", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484812,
                      constraints: ["[$base+0x1c2438] == 0x0", "w2 == 0x0", "x3 == x0", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484812,
                      constraints: ["[$base+0x1c2438] == 0x0", "w2 != 0x0", "writable: x1+0x8", "x0 == 0x0", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484812,
                      constraints: ["[$base+0x1c2438] == 0x0", "w2 != 0x0", "x0 != 0x0", "x3 == x0", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484816,
                      constraints: ["[$base+0x1c2438] == 0x0", "writable: x1+0x8", "x0 == 0x0", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484816,
                      constraints: ["[$base+0x1c2438] == 0x0", "x0 != 0x0", "x3 == x0", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484816,
                      constraints: ["[[$base+0x1c2438]+0xe8] == 0x0", "w6 == [[$base+0x1c2438]+0x70]", "writable: x1+0x8", "x0 == 0x0", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484820,
                      constraints: ["[$base+0x1c2438] == 0x0", "writable: x1+0x8", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484820,
                      constraints: ["[[$base+0x1c2438]+0xe8] == 0x0", "w6 == [[$base+0x1c2438]+0x70]", "writable: x1+0x8", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484824,
                      constraints: ["[$base+0x1c2438] == 0x0", "writable: x1+0x8", "writable: x2+0x428", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484824,
                      constraints: ["[[$base+0x1c2438]+0xe8] == 0x0", "w6 == [[$base+0x1c2438]+0x70]", "writable: x1+0x8", "writable: x2+0x428", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484828,
                      constraints: ["[$base+0x1c2438] == 0x0", "writable: x1+0x8", "writable: x2+0x428", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484828,
                      constraints: ["[[$base+0x1c2438]+0xe8] == 0x0", "w6 == [[$base+0x1c2438]+0x70]", "writable: x1+0x8", "writable: x2+0x428", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484832,
                      constraints: ["[$base+0x1c2438] == 0x0", "writable: x2+0x428", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484832,
                      constraints: ["[[$base+0x1c2438]+0xe8] == 0x0", "w6 == [[$base+0x1c2438]+0x70]", "writable: x2+0x428", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484836,
                      constraints: ["[$base+0x1c2438] == 0x0", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484836,
                      constraints: ["[[$base+0x1c2438]+0xe8] == 0x0", "w6 == [[$base+0x1c2438]+0x70]", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484856,
                      constraints: ["[$base+0x1c2438] == 0x0", "x3 == x0", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484856,
                      constraints: ["[[$base+0x1c2438]+0xe8] == 0x0", "w6 == [[$base+0x1c2438]+0x70]", "x3 == x0", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484896,
                      constraints: ["[$base+0x1c2438] == 0x0", "w0 == 0x0", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484896,
                      constraints: ["[[$base+0x1c2438]+0xe8] == 0x0", "[sp+0x10] == [[$base+0x1c2438]+0x70]", "w0 == 0x0", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484900,
                      constraints: ["[$base+0x1c2438] == 0x0", "w0 == 0x0", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484900,
                      constraints: ["[[$base+0x1c2438]+0xe8] == 0x0", "[sp+0x10] == [[$base+0x1c2438]+0x70]", "w0 == 0x0", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484904,
                      constraints: ["[$base+0x1c2438] == 0x0", "w0 == 0x0", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484904,
                      constraints: ["[[$base+0x1c2438]+0xe8] == 0x0", "w0 == 0x0", "w6 == [[$base+0x1c2438]+0x70]", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484908,
                      constraints: ["[$base+0x1c2438] == 0x0", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484908,
                      constraints: ["[[$base+0x1c2438]+0xe8] == 0x0", "w6 == [[$base+0x1c2438]+0x70]", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484912,
                      constraints: ["[$base+0x1c2438] == 0x0", "writable: x0+0x430", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484912,
                      constraints: ["[[$base+0x1c2438]+0xe8] == 0x0", "w6 == [[$base+0x1c2438]+0x70]", "writable: x0+0x430", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484916,
                      constraints: ["[$base+0x1c2438] == 0x0", "writable: x0+0x8", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484916,
                      constraints: ["[[$base+0x1c2438]+0xe8] == 0x0", "w6 == [[$base+0x1c2438]+0x70]", "writable: x0+0x8", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484920,
                      constraints: ["[$base+0x1c2438] == 0x0", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484920,
                      constraints: ["[[$base+0x1c2438]+0xe8] == 0x0", "w6 == [[$base+0x1c2438]+0x70]", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484924,
                      constraints: ["[x0+0x438] == 0x0", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484924,
                      constraints: ["[[x0+0x438]+0xe8] == 0x0", "w6 == [[x0+0x438]+0x70]", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484928,
                      constraints: ["[x0+0x10] == 0x0", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484928,
                      constraints: ["[[x0+0x10]+0xe8] == 0x0", "w6 == [[x0+0x10]+0x70]", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484932,
                      constraints: ["x2 == 0x0", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484932,
                      constraints: ["[x2+0xe8] == 0x0", "w6 == [x2+0x70]", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484936,
                      constraints: ["[x2+0xe8] == 0x0", "w6 == [x2+0x70]", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484940,
                      constraints: ["[x2+0xe8] == 0x0", "w6 == w1", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484964,
                      constraints: ["[[sp+0x10]+0xe8] == 0x0", "w0 == 0x0", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484968,
                      constraints: ["[x2+0xe8] == 0x0", "w0 == 0x0", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484972,
                      constraints: ["[x2+0xe8] == 0x0", "w0 == 0x0", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484976,
                      constraints: ["[x2+0xe8] == 0x0", "w0 == 0x0", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484980,
                      constraints: ["[x2+0xe8] == 0x0", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484984,
                      constraints: ["x2 == 0x0", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484988,
                      constraints: ["{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484992,
                      constraints: ["x0+0x240 == NULL || {x0+0x240, \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 484996,
                      constraints: ["x0 == NULL || {x0, \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 485000,
                      constraints: ["[sp+0x50] == NULL || {[sp+0x50], \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 485004,
                      constraints: ["[sp+0x50] == NULL || {[sp+0x50], x0+0x248, \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 485008,
                      constraints: ["[sp+0x50] == NULL || {[sp+0x50], x0, \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 485012,
                      constraints: ["[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 485016,
                      constraints: ["[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], x0+0x250, x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 485020,
                      constraints: ["[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], x0, x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 485024,
                      constraints: ["[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 485028,
                      constraints: ["[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0", "x3 == NULL || (u16)[x3] == 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, x3, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 485036,
                      constraints: ["readable: x0", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], x22, ...} is a valid argv", "[[x0]] == NULL || [x0] == NULL || [x0] is a valid envp", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0", "x3 == NULL || (u16)[x3] == 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, x3, sp+0x50, [x0])")
OneGadget::Gadget.add(build_id, 485040,
                      constraints: ["readable: x0", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[x0]] == NULL || [x0] == NULL || [x0] is a valid envp", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0", "x3 == NULL || (u16)[x3] == 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, x3, sp+0x50, [x0])")
OneGadget::Gadget.add(build_id, 485044,
                      constraints: ["readable: x0", "[x4] == NULL || x4 is a valid argv", "[[x0]] == NULL || [x0] == NULL || [x0] is a valid envp", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0", "x3 == NULL || (u16)[x3] == 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, x3, x4, [x0])")
OneGadget::Gadget.add(build_id, 485048,
                      constraints: ["readable: x0", "[x4] == NULL || x4 is a valid argv", "[[x0]] == NULL || [x0] == NULL || [x0] is a valid envp", "x21+0xe0 == NULL || writable: x21+0xe0", "x2 == NULL || (s32)[x2+0x4] <= 0x0", "x3 == NULL || (u16)[x3] == 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x2, x3, x4, [x0])")
OneGadget::Gadget.add(build_id, 485256,
                      constraints: ["[$base+0x1c2438] == 0x0", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 485256,
                      constraints: ["[[$base+0x1c2438]+0xe8] == 0x0", "w6 == [[$base+0x1c2438]+0x70]", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 485260,
                      constraints: ["[$base+0x1c2438] == 0x0", "writable: x0+0x42c", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 485260,
                      constraints: ["[[$base+0x1c2438]+0xe8] == 0x0", "w6 == [[$base+0x1c2438]+0x70]", "writable: x0+0x42c", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 485264,
                      constraints: ["[$base+0x1c2438] == 0x0", "writable: x1+0x4", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 485264,
                      constraints: ["[[$base+0x1c2438]+0xe8] == 0x0", "w6 == [[$base+0x1c2438]+0x70]", "writable: x1+0x4", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 485268,
                      constraints: ["[$base+0x1c2438] == 0x0", "writable: x1+0x4", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 485268,
                      constraints: ["[[$base+0x1c2438]+0xe8] == 0x0", "w6 == [[$base+0x1c2438]+0x70]", "writable: x1+0x4", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 485272,
                      constraints: ["[$base+0x1c2438] == 0x0", "writable: x1+0x4", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 485272,
                      constraints: ["[[$base+0x1c2438]+0xe8] == 0x0", "w6 == [[$base+0x1c2438]+0x70]", "writable: x1+0x4", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 485276,
                      constraints: ["[$base+0x1c2438] == 0x0", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 485276,
                      constraints: ["[[$base+0x1c2438]+0xe8] == 0x0", "w6 == [[$base+0x1c2438]+0x70]", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 485524,
                      constraints: ["[$base+0x1c2438] == 0x0", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 485524,
                      constraints: ["[[$base+0x1c2438]+0xe8] == 0x0", "[sp+0x8] == [[$base+0x1c2438]+0x70]", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 485528,
                      constraints: ["[$base+0x1c2438] == 0x0", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 485528,
                      constraints: ["[[$base+0x1c2438]+0xe8] == 0x0", "[sp+0x8] == [[$base+0x1c2438]+0x70]", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 485532,
                      constraints: ["[$base+0x1c2438] == 0x0", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 485532,
                      constraints: ["[[$base+0x1c2438]+0xe8] == 0x0", "w6 == [[$base+0x1c2438]+0x70]", "{\"sh\", \"-c\", \"--\", x22, ...} is a valid argv", "x21+0xe0 == NULL || writable: x21+0xe0", "x23 == NULL || (s32)[x23+0x4] <= 0x0"],
                      effect: "posix_spawn(x21+0xe0, \"/bin/sh\", x23, 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 817612,
                      constraints: ["[x1] == 0x0", "writable: x29-0x20", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x6] == NULL || x6 == NULL || x6 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29-0x20, x6)")
OneGadget::Gadget.add(build_id, 817616,
                      constraints: ["[x1] == 0x0", "writable: x29-0x20", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x6] == NULL || x6 == NULL || x6 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29-0x20, x6)")
OneGadget::Gadget.add(build_id, 817620,
                      constraints: ["[x1] == 0x0", "writable: x29-0x20", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x6] == NULL || x6 == NULL || x6 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29-0x20, x6)")
OneGadget::Gadget.add(build_id, 817624,
                      constraints: ["writable: x29-0x20", "x3 == 0x0", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x6] == NULL || x6 == NULL || x6 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29-0x20, x6)")
OneGadget::Gadget.add(build_id, 817628,
                      constraints: ["writable: x29-0x20", "x3 == 0x0", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x6] == NULL || x6 == NULL || x6 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29-0x20, x6)")
OneGadget::Gadget.add(build_id, 817632,
                      constraints: ["writable: x29-0x20", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x6] == NULL || x6 == NULL || x6 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29-0x20, x6)")
OneGadget::Gadget.add(build_id, 817712,
                      constraints: ["(u64)x5 < 0x400", "x2 == 0x1", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x6] == NULL || x6 == NULL || x6 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp+0x10, x6)")
OneGadget::Gadget.add(build_id, 817712,
                      constraints: ["(u64)x5 >= 0x400", "x2 == 0x1", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x6] == NULL || x6 == NULL || x6 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp+0x10, x6)")
OneGadget::Gadget.add(build_id, 817716,
                      constraints: ["(u64)x5 < 0x400", "x2 == 0x1", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x6] == NULL || x6 == NULL || x6 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp+0x10, x6)")
OneGadget::Gadget.add(build_id, 817716,
                      constraints: ["(u64)x5 >= 0x400", "x2 == 0x1", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x6] == NULL || x6 == NULL || x6 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp+0x10, x6)")
OneGadget::Gadget.add(build_id, 817724,
                      constraints: ["x2 == 0x1", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x6] == NULL || x6 == NULL || x6 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp+0x10, x6)")
OneGadget::Gadget.add(build_id, 817728,
                      constraints: ["writable: x4", "x2 == 0x1", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x6] == NULL || x6 == NULL || x6 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x4, x6)")
OneGadget::Gadget.add(build_id, 817860,
                      constraints: ["x2 == 0x1", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x6] == NULL || x6 == NULL || x6 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp+0x10, x6)")
OneGadget::Gadget.add(build_id, 817864,
                      constraints: ["x2 == 0x1", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x6] == NULL || x6 == NULL || x6 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp+0x10, x6)")
OneGadget::Gadget.add(build_id, 817868,
                      constraints: ["writable: x4", "x2 == 0x1", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x6] == NULL || x6 == NULL || x6 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x4, x6)")
OneGadget::Gadget.add(build_id, 817920,
                      constraints: ["writable: x29-0x20", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x6] == NULL || x6 == NULL || x6 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29-0x20, x6)")
OneGadget::Gadget.add(build_id, 930244,
                      constraints: ["x0 == 0x0", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 930252,
                      constraints: ["readable: x1", "x0 == 0x0", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[x1]] == NULL || [x1] == NULL || [x1] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [x1])")
OneGadget::Gadget.add(build_id, 930256,
                      constraints: ["x0 == 0x0", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[x28] == NULL || x28 == NULL || x28 is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, x28)")
OneGadget::Gadget.add(build_id, 930404,
                      constraints: ["([sp+0xc8] + 0x1) != 0x0", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 930408,
                      constraints: ["(x0 + 0x1) != 0x0", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 930416,
                      constraints: ["[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 930420,
                      constraints: ["[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[x28] == NULL || x28 == NULL || x28 is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, x28)")
OneGadget::Gadget.add(build_id, 931872,
                      constraints: ["([sp+0xc8] + 0x1) != 0x0", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")

