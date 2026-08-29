require 'one_gadget/gadget'
# http://ports.ubuntu.com/ubuntu-ports/pool/main/g/glibc/libc6_2.39-0ubuntu8.8_riscv64.deb
# 
# RISC-V
# 
# GNU C Library (Ubuntu GLIBC 2.39-0ubuntu8.8) stable release version 2.39.
# Copyright (C) 2024 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 13.3.0.
# libc ABIs: UNIQUE ABSOLUTE IFUNC
# Minimum supported kernel: 4.15.0
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 290284,
                      constraints: ["a3 != a4", "readable: s2", "{\"sh\", \"-c\", \"--\", s4, ...} is a valid argv", "sp+0x208 == NULL || (u16)[sp+0x208] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x208, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 290284,
                      constraints: ["a3 == a4", "readable: s2", "{\"sh\", \"-c\", \"--\", s4, ...} is a valid argv", "sp+0x208 == NULL || (u16)[sp+0x208] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x208, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 290286,
                      constraints: ["a3 != a4", "readable: s2", "{\"sh\", \"-c\", \"--\", s4, ...} is a valid argv", "sp+0x208 == NULL || (u16)[sp+0x208] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x208, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 290286,
                      constraints: ["a3 == a4", "readable: s2", "{\"sh\", \"-c\", \"--\", s4, ...} is a valid argv", "sp+0x208 == NULL || (u16)[sp+0x208] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x208, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 290288,
                      constraints: ["a3 != a4", "readable: s2", "{\"sh\", \"-c\", \"--\", s4, ...} is a valid argv", "sp+0x208 == NULL || (u16)[sp+0x208] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x208, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 290288,
                      constraints: ["a3 == a4", "readable: s2", "{\"sh\", \"-c\", \"--\", s4, ...} is a valid argv", "sp+0x208 == NULL || (u16)[sp+0x208] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x208, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 290292,
                      constraints: ["readable: s2", "{\"sh\", \"-c\", \"--\", s4, ...} is a valid argv", "sp+0x208 == NULL || (u16)[sp+0x208] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x208, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 290296,
                      constraints: ["readable: s2", "{\"sh\", \"-c\", \"--\", s4, ...} is a valid argv", "sp+0x208 == NULL || (u16)[sp+0x208] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x208, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 290298,
                      constraints: ["readable: s2", "{\"sh\", \"-c\", \"--\", s4, ...} is a valid argv", "sp+0x208 == NULL || (u16)[sp+0x208] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, sp+0x208, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 290300,
                      constraints: ["readable: s2", "writable: s1", "{\"sh\", \"-c\", \"--\", s4, ...} is a valid argv", "(u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, s1, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 290302,
                      constraints: ["readable: s2", "writable: a0", "writable: s1", "{\"sh\", \"-c\", \"--\", s4, ...} is a valid argv", "(u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, s1, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 290306,
                      constraints: ["readable: s2", "writable: s1", "{\"sh\", \"-c\", \"--\", s4, ...} is a valid argv", "(u16)[s1] == 0x0"],
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
                      constraints: ["readable: a1", "writable: s1", "{\"sh\", \"-c\", \"--\", s4, ...} is a valid argv", "(u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, s1, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 290318,
                      constraints: ["readable: a1", "writable: a0", "writable: s1", "{\"sh\", \"-c\", \"--\", s4, ...} is a valid argv", "(u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, s1, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 290322,
                      constraints: ["writable: s1", "{\"sh\", \"-c\", \"--\", s4, ...} is a valid argv", "(u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, s1, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 290324,
                      constraints: ["writable: s1", "{\"sh\", \"-c\", \"--\", s4, ...} is a valid argv", "(u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, s1, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 290326,
                      constraints: ["writable: a0", "{\"sh\", \"-c\", \"--\", s4, ...} is a valid argv", "s1 == NULL || (u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, s1, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 290330,
                      constraints: ["{\"sh\", \"-c\", \"--\", s4, ...} is a valid argv", "s1 == NULL || (u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, s1, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 290338,
                      constraints: ["readable: a5", "{\"sh\", \"-c\", \"--\", s4, ...} is a valid argv", "[[a5]] == NULL || [a5] == NULL || [a5] is a valid envp", "s1 == NULL || (u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, s1, sp+0x48, [a5])")
OneGadget::Gadget.add(build_id, 290340,
                      constraints: ["{\"sh\", \"-c\", \"--\", s4, ...} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s1 == NULL || (u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, s1, sp+0x48, a5)")
OneGadget::Gadget.add(build_id, 290344,
                      constraints: ["a6-0x6c4 == NULL || {a6-0x6c4, \"-c\", \"--\", s4, ...} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s1 == NULL || (u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, s1, sp+0x48, a5)")
OneGadget::Gadget.add(build_id, 290348,
                      constraints: ["a6 == NULL || {a6, \"-c\", \"--\", s4, ...} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s1 == NULL || (u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, s1, sp+0x48, a5)")
OneGadget::Gadget.add(build_id, 290350,
                      constraints: ["[sp+0x48] == NULL || {[sp+0x48], \"-c\", \"--\", s4, ...} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s1 == NULL || (u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, s1, sp+0x48, a5)")
OneGadget::Gadget.add(build_id, 290354,
                      constraints: ["[sp+0x48] == NULL || {[sp+0x48], a6-0x6c6, \"--\", s4, ...} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s1 == NULL || (u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, s1, sp+0x48, a5)")
OneGadget::Gadget.add(build_id, 290358,
                      constraints: ["[sp+0x48] == NULL || {[sp+0x48], a6, \"--\", s4, ...} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s1 == NULL || (u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, s1, sp+0x48, a5)")
OneGadget::Gadget.add(build_id, 290360,
                      constraints: ["[sp+0x48] == NULL || {[sp+0x48], a6, \"--\", s4, ...} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "a3 == NULL || (u16)[a3] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, a3, sp+0x48, a5)")
OneGadget::Gadget.add(build_id, 290362,
                      constraints: ["[sp+0x48] == NULL || {[sp+0x48], [sp+0x50], \"--\", s4, ...} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "a3 == NULL || (u16)[a3] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, a3, sp+0x48, a5)")
OneGadget::Gadget.add(build_id, 290364,
                      constraints: ["[a4] == NULL || a4 is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "a3 == NULL || (u16)[a3] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, a3, a4, a5)")
OneGadget::Gadget.add(build_id, 290368,
                      constraints: ["[a4] == NULL || a4 is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "a3 == NULL || (u16)[a3] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, a3, a4, a5)")
OneGadget::Gadget.add(build_id, 290372,
                      constraints: ["[a4] == NULL || a4 is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "a3 == NULL || (u16)[a3] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, a3, a4, a5)")
OneGadget::Gadget.add(build_id, 290374,
                      constraints: ["[a4] == NULL || a4 is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "a2 == NULL || (s32)[a2+0x4] <= 0x0", "a3 == NULL || (u16)[a3] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", a2, a3, a4, a5)")
OneGadget::Gadget.add(build_id, 401880,
                      constraints: ["[$base+0x1743e0] == 0x0", "[$base+0x1743e8] == 0x0", "a4 == 0x0", "writable: s0-0xf0", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, environ)")
OneGadget::Gadget.add(build_id, 401884,
                      constraints: ["[s6+0x208] == 0x0", "[s6+0x210] == 0x0", "a4 == 0x0", "writable: s0-0xf0", "writable: s6+0x200", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, environ)")
OneGadget::Gadget.add(build_id, 401888,
                      constraints: ["[s6+0x10] == 0x0", "[s6+0x8] == 0x0", "a4 == 0x0", "writable: s0-0xf0", "writable: s6", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, environ)")
OneGadget::Gadget.add(build_id, 401892,
                      constraints: ["[s6+0x10] == 0x0", "a4 == 0x0", "a5 == 0x0", "writable: s0-0xf0", "writable: s6", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, environ)")
OneGadget::Gadget.add(build_id, 401896,
                      constraints: ["[s6+0x10] == 0x0", "a4 == 0x0", "a5 == 0x0", "writable: s0-0xf0", "writable: s6", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, environ)")
OneGadget::Gadget.add(build_id, 401898,
                      constraints: ["[s6+0x10] == 0x0", "a5 == 0x0", "writable: s0-0xf0", "writable: s6", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, environ)")
OneGadget::Gadget.add(build_id, 401922,
                      constraints: ["[s6+0x10] == 0x0", "a5 == 0x0", "writable: s0-0xf0", "writable: s6+0x8", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, environ)")
OneGadget::Gadget.add(build_id, 401926,
                      constraints: ["[s6+0x10] == 0x0", "writable: s0-0xf0", "writable: s6+0x8", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, environ)")
OneGadget::Gadget.add(build_id, 401930,
                      constraints: ["[s6+0x10] == 0x0", "writable: s0-0xf0", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, environ)")
OneGadget::Gadget.add(build_id, 401934,
                      constraints: ["s2 == 0x0", "writable: s0-0xf0", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, environ)")
OneGadget::Gadget.add(build_id, 401942,
                      constraints: ["[s2+0xe8] == 0x0", "s11 == a1", "writable: s0-0xf0", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, environ)")
OneGadget::Gadget.add(build_id, 401952,
                      constraints: ["[s2+0xe8] == 0x0", "a0 == 0x0", "writable: s0-0xf0", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, environ)")
OneGadget::Gadget.add(build_id, 401954,
                      constraints: ["[s2+0xe8] == 0x0", "a0 == 0x0", "writable: s0-0xf0", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, environ)")
OneGadget::Gadget.add(build_id, 401956,
                      constraints: ["[s2+0xe8] == 0x0", "writable: s0-0xf0", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, environ)")
OneGadget::Gadget.add(build_id, 401960,
                      constraints: ["s2 == 0x0", "writable: s0-0xf0", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, environ)")
OneGadget::Gadget.add(build_id, 401964,
                      constraints: ["writable: s0-0xf0", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, environ)")
OneGadget::Gadget.add(build_id, 401972,
                      constraints: ["readable: a5", "writable: s0-0xf0", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "[[a5]] == NULL || [a5] == NULL || [a5] is a valid envp", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, [a5])")
OneGadget::Gadget.add(build_id, 401976,
                      constraints: ["readable: a5", "writable: s0-0xf0", "a6+0x52c == NULL || {a6+0x52c, \"-c\", \"--\", s3, ...} is a valid argv", "[[a5]] == NULL || [a5] == NULL || [a5] is a valid envp", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, [a5])")
OneGadget::Gadget.add(build_id, 401980,
                      constraints: ["readable: a5", "writable: s0-0xf0", "a6 == NULL || {a6, \"-c\", \"--\", s3, ...} is a valid argv", "[[a5]] == NULL || [a5] == NULL || [a5] is a valid envp", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, [a5])")
OneGadget::Gadget.add(build_id, 401982,
                      constraints: ["writable: s0-0xf0", "a6 == NULL || {a6, \"-c\", \"--\", s3, ...} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, a5)")
OneGadget::Gadget.add(build_id, 401986,
                      constraints: ["writable: s0-0xe8", "[s0-0xf0] == NULL || {[s0-0xf0], \"-c\", \"--\", s3, ...} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, a5)")
OneGadget::Gadget.add(build_id, 401990,
                      constraints: ["writable: s0-0xe8", "[s0-0xf0] == NULL || {[s0-0xf0], a6+0x526, \"--\", s3, ...} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, a5)")
OneGadget::Gadget.add(build_id, 401994,
                      constraints: ["writable: s0-0xe8", "[s0-0xf0] == NULL || {[s0-0xf0], a6, \"--\", s3, ...} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, a5)")
OneGadget::Gadget.add(build_id, 401998,
                      constraints: ["writable: s0-0xe0", "[s0-0xf0] == NULL || {[s0-0xf0], [s0-0xe8], \"--\", s3, ...} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, a5)")
OneGadget::Gadget.add(build_id, 402002,
                      constraints: ["writable: s0-0xe0", "[a4] == NULL || a4 is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, a4, a5)")
OneGadget::Gadget.add(build_id, 402006,
                      constraints: ["writable: s0-0xe0", "[a4] == NULL || a4 is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, a4, a5)")
OneGadget::Gadget.add(build_id, 402010,
                      constraints: ["writable: s0-0xe0", "[a4] == NULL || a4 is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, a4, a5)")
OneGadget::Gadget.add(build_id, 402012,
                      constraints: ["writable: s0-0xe0", "[a4] == NULL || a4 is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0", "a3 == NULL || (u16)[a3] == 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, a3, a4, a5)")
OneGadget::Gadget.add(build_id, 402014,
                      constraints: ["writable: s0-0xe0", "[a4] == NULL || a4 is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s1+0xe0 == NULL || writable: s1+0xe0", "a2 == NULL || (s32)[a2+0x4] <= 0x0", "a3 == NULL || (u16)[a3] == 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", a2, a3, a4, a5)")
OneGadget::Gadget.add(build_id, 402208,
                      constraints: ["[s6+0x10] == 0x0", "writable: s0-0xf0", "writable: s6", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, environ)")
OneGadget::Gadget.add(build_id, 402210,
                      constraints: ["[s6+0x10] == 0x0", "writable: s0-0xf0", "writable: s6", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, environ)")
OneGadget::Gadget.add(build_id, 402214,
                      constraints: ["[s6+0x10] == 0x0", "writable: s0-0xf0", "writable: s6+0x8", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, environ)")
OneGadget::Gadget.add(build_id, 402218,
                      constraints: ["[s6+0x10] == 0x0", "writable: s0-0xf0", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, environ)")
OneGadget::Gadget.add(build_id, 402232,
                      constraints: ["[s6+0x10] == 0x0", "writable: s0-0xf0", "writable: s6+0x8", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, environ)")
OneGadget::Gadget.add(build_id, 402398,
                      constraints: ["[s6+0x10] == 0x0", "writable: s0-0xf0", "writable: s6+0x4", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, environ)")
OneGadget::Gadget.add(build_id, 402402,
                      constraints: ["[s6+0x10] == 0x0", "writable: s0-0xf0", "{\"sh\", \"-c\", \"--\", s3, ...} is a valid argv", "s1+0xe0 == NULL || writable: s1+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s1+0xe0, \"/bin/sh\", s5, 0, s0-0xf0, environ)")
OneGadget::Gadget.add(build_id, 652124,
                      constraints: ["[a1] == 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x50, a2)")
OneGadget::Gadget.add(build_id, 652124,
                      constraints: ["[a1+0x8] == 0x0", "[a1] != 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x70, a2)")
OneGadget::Gadget.add(build_id, 652126,
                      constraints: ["[a1] == 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp, a2)")
OneGadget::Gadget.add(build_id, 652126,
                      constraints: ["[a1+0x8] == 0x0", "[a1] != 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 652128,
                      constraints: ["[a1] == 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp, a2)")
OneGadget::Gadget.add(build_id, 652128,
                      constraints: ["[a1+0x8] == 0x0", "[a1] != 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 652130,
                      constraints: ["[a1] == 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp, a2)")
OneGadget::Gadget.add(build_id, 652130,
                      constraints: ["[a1+0x8] == 0x0", "[a1] != 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 652132,
                      constraints: ["[a1] == 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp, a2)")
OneGadget::Gadget.add(build_id, 652132,
                      constraints: ["[a1+0x8] == 0x0", "[a1] != 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 652134,
                      constraints: ["[a1] == 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp, a2)")
OneGadget::Gadget.add(build_id, 652134,
                      constraints: ["[a1+0x8] == 0x0", "[a1] != 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 652136,
                      constraints: ["[a1] == 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp, a2)")
OneGadget::Gadget.add(build_id, 652136,
                      constraints: ["[a1+0x8] == 0x0", "[a1] != 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 652138,
                      constraints: ["[a1] == 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp, a2)")
OneGadget::Gadget.add(build_id, 652138,
                      constraints: ["[a1+0x8] == 0x0", "[a1] != 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 652140,
                      constraints: ["[a1] == 0x0", "writable: s0-0x50", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, a2)")
OneGadget::Gadget.add(build_id, 652140,
                      constraints: ["[a1+0x8] == 0x0", "[a1] != 0x0", "writable: s0-0x38", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 652142,
                      constraints: ["a3 == 0x0", "writable: s0-0x50", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, a2)")
OneGadget::Gadget.add(build_id, 652142,
                      constraints: ["[a1+0x8] == 0x0", "a3 != 0x0", "writable: s0-0x38", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 652146,
                      constraints: ["a3 == 0x0", "readable: [s4-0x4d6]", "writable: s0-0x50", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, a2)")
OneGadget::Gadget.add(build_id, 652146,
                      constraints: ["[a1+0x8] == 0x0", "a3 != 0x0", "readable: [s4-0x4d6]", "writable: s0-0x38", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 652150,
                      constraints: ["a3 == 0x0", "readable: s4", "writable: s0-0x50", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, a2)")
OneGadget::Gadget.add(build_id, 652150,
                      constraints: ["[a1+0x8] == 0x0", "a3 != 0x0", "readable: s4", "writable: s0-0x38", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 652154,
                      constraints: ["a3 == 0x0", "writable: s0-0x50", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, a2)")
OneGadget::Gadget.add(build_id, 652154,
                      constraints: ["[a1+0x8] == 0x0", "a3 != 0x0", "writable: s0-0x38", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 652158,
                      constraints: ["[a1+0x8] == 0x0", "a3 != 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 652158,
                      constraints: ["a3 == 0x0", "writable: s0-0x50", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, a2)")
OneGadget::Gadget.add(build_id, 652160,
                      constraints: ["[a1+0x8] == 0x0", "a3 != 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 652160,
                      constraints: ["a3 == 0x0", "writable: s0-0x50", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, a2)")
OneGadget::Gadget.add(build_id, 652162,
                      constraints: ["[a1+0x8] == 0x0", "a3 != 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, s2)")
OneGadget::Gadget.add(build_id, 652162,
                      constraints: ["a3 == 0x0", "writable: s0-0x50", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, s2)")
OneGadget::Gadget.add(build_id, 652164,
                      constraints: ["[a1+0x8] == 0x0", "a3 != 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, s2)")
OneGadget::Gadget.add(build_id, 652164,
                      constraints: ["a3 == 0x0", "writable: s0-0x50", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, s2)")
OneGadget::Gadget.add(build_id, 652166,
                      constraints: ["[a1+0x8] == 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, s2)")
OneGadget::Gadget.add(build_id, 652168,
                      constraints: ["[a1] == 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, s2)")
OneGadget::Gadget.add(build_id, 652172,
                      constraints: ["[a1] == 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, s2)")
OneGadget::Gadget.add(build_id, 652174,
                      constraints: ["[a4] == 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, s2)")
OneGadget::Gadget.add(build_id, 652212,
                      constraints: ["a2 == 0x1", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp, s2)")
OneGadget::Gadget.add(build_id, 652214,
                      constraints: ["a2 == 0x1", "writable: s1", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s1, s2)")
OneGadget::Gadget.add(build_id, 652218,
                      constraints: ["a2 == 0x1", "writable: s1", "a4+0x3c2 == NULL || {a4+0x3c2, a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s1, s2)")
OneGadget::Gadget.add(build_id, 652222,
                      constraints: ["a2 == 0x1", "writable: s1", "a4 == NULL || {a4, a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s1, s2)")
OneGadget::Gadget.add(build_id, 652224,
                      constraints: ["a2 == 0x1", "writable: s1+0x8", "[s1] == NULL || s1 == NULL || s1 is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s1, s2)")
OneGadget::Gadget.add(build_id, 652226,
                      constraints: ["a2 == 0x1", "writable: s1+0x10", "[s1] == NULL || s1 == NULL || s1 is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s1, s2)")
OneGadget::Gadget.add(build_id, 652228,
                      constraints: ["a2 == a4", "writable: s1+0x10", "[s1] == NULL || s1 == NULL || s1 is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s1, s2)")
OneGadget::Gadget.add(build_id, 652232,
                      constraints: ["writable: s1+0x10", "[s1] == NULL || s1 == NULL || s1 is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s1, s2)")
OneGadget::Gadget.add(build_id, 652236,
                      constraints: ["[s1] == NULL || s1 == NULL || s1 is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s1, s2)")
OneGadget::Gadget.add(build_id, 652238,
                      constraints: ["[s1] == NULL || s1 == NULL || s1 is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s1, a2)")
OneGadget::Gadget.add(build_id, 652240,
                      constraints: ["[a1] == NULL || a1 == NULL || a1 is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", a1, a2)")
OneGadget::Gadget.add(build_id, 652300,
                      constraints: ["[s1] == NULL || s1 == NULL || s1 is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s1, s2)")
OneGadget::Gadget.add(build_id, 652320,
                      constraints: ["writable: s0-0x50", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, s2)")
OneGadget::Gadget.add(build_id, 652324,
                      constraints: ["writable: s0-0x50", "a5+0x358 == NULL || {a5+0x358, a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, s2)")
OneGadget::Gadget.add(build_id, 652328,
                      constraints: ["writable: s0-0x50", "a5 == NULL || {a5, a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, s2)")
OneGadget::Gadget.add(build_id, 652332,
                      constraints: ["writable: s0-0x48", "[s0-0x50] == NULL || {[s0-0x50], a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, s2)")
OneGadget::Gadget.add(build_id, 652336,
                      constraints: ["writable: s0-0x40", "[s0-0x50] == NULL || {[s0-0x50], [s0-0x48], NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, s2)")
OneGadget::Gadget.add(build_id, 652340,
                      constraints: ["writable: s1+0x10", "[s1] == NULL || s1 == NULL || s1 is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s1, s2)")
OneGadget::Gadget.add(build_id, 742282,
                      constraints: ["a0 == 0x0", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 742286,
                      constraints: ["[[[$base+0x171fc0]]] == 0x0", "[sp+0xc8] != -0x1", "[sp+0xc8] != [sp+0xc0]", "writable: (([sp+0xc0] << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 742290,
                      constraints: ["[[[a5-0x3ce]]] == 0x0", "[sp+0xc8] != -0x1", "[sp+0xc8] != [sp+0xc0]", "writable: (([sp+0xc0] << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 742294,
                      constraints: ["[[a5]] == 0x0", "[sp+0xc8] != -0x1", "[sp+0xc8] != [sp+0xc0]", "writable: (([sp+0xc0] << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 742298,
                      constraints: ["[[a5]] == 0x0", "[sp+0xc8] != -0x1", "[sp+0xc8] != [sp+0xc0]", "writable: (([sp+0xc0] << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 742302,
                      constraints: ["[s10] == 0x0", "[sp+0xc8] != -0x1", "[sp+0xc8] != [sp+0xc0]", "writable: (([sp+0xc0] << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 742304,
                      constraints: ["[s10] == 0x0", "[sp+0xc8] != -0x1", "s0 != -0x1", "s0 != [sp+0xc0]", "writable: (([sp+0xc0] << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 742308,
                      constraints: ["[sp+0xc8] != -0x1", "s0 != -0x1", "s0 != [sp+0xc0]", "s8 == 0x0", "writable: (([sp+0xc0] << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 742328,
                      constraints: ["[s10+0x8] == 0x0", "[sp+0xc8] != -0x1", "s0 != -0x1", "s0 != [sp+0xc0]", "writable: (([sp+0xc0] << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 742332,
                      constraints: ["[sp+0xc8] != -0x1", "s0 != -0x1", "s0 != [sp+0xc0]", "s8 == 0x0", "writable: (([sp+0xc0] << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 742334,
                      constraints: ["[sp+0xc8] != -0x1", "s0 != -0x1", "s0 != [sp+0xc0]", "s8 == 0x0", "writable: (([sp+0xc0] << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 742360,
                      constraints: ["[s10+0x8] == 0x0", "[sp+0xc8] != -0x1", "[sp+0xc8] != a5+0x1", "writable: ((a5 << 0x3) + [sp+0xd0])", "writable: ((a5+0x1 << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "s8 == NULL || readable: s8", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 742364,
                      constraints: ["[s10+0x8] == 0x0", "[sp+0xc8] != -0x1", "[sp+0xc8] != a4", "writable: ((a4 << 0x3) + [sp+0xd0])", "writable: ((a5 << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "s8 == NULL || readable: s8", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 742366,
                      constraints: ["[s10+0x8] == 0x0", "[sp+0xc8] != -0x1", "[sp+0xc8] != [sp+0xc0]", "writable: (([sp+0xc0] << 0x3) + [sp+0xd0])", "writable: ((a5 << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "s8 == NULL || readable: s8", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 742368,
                      constraints: ["[s10+0x8] == 0x0", "[sp+0xc8] != -0x1", "[sp+0xc8] != [sp+0xc0]", "writable: (([sp+0xc0] << 0x3) + [sp+0xd0])", "writable: ((a5 << 0x3) + a4)", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 742370,
                      constraints: ["[s10+0x8] == 0x0", "[sp+0xc8] != -0x1", "[sp+0xc8] != [sp+0xc0]", "writable: (([sp+0xc0] << 0x3) + [sp+0xd0])", "writable: (a5 + a4)", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 742372,
                      constraints: ["[s10+0x8] == 0x0", "[sp+0xc8] != -0x1", "[sp+0xc8] != [sp+0xc0]", "writable: (([sp+0xc0] << 0x3) + [sp+0xd0])", "writable: a5", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 742376,
                      constraints: ["[s10+0x8] == 0x0", "[sp+0xc8] != -0x1", "[sp+0xc8] != [sp+0xc0]", "writable: (([sp+0xc0] << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 742378,
                      constraints: ["[s10+0x8] == 0x0", "[sp+0xc8] != -0x1", "s0 != -0x1", "s0 != [sp+0xc0]", "writable: (([sp+0xc0] << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 742386,
                      constraints: ["[sp+0xc8] != -0x1", "s0 != -0x1", "s0 != [sp+0xc0]", "writable: (([sp+0xc0] << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 742390,
                      constraints: ["[sp+0xc8] != -0x1", "s0 != -0x1", "s0 != [sp+0xc0]", "writable: (([sp+0xc0] << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 742392,
                      constraints: ["[sp+0xc8] != -0x1", "s0 != [sp+0xc0]", "s0 != a5", "writable: (([sp+0xc0] << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 742396,
                      constraints: ["[sp+0xc8] != -0x1", "s0 != [sp+0xc0]", "writable: (([sp+0xc0] << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 742398,
                      constraints: ["[sp+0xc8] != -0x1", "s0 != a5", "writable: ((a5 << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 742402,
                      constraints: ["[sp+0xc8] != -0x1", "writable: ((a5 << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 742406,
                      constraints: ["[sp+0xc8] != -0x1", "writable: ((a5 << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 742408,
                      constraints: ["[sp+0xc8] != -0x1", "writable: ((a5 << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 742410,
                      constraints: ["[sp+0xc8] != -0x1", "writable: ((a5 << 0x3) + a4)", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 742412,
                      constraints: ["[sp+0xc8] != -0x1", "writable: (a5 + a4)", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 742414,
                      constraints: ["[sp+0xc8] != -0x1", "writable: a5", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 742418,
                      constraints: ["[sp+0xc8] != -0x1", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 742420,
                      constraints: ["a4 != -0x1", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 742422,
                      constraints: ["a4 != a5", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 742426,
                      constraints: ["[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 742428,
                      constraints: ["[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, a5)")
OneGadget::Gadget.add(build_id, 742432,
                      constraints: ["[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, a5)")
OneGadget::Gadget.add(build_id, 742434,
                      constraints: ["[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "a2 == NULL || (s32)[a2+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", a2, 0, sp+0x50, a5)")
OneGadget::Gadget.add(build_id, 742436,
                      constraints: ["[a4] == NULL || a4 is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "a2 == NULL || (s32)[a2+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", a2, 0, a4, a5)")
OneGadget::Gadget.add(build_id, 742438,
                      constraints: ["[a4] == NULL || a4 is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "a2 == NULL || (s32)[a2+0x4] <= 0x0", "a3 == NULL || (u16)[a3] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", a2, a3, a4, a5)")
OneGadget::Gadget.add(build_id, 743324,
                      constraints: ["[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, environ)")
OneGadget::Gadget.add(build_id, 743332,
                      constraints: ["readable: a5", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[a5]] == NULL || [a5] == NULL || [a5] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [a5])")
OneGadget::Gadget.add(build_id, 743334,
                      constraints: ["[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, a5)")
OneGadget::Gadget.add(build_id, 743352,
                      constraints: ["[s10+0x8] == 0x0", "[sp+0xc8] != -0x1", "[sp+0xc8] != [sp+0xc0]", "writable: (([sp+0xc0] << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 743354,
                      constraints: ["[s10+0x8] == 0x0", "[sp+0xc8] != -0x1", "s0 != -0x1", "s0 != [sp+0xc0]", "writable: (([sp+0xc0] << 0x3) + [sp+0xd0])", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")
OneGadget::Gadget.add(build_id, 743458,
                      constraints: ["[sp+0xc8] != -0x1", "[sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv", "[[sp+0xd0]] == NULL || [sp+0xd0] == NULL || [sp+0xd0] is a valid envp", "[sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", [sp+0x30], 0, sp+0x50, [sp+0xd0])")

