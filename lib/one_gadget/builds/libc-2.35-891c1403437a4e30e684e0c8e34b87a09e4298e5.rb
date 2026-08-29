require 'one_gadget/gadget'
# http://ports.ubuntu.com/ubuntu-ports/pool/main/g/glibc/libc6_2.35-0ubuntu3.14_riscv64.deb
# 
# RISC-V
# 
# GNU C Library (Ubuntu GLIBC 2.35-0ubuntu3.14) stable release version 2.35.
# Copyright (C) 2022 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 11.4.0.
# libc ABIs: UNIQUE ABSOLUTE IFUNC
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 262068,
                      constraints: ["a3 != a4", "readable: s4", "{\"sh\", \"-c\", s3, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 262068,
                      constraints: ["a3 == a4", "readable: s4", "{\"sh\", \"-c\", s3, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 262070,
                      constraints: ["a3 != a4", "readable: s4", "{\"sh\", \"-c\", s3, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 262070,
                      constraints: ["a3 == a4", "readable: s4", "{\"sh\", \"-c\", s3, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 262072,
                      constraints: ["a3 != a4", "readable: s4", "{\"sh\", \"-c\", s3, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 262072,
                      constraints: ["a3 == a4", "readable: s4", "{\"sh\", \"-c\", s3, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 262076,
                      constraints: ["readable: s4", "{\"sh\", \"-c\", s3, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 262080,
                      constraints: ["readable: s4", "{\"sh\", \"-c\", s3, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 262082,
                      constraints: ["readable: s4", "{\"sh\", \"-c\", s3, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 262084,
                      constraints: ["readable: s4", "writable: s1", "{\"sh\", \"-c\", s3, NULL} is a valid argv", "(u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, s1, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 262086,
                      constraints: ["readable: s4", "writable: a0", "writable: s1", "{\"sh\", \"-c\", s3, NULL} is a valid argv", "(u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, s1, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 262090,
                      constraints: ["readable: s4", "writable: s1", "{\"sh\", \"-c\", s3, NULL} is a valid argv", "(u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, s1, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 262092,
                      constraints: ["readable: a1", "writable: s1", "{\"sh\", \"-c\", s3, NULL} is a valid argv", "(u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, s1, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 262094,
                      constraints: ["readable: a1", "writable: a0", "writable: s1", "{\"sh\", \"-c\", s3, NULL} is a valid argv", "(u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, s1, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 262098,
                      constraints: ["writable: s1", "{\"sh\", \"-c\", s3, NULL} is a valid argv", "(u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, s1, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 262100,
                      constraints: ["readable: a1", "writable: s1", "{\"sh\", \"-c\", s3, NULL} is a valid argv", "(u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, s1, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 262102,
                      constraints: ["readable: a1", "writable: a0", "writable: s1", "{\"sh\", \"-c\", s3, NULL} is a valid argv", "(u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, s1, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 262106,
                      constraints: ["writable: s1", "{\"sh\", \"-c\", s3, NULL} is a valid argv", "(u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, s1, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 262108,
                      constraints: ["writable: s1", "{\"sh\", \"-c\", s3, NULL} is a valid argv", "(u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, s1, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 262110,
                      constraints: ["writable: a0", "{\"sh\", \"-c\", s3, NULL} is a valid argv", "s1 == NULL || (u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, s1, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 262114,
                      constraints: ["{\"sh\", \"-c\", s3, NULL} is a valid argv", "s1 == NULL || (u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, s1, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 262122,
                      constraints: ["readable: a5", "{\"sh\", \"-c\", s3, NULL} is a valid argv", "[[a5]] == NULL || [a5] == NULL || [a5] is a valid envp", "s1 == NULL || (u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, s1, sp+0x40, [a5])")
OneGadget::Gadget.add(build_id, 262124,
                      constraints: ["{\"sh\", \"-c\", s3, NULL} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s1 == NULL || (u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, s1, sp+0x40, a5)")
OneGadget::Gadget.add(build_id, 262128,
                      constraints: ["a6+0xec == NULL || {a6+0xec, \"-c\", s3, NULL} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s1 == NULL || (u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, s1, sp+0x40, a5)")
OneGadget::Gadget.add(build_id, 262132,
                      constraints: ["a6 == NULL || {a6, \"-c\", s3, NULL} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s1 == NULL || (u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, s1, sp+0x40, a5)")
OneGadget::Gadget.add(build_id, 262134,
                      constraints: ["[sp+0x40] == NULL || {[sp+0x40], \"-c\", s3, NULL} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s1 == NULL || (u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, s1, sp+0x40, a5)")
OneGadget::Gadget.add(build_id, 262136,
                      constraints: ["[a4] == NULL || a4 is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s1 == NULL || (u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, s1, a4, a5)")
OneGadget::Gadget.add(build_id, 262140,
                      constraints: ["[a4] == NULL || a4 is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s1 == NULL || (u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, s1, a4, a5)")
OneGadget::Gadget.add(build_id, 262144,
                      constraints: ["[a4] == NULL || a4 is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s1 == NULL || (u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, s1, a4, a5)")
OneGadget::Gadget.add(build_id, 262146,
                      constraints: ["[a4] == NULL || a4 is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "a3 == NULL || (u16)[a3] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, a3, a4, a5)")
OneGadget::Gadget.add(build_id, 262148,
                      constraints: ["[a4] == NULL || a4 is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "a2 == NULL || (s32)[a2+0x4] <= 0x0", "a3 == NULL || (u16)[a3] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", a2, a3, a4, a5)")
OneGadget::Gadget.add(build_id, 372064,
                      constraints: ["s1 == 0x0", "writable: s6+0xc", "{\"sh\", \"-c\", s2, NULL} is a valid argv", "s0+0xe0 == NULL || writable: s0+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s0+0xe0, \"/bin/sh\", s5, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 372068,
                      constraints: ["s1 == 0x0", "{\"sh\", \"-c\", s2, NULL} is a valid argv", "s0+0xe0 == NULL || writable: s0+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s0+0xe0, \"/bin/sh\", s5, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 372072,
                      constraints: ["[s1+0xe8] == 0x0", "s3 == a1", "{\"sh\", \"-c\", s2, NULL} is a valid argv", "s0+0xe0 == NULL || writable: s0+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s0+0xe0, \"/bin/sh\", s5, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 372082,
                      constraints: ["[s1+0xe8] == 0x0", "a0 == 0x0", "{\"sh\", \"-c\", s2, NULL} is a valid argv", "s0+0xe0 == NULL || writable: s0+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s0+0xe0, \"/bin/sh\", s5, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 372084,
                      constraints: ["[s1+0xe8] == 0x0", "{\"sh\", \"-c\", s2, NULL} is a valid argv", "s0+0xe0 == NULL || writable: s0+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s0+0xe0, \"/bin/sh\", s5, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 372086,
                      constraints: ["s1 == 0x0", "{\"sh\", \"-c\", s2, NULL} is a valid argv", "s0+0xe0 == NULL || writable: s0+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s0+0xe0, \"/bin/sh\", s5, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 372088,
                      constraints: ["{\"sh\", \"-c\", s2, NULL} is a valid argv", "s0+0xe0 == NULL || writable: s0+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s0+0xe0, \"/bin/sh\", s5, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 372096,
                      constraints: ["readable: a5", "{\"sh\", \"-c\", s2, NULL} is a valid argv", "[[a5]] == NULL || [a5] == NULL || [a5] is a valid envp", "s0+0xe0 == NULL || writable: s0+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s0+0xe0, \"/bin/sh\", s5, 0, sp+0x38, [a5])")
OneGadget::Gadget.add(build_id, 372098,
                      constraints: ["{\"sh\", \"-c\", s2, NULL} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s0+0xe0 == NULL || writable: s0+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s0+0xe0, \"/bin/sh\", s5, 0, sp+0x38, a5)")
OneGadget::Gadget.add(build_id, 372102,
                      constraints: ["a6+0x356 == NULL || {a6+0x356, \"-c\", s2, NULL} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s0+0xe0 == NULL || writable: s0+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s0+0xe0, \"/bin/sh\", s5, 0, sp+0x38, a5)")
OneGadget::Gadget.add(build_id, 372106,
                      constraints: ["a6 == NULL || {a6, \"-c\", s2, NULL} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s0+0xe0 == NULL || writable: s0+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s0+0xe0, \"/bin/sh\", s5, 0, sp+0x38, a5)")
OneGadget::Gadget.add(build_id, 372108,
                      constraints: ["[sp+0x38] == NULL || {[sp+0x38], \"-c\", s2, NULL} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s0+0xe0 == NULL || writable: s0+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s0+0xe0, \"/bin/sh\", s5, 0, sp+0x38, a5)")
OneGadget::Gadget.add(build_id, 372110,
                      constraints: ["[a4] == NULL || a4 is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s0+0xe0 == NULL || writable: s0+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s0+0xe0, \"/bin/sh\", s5, 0, a4, a5)")
OneGadget::Gadget.add(build_id, 372114,
                      constraints: ["[a4] == NULL || a4 is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s0+0xe0 == NULL || writable: s0+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s0+0xe0, \"/bin/sh\", s5, 0, a4, a5)")
OneGadget::Gadget.add(build_id, 372118,
                      constraints: ["[a4] == NULL || a4 is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s0+0xe0 == NULL || writable: s0+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s0+0xe0, \"/bin/sh\", s5, 0, a4, a5)")
OneGadget::Gadget.add(build_id, 372120,
                      constraints: ["[a4] == NULL || a4 is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s0+0xe0 == NULL || writable: s0+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0", "a3 == NULL || (u16)[a3] == 0x0"],
                      effect: "posix_spawn(s0+0xe0, \"/bin/sh\", s5, a3, a4, a5)")
OneGadget::Gadget.add(build_id, 372122,
                      constraints: ["[a4] == NULL || a4 is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s0+0xe0 == NULL || writable: s0+0xe0", "a2 == NULL || (s32)[a2+0x4] <= 0x0", "a3 == NULL || (u16)[a3] == 0x0"],
                      effect: "posix_spawn(s0+0xe0, \"/bin/sh\", a2, a3, a4, a5)")
OneGadget::Gadget.add(build_id, 599926,
                      constraints: ["[a1] == 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x50, a2)")
OneGadget::Gadget.add(build_id, 599926,
                      constraints: ["[a1+0x8] == 0x0", "[a1] != 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x70, a2)")
OneGadget::Gadget.add(build_id, 599928,
                      constraints: ["[a1] == 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp, a2)")
OneGadget::Gadget.add(build_id, 599928,
                      constraints: ["[a1+0x8] == 0x0", "[a1] != 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 599930,
                      constraints: ["[a1] == 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp, a2)")
OneGadget::Gadget.add(build_id, 599930,
                      constraints: ["[a1+0x8] == 0x0", "[a1] != 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 599932,
                      constraints: ["[a1] == 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp, a2)")
OneGadget::Gadget.add(build_id, 599932,
                      constraints: ["[a1+0x8] == 0x0", "[a1] != 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 599934,
                      constraints: ["[a1] == 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp, a2)")
OneGadget::Gadget.add(build_id, 599934,
                      constraints: ["[a1+0x8] == 0x0", "[a1] != 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 599936,
                      constraints: ["[a1] == 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp, a2)")
OneGadget::Gadget.add(build_id, 599936,
                      constraints: ["[a1+0x8] == 0x0", "[a1] != 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 599938,
                      constraints: ["[a1] == 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp, a2)")
OneGadget::Gadget.add(build_id, 599938,
                      constraints: ["[a1+0x8] == 0x0", "[a1] != 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 599940,
                      constraints: ["[a1] == 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp, a2)")
OneGadget::Gadget.add(build_id, 599940,
                      constraints: ["[a1+0x8] == 0x0", "[a1] != 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 599942,
                      constraints: ["[a1] == 0x0", "writable: s0-0x50", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, a2)")
OneGadget::Gadget.add(build_id, 599942,
                      constraints: ["[a1+0x8] == 0x0", "[a1] != 0x0", "writable: s0-0x38", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 599944,
                      constraints: ["a3 == 0x0", "writable: s0-0x50", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, a2)")
OneGadget::Gadget.add(build_id, 599944,
                      constraints: ["[a1+0x8] == 0x0", "a3 != 0x0", "writable: s0-0x38", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 599948,
                      constraints: ["a3 == 0x0", "readable: [s3-0xf0]", "writable: s0-0x50", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, a2)")
OneGadget::Gadget.add(build_id, 599948,
                      constraints: ["[a1+0x8] == 0x0", "a3 != 0x0", "readable: [s3-0xf0]", "writable: s0-0x38", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 599952,
                      constraints: ["a3 == 0x0", "readable: s3", "writable: s0-0x50", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, a2)")
OneGadget::Gadget.add(build_id, 599952,
                      constraints: ["[a1+0x8] == 0x0", "a3 != 0x0", "readable: s3", "writable: s0-0x38", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 599956,
                      constraints: ["a3 == 0x0", "writable: s0-0x50", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, a2)")
OneGadget::Gadget.add(build_id, 599956,
                      constraints: ["[a1+0x8] == 0x0", "a3 != 0x0", "writable: s0-0x38", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 599960,
                      constraints: ["[a1+0x8] == 0x0", "a3 != 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 599960,
                      constraints: ["a3 == 0x0", "writable: s0-0x50", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, a2)")
OneGadget::Gadget.add(build_id, 599962,
                      constraints: ["a3 == 0x0", "writable: s0-0x50", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, a2)")
OneGadget::Gadget.add(build_id, 599964,
                      constraints: ["a3 == 0x0", "writable: s0-0x50", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, s2)")
OneGadget::Gadget.add(build_id, 599966,
                      constraints: ["a3 == 0x0", "writable: s0-0x50", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, s2)")
OneGadget::Gadget.add(build_id, 600014,
                      constraints: ["a5 == 0x1", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp, s2)")
OneGadget::Gadget.add(build_id, 600016,
                      constraints: ["a5 == 0x1", "writable: s1", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s1, s2)")
OneGadget::Gadget.add(build_id, 600020,
                      constraints: ["a5 == 0x1", "writable: s1", "a4-0x6e8 == NULL || {a4-0x6e8, a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s1, s2)")
OneGadget::Gadget.add(build_id, 600024,
                      constraints: ["a5 == 0x1", "writable: s1", "a4 == NULL || {a4, a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s1, s2)")
OneGadget::Gadget.add(build_id, 600026,
                      constraints: ["a5 == 0x1", "writable: s1+0x8", "[s1] == NULL || s1 == NULL || s1 is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s1, s2)")
OneGadget::Gadget.add(build_id, 600028,
                      constraints: ["a5 == 0x1", "writable: s1+0x10", "[s1] == NULL || s1 == NULL || s1 is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s1, s2)")
OneGadget::Gadget.add(build_id, 600030,
                      constraints: ["a5 == a4", "writable: s1+0x10", "[s1] == NULL || s1 == NULL || s1 is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s1, s2)")
OneGadget::Gadget.add(build_id, 600034,
                      constraints: ["writable: s1+0x10", "[s1] == NULL || s1 == NULL || s1 is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s1, s2)")
OneGadget::Gadget.add(build_id, 600038,
                      constraints: ["[s1] == NULL || s1 == NULL || s1 is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s1, s2)")
OneGadget::Gadget.add(build_id, 600040,
                      constraints: ["[s1] == NULL || s1 == NULL || s1 is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s1, a2)")
OneGadget::Gadget.add(build_id, 600042,
                      constraints: ["[a1] == NULL || a1 == NULL || a1 is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", a1, a2)")
OneGadget::Gadget.add(build_id, 600098,
                      constraints: ["[s1] == NULL || s1 == NULL || s1 is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s1, s2)")
OneGadget::Gadget.add(build_id, 600118,
                      constraints: ["writable: s0-0x50", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, s2)")
OneGadget::Gadget.add(build_id, 600122,
                      constraints: ["writable: s0-0x50", "a5-0x74e == NULL || {a5-0x74e, a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, s2)")
OneGadget::Gadget.add(build_id, 600126,
                      constraints: ["writable: s0-0x50", "a5 == NULL || {a5, a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, s2)")
OneGadget::Gadget.add(build_id, 600130,
                      constraints: ["writable: s0-0x48", "[s0-0x50] == NULL || {[s0-0x50], a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, s2)")
OneGadget::Gadget.add(build_id, 600134,
                      constraints: ["writable: s0-0x40", "[s0-0x50] == NULL || {[s0-0x50], [s0-0x48], NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, s2)")
OneGadget::Gadget.add(build_id, 600138,
                      constraints: ["writable: s1+0x10", "[s1] == NULL || s1 == NULL || s1 is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s1, s2)")
OneGadget::Gadget.add(build_id, 683392,
                      constraints: ["a0 == 0x0", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, environ)")
OneGadget::Gadget.add(build_id, 683396,
                      constraints: ["[[[$base+0x1267c0]]] == 0x0", "[sp+0xd0] != [sp+0xd8]", "[sp+0xd8] != -0x1", "writable: (([sp+0xd0] << 0x3) + [sp+0xe0])", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 683400,
                      constraints: ["[[[a5-0x5c4]]] == 0x0", "[sp+0xd0] != [sp+0xd8]", "[sp+0xd8] != -0x1", "writable: (([sp+0xd0] << 0x3) + [sp+0xe0])", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 683404,
                      constraints: ["[[a5]] == 0x0", "[sp+0xd0] != [sp+0xd8]", "[sp+0xd8] != -0x1", "writable: (([sp+0xd0] << 0x3) + [sp+0xe0])", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 683408,
                      constraints: ["[s11] == 0x0", "[sp+0xd0] != [sp+0xd8]", "[sp+0xd8] != -0x1", "writable: (([sp+0xd0] << 0x3) + [sp+0xe0])", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 683410,
                      constraints: ["[s11] == 0x0", "[sp+0xd0] != s5", "[sp+0xd8] != -0x1", "s5 != -0x1", "writable: (([sp+0xd0] << 0x3) + [sp+0xe0])", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 683414,
                      constraints: ["[sp+0xd0] != s5", "[sp+0xd8] != -0x1", "s5 != -0x1", "s6 == 0x0", "writable: (([sp+0xd0] << 0x3) + [sp+0xe0])", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 683430,
                      constraints: ["[s11+0x8] == 0x0", "[sp+0xd0] != s5", "[sp+0xd8] != -0x1", "s5 != -0x1", "writable: (([sp+0xd0] << 0x3) + [sp+0xe0])", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 683434,
                      constraints: ["[sp+0xd0] != s5", "[sp+0xd8] != -0x1", "s5 != -0x1", "s6 == 0x0", "writable: (([sp+0xd0] << 0x3) + [sp+0xe0])", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 683436,
                      constraints: ["[sp+0xd0] != s5", "[sp+0xd8] != -0x1", "s5 != -0x1", "s6 == 0x0", "writable: (([sp+0xd0] << 0x3) + [sp+0xe0])", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 683462,
                      constraints: ["[s11+0x8] == 0x0", "[sp+0xd8] != -0x1", "a3+0x1 != [sp+0xd8]", "writable: ((a3 << 0x3) + [sp+0xe0])", "writable: ((a3+0x1 << 0x3) + [sp+0xe0])", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "s6 == NULL || readable: s6", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 683466,
                      constraints: ["[s11+0x8] == 0x0", "[sp+0xd8] != -0x1", "a2 != [sp+0xd8]", "writable: ((a2 << 0x3) + [sp+0xe0])", "writable: ((a3 << 0x3) + [sp+0xe0])", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "s6 == NULL || readable: s6", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 683468,
                      constraints: ["[s11+0x8] == 0x0", "[sp+0xd0] != [sp+0xd8]", "[sp+0xd8] != -0x1", "writable: (([sp+0xd0] << 0x3) + [sp+0xe0])", "writable: ((a3 << 0x3) + [sp+0xe0])", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "s6 == NULL || readable: s6", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 683470,
                      constraints: ["[s11+0x8] == 0x0", "[sp+0xd0] != [sp+0xd8]", "[sp+0xd8] != -0x1", "writable: (([sp+0xd0] << 0x3) + [sp+0xe0])", "writable: ((a3 << 0x3) + a2)", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 683472,
                      constraints: ["[s11+0x8] == 0x0", "[sp+0xd0] != [sp+0xd8]", "[sp+0xd8] != -0x1", "writable: (([sp+0xd0] << 0x3) + [sp+0xe0])", "writable: (a3 + a2)", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 683474,
                      constraints: ["[s11+0x8] == 0x0", "[sp+0xd0] != [sp+0xd8]", "[sp+0xd8] != -0x1", "writable: (([sp+0xd0] << 0x3) + [sp+0xe0])", "writable: a3", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 683478,
                      constraints: ["[s11+0x8] == 0x0", "[sp+0xd0] != [sp+0xd8]", "[sp+0xd8] != -0x1", "writable: (([sp+0xd0] << 0x3) + [sp+0xe0])", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 683480,
                      constraints: ["[s11+0x8] == 0x0", "[sp+0xd0] != s5", "[sp+0xd8] != -0x1", "s5 != -0x1", "writable: (([sp+0xd0] << 0x3) + [sp+0xe0])", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 683488,
                      constraints: ["[sp+0xd0] != s5", "[sp+0xd8] != -0x1", "s5 != -0x1", "writable: (([sp+0xd0] << 0x3) + [sp+0xe0])", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 683490,
                      constraints: ["[sp+0xd0] != s5", "[sp+0xd8] != -0x1", "s5 != a5", "writable: (([sp+0xd0] << 0x3) + [sp+0xe0])", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 683494,
                      constraints: ["[sp+0xd0] != s5", "[sp+0xd8] != -0x1", "writable: (([sp+0xd0] << 0x3) + [sp+0xe0])", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 683496,
                      constraints: ["[sp+0xd8] != -0x1", "a5 != s5", "writable: ((a5 << 0x3) + [sp+0xe0])", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 683500,
                      constraints: ["[sp+0xd8] != -0x1", "writable: ((a5 << 0x3) + [sp+0xe0])", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 683504,
                      constraints: ["[sp+0xd8] != -0x1", "writable: ((a5 << 0x3) + [sp+0xe0])", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 683506,
                      constraints: ["[sp+0xd8] != -0x1", "writable: ((a5 << 0x3) + [sp+0xe0])", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 683508,
                      constraints: ["[sp+0xd8] != -0x1", "writable: ((a5 << 0x3) + a4)", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 683510,
                      constraints: ["[sp+0xd8] != -0x1", "writable: (a5 + a4)", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 683512,
                      constraints: ["[sp+0xd8] != -0x1", "writable: a5", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 683516,
                      constraints: ["[sp+0xd8] != -0x1", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 683518,
                      constraints: ["a4 != -0x1", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 683520,
                      constraints: ["a4 != a5", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 683524,
                      constraints: ["[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 683526,
                      constraints: ["[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, a5)")
OneGadget::Gadget.add(build_id, 683528,
                      constraints: ["[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "a2 == NULL || (s32)[a2+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", a2, 0, sp+0x60, a5)")
OneGadget::Gadget.add(build_id, 683530,
                      constraints: ["[a4] == NULL || a4 is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "a2 == NULL || (s32)[a2+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", a2, 0, a4, a5)")
OneGadget::Gadget.add(build_id, 683532,
                      constraints: ["[a4] == NULL || a4 is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "a2 == NULL || (s32)[a2+0x4] <= 0x0", "a3 == NULL || (u16)[a3] == 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", a2, a3, a4, a5)")
OneGadget::Gadget.add(build_id, 684242,
                      constraints: ["[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, environ)")
OneGadget::Gadget.add(build_id, 684250,
                      constraints: ["readable: a5", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[a5]] == NULL || [a5] == NULL || [a5] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [a5])")
OneGadget::Gadget.add(build_id, 684252,
                      constraints: ["[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, a5)")
OneGadget::Gadget.add(build_id, 684262,
                      constraints: ["[s11+0x8] == 0x0", "[sp+0xd0] != [sp+0xd8]", "[sp+0xd8] != -0x1", "writable: (([sp+0xd0] << 0x3) + [sp+0xe0])", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 684264,
                      constraints: ["[s11+0x8] == 0x0", "[sp+0xd0] != s5", "[sp+0xd8] != -0x1", "s5 != -0x1", "writable: (([sp+0xd0] << 0x3) + [sp+0xe0])", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 684338,
                      constraints: ["[sp+0xd8] != -0x1", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")

