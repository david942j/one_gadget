require 'one_gadget/gadget'
# http://ports.ubuntu.com/ubuntu-ports/pool/main/g/glibc/libc6_2.31-0ubuntu9.18_armhf.deb
# 
# ARM
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
OneGadget::Gadget.add(build_id, 192398,
                      constraints: ["readable: r4", "[r1] == NULL || r1 is a valid argv", "[[r4]] == NULL || [r4] == NULL || [r4] is a valid envp", "r9 == NULL || writable: r9", "r1 == NULL || (s32)[r1+0x4] <= 0x0", "r3 == NULL || (u16)[r3] == 0x0"],
                      effect: "posix_spawn(r9, \"/bin/sh\", r1, r3, r1, [r4])")
OneGadget::Gadget.add(build_id, 192400,
                      constraints: ["readable: r4", "[r1] == NULL || r1 is a valid argv", "[[r4]] == NULL || [r4] == NULL || [r4] is a valid envp", "r9 == NULL || writable: r9", "r2 == NULL || (s32)[r2+0x4] <= 0x0", "r3 == NULL || (u16)[r3] == 0x0"],
                      effect: "posix_spawn(r9, \"/bin/sh\", r2, r3, r1, [r4])")
OneGadget::Gadget.add(build_id, 193166,
                      constraints: ["readable: r4", "[r1] == NULL || r1 is a valid argv", "[[r4]] == NULL || [r4] == NULL || [r4] is a valid envp", "r9 == NULL || writable: r9", "r2 == NULL || (s32)[r2+0x4] <= 0x0", "sl == NULL || (u16)[sl] == 0x0"],
                      effect: "posix_spawn(r9, \"/bin/sh\", r2, sl, r1, [r4])")
OneGadget::Gadget.add(build_id, 193168,
                      constraints: ["readable: r4", "[r1] == NULL || r1 is a valid argv", "[[r4]] == NULL || [r4] == NULL || [r4] is a valid envp", "r9 == NULL || writable: r9", "r2 == NULL || (s32)[r2+0x4] <= 0x0", "r3 == NULL || (u16)[r3] == 0x0"],
                      effect: "posix_spawn(r9, \"/bin/sh\", r2, r3, r1, [r4])")
OneGadget::Gadget.add(build_id, 193170,
                      constraints: ["readable: r4", "[[sp]] == NULL || [sp] is a valid argv", "[[r4]] == NULL || [r4] == NULL || [r4] is a valid envp", "r9 == NULL || writable: r9", "r2 == NULL || (s32)[r2+0x4] <= 0x0", "r3 == NULL || (u16)[r3] == 0x0"],
                      effect: "posix_spawn(r9, \"/bin/sh\", r2, r3, [sp], [r4])")
OneGadget::Gadget.add(build_id, 193172,
                      constraints: ["readable: r4", "[[sp]] == NULL || [sp] is a valid argv", "[[r4]] == NULL || [r4] == NULL || [r4] is a valid envp", "r0 == NULL || writable: r0", "r2 == NULL || (s32)[r2+0x4] <= 0x0", "r3 == NULL || (u16)[r3] == 0x0"],
                      effect: "posix_spawn(r0, \"/bin/sh\", r2, r3, [sp], [r4])")
