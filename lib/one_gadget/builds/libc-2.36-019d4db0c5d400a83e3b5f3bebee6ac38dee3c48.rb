require 'one_gadget/gadget'
# spec/data/mipsel-libc-2.36.so
# 
# MIPS R3000
# 
# GNU C Library (Debian GLIBC 2.36-9+deb12u14) stable release version 2.36.
# Copyright (C) 2022 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 12.2.0.
# libc ABIs: MIPS_PLT UNIQUE MIPS_O32_FP64 ABSOLUTE MIPS_XHASH
# Minimum supported kernel: 3.2.0
# For bug reporting instructions, please see:
# <http://www.debian.org/Bugs/>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 308164,
                      constraints: ["gp is the GOT address of libc", "[sp+0x18] is the GOT address of libc", "a0 != v1", "readable: [sp+0x28]", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1fc == NULL || (u16)[sp+0x1fc] == 0x0"],
                      effect: "posix_spawn(sp+0x3c, \"/bin/sh\", 0, sp+0x1fc, sp+0x5c, environ)")
OneGadget::Gadget.add(build_id, 308164,
                      constraints: ["gp is the GOT address of libc", "[sp+0x18] is the GOT address of libc", "a0 == v1", "readable: [sp+0x28]", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1fc == NULL || (u16)[sp+0x1fc] == 0x0"],
                      effect: "posix_spawn(sp+0x3c, \"/bin/sh\", 0, sp+0x1fc, sp+0x5c, environ)")
OneGadget::Gadget.add(build_id, 308168,
                      constraints: ["gp is the GOT address of libc", "[sp+0x18] is the GOT address of libc", "a0 != v1", "readable: [sp+0x28]", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1fc == NULL || (u16)[sp+0x1fc] == 0x0"],
                      effect: "posix_spawn(sp+0x3c, \"/bin/sh\", 0, sp+0x1fc, sp+0x5c, environ)")
OneGadget::Gadget.add(build_id, 308168,
                      constraints: ["gp is the GOT address of libc", "[sp+0x18] is the GOT address of libc", "a0 == v1", "readable: [sp+0x28]", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1fc == NULL || (u16)[sp+0x1fc] == 0x0"],
                      effect: "posix_spawn(sp+0x3c, \"/bin/sh\", 0, sp+0x1fc, sp+0x5c, environ)")
OneGadget::Gadget.add(build_id, 308172,
                      constraints: ["gp is the GOT address of libc", "[sp+0x18] is the GOT address of libc", "readable: [sp+0x28]", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1fc == NULL || (u16)[sp+0x1fc] == 0x0"],
                      effect: "posix_spawn(sp+0x3c, \"/bin/sh\", 0, sp+0x1fc, sp+0x5c, environ)")
OneGadget::Gadget.add(build_id, 308176,
                      constraints: ["gp is the GOT address of libc", "[sp+0x18] is the GOT address of libc", "readable: [sp+0x28]", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1fc == NULL || (u16)[sp+0x1fc] == 0x0"],
                      effect: "posix_spawn(sp+0x3c, \"/bin/sh\", 0, sp+0x1fc, sp+0x5c, environ)")
OneGadget::Gadget.add(build_id, 308180,
                      constraints: ["gp is the GOT address of libc", "[sp+0x18] is the GOT address of libc", "readable: [sp+0x28]", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1fc == NULL || (u16)[sp+0x1fc] == 0x0"],
                      effect: "posix_spawn(sp+0x3c, \"/bin/sh\", 0, sp+0x1fc, sp+0x5c, environ)")
OneGadget::Gadget.add(build_id, 308184,
                      constraints: ["gp is the GOT address of libc", "[sp+0x18] is the GOT address of libc", "readable: [sp+0x28]", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "sp+0x1fc == NULL || (u16)[sp+0x1fc] == 0x0"],
                      effect: "posix_spawn(sp+0x3c, \"/bin/sh\", 0, sp+0x1fc, sp+0x5c, environ)")
OneGadget::Gadget.add(build_id, 308188,
                      constraints: ["gp is the GOT address of libc", "[sp+0x18] is the GOT address of libc", "readable: [sp+0x28]", "writable: s1", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "(u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0x3c, \"/bin/sh\", 0, s1, sp+0x5c, environ)")
OneGadget::Gadget.add(build_id, 308192,
                      constraints: ["gp is the GOT address of libc", "[sp+0x18] is the GOT address of libc", "readable: [sp+0x28]", "writable: s1", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "(u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0x3c, \"/bin/sh\", 0, s1, sp+0x5c, environ)")
OneGadget::Gadget.add(build_id, 308196,
                      constraints: ["gp is the GOT address of libc", "[sp+0x18] is the GOT address of libc", "readable: [sp+0x28]", "writable: s1", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "(u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0x3c, \"/bin/sh\", 0, s1, sp+0x5c, environ)")
OneGadget::Gadget.add(build_id, 308200,
                      constraints: ["gp is the GOT address of libc", "[sp+0x18] is the GOT address of libc", "readable: [sp+0x28]", "writable: s1", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "(u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0x3c, \"/bin/sh\", 0, s1, sp+0x5c, environ)")
OneGadget::Gadget.add(build_id, 308204,
                      constraints: ["gp is the GOT address of libc", "[sp+0x18] is the GOT address of libc", "readable: [sp+0x28]", "writable: a0", "writable: s1", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "(u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0x3c, \"/bin/sh\", 0, s1, sp+0x5c, environ)")
OneGadget::Gadget.add(build_id, 308208,
                      constraints: ["gp is the GOT address of libc", "[sp+0x18] is the GOT address of libc", "readable: [sp+0x28]", "writable: a0", "writable: s1", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "(u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0x3c, \"/bin/sh\", 0, s1, sp+0x5c, environ)")
OneGadget::Gadget.add(build_id, 308212,
                      constraints: ["gp is the GOT address of libc", "[sp+0x18] is the GOT address of libc", "readable: [sp+0x28]", "writable: a0", "writable: s1", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "(u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0x3c, \"/bin/sh\", 0, s1, sp+0x5c, environ)")
OneGadget::Gadget.add(build_id, 308216,
                      constraints: ["gp is the GOT address of libc", "[sp+0x18] is the GOT address of libc", "writable: s1", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "(u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0x3c, \"/bin/sh\", 0, s1, sp+0x5c, environ)")
OneGadget::Gadget.add(build_id, 308220,
                      constraints: ["gp is the GOT address of libc", "[sp+0x18] is the GOT address of libc", "writable: s1", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "(u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0x3c, \"/bin/sh\", 0, s1, sp+0x5c, environ)")
OneGadget::Gadget.add(build_id, 308224,
                      constraints: ["gp is the GOT address of libc", "[sp+0x18] is the GOT address of libc", "readable: a1", "writable: s1", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "(u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0x3c, \"/bin/sh\", 0, s1, sp+0x5c, environ)")
OneGadget::Gadget.add(build_id, 308228,
                      constraints: ["gp is the GOT address of libc", "[sp+0x18] is the GOT address of libc", "readable: a1", "writable: s1", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "(u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0x3c, \"/bin/sh\", 0, s1, sp+0x5c, environ)")
OneGadget::Gadget.add(build_id, 308232,
                      constraints: ["gp is the GOT address of libc", "[sp+0x18] is the GOT address of libc", "readable: a1", "writable: s1", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "(u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0x3c, \"/bin/sh\", 0, s1, sp+0x5c, environ)")
OneGadget::Gadget.add(build_id, 308236,
                      constraints: ["gp is the GOT address of libc", "[sp+0x18] is the GOT address of libc", "writable: s1", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "(u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0x3c, \"/bin/sh\", 0, s1, sp+0x5c, environ)")
OneGadget::Gadget.add(build_id, 308240,
                      constraints: ["gp is the GOT address of libc", "[sp+0x18] is the GOT address of libc", "writable: s1", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "(u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0x3c, \"/bin/sh\", 0, s1, sp+0x5c, environ)")
OneGadget::Gadget.add(build_id, 308244,
                      constraints: ["gp is the GOT address of libc", "[sp+0x18] is the GOT address of libc", "writable: s1", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "(u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0x3c, \"/bin/sh\", 0, s1, sp+0x5c, environ)")
OneGadget::Gadget.add(build_id, 308248,
                      constraints: ["gp is the GOT address of libc", "[sp+0x18] is the GOT address of libc", "writable: s1", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "(u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0x3c, \"/bin/sh\", 0, s1, sp+0x5c, environ)")
OneGadget::Gadget.add(build_id, 308252,
                      constraints: ["gp is the GOT address of libc", "[sp+0x18] is the GOT address of libc", "writable: s1", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "(u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0x3c, \"/bin/sh\", 0, s1, sp+0x5c, environ)")
OneGadget::Gadget.add(build_id, 308256,
                      constraints: ["gp is the GOT address of libc", "[sp+0x18] is the GOT address of libc", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "s1 == NULL || (u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0x3c, \"/bin/sh\", 0, s1, sp+0x5c, environ)")
OneGadget::Gadget.add(build_id, 308260,
                      constraints: ["gp is the GOT address of libc", "[sp+0x18] is the GOT address of libc", "{\"sh\", \"-c\", s5, NULL} is a valid argv", "s1 == NULL || (u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0x3c, \"/bin/sh\", 0, s1, sp+0x5c, environ)")
OneGadget::Gadget.add(build_id, 308264,
                      constraints: ["gp is the GOT address of libc", "[sp+0x18] is the GOT address of libc", "[v1] == NULL || v1 is a valid argv", "s1 == NULL || (u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0x3c, \"/bin/sh\", 0, s1, v1, environ)")
OneGadget::Gadget.add(build_id, 308268,
                      constraints: ["gp is the GOT address of libc", "[v1] == NULL || v1 is a valid argv", "s1 == NULL || (u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0x3c, \"/bin/sh\", 0, s1, v1, environ)")
OneGadget::Gadget.add(build_id, 308272,
                      constraints: ["gp is the GOT address of libc", "[v1] == NULL || v1 is a valid argv", "a2 == NULL || (s32)[a2+0x4] <= 0x0", "s1 == NULL || (u16)[s1] == 0x0"],
                      effect: "posix_spawn(sp+0x3c, \"/bin/sh\", a2, s1, v1, environ)")
OneGadget::Gadget.add(build_id, 308276,
                      constraints: ["gp is the GOT address of libc", "[v1] == NULL || v1 is a valid argv", "a0 == NULL || writable: a0", "a2 == NULL || (s32)[a2+0x4] <= 0x0", "s1 == NULL || (u16)[s1] == 0x0"],
                      effect: "posix_spawn(a0, \"/bin/sh\", a2, s1, v1, environ)")
OneGadget::Gadget.add(build_id, 308280,
                      constraints: ["gp is the GOT address of libc", "[v1] == NULL || v1 is a valid argv", "a0 == NULL || writable: a0", "a2 == NULL || (s32)[a2+0x4] <= 0x0", "s1 == NULL || (u16)[s1] == 0x0"],
                      effect: "posix_spawn(a0, \"/bin/sh\", a2, s1, v1, environ)")
OneGadget::Gadget.add(build_id, 308284,
                      constraints: ["gp is the GOT address of libc", "[v1] == NULL || v1 is a valid argv", "a0 == NULL || writable: a0", "a2 == NULL || (s32)[a2+0x4] <= 0x0", "a3 == NULL || (u16)[a3] == 0x0"],
                      effect: "posix_spawn(a0, \"/bin/sh\", a2, a3, v1, environ)")
OneGadget::Gadget.add(build_id, 308288,
                      constraints: ["gp is the GOT address of libc", "[v1] == NULL || v1 is a valid argv", "a0 == NULL || writable: a0", "a2 == NULL || (s32)[a2+0x4] <= 0x0", "a3 == NULL || (u16)[a3] == 0x0"],
                      effect: "posix_spawn(a0, \"/bin/sh\", a2, a3, v1, environ)")
OneGadget::Gadget.add(build_id, 308292,
                      constraints: ["gp is the GOT address of libc", "readable: v0", "[v1] == NULL || v1 is a valid argv", "[[v0]] == NULL || [v0] == NULL || [v0] is a valid envp", "a0 == NULL || writable: a0", "a2 == NULL || (s32)[a2+0x4] <= 0x0", "a3 == NULL || (u16)[a3] == 0x0"],
                      effect: "posix_spawn(a0, \"/bin/sh\", a2, a3, v1, [v0])")
OneGadget::Gadget.add(build_id, 467588,
                      constraints: ["gp is the GOT address of libc", "[$base+0x1d32fc] == 0x0", "writable: s2+0x4", "{\"sh\", \"-c\", s0, NULL} is a valid argv", "s7+0xa0 == NULL || writable: s7+0xa0", "s1 == NULL || (s32)[s1+0x4] <= 0x0"],
                      effect: "posix_spawn(s7+0xa0, \"/bin/sh\", s1, 0, sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 467592,
                      constraints: ["gp is the GOT address of libc", "[v0+0x32fc] == 0x0", "writable: s2+0x4", "{\"sh\", \"-c\", s0, NULL} is a valid argv", "s7+0xa0 == NULL || writable: s7+0xa0", "s1 == NULL || (s32)[s1+0x4] <= 0x0"],
                      effect: "posix_spawn(s7+0xa0, \"/bin/sh\", s1, 0, sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 467596,
                      constraints: ["gp is the GOT address of libc", "[v0+0x32fc] == 0x0", "writable: s2+0x4", "{\"sh\", \"-c\", s0, NULL} is a valid argv", "s7+0xa0 == NULL || writable: s7+0xa0", "s1 == NULL || (s32)[s1+0x4] <= 0x0"],
                      effect: "posix_spawn(s7+0xa0, \"/bin/sh\", s1, 0, sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 467600,
                      constraints: ["gp is the GOT address of libc", "[v1+0x32fc] == 0x0", "writable: s2+0x4", "{\"sh\", \"-c\", s0, NULL} is a valid argv", "s7+0xa0 == NULL || writable: s7+0xa0", "s1 == NULL || (s32)[s1+0x4] <= 0x0"],
                      effect: "posix_spawn(s7+0xa0, \"/bin/sh\", s1, 0, sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 467604,
                      constraints: ["gp is the GOT address of libc", "[v1+0x32fc] == 0x0", "writable: s2+0x4", "{\"sh\", \"-c\", s0, NULL} is a valid argv", "s7+0xa0 == NULL || writable: s7+0xa0", "s1 == NULL || (s32)[s1+0x4] <= 0x0"],
                      effect: "posix_spawn(s7+0xa0, \"/bin/sh\", s1, 0, sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 467608,
                      constraints: ["gp is the GOT address of libc", "[v1+0x32fc] == 0x0", "writable: s2+0x4", "{\"sh\", \"-c\", s0, NULL} is a valid argv", "s7+0xa0 == NULL || writable: s7+0xa0", "s1 == NULL || (s32)[s1+0x4] <= 0x0"],
                      effect: "posix_spawn(s7+0xa0, \"/bin/sh\", s1, 0, sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 467612,
                      constraints: ["gp is the GOT address of libc", "s5 == 0x0", "writable: s2+0x4", "{\"sh\", \"-c\", s0, NULL} is a valid argv", "s7+0xa0 == NULL || writable: s7+0xa0", "s1 == NULL || (s32)[s1+0x4] <= 0x0"],
                      effect: "posix_spawn(s7+0xa0, \"/bin/sh\", s1, 0, sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 467616,
                      constraints: ["gp is the GOT address of libc", "s5 == 0x0", "writable: s2+0x4", "{\"sh\", \"-c\", s0, NULL} is a valid argv", "s7+0xa0 == NULL || writable: s7+0xa0", "s1 == NULL || (s32)[s1+0x4] <= 0x0"],
                      effect: "posix_spawn(s7+0xa0, \"/bin/sh\", s1, 0, sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 467664,
                      constraints: ["gp is the GOT address of libc", "{\"sh\", \"-c\", s0, NULL} is a valid argv", "s7+0xa0 == NULL || writable: s7+0xa0", "s1 == NULL || (s32)[s1+0x4] <= 0x0"],
                      effect: "posix_spawn(s7+0xa0, \"/bin/sh\", s1, 0, sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 467668,
                      constraints: ["gp is the GOT address of libc", "readable: v0", "{\"sh\", \"-c\", s0, NULL} is a valid argv", "[[v0]] == NULL || [v0] == NULL || [v0] is a valid envp", "s7+0xa0 == NULL || writable: s7+0xa0", "s1 == NULL || (s32)[s1+0x4] <= 0x0"],
                      effect: "posix_spawn(s7+0xa0, \"/bin/sh\", s1, 0, sp+0x58, [v0])")
OneGadget::Gadget.add(build_id, 467672,
                      constraints: ["gp is the GOT address of libc", "readable: v0", "[v1] == NULL || v1 is a valid argv", "[[v0]] == NULL || [v0] == NULL || [v0] is a valid envp", "s7+0xa0 == NULL || writable: s7+0xa0", "s1 == NULL || (s32)[s1+0x4] <= 0x0"],
                      effect: "posix_spawn(s7+0xa0, \"/bin/sh\", s1, 0, v1, [v0])")
OneGadget::Gadget.add(build_id, 1604260,
                      constraints: ["gp is the GOT address of libc", "a2-0x6a84 == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", a2-0x6a84)")
OneGadget::Gadget.add(build_id, 1604264,
                      constraints: ["gp is the GOT address of libc", "a2-0x6a84 == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", a2-0x6a84)")
OneGadget::Gadget.add(build_id, 1604268,
                      constraints: ["gp is the GOT address of libc", "a1-0x6a88 == NULL"],
                      effect: "execl(\"/bin/sh\", a1-0x6a88)")

