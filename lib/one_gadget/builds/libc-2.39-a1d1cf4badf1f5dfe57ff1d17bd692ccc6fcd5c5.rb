require 'one_gadget/gadget'
# spec/data/riscv64-libc-2.39.so
# 
# RISC-V
# 
# GNU C Library (Ubuntu GLIBC 2.39-0ubuntu8) stable release version 2.39.
# Copyright (C) 2024 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 13.2.0.
# libc ABIs: UNIQUE ABSOLUTE IFUNC
# Minimum supported kernel: 4.15.0
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 290276,
                      constraints: ["a3 != a4", "readable: s2", "{\"sh\", \"-c\", \"--\", s4, ...} is a valid argv", "sp+0x208 == NULL || (u16)[sp+0x208] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x208, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 290276,
                      constraints: ["a3 == a4", "readable: s2", "{\"sh\", \"-c\", \"--\", s4, ...} is a valid argv", "sp+0x208 == NULL || (u16)[sp+0x208] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x208, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 290278,
                      constraints: ["a3 != a4", "readable: s2", "{\"sh\", \"-c\", \"--\", s4, ...} is a valid argv", "sp+0x208 == NULL || (u16)[sp+0x208] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x208, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 290278,
                      constraints: ["a3 == a4", "readable: s2", "{\"sh\", \"-c\", \"--\", s4, ...} is a valid argv", "sp+0x208 == NULL || (u16)[sp+0x208] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x208, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 290280,
                      constraints: ["a3 != a4", "readable: s2", "{\"sh\", \"-c\", \"--\", s4, ...} is a valid argv", "sp+0x208 == NULL || (u16)[sp+0x208] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x208, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 290280,
                      constraints: ["a3 == a4", "readable: s2", "{\"sh\", \"-c\", \"--\", s4, ...} is a valid argv", "sp+0x208 == NULL || (u16)[sp+0x208] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x208, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 290284,
                      constraints: ["readable: s2", "{\"sh\", \"-c\", \"--\", s4, ...} is a valid argv", "sp+0x208 == NULL || (u16)[sp+0x208] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x208, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 290288,
                      constraints: ["readable: s2", "{\"sh\", \"-c\", \"--\", s4, ...} is a valid argv", "sp+0x208 == NULL || (u16)[sp+0x208] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x208, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 290290,
                      constraints: ["readable: s2", "{\"sh\", \"-c\", \"--\", s4, ...} is a valid argv", "sp+0x208 == NULL || (u16)[sp+0x208] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x208, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 290292,
                      constraints: ["readable: s2", "writable: s1", "{\"sh\", \"-c\", \"--\", s4, ...} is a valid argv", "(u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, s1, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 290294,
                      constraints: ["readable: s2", "writable: a0", "writable: s1", "{\"sh\", \"-c\", \"--\", s4, ...} is a valid argv", "(u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, s1, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 290298,
                      constraints: ["readable: s2", "writable: s1", "{\"sh\", \"-c\", \"--\", s4, ...} is a valid argv", "(u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, s1, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 290300,
                      constraints: ["readable: a1", "writable: s1", "{\"sh\", \"-c\", \"--\", s4, ...} is a valid argv", "(u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, s1, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 290302,
                      constraints: ["readable: a1", "writable: a0", "writable: s1", "{\"sh\", \"-c\", \"--\", s4, ...} is a valid argv", "(u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, s1, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 290306,
                      constraints: ["writable: s1", "{\"sh\", \"-c\", \"--\", s4, ...} is a valid argv", "(u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, s1, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 290308,
                      constraints: ["readable: a1", "writable: s1", "{\"sh\", \"-c\", \"--\", s4, ...} is a valid argv", "(u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, s1, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 290310,
                      constraints: ["readable: a1", "writable: a0", "writable: s1", "{\"sh\", \"-c\", \"--\", s4, ...} is a valid argv", "(u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, s1, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 290314,
                      constraints: ["writable: s1", "{\"sh\", \"-c\", \"--\", s4, ...} is a valid argv", "(u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, s1, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 290316,
                      constraints: ["writable: s1", "{\"sh\", \"-c\", \"--\", s4, ...} is a valid argv", "(u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, s1, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 290318,
                      constraints: ["writable: a0", "{\"sh\", \"-c\", \"--\", s4, ...} is a valid argv", "s1 == NULL || (u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, s1, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 290322,
                      constraints: ["{\"sh\", \"-c\", \"--\", s4, ...} is a valid argv", "s1 == NULL || (u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, s1, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 290330,
                      constraints: ["readable: a5", "{\"sh\", \"-c\", \"--\", s4, ...} is a valid argv", "[[a5]] == NULL || [a5] == NULL || [a5] is a valid envp", "s1 == NULL || (u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, s1, sp+0x48, [a5])")
OneGadget::Gadget.add(build_id, 290332,
                      constraints: ["{\"sh\", \"-c\", \"--\", s4, ...} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s1 == NULL || (u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, s1, sp+0x48, a5)")
OneGadget::Gadget.add(build_id, 290336,
                      constraints: ["a6-0x4cc == NULL || {a6-0x4cc, \"-c\", \"--\", s4, ...} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s1 == NULL || (u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, s1, sp+0x48, a5)")
OneGadget::Gadget.add(build_id, 290340,
                      constraints: ["a6 == NULL || {a6, \"-c\", \"--\", s4, ...} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s1 == NULL || (u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, s1, sp+0x48, a5)")
OneGadget::Gadget.add(build_id, 290342,
                      constraints: ["[sp+0x48] == NULL || {[sp+0x48], \"-c\", \"--\", s4, ...} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s1 == NULL || (u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, s1, sp+0x48, a5)")
OneGadget::Gadget.add(build_id, 290346,
                      constraints: ["[sp+0x48] == NULL || {[sp+0x48], a6-0x4ce, \"--\", s4, ...} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s1 == NULL || (u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, s1, sp+0x48, a5)")
OneGadget::Gadget.add(build_id, 290350,
                      constraints: ["[sp+0x48] == NULL || {[sp+0x48], a6, \"--\", s4, ...} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s1 == NULL || (u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, s1, sp+0x48, a5)")
OneGadget::Gadget.add(build_id, 290352,
                      constraints: ["[sp+0x48] == NULL || {[sp+0x48], a6, \"--\", s4, ...} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "a3 == NULL || (u16)[a3] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, a3, sp+0x48, a5)")
OneGadget::Gadget.add(build_id, 290354,
                      constraints: ["[sp+0x48] == NULL || {[sp+0x48], [sp+0x50], \"--\", s4, ...} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "a3 == NULL || (u16)[a3] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, a3, sp+0x48, a5)")
OneGadget::Gadget.add(build_id, 290356,
                      constraints: ["[a4] == NULL || a4 is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "a3 == NULL || (u16)[a3] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, a3, a4, a5)")
OneGadget::Gadget.add(build_id, 290360,
                      constraints: ["[a4] == NULL || a4 is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "a3 == NULL || (u16)[a3] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, a3, a4, a5)")
OneGadget::Gadget.add(build_id, 290364,
                      constraints: ["[a4] == NULL || a4 is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "a3 == NULL || (u16)[a3] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, a3, a4, a5)")
OneGadget::Gadget.add(build_id, 290366,
                      constraints: ["[a4] == NULL || a4 is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "a2 == NULL || (s32)[a2+0x4] <= 0x0", "a3 == NULL || (u16)[a3] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", a2, a3, a4, a5)")
OneGadget::Gadget.add(build_id, 402824,
                      constraints: ["[$base+0x1743e0] == 0x0", "[$base+0x1743e8] == 0x0", "a4 == 0x0", "writable: s0-0xf0", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, environ)")
OneGadget::Gadget.add(build_id, 402828,
                      constraints: ["[s6-0x1a0] == 0x0", "[s6-0x1a8] == 0x0", "a4 == 0x0", "writable: s0-0xf0", "writable: s6-0x1b0", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, environ)")
OneGadget::Gadget.add(build_id, 402832,
                      constraints: ["[s6+0x10] == 0x0", "[s6+0x8] == 0x0", "a4 == 0x0", "writable: s0-0xf0", "writable: s6", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, environ)")
OneGadget::Gadget.add(build_id, 402836,
                      constraints: ["[s6+0x10] == 0x0", "a4 == 0x0", "a5 == 0x0", "writable: s0-0xf0", "writable: s6", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, environ)")
OneGadget::Gadget.add(build_id, 402840,
                      constraints: ["[s6+0x10] == 0x0", "a4 == 0x0", "a5 == 0x0", "writable: s0-0xf0", "writable: s6", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, environ)")
OneGadget::Gadget.add(build_id, 402842,
                      constraints: ["[s6+0x10] == 0x0", "a5 == 0x0", "writable: s0-0xf0", "writable: s6", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, environ)")
OneGadget::Gadget.add(build_id, 402866,
                      constraints: ["[s6+0x10] == 0x0", "a5 == 0x0", "writable: s0-0xf0", "writable: s6+0x8", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, environ)")
OneGadget::Gadget.add(build_id, 402870,
                      constraints: ["[s6+0x10] == 0x0", "writable: s0-0xf0", "writable: s6+0x8", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, environ)")
OneGadget::Gadget.add(build_id, 402874,
                      constraints: ["[s6+0x10] == 0x0", "writable: s0-0xf0", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, environ)")
OneGadget::Gadget.add(build_id, 402878,
                      constraints: ["s2 == 0x0", "writable: s0-0xf0", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, environ)")
OneGadget::Gadget.add(build_id, 402886,
                      constraints: ["[s2+0xe8] == 0x0", "s11 == a1", "writable: s0-0xf0", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, environ)")
OneGadget::Gadget.add(build_id, 402896,
                      constraints: ["[s2+0xe8] == 0x0", "a0 == 0x0", "writable: s0-0xf0", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, environ)")
OneGadget::Gadget.add(build_id, 402898,
                      constraints: ["[s2+0xe8] == 0x0", "a0 == 0x0", "writable: s0-0xf0", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, environ)")
OneGadget::Gadget.add(build_id, 402900,
                      constraints: ["[s2+0xe8] == 0x0", "writable: s0-0xf0", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, environ)")
OneGadget::Gadget.add(build_id, 402904,
                      constraints: ["s2 == 0x0", "writable: s0-0xf0", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, environ)")
OneGadget::Gadget.add(build_id, 402908,
                      constraints: ["writable: s0-0xf0", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, environ)")
OneGadget::Gadget.add(build_id, 402916,
                      constraints: ["readable: a5", "writable: s0-0xf0", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "[[a5]] == NULL || [a5] == NULL || [a5] is a valid envp", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, [a5])")
OneGadget::Gadget.add(build_id, 402920,
                      constraints: ["readable: a5", "writable: s0-0xf0", "a6+0x36c == NULL || {a6+0x36c, \"-c\", \"--\", s3, ...} is a valid argv", "[[a5]] == NULL || [a5] == NULL || [a5] is a valid envp", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, [a5])")
OneGadget::Gadget.add(build_id, 402924,
                      constraints: ["readable: a5", "writable: s0-0xf0", "a6 == NULL || {a6, \"-c\", \"--\", s3, ...} is a valid argv", "[[a5]] == NULL || [a5] == NULL || [a5] is a valid envp", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, [a5])")
OneGadget::Gadget.add(build_id, 402926,
                      constraints: ["writable: s0-0xf0", "a6 == NULL || {a6, \"-c\", \"--\", s3, ...} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, a5)")
OneGadget::Gadget.add(build_id, 402930,
                      constraints: ["writable: s0-0xe8", "[s0-0xf0] == NULL || {[s0-0xf0], \"-c\", \"--\", s3, ...} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, a5)")
OneGadget::Gadget.add(build_id, 402934,
                      constraints: ["writable: s0-0xe8", "[s0-0xf0] == NULL || {[s0-0xf0], a6+0x366, \"--\", s3, ...} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, a5)")
OneGadget::Gadget.add(build_id, 402938,
                      constraints: ["writable: s0-0xe8", "[s0-0xf0] == NULL || {[s0-0xf0], a6, \"--\", s3, ...} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, a5)")
OneGadget::Gadget.add(build_id, 402942,
                      constraints: ["writable: s0-0xe0", "[s0-0xf0] == NULL || {[s0-0xf0], [s0-0xe8], \"--\", s3, ...} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, a5)")
OneGadget::Gadget.add(build_id, 402946,
                      constraints: ["writable: s0-0xe0", "[a4] == NULL || a4 is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, a4, a5)")
OneGadget::Gadget.add(build_id, 402950,
                      constraints: ["writable: s0-0xe0", "[a4] == NULL || a4 is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, a4, a5)")
OneGadget::Gadget.add(build_id, 402954,
                      constraints: ["writable: s0-0xe0", "[a4] == NULL || a4 is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, a4, a5)")
OneGadget::Gadget.add(build_id, 402956,
                      constraints: ["writable: s0-0xe0", "[a4] == NULL || a4 is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0", "a3 == NULL || (u16)[a3] == 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, a3, a4, a5)")
OneGadget::Gadget.add(build_id, 402958,
                      constraints: ["writable: s0-0xe0", "[a4] == NULL || a4 is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s1+0xe0 == NULL || writable: s1+0xe0", "a2 == NULL || (s32)[a2+0x4] <= 0x0", "a3 == NULL || (u16)[a3] == 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", a2, a3, a4, a5)")
OneGadget::Gadget.add(build_id, 403152,
                      constraints: ["[s6+0x10] == 0x0", "writable: s0-0xf0", "writable: s6", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, environ)")
OneGadget::Gadget.add(build_id, 403154,
                      constraints: ["[s6+0x10] == 0x0", "writable: s0-0xf0", "writable: s6", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, environ)")
OneGadget::Gadget.add(build_id, 403158,
                      constraints: ["[s6+0x10] == 0x0", "writable: s0-0xf0", "writable: s6+0x8", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, environ)")
OneGadget::Gadget.add(build_id, 403162,
                      constraints: ["[s6+0x10] == 0x0", "writable: s0-0xf0", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, environ)")
OneGadget::Gadget.add(build_id, 403176,
                      constraints: ["[s6+0x10] == 0x0", "writable: s0-0xf0", "writable: s6+0x8", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, environ)")
OneGadget::Gadget.add(build_id, 403342,
                      constraints: ["[s6+0x10] == 0x0", "writable: s0-0xf0", "writable: s6+0x4", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, environ)")
OneGadget::Gadget.add(build_id, 403346,
                      constraints: ["[s6+0x10] == 0x0", "writable: s0-0xf0", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, environ)")
OneGadget::Gadget.add(build_id, 653000,
                      constraints: ["[a1] == 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x50, a2)")
OneGadget::Gadget.add(build_id, 653000,
                      constraints: ["[a1+0x8] == 0x0", "[a1] != 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x70, a2)")
OneGadget::Gadget.add(build_id, 653002,
                      constraints: ["[a1] == 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp, a2)")
OneGadget::Gadget.add(build_id, 653002,
                      constraints: ["[a1+0x8] == 0x0", "[a1] != 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 653004,
                      constraints: ["[a1] == 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp, a2)")
OneGadget::Gadget.add(build_id, 653004,
                      constraints: ["[a1+0x8] == 0x0", "[a1] != 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 653006,
                      constraints: ["[a1] == 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp, a2)")
OneGadget::Gadget.add(build_id, 653006,
                      constraints: ["[a1+0x8] == 0x0", "[a1] != 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 653008,
                      constraints: ["[a1] == 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp, a2)")
OneGadget::Gadget.add(build_id, 653008,
                      constraints: ["[a1+0x8] == 0x0", "[a1] != 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 653010,
                      constraints: ["[a1] == 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp, a2)")
OneGadget::Gadget.add(build_id, 653010,
                      constraints: ["[a1+0x8] == 0x0", "[a1] != 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 653012,
                      constraints: ["[a1] == 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp, a2)")
OneGadget::Gadget.add(build_id, 653012,
                      constraints: ["[a1+0x8] == 0x0", "[a1] != 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 653014,
                      constraints: ["[a1] == 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp, a2)")
OneGadget::Gadget.add(build_id, 653014,
                      constraints: ["[a1+0x8] == 0x0", "[a1] != 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 653016,
                      constraints: ["[a1] == 0x0", "writable: s0-0x50", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, a2)")
OneGadget::Gadget.add(build_id, 653016,
                      constraints: ["[a1+0x8] == 0x0", "[a1] != 0x0", "writable: s0-0x38", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 653018,
                      constraints: ["a3 == 0x0", "writable: s0-0x50", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, a2)")
OneGadget::Gadget.add(build_id, 653018,
                      constraints: ["[a1+0x8] == 0x0", "a3 != 0x0", "writable: s0-0x38", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 653022,
                      constraints: ["a3 == 0x0", "readable: [s4+0x7be]", "writable: s0-0x50", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, a2)")
OneGadget::Gadget.add(build_id, 653022,
                      constraints: ["[a1+0x8] == 0x0", "a3 != 0x0", "readable: [s4+0x7be]", "writable: s0-0x38", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 653026,
                      constraints: ["a3 == 0x0", "readable: s4", "writable: s0-0x50", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, a2)")
OneGadget::Gadget.add(build_id, 653026,
                      constraints: ["[a1+0x8] == 0x0", "a3 != 0x0", "readable: s4", "writable: s0-0x38", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 653030,
                      constraints: ["a3 == 0x0", "writable: s0-0x50", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, a2)")
OneGadget::Gadget.add(build_id, 653030,
                      constraints: ["[a1+0x8] == 0x0", "a3 != 0x0", "writable: s0-0x38", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 653034,
                      constraints: ["[a1+0x8] == 0x0", "a3 != 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 653034,
                      constraints: ["a3 == 0x0", "writable: s0-0x50", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, a2)")
OneGadget::Gadget.add(build_id, 653036,
                      constraints: ["[a1+0x8] == 0x0", "a3 != 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 653036,
                      constraints: ["a3 == 0x0", "writable: s0-0x50", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, a2)")
OneGadget::Gadget.add(build_id, 653038,
                      constraints: ["[a1+0x8] == 0x0", "a3 != 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, s2)")
OneGadget::Gadget.add(build_id, 653038,
                      constraints: ["a3 == 0x0", "writable: s0-0x50", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, s2)")
OneGadget::Gadget.add(build_id, 653040,
                      constraints: ["[a1+0x8] == 0x0", "a3 != 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, s2)")
OneGadget::Gadget.add(build_id, 653040,
                      constraints: ["a3 == 0x0", "writable: s0-0x50", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, s2)")
OneGadget::Gadget.add(build_id, 653042,
                      constraints: ["[a1+0x8] == 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, s2)")
OneGadget::Gadget.add(build_id, 653044,
                      constraints: ["[a1] == 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, s2)")
OneGadget::Gadget.add(build_id, 653048,
                      constraints: ["[a1] == 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, s2)")
OneGadget::Gadget.add(build_id, 653050,
                      constraints: ["[a4] == 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, s2)")
OneGadget::Gadget.add(build_id, 653088,
                      constraints: ["a2 == 0x1", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp, s2)")
OneGadget::Gadget.add(build_id, 653090,
                      constraints: ["a2 == 0x1", "writable: s1", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s1, s2)")
OneGadget::Gadget.add(build_id, 653094,
                      constraints: ["a2 == 0x1", "writable: s1", "a4+0x246 == NULL || {a4+0x246, a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s1, s2)")
OneGadget::Gadget.add(build_id, 653098,
                      constraints: ["a2 == 0x1", "writable: s1", "a4 == NULL || {a4, a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s1, s2)")
OneGadget::Gadget.add(build_id, 653100,
                      constraints: ["a2 == 0x1", "writable: s1+0x8", "[s1] == NULL || s1 == NULL || s1 is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s1, s2)")
OneGadget::Gadget.add(build_id, 653102,
                      constraints: ["a2 == 0x1", "writable: s1+0x10", "[s1] == NULL || s1 == NULL || s1 is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s1, s2)")
OneGadget::Gadget.add(build_id, 653104,
                      constraints: ["a2 == a4", "writable: s1+0x10", "[s1] == NULL || s1 == NULL || s1 is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s1, s2)")
OneGadget::Gadget.add(build_id, 653108,
                      constraints: ["writable: s1+0x10", "[s1] == NULL || s1 == NULL || s1 is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s1, s2)")
OneGadget::Gadget.add(build_id, 653112,
                      constraints: ["[s1] == NULL || s1 == NULL || s1 is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s1, s2)")
OneGadget::Gadget.add(build_id, 653114,
                      constraints: ["[s1] == NULL || s1 == NULL || s1 is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s1, a2)")
OneGadget::Gadget.add(build_id, 653116,
                      constraints: ["[a1] == NULL || a1 == NULL || a1 is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", a1, a2)")
OneGadget::Gadget.add(build_id, 653176,
                      constraints: ["[s1] == NULL || s1 == NULL || s1 is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s1, s2)")
OneGadget::Gadget.add(build_id, 653196,
                      constraints: ["writable: s0-0x50", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, s2)")
OneGadget::Gadget.add(build_id, 653200,
                      constraints: ["writable: s0-0x50", "a5+0x1dc == NULL || {a5+0x1dc, a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, s2)")
OneGadget::Gadget.add(build_id, 653204,
                      constraints: ["writable: s0-0x50", "a5 == NULL || {a5, a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, s2)")
OneGadget::Gadget.add(build_id, 653208,
                      constraints: ["writable: s0-0x48", "[s0-0x50] == NULL || {[s0-0x50], a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, s2)")
OneGadget::Gadget.add(build_id, 653212,
                      constraints: ["writable: s0-0x40", "[s0-0x50] == NULL || {[s0-0x50], [s0-0x48], NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, s2)")
OneGadget::Gadget.add(build_id, 653216,
                      constraints: ["writable: s1+0x10", "[s1] == NULL || s1 == NULL || s1 is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s1, s2)")
OneGadget::Gadget.add(build_id, 743114,
                      constraints: ["a0 == 0x0", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 743118,
                      constraints: ["[[[$base+0x171fc0]]] == 0x0", "[sp+0xc8] != -0x1", "[sp+0xc8] != [sp+0xc0]", "writable: (([sp+0xc0] << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 743122,
                      constraints: ["[[[a5-0x70e]]] == 0x0", "[sp+0xc8] != -0x1", "[sp+0xc8] != [sp+0xc0]", "writable: (([sp+0xc0] << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 743126,
                      constraints: ["[[a5]] == 0x0", "[sp+0xc8] != -0x1", "[sp+0xc8] != [sp+0xc0]", "writable: (([sp+0xc0] << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 743130,
                      constraints: ["[[a5]] == 0x0", "[sp+0xc8] != -0x1", "[sp+0xc8] != [sp+0xc0]", "writable: (([sp+0xc0] << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 743134,
                      constraints: ["[s10] == 0x0", "[sp+0xc8] != -0x1", "[sp+0xc8] != [sp+0xc0]", "writable: (([sp+0xc0] << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 743136,
                      constraints: ["[s10] == 0x0", "[sp+0xc8] != -0x1", "s0 != -0x1", "s0 != [sp+0xc0]", "writable: (([sp+0xc0] << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 743140,
                      constraints: ["[sp+0xc8] != -0x1", "s0 != -0x1", "s0 != [sp+0xc0]", "s8 == 0x0", "writable: (([sp+0xc0] << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 743160,
                      constraints: ["[s10+0x8] == 0x0", "[sp+0xc8] != -0x1", "s0 != -0x1", "s0 != [sp+0xc0]", "writable: (([sp+0xc0] << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 743164,
                      constraints: ["[sp+0xc8] != -0x1", "s0 != -0x1", "s0 != [sp+0xc0]", "s8 == 0x0", "writable: (([sp+0xc0] << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 743166,
                      constraints: ["[sp+0xc8] != -0x1", "s0 != -0x1", "s0 != [sp+0xc0]", "s8 == 0x0", "writable: (([sp+0xc0] << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 743192,
                      constraints: ["[s10+0x8] == 0x0", "[sp+0xc8] != -0x1", "[sp+0xc8] != a5+0x1", "writable: ((a5 << 0x3) + [sp+0xd0])", "writable: ((a5+0x1 << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "s8 == NULL || readable: s8", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 743196,
                      constraints: ["[s10+0x8] == 0x0", "[sp+0xc8] != -0x1", "[sp+0xc8] != a4", "writable: ((a4 << 0x3) + [sp+0xd0])", "writable: ((a5 << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "s8 == NULL || readable: s8", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 743198,
                      constraints: ["[s10+0x8] == 0x0", "[sp+0xc8] != -0x1", "[sp+0xc8] != [sp+0xc0]", "writable: (([sp+0xc0] << 0x3) + [sp+0xd0])", "writable: ((a5 << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "s8 == NULL || readable: s8", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 743200,
                      constraints: ["[s10+0x8] == 0x0", "[sp+0xc8] != -0x1", "[sp+0xc8] != [sp+0xc0]", "writable: (([sp+0xc0] << 0x3) + [sp+0xd0])", "writable: ((a5 << 0x3) + a4)", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 743202,
                      constraints: ["[s10+0x8] == 0x0", "[sp+0xc8] != -0x1", "[sp+0xc8] != [sp+0xc0]", "writable: (([sp+0xc0] << 0x3) + [sp+0xd0])", "writable: (a5 + a4)", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 743204,
                      constraints: ["[s10+0x8] == 0x0", "[sp+0xc8] != -0x1", "[sp+0xc8] != [sp+0xc0]", "writable: (([sp+0xc0] << 0x3) + [sp+0xd0])", "writable: a5", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 743208,
                      constraints: ["[s10+0x8] == 0x0", "[sp+0xc8] != -0x1", "[sp+0xc8] != [sp+0xc0]", "writable: (([sp+0xc0] << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 743210,
                      constraints: ["[s10+0x8] == 0x0", "[sp+0xc8] != -0x1", "s0 != -0x1", "s0 != [sp+0xc0]", "writable: (([sp+0xc0] << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 743218,
                      constraints: ["[sp+0xc8] != -0x1", "s0 != -0x1", "s0 != [sp+0xc0]", "writable: (([sp+0xc0] << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 743222,
                      constraints: ["[sp+0xc8] != -0x1", "s0 != -0x1", "s0 != [sp+0xc0]", "writable: (([sp+0xc0] << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 743224,
                      constraints: ["[sp+0xc8] != -0x1", "s0 != [sp+0xc0]", "s0 != a5", "writable: (([sp+0xc0] << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 743228,
                      constraints: ["[sp+0xc8] != -0x1", "s0 != [sp+0xc0]", "writable: (([sp+0xc0] << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 743230,
                      constraints: ["[sp+0xc8] != -0x1", "s0 != a5", "writable: ((a5 << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 743234,
                      constraints: ["[sp+0xc8] != -0x1", "writable: ((a5 << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 743238,
                      constraints: ["[sp+0xc8] != -0x1", "writable: ((a5 << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 743240,
                      constraints: ["[sp+0xc8] != -0x1", "writable: ((a5 << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 743242,
                      constraints: ["[sp+0xc8] != -0x1", "writable: ((a5 << 0x3) + a4)", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 743244,
                      constraints: ["[sp+0xc8] != -0x1", "writable: (a5 + a4)", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 743246,
                      constraints: ["[sp+0xc8] != -0x1", "writable: a5", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 743250,
                      constraints: ["[sp+0xc8] != -0x1", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 743252,
                      constraints: ["a4 != -0x1", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 743254,
                      constraints: ["a4 != a5", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 743258,
                      constraints: ["[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 743260,
                      constraints: ["[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, a5)")
OneGadget::Gadget.add(build_id, 743264,
                      constraints: ["[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, a5)")
OneGadget::Gadget.add(build_id, 743266,
                      constraints: ["[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "a2 == NULL || (s32)[a2+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", a2, 0, sp+0x50, a5)")
OneGadget::Gadget.add(build_id, 743268,
                      constraints: ["[a4] == NULL || a4 is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "a2 == NULL || (s32)[a2+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", a2, 0, a4, a5)")
OneGadget::Gadget.add(build_id, 743270,
                      constraints: ["[a4] == NULL || a4 is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "a2 == NULL || (s32)[a2+0x4] <= 0x0", "a3 == NULL || (u16)[a3] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", a2, a3, a4, a5)")
OneGadget::Gadget.add(build_id, 744156,
                      constraints: ["[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 744164,
                      constraints: ["readable: a5", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[a5]] == NULL || [a5] == NULL || [a5] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [a5])")
OneGadget::Gadget.add(build_id, 744166,
                      constraints: ["[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, a5)")
OneGadget::Gadget.add(build_id, 744184,
                      constraints: ["[s10+0x8] == 0x0", "[sp+0xc8] != -0x1", "[sp+0xc8] != [sp+0xc0]", "writable: (([sp+0xc0] << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 744186,
                      constraints: ["[s10+0x8] == 0x0", "[sp+0xc8] != -0x1", "s0 != -0x1", "s0 != [sp+0xc0]", "writable: (([sp+0xc0] << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 744290,
                      constraints: ["[sp+0xc8] != -0x1", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")

