require 'one_gadget/gadget'
# spec/data/libc-2.43-8c7af7f227b3871d6afba752cbb617f317023de5.so
# 
# ARM
# 
# GNU C Library (Ubuntu GLIBC 2.43-2ubuntu2) stable release version 2.43.
# Copyright (C) 2026 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 15.2.0.
# libc ABIs: UNIQUE ABSOLUTE
# Minimum supported kernel: 3.2.0
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 241600,
                      constraints: ["r6 is the GOT address of libc", "readable: r5", "writable: r0", "writable: r7", "{\"sh\", \"-c\", \"--\", r9, ...} is a valid argv", "(u16)[r7] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, r7, sp+0x2c, environ)")
OneGadget::Gadget.add(build_id, 241604,
                      constraints: ["r6 is the GOT address of libc", "readable: r5", "writable: r7", "{\"sh\", \"-c\", \"--\", r9, ...} is a valid argv", "(u16)[r7] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, r7, sp+0x2c, environ)")
OneGadget::Gadget.add(build_id, 241606,
                      constraints: ["r6 is the GOT address of libc", "readable: r1", "writable: r7", "{\"sh\", \"-c\", \"--\", r9, ...} is a valid argv", "(u16)[r7] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, r7, sp+0x2c, environ)")
OneGadget::Gadget.add(build_id, 241608,
                      constraints: ["r6 is the GOT address of libc", "readable: r1", "writable: r0", "writable: r7", "{\"sh\", \"-c\", \"--\", r9, ...} is a valid argv", "(u16)[r7] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, r7, sp+0x2c, environ)")
OneGadget::Gadget.add(build_id, 241612,
                      constraints: ["r6 is the GOT address of libc", "writable: r7", "{\"sh\", \"-c\", \"--\", r9, ...} is a valid argv", "(u16)[r7] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, r7, sp+0x2c, environ)")
OneGadget::Gadget.add(build_id, 241614,
                      constraints: ["r6 is the GOT address of libc", "readable: r1", "writable: r7", "{\"sh\", \"-c\", \"--\", r9, ...} is a valid argv", "(u16)[r7] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, r7, sp+0x2c, environ)")
OneGadget::Gadget.add(build_id, 241616,
                      constraints: ["r6 is the GOT address of libc", "readable: r1", "writable: r0", "writable: r7", "{\"sh\", \"-c\", \"--\", r9, ...} is a valid argv", "(u16)[r7] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, r7, sp+0x2c, environ)")
OneGadget::Gadget.add(build_id, 241620,
                      constraints: ["r6 is the GOT address of libc", "writable: r7", "{\"sh\", \"-c\", \"--\", r9, ...} is a valid argv", "(u16)[r7] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, r7, sp+0x2c, environ)")
OneGadget::Gadget.add(build_id, 241622,
                      constraints: ["r6 is the GOT address of libc", "writable: r7", "{\"sh\", \"-c\", \"--\", r9, ...} is a valid argv", "(u16)[r7] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, r7, sp+0x2c, environ)")
OneGadget::Gadget.add(build_id, 241624,
                      constraints: ["r6 is the GOT address of libc", "writable: r0", "{\"sh\", \"-c\", \"--\", r9, ...} is a valid argv", "r7 == NULL || (u16)[r7] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, r7, sp+0x2c, environ)")
OneGadget::Gadget.add(build_id, 241628,
                      constraints: ["r6 is the GOT address of libc", "{\"sh\", \"-c\", \"--\", r9, ...} is a valid argv", "r7 == NULL || (u16)[r7] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, r7, sp+0x2c, environ)")
OneGadget::Gadget.add(build_id, 241630,
                      constraints: ["r6 is the GOT address of libc", "(r2 + $base+0x3afe6) == NULL || {(r2 + $base+0x3afe6), \"-c\", \"--\", r9, ...} is a valid argv", "r7 == NULL || (u16)[r7] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, r7, sp+0x2c, environ)")
OneGadget::Gadget.add(build_id, 241660,
                      constraints: ["readable: r1", "[r3] == NULL || r3 is a valid argv", "[[r1]] == NULL || [r1] == NULL || [r1] is a valid envp", "r2 == NULL || (s32)[r2+0x4] <= 0x0", "r7 == NULL || (u16)[r7] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", r2, r7, r3, [r1])")
OneGadget::Gadget.add(build_id, 241662,
                      constraints: ["readable: r1", "[r3] == NULL || r3 is a valid argv", "[[r1]] == NULL || [r1] == NULL || [r1] is a valid envp", "r6 == NULL || writable: r6", "r2 == NULL || (s32)[r2+0x4] <= 0x0", "r7 == NULL || (u16)[r7] == 0x0"],
                      effect: "posix_spawn(r6, \"/bin/sh\", r2, r7, r3, [r1])")
OneGadget::Gadget.add(build_id, 241664,
                      constraints: ["readable: r1", "[[sp]] == NULL || [sp] is a valid argv", "[[r1]] == NULL || [r1] == NULL || [r1] is a valid envp", "r6 == NULL || writable: r6", "r2 == NULL || (s32)[r2+0x4] <= 0x0", "r7 == NULL || (u16)[r7] == 0x0"],
                      effect: "posix_spawn(r6, \"/bin/sh\", r2, r7, [sp], [r1])")
OneGadget::Gadget.add(build_id, 241666,
                      constraints: ["readable: r1", "[[sp]] == NULL || [sp] is a valid argv", "[[r1]] == NULL || [r1] == NULL || [r1] is a valid envp", "r0 == NULL || writable: r0", "r2 == NULL || (s32)[r2+0x4] <= 0x0", "r7 == NULL || (u16)[r7] == 0x0"],
                      effect: "posix_spawn(r0, \"/bin/sh\", r2, r7, [sp], [r1])")
OneGadget::Gadget.add(build_id, 241668,
                      constraints: ["[[sp]] == NULL || [sp] is a valid argv", "[r3] == NULL || r3 == NULL || r3 is a valid envp", "r0 == NULL || writable: r0", "r2 == NULL || (s32)[r2+0x4] <= 0x0", "r7 == NULL || (u16)[r7] == 0x0"],
                      effect: "posix_spawn(r0, \"/bin/sh\", r2, r7, [sp], r3)")
OneGadget::Gadget.add(build_id, 344924,
                      constraints: ["r7 is the GOT address of libc", "[$base+0x1314fc] == 0x0", "ip == 0x0", "r3-0x4e0 == [r0+0x8]", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 344924,
                      constraints: ["r7 is the GOT address of libc", "[$base+0x1314fc] == 0x0", "[r0+0x8] == 0x0", "ip != 0x0", "writable: r0", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 344924,
                      constraints: ["r7 is the GOT address of libc", "[$base+0x1314fc] == 0x0", "[r0+0x8] != 0x0", "ip != 0x0", "r3-0x4e0 == [r0+0x8]", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 344928,
                      constraints: ["r7 is the GOT address of libc", "[$base+0x1314fc] == 0x0", "ip == 0x0", "r2 == [r0+0x8]", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 344928,
                      constraints: ["r7 is the GOT address of libc", "[$base+0x1314fc] == 0x0", "[r0+0x8] == 0x0", "ip != 0x0", "writable: r0", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 344928,
                      constraints: ["r7 is the GOT address of libc", "[$base+0x1314fc] == 0x0", "[r0+0x8] != 0x0", "ip != 0x0", "r2 == [r0+0x8]", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 344930,
                      constraints: ["r7 is the GOT address of libc", "[$base+0x1314fc] == 0x0", "ip == 0x0", "r2 == r1", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 344930,
                      constraints: ["r7 is the GOT address of libc", "[$base+0x1314fc] == 0x0", "ip != 0x0", "r1 == 0x0", "writable: r0", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 344930,
                      constraints: ["r7 is the GOT address of libc", "[$base+0x1314fc] == 0x0", "ip != 0x0", "r1 != 0x0", "r2 == r1", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 344932,
                      constraints: ["r7 is the GOT address of libc", "[$base+0x1314fc] == 0x0", "ip == 0x0", "r2 == r1", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 344932,
                      constraints: ["r7 is the GOT address of libc", "[$base+0x1314fc] == 0x0", "ip != 0x0", "r1 == 0x0", "writable: r0", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 344932,
                      constraints: ["r7 is the GOT address of libc", "[$base+0x1314fc] == 0x0", "ip != 0x0", "r1 != 0x0", "r2 == r1", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 344938,
                      constraints: ["r7 is the GOT address of libc", "[$base+0x1314fc] == 0x0", "r1 == 0x0", "writable: r0", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 344938,
                      constraints: ["r7 is the GOT address of libc", "[$base+0x1314fc] == 0x0", "r1 != 0x0", "r2 == r1", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 344938,
                      constraints: ["r7 is the GOT address of libc", "[[$base+0x1314fc]+0xa4] == 0x0", "r1 == 0x0", "r3 == [[$base+0x1314fc]+0x38]", "writable: r0", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 344940,
                      constraints: ["r7 is the GOT address of libc", "[$base+0x1314fc] == 0x0", "writable: r0", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 344940,
                      constraints: ["r7 is the GOT address of libc", "[[$base+0x1314fc]+0xa4] == 0x0", "r3 == [[$base+0x1314fc]+0x38]", "writable: r0", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 344942,
                      constraints: ["r7 is the GOT address of libc", "[$base+0x1314fc] == 0x0", "writable: r0", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 344942,
                      constraints: ["r7 is the GOT address of libc", "[[$base+0x1314fc]+0xa4] == 0x0", "r3 == [[$base+0x1314fc]+0x38]", "writable: r0", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 344944,
                      constraints: ["r7 is the GOT address of libc", "[$base+0x1314fc] == 0x0", "writable: r0", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 344944,
                      constraints: ["r7 is the GOT address of libc", "[[$base+0x1314fc]+0xa4] == 0x0", "r3 == [[$base+0x1314fc]+0x38]", "writable: r0", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 344946,
                      constraints: ["r7 is the GOT address of libc", "[$base+0x1314fc] == 0x0", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 344946,
                      constraints: ["r7 is the GOT address of libc", "[[$base+0x1314fc]+0xa4] == 0x0", "r3 == [[$base+0x1314fc]+0x38]", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 344956,
                      constraints: ["r7 is the GOT address of libc", "[$base+0x1314fc] == 0x0", "r2 == r1", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 344956,
                      constraints: ["r7 is the GOT address of libc", "[[$base+0x1314fc]+0xa4] == 0x0", "r2 == r1", "r3 == [[$base+0x1314fc]+0x38]", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 344980,
                      constraints: ["r7 is the GOT address of libc", "[$base+0x1314fc] == 0x0", "r5 == 0x0", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 344992,
                      constraints: ["r7 is the GOT address of libc", "[$base+0x1314fc] == 0x0", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 344992,
                      constraints: ["r7 is the GOT address of libc", "[[$base+0x1314fc]+0xa4] == 0x0", "r3 == [[$base+0x1314fc]+0x38]", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 344994,
                      constraints: ["r7 is the GOT address of libc", "[$base+0x1314fc] == 0x0", "writable: (r1 + $base+0x543a6)+0x8", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 344994,
                      constraints: ["r7 is the GOT address of libc", "[[$base+0x1314fc]+0xa4] == 0x0", "r3 == [[$base+0x1314fc]+0x38]", "writable: (r1 + $base+0x543a6)+0x8", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 344996,
                      constraints: ["r7 is the GOT address of libc", "[$base+0x1314fc] == 0x0", "writable: r1+0x8", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 344996,
                      constraints: ["r7 is the GOT address of libc", "[[$base+0x1314fc]+0xa4] == 0x0", "r3 == [[$base+0x1314fc]+0x38]", "writable: r1+0x8", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 344998,
                      constraints: ["r7 is the GOT address of libc", "[$base+0x1314fc] == 0x0", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 344998,
                      constraints: ["r7 is the GOT address of libc", "[[$base+0x1314fc]+0xa4] == 0x0", "r3 == [[$base+0x1314fc]+0x38]", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 345000,
                      constraints: ["r7 is the GOT address of libc", "[(r2 + $base+0x543ac)+0xc] == 0x0", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 345000,
                      constraints: ["r7 is the GOT address of libc", "[[(r2 + $base+0x543ac)+0xc]+0xa4] == 0x0", "r3 == [[(r2 + $base+0x543ac)+0xc]+0x38]", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 345002,
                      constraints: ["r7 is the GOT address of libc", "[r2+0xc] == 0x0", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 345002,
                      constraints: ["r7 is the GOT address of libc", "[[r2+0xc]+0xa4] == 0x0", "r3 == [[r2+0xc]+0x38]", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 345004,
                      constraints: ["r7 is the GOT address of libc", "r2 == 0x0", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 345004,
                      constraints: ["r7 is the GOT address of libc", "[r2+0xa4] == 0x0", "r3 == [r2+0x38]", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 345006,
                      constraints: ["r7 is the GOT address of libc", "[r2+0xa4] == 0x0", "r3 == [r2+0x38]", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 345008,
                      constraints: ["r7 is the GOT address of libc", "[r2+0xa4] == 0x0", "r3 == [r2+0x38]", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 345010,
                      constraints: ["r7 is the GOT address of libc", "[r4+0xa4] == 0x0", "r3 == [r4+0x38]", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 345012,
                      constraints: ["r7 is the GOT address of libc", "[r4+0xa4] == 0x0", "r3 == r1", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 345024,
                      constraints: ["r7 is the GOT address of libc", "[r4+0xa4] == 0x0", "r0 == 0x0", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 345026,
                      constraints: ["r7 is the GOT address of libc", "[r4+0xa4] == 0x0", "r0 == 0x0", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 345032,
                      constraints: ["r7 is the GOT address of libc", "[r4+0xa4] == 0x0", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 345036,
                      constraints: ["r7 is the GOT address of libc", "r4 == 0x0", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 345040,
                      constraints: ["r7 is the GOT address of libc", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 345042,
                      constraints: ["r7 is the GOT address of libc", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 345044,
                      constraints: ["r7 is the GOT address of libc", "(r3 + $base+0x543de) == NULL || {(r3 + $base+0x543de), \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 345048,
                      constraints: ["r7 is the GOT address of libc", "(r3 + $base+0x543de) == NULL || {(r3 + $base+0x543de), \"-c\", \"--\", r8, ...} is a valid argv", "r0 == NULL || writable: r0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 345182,
                      constraints: ["r7 is the GOT address of libc", "[$base+0x1314fc] == 0x0", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 345182,
                      constraints: ["r7 is the GOT address of libc", "[[$base+0x1314fc]+0xa4] == 0x0", "r3 == [[$base+0x1314fc]+0x38]", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 345184,
                      constraints: ["r7 is the GOT address of libc", "[$base+0x1314fc] == 0x0", "writable: (r1 + $base+0x54464)+0x4", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 345184,
                      constraints: ["r7 is the GOT address of libc", "[[$base+0x1314fc]+0xa4] == 0x0", "r3 == [[$base+0x1314fc]+0x38]", "writable: (r1 + $base+0x54464)+0x4", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 345186,
                      constraints: ["r7 is the GOT address of libc", "[$base+0x1314fc] == 0x0", "writable: r1+0x4", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 345186,
                      constraints: ["r7 is the GOT address of libc", "[[$base+0x1314fc]+0xa4] == 0x0", "r3 == [[$base+0x1314fc]+0x38]", "writable: r1+0x4", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 345188,
                      constraints: ["r7 is the GOT address of libc", "[$base+0x1314fc] == 0x0", "writable: r1+0x4", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 345188,
                      constraints: ["r7 is the GOT address of libc", "[[$base+0x1314fc]+0xa4] == 0x0", "r3 == [[$base+0x1314fc]+0x38]", "writable: r1+0x4", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 345190,
                      constraints: ["r7 is the GOT address of libc", "[$base+0x1314fc] == 0x0", "writable: r1+0x4", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 345190,
                      constraints: ["r7 is the GOT address of libc", "[[$base+0x1314fc]+0xa4] == 0x0", "r3 == [[$base+0x1314fc]+0x38]", "writable: r1+0x4", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 345192,
                      constraints: ["r7 is the GOT address of libc", "[$base+0x1314fc] == 0x0", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 345192,
                      constraints: ["r7 is the GOT address of libc", "[[$base+0x1314fc]+0xa4] == 0x0", "r3 == [[$base+0x1314fc]+0x38]", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r6+0xa0 == NULL || writable: r6+0xa0", "sp+0x50 == NULL || (s32)[sp+0x54] <= 0x0"],
                      effect: "posix_spawn(r6+0xa0, \"/bin/sh\", sp+0x50, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 579914,
                      constraints: ["[r4] == NULL || r4 == NULL || r4 is a valid argv", "[r5] == NULL || r5 == NULL || r5 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r4, r5)")
OneGadget::Gadget.add(build_id, 579966,
                      constraints: ["[r4] == NULL || r4 == NULL || r4 is a valid argv", "[r5] == NULL || r5 == NULL || r5 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r4, r5)")
OneGadget::Gadget.add(build_id, 672456,
                      constraints: ["r0 == 0x0", "readable: r3", "[[sp+0x38]] == NULL || [sp+0x38] is a valid argv", "[[r3]] == NULL || [r3] == NULL || [r3] is a valid envp", "[sp+0x30] == NULL || writable: [sp+0x30]", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn([sp+0x30], \"/bin/sh\", [sp+0x28], 0, [sp+0x38], [r3])")
OneGadget::Gadget.add(build_id, 672460,
                      constraints: ["r0 == 0x0", "[[sp+0x38]] == NULL || [sp+0x38] is a valid argv", "[r9] == NULL || r9 == NULL || r9 is a valid envp", "[sp+0x30] == NULL || writable: [sp+0x30]", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn([sp+0x30], \"/bin/sh\", [sp+0x28], 0, [sp+0x38], r9)")
OneGadget::Gadget.add(build_id, 672564,
                      constraints: ["readable: r5+0x8", "[[sp+0x38]] == NULL || [sp+0x38] is a valid argv", "[[r5+0x8]] == NULL || [r5+0x8] == NULL || [r5+0x8] is a valid envp", "[sp+0x30] == NULL || writable: [sp+0x30]", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn([sp+0x30], \"/bin/sh\", [sp+0x28], 0, [sp+0x38], [r5+0x8])")
OneGadget::Gadget.add(build_id, 672568,
                      constraints: ["[[sp+0x38]] == NULL || [sp+0x38] is a valid argv", "[r9] == NULL || r9 == NULL || r9 is a valid envp", "[sp+0x30] == NULL || writable: [sp+0x30]", "[sp+0x28] == NULL || (s32)[[sp+0x28]+0x4] <= 0x0"],
                      effect: "posix_spawn([sp+0x30], \"/bin/sh\", [sp+0x28], 0, [sp+0x38], r9)")

