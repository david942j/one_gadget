require 'one_gadget/gadget'
# http://ports.ubuntu.com/ubuntu-ports/pool/main/g/glibc/libc6_2.31-0ubuntu9.18_riscv64.deb
# 
# RISC-V
# 
# GNU C Library (Ubuntu GLIBC 2.31-0ubuntu9.18) stable release version 2.31.
# Copyright (C) 2020 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 9.4.0.
# libc ABIs: UNIQUE ABSOLUTE
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 234878,
                      constraints: ["[s1+0x8] != 0x1", "[s1+0xa0] != 0x1", "readable: s0", "readable: s4", "s0 == sp+0x158", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234878,
                      constraints: ["[s1+0x8] == 0x1", "[s1+0xa0] != 0x1", "readable: s0", "readable: s4", "s0 == sp+0x158", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234878,
                      constraints: ["[s1+0x8] != 0x1", "[s1+0xa0] == 0x1", "readable: s0", "readable: s4", "s0 == sp+0x158", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234878,
                      constraints: ["[s1+0x8] == 0x1", "[s1+0xa0] == 0x1", "readable: s0", "readable: s4", "s0 == sp+0x158", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234880,
                      constraints: ["[s1+0x8] != 0x1", "[s1+0xa0] != 0x1", "readable: s0", "readable: s4", "s0 == a5", "writable: a5", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234880,
                      constraints: ["[s1+0x8] == 0x1", "[s1+0xa0] != 0x1", "readable: s0", "readable: s4", "s0 == a5", "writable: a5", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234880,
                      constraints: ["[s1+0x8] != 0x1", "[s1+0xa0] == 0x1", "readable: s0", "readable: s4", "s0 == a5", "writable: a5", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234880,
                      constraints: ["[s1+0x8] == 0x1", "[s1+0xa0] == 0x1", "readable: s0", "readable: s4", "s0 == a5", "writable: a5", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234884,
                      constraints: ["[s1+0x8] != 0x1", "[s1+0xa0] != 0x1", "readable: s0", "readable: s4", "s0 == a5", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234884,
                      constraints: ["[s1+0x8] == 0x1", "[s1+0xa0] != 0x1", "readable: s0", "readable: s4", "s0 == a5", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234884,
                      constraints: ["[s1+0x8] != 0x1", "[s1+0xa0] == 0x1", "readable: s0", "readable: s4", "s0 == a5", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234884,
                      constraints: ["[s1+0x8] == 0x1", "[s1+0xa0] == 0x1", "readable: s0", "readable: s4", "s0 == a5", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234886,
                      constraints: ["[s1+0x8] != 0x1", "[s1+0xa0] != 0x1", "readable: s0", "readable: s4", "s0 == a4", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234886,
                      constraints: ["[s1+0x8] == 0x1", "[s1+0xa0] != 0x1", "readable: s0", "readable: s4", "s0 == a4", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234886,
                      constraints: ["[s1+0x8] != 0x1", "[s1+0xa0] == 0x1", "readable: s0", "readable: s4", "s0 == a4", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234886,
                      constraints: ["[s1+0x8] == 0x1", "[s1+0xa0] == 0x1", "readable: s0", "readable: s4", "s0 == a4", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234888,
                      constraints: ["[s1+0x8] != 0x1", "[s1+0xa0] != 0x1", "readable: s0", "readable: s4", "s0 == a4", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234888,
                      constraints: ["[s1+0x8] == 0x1", "[s1+0xa0] != 0x1", "readable: s0", "readable: s4", "s0 == a4", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234888,
                      constraints: ["[s1+0x8] != 0x1", "[s1+0xa0] == 0x1", "readable: s0", "readable: s4", "s0 == a4", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234888,
                      constraints: ["[s1+0x8] == 0x1", "[s1+0xa0] == 0x1", "readable: s0", "readable: s4", "s0 == a4", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234892,
                      constraints: ["[s1+0x8] != 0x1", "[s1+0xa0] != 0x1", "readable: s0", "readable: s4", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234892,
                      constraints: ["[s1+0x8] == 0x1", "[s1+0xa0] != 0x1", "readable: s0", "readable: s4", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234892,
                      constraints: ["[s1+0x8] != 0x1", "[s1+0xa0] == 0x1", "readable: s0", "readable: s4", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234892,
                      constraints: ["[s1+0x8] == 0x1", "[s1+0xa0] == 0x1", "readable: s0", "readable: s4", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234894,
                      constraints: ["[s1+0xa0] != 0x1", "a4 != 0x1", "readable: s0", "readable: s4", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234894,
                      constraints: ["[s1+0xa0] != 0x1", "a4 == 0x1", "readable: s0", "readable: s4", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234894,
                      constraints: ["[s1+0xa0] == 0x1", "a4 != 0x1", "readable: s0", "readable: s4", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234894,
                      constraints: ["[s1+0xa0] == 0x1", "a4 == 0x1", "readable: s0", "readable: s4", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234896,
                      constraints: ["[s1+0xa0] != 0x1", "a4 != a5", "readable: s0", "readable: s4", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234896,
                      constraints: ["[s1+0xa0] != 0x1", "a4 == a5", "readable: s0", "readable: s4", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234896,
                      constraints: ["[s1+0xa0] == 0x1", "a4 != a5", "readable: s0", "readable: s4", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234896,
                      constraints: ["[s1+0xa0] == 0x1", "a4 == a5", "readable: s0", "readable: s4", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234900,
                      constraints: ["[s1+0xa0] != 0x1", "readable: s0", "readable: s4", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234900,
                      constraints: ["[s1+0xa0] == 0x1", "readable: s0", "readable: s4", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234902,
                      constraints: ["[s1+0xa0] != 0x1", "readable: s0", "readable: s4", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234902,
                      constraints: ["[s1+0xa0] == 0x1", "readable: s0", "readable: s4", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234906,
                      constraints: ["[s1+0xa0] != 0x1", "readable: s0", "readable: s4", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234906,
                      constraints: ["[s1+0xa0] == 0x1", "readable: s0", "readable: s4", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234908,
                      constraints: ["[s1+0xa0] != 0x1", "readable: s0", "readable: s4", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234908,
                      constraints: ["[s1+0xa0] == 0x1", "readable: s0", "readable: s4", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234910,
                      constraints: ["a4 != 0x1", "readable: s0", "readable: s4", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234910,
                      constraints: ["a4 == 0x1", "readable: s0", "readable: s4", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234912,
                      constraints: ["a4 != a5", "readable: s0", "readable: s4", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234912,
                      constraints: ["a4 == a5", "readable: s0", "readable: s4", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234916,
                      constraints: ["readable: s0", "readable: s4", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234918,
                      constraints: ["readable: s0", "readable: s4", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234922,
                      constraints: ["readable: s0", "readable: s4", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234924,
                      constraints: ["readable: s0", "readable: s4", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234928,
                      constraints: ["readable: s0", "readable: s4", "writable: s3", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "(u16)[s3] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, s3, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234930,
                      constraints: ["readable: s0", "readable: s4", "writable: a0", "writable: s3", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "(u16)[s3] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, s3, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234934,
                      constraints: ["readable: s0", "readable: s4", "writable: s3", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "(u16)[s3] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, s3, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234936,
                      constraints: ["readable: a1", "readable: s0", "writable: s3", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "(u16)[s3] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, s3, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234938,
                      constraints: ["readable: a1", "readable: s0", "writable: a0", "writable: s3", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "(u16)[s3] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, s3, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234942,
                      constraints: ["readable: s0", "writable: s3", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "(u16)[s3] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, s3, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234944,
                      constraints: ["readable: a1", "writable: s3", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "(u16)[s3] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, s3, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234946,
                      constraints: ["readable: a1", "writable: a0", "writable: s3", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "(u16)[s3] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, s3, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234950,
                      constraints: ["writable: s3", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "(u16)[s3] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, s3, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234952,
                      constraints: ["writable: s3", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "(u16)[s3] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, s3, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234954,
                      constraints: ["writable: a0", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "s3 == NULL || (u16)[s3] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, s3, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234958,
                      constraints: ["{\"sh\", \"-c\", s5, NULL} is a valid argv", "s3 == NULL || (u16)[s3] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, s3, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 234966,
                      constraints: ["readable: a5", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "[[a5]] == NULL || [a5] == NULL || [a5] is a valid envp", "s3 == NULL || (u16)[s3] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, s3, sp+0x40, [a5])")
OneGadget::Gadget.add(build_id, 234968,
                      constraints: ["{\"sh\", \"-c\", s5, NULL} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s3 == NULL || (u16)[s3] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, s3, sp+0x40, a5)")
OneGadget::Gadget.add(build_id, 234972,
                      constraints: ["a6+0x6b0 == NULL || {a6+0x6b0, \"-c\", s5, NULL} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s3 == NULL || (u16)[s3] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, s3, sp+0x40, a5)")
OneGadget::Gadget.add(build_id, 234976,
                      constraints: ["a6 == NULL || {a6, \"-c\", s5, NULL} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s3 == NULL || (u16)[s3] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, s3, sp+0x40, a5)")
OneGadget::Gadget.add(build_id, 234978,
                      constraints: ["[sp+0x40] == NULL || {[sp+0x40], \"-c\", s5, NULL} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s3 == NULL || (u16)[s3] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, s3, sp+0x40, a5)")
OneGadget::Gadget.add(build_id, 234980,
                      constraints: ["[a4] == NULL || a4 is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s3 == NULL || (u16)[s3] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, s3, a4, a5)")
OneGadget::Gadget.add(build_id, 234984,
                      constraints: ["[a4] == NULL || a4 is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s3 == NULL || (u16)[s3] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, s3, a4, a5)")
OneGadget::Gadget.add(build_id, 234988,
                      constraints: ["[a4] == NULL || a4 is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s3 == NULL || (u16)[s3] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, s3, a4, a5)")
OneGadget::Gadget.add(build_id, 234990,
                      constraints: ["[a4] == NULL || a4 is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "a3 == NULL || (u16)[a3] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, a3, a4, a5)")
OneGadget::Gadget.add(build_id, 234992,
                      constraints: ["[a4] == NULL || a4 is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "a2 == NULL || (s32)[a2+0x4] <= 0x0", "a3 == NULL || (u16)[a3] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", a2, a3, a4, a5)")
OneGadget::Gadget.add(build_id, 352156,
                      constraints: ["s1 == 0x0", "writable: s6+0xc", "{\"sh\", \"-c\", s3, NULL} is a valid argv", "s0+0xe0 == NULL || writable: s0+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s0+0xe0, \"/bin/sh\", s5, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 352160,
                      constraints: ["s1 == 0x0", "{\"sh\", \"-c\", s3, NULL} is a valid argv", "s0+0xe0 == NULL || writable: s0+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s0+0xe0, \"/bin/sh\", s5, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 352164,
                      constraints: ["[s1+0xe8] == 0x0", "s2 == a1", "{\"sh\", \"-c\", s3, NULL} is a valid argv", "s0+0xe0 == NULL || writable: s0+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s0+0xe0, \"/bin/sh\", s5, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 352174,
                      constraints: ["[s1+0xe8] == 0x0", "a0 == 0x0", "{\"sh\", \"-c\", s3, NULL} is a valid argv", "s0+0xe0 == NULL || writable: s0+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s0+0xe0, \"/bin/sh\", s5, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 352178,
                      constraints: ["[s1+0xe8] == 0x0", "{\"sh\", \"-c\", s3, NULL} is a valid argv", "s0+0xe0 == NULL || writable: s0+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s0+0xe0, \"/bin/sh\", s5, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 352180,
                      constraints: ["s1 == 0x0", "{\"sh\", \"-c\", s3, NULL} is a valid argv", "s0+0xe0 == NULL || writable: s0+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s0+0xe0, \"/bin/sh\", s5, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 352182,
                      constraints: ["{\"sh\", \"-c\", s3, NULL} is a valid argv", "s0+0xe0 == NULL || writable: s0+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s0+0xe0, \"/bin/sh\", s5, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 352190,
                      constraints: ["readable: a5", "{\"sh\", \"-c\", s3, NULL} is a valid argv", "[[a5]] == NULL || [a5] == NULL || [a5] is a valid envp", "s0+0xe0 == NULL || writable: s0+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s0+0xe0, \"/bin/sh\", s5, 0, sp+0x38, [a5])")
OneGadget::Gadget.add(build_id, 352192,
                      constraints: ["{\"sh\", \"-c\", s3, NULL} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s0+0xe0 == NULL || writable: s0+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s0+0xe0, \"/bin/sh\", s5, 0, sp+0x38, a5)")
OneGadget::Gadget.add(build_id, 352196,
                      constraints: ["a6-0x338 == NULL || {a6-0x338, \"-c\", s3, NULL} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s0+0xe0 == NULL || writable: s0+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s0+0xe0, \"/bin/sh\", s5, 0, sp+0x38, a5)")
OneGadget::Gadget.add(build_id, 352200,
                      constraints: ["a6 == NULL || {a6, \"-c\", s3, NULL} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s0+0xe0 == NULL || writable: s0+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s0+0xe0, \"/bin/sh\", s5, 0, sp+0x38, a5)")
OneGadget::Gadget.add(build_id, 352202,
                      constraints: ["[sp+0x38] == NULL || {[sp+0x38], \"-c\", s3, NULL} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s0+0xe0 == NULL || writable: s0+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s0+0xe0, \"/bin/sh\", s5, 0, sp+0x38, a5)")
OneGadget::Gadget.add(build_id, 352204,
                      constraints: ["[a4] == NULL || a4 is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s0+0xe0 == NULL || writable: s0+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s0+0xe0, \"/bin/sh\", s5, 0, a4, a5)")
OneGadget::Gadget.add(build_id, 352208,
                      constraints: ["[a4] == NULL || a4 is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s0+0xe0 == NULL || writable: s0+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s0+0xe0, \"/bin/sh\", s5, 0, a4, a5)")
OneGadget::Gadget.add(build_id, 352212,
                      constraints: ["[a4] == NULL || a4 is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s0+0xe0 == NULL || writable: s0+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0"],
                      effect: "posix_spawn(s0+0xe0, \"/bin/sh\", s5, 0, a4, a5)")
OneGadget::Gadget.add(build_id, 352214,
                      constraints: ["[a4] == NULL || a4 is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s0+0xe0 == NULL || writable: s0+0xe0", "s5 == NULL || (s32)[s5+0x4] <= 0x0", "a3 == NULL || (u16)[a3] == 0x0"],
                      effect: "posix_spawn(s0+0xe0, \"/bin/sh\", s5, a3, a4, a5)")
OneGadget::Gadget.add(build_id, 352216,
                      constraints: ["[a4] == NULL || a4 is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "s0+0xe0 == NULL || writable: s0+0xe0", "a2 == NULL || (s32)[a2+0x4] <= 0x0", "a3 == NULL || (u16)[a3] == 0x0"],
                      effect: "posix_spawn(s0+0xe0, \"/bin/sh\", a2, a3, a4, a5)")
OneGadget::Gadget.add(build_id, 541154,
                      constraints: ["[a1] == 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x50, a2)")
OneGadget::Gadget.add(build_id, 541154,
                      constraints: ["[a1+0x8] == 0x0", "[a1] != 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x70, a2)")
OneGadget::Gadget.add(build_id, 541156,
                      constraints: ["[a1] == 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp, a2)")
OneGadget::Gadget.add(build_id, 541156,
                      constraints: ["[a1+0x8] == 0x0", "[a1] != 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 541158,
                      constraints: ["[a1] == 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp, a2)")
OneGadget::Gadget.add(build_id, 541158,
                      constraints: ["[a1+0x8] == 0x0", "[a1] != 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 541160,
                      constraints: ["[a1] == 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp, a2)")
OneGadget::Gadget.add(build_id, 541160,
                      constraints: ["[a1+0x8] == 0x0", "[a1] != 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 541162,
                      constraints: ["[a1] == 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp, a2)")
OneGadget::Gadget.add(build_id, 541162,
                      constraints: ["[a1+0x8] == 0x0", "[a1] != 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 541164,
                      constraints: ["[a1] == 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp, a2)")
OneGadget::Gadget.add(build_id, 541164,
                      constraints: ["[a1+0x8] == 0x0", "[a1] != 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 541166,
                      constraints: ["[a1] == 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp, a2)")
OneGadget::Gadget.add(build_id, 541166,
                      constraints: ["[a1+0x8] == 0x0", "[a1] != 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 541168,
                      constraints: ["[a1] == 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp, a2)")
OneGadget::Gadget.add(build_id, 541168,
                      constraints: ["[a1+0x8] == 0x0", "[a1] != 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 541170,
                      constraints: ["[a1] == 0x0", "writable: s0-0x50", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, a2)")
OneGadget::Gadget.add(build_id, 541170,
                      constraints: ["[a1+0x8] == 0x0", "[a1] != 0x0", "writable: s0-0x38", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 541174,
                      constraints: ["[a1] == 0x0", "readable: [s3+0x4ce]", "writable: s0-0x50", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, a2)")
OneGadget::Gadget.add(build_id, 541174,
                      constraints: ["[a1+0x8] == 0x0", "[a1] != 0x0", "readable: [s3+0x4ce]", "writable: s0-0x38", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 541178,
                      constraints: ["[a1] == 0x0", "readable: s3", "writable: s0-0x50", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, a2)")
OneGadget::Gadget.add(build_id, 541178,
                      constraints: ["[a1+0x8] == 0x0", "[a1] != 0x0", "readable: s3", "writable: s0-0x38", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 541182,
                      constraints: ["[a1] == 0x0", "writable: s0-0x50", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, a2)")
OneGadget::Gadget.add(build_id, 541182,
                      constraints: ["[a1+0x8] == 0x0", "[a1] != 0x0", "writable: s0-0x38", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 541184,
                      constraints: ["a3 == 0x0", "writable: s0-0x50", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, a2)")
OneGadget::Gadget.add(build_id, 541184,
                      constraints: ["[a1+0x8] == 0x0", "a3 != 0x0", "writable: s0-0x38", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, a2)")
OneGadget::Gadget.add(build_id, 541186,
                      constraints: ["a3 == 0x0", "writable: s0-0x50", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, s2)")
OneGadget::Gadget.add(build_id, 541186,
                      constraints: ["[a1+0x8] == 0x0", "a3 != 0x0", "writable: s0-0x38", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, s2)")
OneGadget::Gadget.add(build_id, 541190,
                      constraints: ["[a1+0x8] == 0x0", "a3 != 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, s2)")
OneGadget::Gadget.add(build_id, 541190,
                      constraints: ["a3 == 0x0", "writable: s0-0x50", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, s2)")
OneGadget::Gadget.add(build_id, 541192,
                      constraints: ["[a1+0x8] == 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, s2)")
OneGadget::Gadget.add(build_id, 541194,
                      constraints: ["[a1] == 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, s2)")
OneGadget::Gadget.add(build_id, 541198,
                      constraints: ["[a1] == 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, s2)")
OneGadget::Gadget.add(build_id, 541200,
                      constraints: ["[a4] == 0x0", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, s2)")
OneGadget::Gadget.add(build_id, 541242,
                      constraints: ["a5 == 0x1", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp, s2)")
OneGadget::Gadget.add(build_id, 541244,
                      constraints: ["a5 == 0x1", "writable: s1", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s1, s2)")
OneGadget::Gadget.add(build_id, 541248,
                      constraints: ["a5 == 0x1", "writable: s1", "a4-0x5a4 == NULL || {a4-0x5a4, a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s1, s2)")
OneGadget::Gadget.add(build_id, 541252,
                      constraints: ["a5 == 0x1", "writable: s1", "a4 == NULL || {a4, a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s1, s2)")
OneGadget::Gadget.add(build_id, 541254,
                      constraints: ["a5 == 0x1", "writable: s1+0x8", "[s1] == NULL || s1 == NULL || s1 is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s1, s2)")
OneGadget::Gadget.add(build_id, 541256,
                      constraints: ["a5 == 0x1", "writable: s1+0x10", "[s1] == NULL || s1 == NULL || s1 is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s1, s2)")
OneGadget::Gadget.add(build_id, 541258,
                      constraints: ["a5 == a4", "writable: s1+0x10", "[s1] == NULL || s1 == NULL || s1 is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s1, s2)")
OneGadget::Gadget.add(build_id, 541262,
                      constraints: ["writable: s1+0x10", "[s1] == NULL || s1 == NULL || s1 is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s1, s2)")
OneGadget::Gadget.add(build_id, 541266,
                      constraints: ["[s1] == NULL || s1 == NULL || s1 is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s1, s2)")
OneGadget::Gadget.add(build_id, 541268,
                      constraints: ["[s1] == NULL || s1 == NULL || s1 is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s1, a2)")
OneGadget::Gadget.add(build_id, 541270,
                      constraints: ["[a1] == NULL || a1 == NULL || a1 is a valid argv", "[a2] == NULL || a2 == NULL || a2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", a1, a2)")
OneGadget::Gadget.add(build_id, 541324,
                      constraints: ["[s1] == NULL || s1 == NULL || s1 is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s1, s2)")
OneGadget::Gadget.add(build_id, 541342,
                      constraints: ["writable: s0-0x50", "a0 == NULL || {\"/bin/sh\", a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, s2)")
OneGadget::Gadget.add(build_id, 541346,
                      constraints: ["writable: s0-0x50", "a5-0x606 == NULL || {a5-0x606, a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, s2)")
OneGadget::Gadget.add(build_id, 541350,
                      constraints: ["writable: s0-0x50", "a5 == NULL || {a5, a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, s2)")
OneGadget::Gadget.add(build_id, 541352,
                      constraints: ["writable: s0-0x50", "a5 == NULL || {a5, a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, s2)")
OneGadget::Gadget.add(build_id, 541356,
                      constraints: ["writable: s0-0x48", "[s0-0x50] == NULL || {[s0-0x50], a0, NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, s2)")
OneGadget::Gadget.add(build_id, 541360,
                      constraints: ["writable: s0-0x40", "[s0-0x50] == NULL || {[s0-0x50], [s0-0x48], NULL} is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s0-0x50, s2)")
OneGadget::Gadget.add(build_id, 541364,
                      constraints: ["writable: s1+0x10", "[s1] == NULL || s1 == NULL || s1 is a valid argv", "[s2] == NULL || s2 == NULL || s2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", s1, s2)")
OneGadget::Gadget.add(build_id, 625022,
                      constraints: ["a0 == 0x0", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, environ)")
OneGadget::Gadget.add(build_id, 625026,
                      constraints: ["[[[$base+0x108620]]] == 0x0", "[sp+0xd0] != [sp+0xd8]", "[sp+0xd8] != -0x1", "writable: (([sp+0xd0] << 0x3) + [sp+0xe0])", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 625030,
                      constraints: ["[[[a5-0x362]]] == 0x0", "[sp+0xd0] != [sp+0xd8]", "[sp+0xd8] != -0x1", "writable: (([sp+0xd0] << 0x3) + [sp+0xe0])", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 625034,
                      constraints: ["[[a5]] == 0x0", "[sp+0xd0] != [sp+0xd8]", "[sp+0xd8] != -0x1", "writable: (([sp+0xd0] << 0x3) + [sp+0xe0])", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 625038,
                      constraints: ["[s11] == 0x0", "[sp+0xd0] != [sp+0xd8]", "[sp+0xd8] != -0x1", "writable: (([sp+0xd0] << 0x3) + [sp+0xe0])", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 625040,
                      constraints: ["[s11] == 0x0", "[sp+0xd0] != s5", "[sp+0xd8] != -0x1", "s5 != -0x1", "writable: (([sp+0xd0] << 0x3) + [sp+0xe0])", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 625044,
                      constraints: ["[sp+0xd0] != s5", "[sp+0xd8] != -0x1", "s5 != -0x1", "s6 == 0x0", "writable: (([sp+0xd0] << 0x3) + [sp+0xe0])", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 625060,
                      constraints: ["[s11+0x8] == 0x0", "[sp+0xd0] != s5", "[sp+0xd8] != -0x1", "s5 != -0x1", "writable: (([sp+0xd0] << 0x3) + [sp+0xe0])", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 625064,
                      constraints: ["[sp+0xd0] != s5", "[sp+0xd8] != -0x1", "s5 != -0x1", "s6 == 0x0", "writable: (([sp+0xd0] << 0x3) + [sp+0xe0])", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 625066,
                      constraints: ["[sp+0xd0] != s5", "[sp+0xd8] != -0x1", "s5 != -0x1", "s6 == 0x0", "writable: (([sp+0xd0] << 0x3) + [sp+0xe0])", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 625092,
                      constraints: ["[s11+0x8] == 0x0", "[sp+0xd8] != -0x1", "a3+0x1 != [sp+0xd8]", "writable: ((a3 << 0x3) + [sp+0xe0])", "writable: ((a3+0x1 << 0x3) + [sp+0xe0])", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "s6 == NULL || readable: s6", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 625096,
                      constraints: ["[s11+0x8] == 0x0", "[sp+0xd8] != -0x1", "a2 != [sp+0xd8]", "writable: ((a2 << 0x3) + [sp+0xe0])", "writable: ((a3 << 0x3) + [sp+0xe0])", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "s6 == NULL || readable: s6", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 625098,
                      constraints: ["[s11+0x8] == 0x0", "[sp+0xd0] != [sp+0xd8]", "[sp+0xd8] != -0x1", "writable: (([sp+0xd0] << 0x3) + [sp+0xe0])", "writable: ((a3 << 0x3) + [sp+0xe0])", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "s6 == NULL || readable: s6", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 625100,
                      constraints: ["[s11+0x8] == 0x0", "[sp+0xd0] != [sp+0xd8]", "[sp+0xd8] != -0x1", "writable: (([sp+0xd0] << 0x3) + [sp+0xe0])", "writable: ((a3 << 0x3) + a2)", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 625102,
                      constraints: ["[s11+0x8] == 0x0", "[sp+0xd0] != [sp+0xd8]", "[sp+0xd8] != -0x1", "writable: (([sp+0xd0] << 0x3) + [sp+0xe0])", "writable: (a3 + a2)", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 625104,
                      constraints: ["[s11+0x8] == 0x0", "[sp+0xd0] != [sp+0xd8]", "[sp+0xd8] != -0x1", "writable: (([sp+0xd0] << 0x3) + [sp+0xe0])", "writable: a3", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 625108,
                      constraints: ["[s11+0x8] == 0x0", "[sp+0xd0] != [sp+0xd8]", "[sp+0xd8] != -0x1", "writable: (([sp+0xd0] << 0x3) + [sp+0xe0])", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 625110,
                      constraints: ["[s11+0x8] == 0x0", "[sp+0xd0] != s5", "[sp+0xd8] != -0x1", "s5 != -0x1", "writable: (([sp+0xd0] << 0x3) + [sp+0xe0])", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 625118,
                      constraints: ["[sp+0xd0] != s5", "[sp+0xd8] != -0x1", "s5 != -0x1", "writable: (([sp+0xd0] << 0x3) + [sp+0xe0])", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 625120,
                      constraints: ["[sp+0xd0] != s5", "[sp+0xd8] != -0x1", "s5 != a5", "writable: (([sp+0xd0] << 0x3) + [sp+0xe0])", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 625124,
                      constraints: ["[sp+0xd0] != s5", "[sp+0xd8] != -0x1", "writable: (([sp+0xd0] << 0x3) + [sp+0xe0])", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 625126,
                      constraints: ["[sp+0xd8] != -0x1", "a5 != s5", "writable: ((a5 << 0x3) + [sp+0xe0])", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 625130,
                      constraints: ["[sp+0xd8] != -0x1", "writable: ((a5 << 0x3) + [sp+0xe0])", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 625134,
                      constraints: ["[sp+0xd8] != -0x1", "writable: ((a5 << 0x3) + [sp+0xe0])", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 625136,
                      constraints: ["[sp+0xd8] != -0x1", "writable: ((a5 << 0x3) + [sp+0xe0])", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 625138,
                      constraints: ["[sp+0xd8] != -0x1", "writable: ((a5 << 0x3) + a4)", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 625140,
                      constraints: ["[sp+0xd8] != -0x1", "writable: (a5 + a4)", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 625142,
                      constraints: ["[sp+0xd8] != -0x1", "writable: a5", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 625146,
                      constraints: ["[sp+0xd8] != -0x1", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 625148,
                      constraints: ["a4 != -0x1", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 625150,
                      constraints: ["a4 != a5", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 625154,
                      constraints: ["[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 625156,
                      constraints: ["[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, a5)")
OneGadget::Gadget.add(build_id, 625158,
                      constraints: ["[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "a2 == NULL || (s32)[a2+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", a2, 0, sp+0x60, a5)")
OneGadget::Gadget.add(build_id, 625160,
                      constraints: ["[a4] == NULL || a4 is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "a2 == NULL || (s32)[a2+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", a2, 0, a4, a5)")
OneGadget::Gadget.add(build_id, 625162,
                      constraints: ["[a4] == NULL || a4 is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "a2 == NULL || (s32)[a2+0x4] <= 0x0", "a3 == NULL || (u16)[a3] == 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", a2, a3, a4, a5)")
OneGadget::Gadget.add(build_id, 625872,
                      constraints: ["[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, environ)")
OneGadget::Gadget.add(build_id, 625880,
                      constraints: ["readable: a5", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[a5]] == NULL || [a5] == NULL || [a5] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [a5])")
OneGadget::Gadget.add(build_id, 625882,
                      constraints: ["[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[a5] == NULL || a5 == NULL || a5 is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, a5)")
OneGadget::Gadget.add(build_id, 625892,
                      constraints: ["[s11+0x8] == 0x0", "[sp+0xd0] != [sp+0xd8]", "[sp+0xd8] != -0x1", "writable: (([sp+0xd0] << 0x3) + [sp+0xe0])", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 625894,
                      constraints: ["[s11+0x8] == 0x0", "[sp+0xd0] != s5", "[sp+0xd8] != -0x1", "s5 != -0x1", "writable: (([sp+0xd0] << 0x3) + [sp+0xe0])", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")
OneGadget::Gadget.add(build_id, 625918,
                      constraints: ["[sp+0xd8] != -0x1", "[sp+0x60] == NULL || {[sp+0x60], [sp+0x68], [sp+0x70], [sp+0x78], ...} is a valid argv", "[[sp+0xe0]] == NULL || [sp+0xe0] == NULL || [sp+0xe0] is a valid envp", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0x54, \"/bin/sh\", [sp+0x28], 0, sp+0x60, [sp+0xe0])")