OneGadget::Gadget.add(build_id, 301308,
                      constraints: ["r7 is the GOT address of libc", "[$base+0xfc648] == 0x0", "[(r3 + $base+0x49906)+0xc] == r2-0x4c0", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 301308,
                      constraints: ["r7 is the GOT address of libc", "[(r3 + $base+0x49906)+0xc] == r2-0x4c0", "[[$base+0xfc648]+0xa4] == 0x0", "fp == [[$base+0xfc648]+0x38]", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 301310,
                      constraints: ["r7 is the GOT address of libc", "[$base+0xfc648] == 0x0", "[(r3 + $base+0x49906)+0xc] == r2-0x4c0", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 301310,
                      constraints: ["r7 is the GOT address of libc", "[(r3 + $base+0x49906)+0xc] == r2-0x4c0", "[[$base+0xfc648]+0xa4] == 0x0", "fp == [[$base+0xfc648]+0x38]", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 301314,
                      constraints: ["r7 is the GOT address of libc", "[$base+0xfc648] == 0x0", "[(r3 + $base+0x49906)+0xc] == r2", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 301314,
                      constraints: ["r7 is the GOT address of libc", "[(r3 + $base+0x49906)+0xc] == r2", "[[$base+0xfc648]+0xa4] == 0x0", "fp == [[$base+0xfc648]+0x38]", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 301316,
                      constraints: ["r7 is the GOT address of libc", "[$base+0xfc648] == 0x0", "[r3+0xc] == r2", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 301316,
                      constraints: ["r7 is the GOT address of libc", "[[$base+0xfc648]+0xa4] == 0x0", "[r3+0xc] == r2", "fp == [[$base+0xfc648]+0x38]", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 301318,
                      constraints: ["r7 is the GOT address of libc", "[$base+0xfc648] == 0x0", "r1 == r2", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 301318,
                      constraints: ["r7 is the GOT address of libc", "[[$base+0xfc648]+0xa4] == 0x0", "fp == [[$base+0xfc648]+0x38]", "r1 == r2", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 301338,
                      constraints: ["r7 is the GOT address of libc", "[$base+0xfc648] == 0x0", "ip == 0x0", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 301352,
                      constraints: ["r7 is the GOT address of libc", "[$base+0xfc648] == 0x0", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 301352,
                      constraints: ["r7 is the GOT address of libc", "[[$base+0xfc648]+0xa4] == 0x0", "fp == [[$base+0xfc648]+0x38]", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 301354,
                      constraints: ["r7 is the GOT address of libc", "[$base+0xfc648] == 0x0", "writable: (r3 + $base+0x4992e)+0xc", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 301354,
                      constraints: ["r7 is the GOT address of libc", "[[$base+0xfc648]+0xa4] == 0x0", "fp == [[$base+0xfc648]+0x38]", "writable: (r3 + $base+0x4992e)+0xc", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 301356,
                      constraints: ["r7 is the GOT address of libc", "[$base+0xfc648] == 0x0", "writable: r3+0xc", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 301356,
                      constraints: ["r7 is the GOT address of libc", "[[$base+0xfc648]+0xa4] == 0x0", "fp == [[$base+0xfc648]+0x38]", "writable: r3+0xc", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 301358,
                      constraints: ["r7 is the GOT address of libc", "[$base+0xfc648] == 0x0", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 301358,
                      constraints: ["r7 is the GOT address of libc", "[[$base+0xfc648]+0xa4] == 0x0", "fp == [[$base+0xfc648]+0x38]", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 301360,
                      constraints: ["r7 is the GOT address of libc", "[(r2 + $base+0x49934)] == 0x0", "writable: (r2 + $base+0x49934)+0x8", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 301360,
                      constraints: ["r7 is the GOT address of libc", "[[(r2 + $base+0x49934)]+0xa4] == 0x0", "fp == [[(r2 + $base+0x49934)]+0x38]", "writable: (r2 + $base+0x49934)+0x8", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 301362,
                      constraints: ["r7 is the GOT address of libc", "[r2] == 0x0", "writable: r2+0x8", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 301362,
                      constraints: ["r7 is the GOT address of libc", "[[r2]+0xa4] == 0x0", "fp == [[r2]+0x38]", "writable: r2+0x8", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 301364,
                      constraints: ["r7 is the GOT address of libc", "[r2] == 0x0", "writable: r2+0x8", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 301364,
                      constraints: ["r7 is the GOT address of libc", "[[r2]+0xa4] == 0x0", "fp == [[r2]+0x38]", "writable: r2+0x8", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 301368,
                      constraints: ["r7 is the GOT address of libc", "r9 == 0x0", "writable: r2+0x8", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 301368,
                      constraints: ["r7 is the GOT address of libc", "[r9+0xa4] == 0x0", "fp == [r9+0x38]", "writable: r2+0x8", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 301370,
                      constraints: ["r7 is the GOT address of libc", "r9 == 0x0", "writable: r2+0x8", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 301370,
                      constraints: ["r7 is the GOT address of libc", "[r9+0xa4] == 0x0", "fp == [r9+0x38]", "writable: r2+0x8", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 301372,
                      constraints: ["r7 is the GOT address of libc", "r9 == 0x0", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 301372,
                      constraints: ["r7 is the GOT address of libc", "[r9+0xa4] == 0x0", "fp == [r9+0x38]", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 301378,
                      constraints: ["r7 is the GOT address of libc", "[r9+0xa4] == 0x0", "fp == [r9+0x38]", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 301380,
                      constraints: ["r7 is the GOT address of libc", "[r3+0xa4] == 0x0", "fp == [r3+0x38]", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 301382,
                      constraints: ["r7 is the GOT address of libc", "[r3+0xa4] == 0x0", "fp == [r3+0x38]", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 301384,
                      constraints: ["r7 is the GOT address of libc", "[r4+0xa4] == 0x0", "fp == [r4+0x38]", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 301386,
                      constraints: ["r7 is the GOT address of libc", "[r4+0xa4] == 0x0", "fp == r1", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 301396,
                      constraints: ["r7 is the GOT address of libc", "[r4+0xa4] == 0x0", "r0 == 0x0", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 301400,
                      constraints: ["r7 is the GOT address of libc", "[r4+0xa4] == 0x0", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 301404,
                      constraints: ["r7 is the GOT address of libc", "r4 == 0x0", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 301408,
                      constraints: ["r7 is the GOT address of libc", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 301410,
                      constraints: ["r7 is the GOT address of libc", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 301444,
                      constraints: ["readable: r6", "[sp+0x38] == NULL || {[sp+0x38], [sp+0x3c], [sp+0x40], [sp+0x44], ...} is a valid argv", "[[r6]] == NULL || [r6] == NULL || [r6] is a valid envp", "r0 == NULL || writable: r0", "r2 == NULL || (s32)[r2+0x4] <= 0x0", "r3 == NULL || (u16)[r3] == 0x0"],
                      effect: "posix_spawn(r0, \"/bin/sh\", r2, r3, sp+0x38, [r6])")
OneGadget::Gadget.add(build_id, 301446,
                      constraints: ["readable: r6", "[r1] == NULL || r1 is a valid argv", "[[r6]] == NULL || [r6] == NULL || [r6] is a valid envp", "r0 == NULL || writable: r0", "r2 == NULL || (s32)[r2+0x4] <= 0x0", "r3 == NULL || (u16)[r3] == 0x0"],
                      effect: "posix_spawn(r0, \"/bin/sh\", r2, r3, r1, [r6])")
OneGadget::Gadget.add(build_id, 301448,
                      constraints: ["readable: r6", "[[sp]] == NULL || [sp] is a valid argv", "[[r6]] == NULL || [r6] == NULL || [r6] is a valid envp", "r0 == NULL || writable: r0", "r2 == NULL || (s32)[r2+0x4] <= 0x0", "r3 == NULL || (u16)[r3] == 0x0"],
                      effect: "posix_spawn(r0, \"/bin/sh\", r2, r3, [sp], [r6])")
OneGadget::Gadget.add(build_id, 301770,
                      constraints: ["r7 is the GOT address of libc", "[$base+0xfc648] == 0x0", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 301770,
                      constraints: ["r7 is the GOT address of libc", "[[$base+0xfc648]+0xa4] == 0x0", "fp == [[$base+0xfc648]+0x38]", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 301772,
                      constraints: ["r7 is the GOT address of libc", "[$base+0xfc648] == 0x0", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 301772,
                      constraints: ["r7 is the GOT address of libc", "[[$base+0xfc648]+0xa4] == 0x0", "fp == [[$base+0xfc648]+0x38]", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 491684,
                      constraints: ["[r1] == 0x0", "readable: [(r0 + $base+0x780ac)+0x154]", "ip == NULL || {\"/bin/sh\", ip, NULL} is a valid argv", "[r2] == NULL || r2 == NULL || r2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x10, r2)")
OneGadget::Gadget.add(build_id, 491684,
                      constraints: ["[r1+0x4] == 0x0", "[r1] != 0x0", "readable: [(r0 + $base+0x780ac)+0x154]", "ip == NULL || {\"/bin/sh\", ip, NULL} is a valid argv", "[r2] == NULL || r2 == NULL || r2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x10, r2)")
OneGadget::Gadget.add(build_id, 491686,
                      constraints: ["[r1] == 0x0", "readable: [(r0 + $base+0x780ac)+0x154]", "ip == NULL || {\"/bin/sh\", ip, NULL} is a valid argv", "[r8] == NULL || r8 == NULL || r8 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x10, r8)")
OneGadget::Gadget.add(build_id, 491686,
                      constraints: ["[r1+0x4] == 0x0", "[r1] != 0x0", "readable: [(r0 + $base+0x780ac)+0x154]", "ip == NULL || {\"/bin/sh\", ip, NULL} is a valid argv", "[r8] == NULL || r8 == NULL || r8 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x10, r8)")
OneGadget::Gadget.add(build_id, 491698,
                      constraints: ["r3 == 0x0", "readable: r2", "writable: r7", "ip == NULL || {\"/bin/sh\", ip, NULL} is a valid argv", "[r8] == NULL || r8 == NULL || r8 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r7, r8)")
OneGadget::Gadget.add(build_id, 491698,
                      constraints: ["[r1+0x4] == 0x0", "r3 != 0x0", "readable: r2", "writable: r7", "ip == NULL || {\"/bin/sh\", ip, NULL} is a valid argv", "[r8] == NULL || r8 == NULL || r8 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r7, r8)")
OneGadget::Gadget.add(build_id, 491700,
                      constraints: ["r3 == 0x0", "writable: r7", "ip == NULL || {\"/bin/sh\", ip, NULL} is a valid argv", "[r8] == NULL || r8 == NULL || r8 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r7, r8)")
OneGadget::Gadget.add(build_id, 491700,
                      constraints: ["[r1+0x4] == 0x0", "r3 != 0x0", "writable: r7", "ip == NULL || {\"/bin/sh\", ip, NULL} is a valid argv", "[r8] == NULL || r8 == NULL || r8 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r7, r8)")
OneGadget::Gadget.add(build_id, 491702,
                      constraints: ["r3 == 0x0", "writable: r7", "ip == NULL || {\"/bin/sh\", ip, NULL} is a valid argv", "[r8] == NULL || r8 == NULL || r8 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r7, r8)")
OneGadget::Gadget.add(build_id, 491702,
                      constraints: ["[r1+0x4] == 0x0", "r3 != 0x0", "writable: r7", "ip == NULL || {\"/bin/sh\", ip, NULL} is a valid argv", "[r8] == NULL || r8 == NULL || r8 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r7, r8)")
OneGadget::Gadget.add(build_id, 491706,
                      constraints: ["r3 == 0x0", "writable: r7", "ip == NULL || {\"/bin/sh\", ip, NULL} is a valid argv", "[r8] == NULL || r8 == NULL || r8 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r7, r8)")
OneGadget::Gadget.add(build_id, 491706,
                      constraints: ["[r1+0x4] == 0x0", "r3 != 0x0", "writable: r7", "ip == NULL || {\"/bin/sh\", ip, NULL} is a valid argv", "[r8] == NULL || r8 == NULL || r8 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r7, r8)")
OneGadget::Gadget.add(build_id, 491708,
                      constraints: ["[r1+0x4] == 0x0", "writable: r7", "ip == NULL || {\"/bin/sh\", ip, NULL} is a valid argv", "[r8] == NULL || r8 == NULL || r8 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r7, r8)")
OneGadget::Gadget.add(build_id, 491710,
                      constraints: ["[r4+0x4] == 0x0", "writable: r7", "ip == NULL || {\"/bin/sh\", ip, NULL} is a valid argv", "[r8] == NULL || r8 == NULL || r8 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r7, r8)")
OneGadget::Gadget.add(build_id, 491712,
                      constraints: ["[r4+0x4] == 0x0", "r3+0x1 == 0x1", "writable: r7", "ip == NULL || {\"/bin/sh\", ip, NULL} is a valid argv", "[r8] == NULL || r8 == NULL || r8 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r7, r8)")
OneGadget::Gadget.add(build_id, 491716,
                      constraints: ["r3+0x1 == 0x1", "r5 == 0x0", "writable: r7", "ip == NULL || {\"/bin/sh\", ip, NULL} is a valid argv", "[r8] == NULL || r8 == NULL || r8 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r7, r8)")
OneGadget::Gadget.add(build_id, 491718,
                      constraints: ["r3+0x1 == 0x1", "r5 == 0x0", "writable: r7", "ip == NULL || {\"/bin/sh\", ip, NULL} is a valid argv", "[r8] == NULL || r8 == NULL || r8 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r7, r8)")
OneGadget::Gadget.add(build_id, 491720,
                      constraints: ["r3 == 0x1", "r5 == 0x0", "writable: r7", "ip == NULL || {\"/bin/sh\", ip, NULL} is a valid argv", "[r8] == NULL || r8 == NULL || r8 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r7, r8)")
OneGadget::Gadget.add(build_id, 491722,
                      constraints: ["r3 == 0x1", "r5 == 0x0", "writable: r7", "ip == NULL || {\"/bin/sh\", ip, NULL} is a valid argv", "[r8] == NULL || r8 == NULL || r8 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r7, r8)")
OneGadget::Gadget.add(build_id, 491726,
                      constraints: ["r3 == 0x1", "writable: r7", "ip == NULL || {\"/bin/sh\", ip, NULL} is a valid argv", "[r8] == NULL || r8 == NULL || r8 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r7, r8)")
OneGadget::Gadget.add(build_id, 491762,
                      constraints: ["[r4] == NULL || r4 == NULL || r4 is a valid argv", "[r8] == NULL || r8 == NULL || r8 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r4, r8)")
OneGadget::Gadget.add(build_id, 491802,
                      constraints: ["writable: r7", "ip == NULL || {\"/bin/sh\", ip, NULL} is a valid argv", "[r8] == NULL || r8 == NULL || r8 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r7, r8)")
OneGadget::Gadget.add(build_id, 491804,
                      constraints: ["writable: r7", "(r3 + $base+0x78128) == NULL || {(r3 + $base+0x78128), ip, NULL} is a valid argv", "[r8] == NULL || r8 == NULL || r8 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r7, r8)")
OneGadget::Gadget.add(build_id, 491806,
                      constraints: ["writable: r7", "(r3 + $base+0x78128) == NULL || {(r3 + $base+0x78128), ip, r2, [r7+0xc], ...} is a valid argv", "[r8] == NULL || r8 == NULL || r8 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r7, r8)")
OneGadget::Gadget.add(build_id, 491808,
                      constraints: ["writable: r7", "[r4] == NULL || r4 == NULL || r4 is a valid argv", "[r8] == NULL || r8 == NULL || r8 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r4, r8)")
OneGadget::Gadget.add(build_id, 491812,
                      constraints: ["writable: r7", "[r4] == NULL || r4 == NULL || r4 is a valid argv", "[r8] == NULL || r8 == NULL || r8 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r4, r8)")
OneGadget::Gadget.add(build_id, 491814,
                      constraints: ["writable: r7", "[r4] == NULL || r4 == NULL || r4 is a valid argv", "[r8] == NULL || r8 == NULL || r8 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r4, r8)")
OneGadget::Gadget.add(build_id, 491816,
                      constraints: ["writable: r7", "[r4] == NULL || r4 == NULL || r4 is a valid argv", "[r8] == NULL || r8 == NULL || r8 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r4, r8)")
OneGadget::Gadget.add(build_id, 491818,
                      constraints: ["[r4] == NULL || r4 == NULL || r4 is a valid argv", "[r8] == NULL || r8 == NULL || r8 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r4, r8)")
OneGadget::Gadget.add(build_id, 580570,
                      constraints: ["[[sp+0x2c]] == NULL || [sp+0x2c] is a valid argv", "[r3] == NULL || r3 == NULL || r3 is a valid envp", "[sp+0x28] == NULL || writable: [sp+0x28]", "s18 == NULL || (s32)[s18+0x4] <= 0x0"],
                      effect: "posix_spawn([sp+0x28], \"/bin/sh\", s18, 0, [sp+0x2c], r3)")
OneGadget::Gadget.add(build_id, 580572,
                      constraints: ["[r2] == NULL || r2 is a valid argv", "[r3] == NULL || r3 == NULL || r3 is a valid envp", "[sp+0x28] == NULL || writable: [sp+0x28]", "s18 == NULL || (s32)[s18+0x4] <= 0x0"],
                      effect: "posix_spawn([sp+0x28], \"/bin/sh\", s18, 0, r2, r3)")
OneGadget::Gadget.add(build_id, 581486,
                      constraints: ["readable: r3", "[[sp+0x2c]] == NULL || [sp+0x2c] is a valid argv", "[[r3]] == NULL || [r3] == NULL || [r3] is a valid envp", "[sp+0x28] == NULL || writable: [sp+0x28]", "s18 == NULL || (s32)[s18+0x4] <= 0x0"],
                      effect: "posix_spawn([sp+0x28], \"/bin/sh\", s18, 0, [sp+0x2c], [r3])")
OneGadget::Gadget.add(build_id, 581488,
                      constraints: ["[[sp+0x2c]] == NULL || [sp+0x2c] is a valid argv", "[r3] == NULL || r3 == NULL || r3 is a valid envp", "[sp+0x28] == NULL || writable: [sp+0x28]", "s18 == NULL || (s32)[s18+0x4] <= 0x0"],
                      effect: "posix_spawn([sp+0x28], \"/bin/sh\", s18, 0, [sp+0x2c], r3)")

