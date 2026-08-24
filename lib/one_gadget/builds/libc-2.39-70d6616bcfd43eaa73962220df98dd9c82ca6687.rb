require 'one_gadget/gadget'
# http://ports.ubuntu.com/ubuntu-ports/pool/main/g/glibc/libc6_2.39-0ubuntu8.8_armhf.deb
# 
# ARM
# 
# GNU C Library (Ubuntu GLIBC 2.39-0ubuntu8.8) stable release version 2.39.
# Copyright (C) 2024 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 13.3.0.
# libc ABIs: UNIQUE ABSOLUTE
# Minimum supported kernel: 3.2.0
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 233258,
                      constraints: ["r6 is the GOT address of libc", "readable: r7", "readable: r9", "writable: r0", "writable: r8", "{\"sh\", \"-c\", \"--\", r5, ...} is a valid argv", "(u16)[r8] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, r8, sp+0x2c, environ)")
OneGadget::Gadget.add(build_id, 233262,
                      constraints: ["r6 is the GOT address of libc", "readable: r7", "readable: r9", "writable: r8", "{\"sh\", \"-c\", \"--\", r5, ...} is a valid argv", "(u16)[r8] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, r8, sp+0x2c, environ)")
OneGadget::Gadget.add(build_id, 233264,
                      constraints: ["r6 is the GOT address of libc", "readable: r1", "readable: r9", "writable: r8", "{\"sh\", \"-c\", \"--\", r5, ...} is a valid argv", "(u16)[r8] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, r8, sp+0x2c, environ)")
OneGadget::Gadget.add(build_id, 233266,
                      constraints: ["r6 is the GOT address of libc", "readable: r1", "readable: r9", "writable: r0", "writable: r8", "{\"sh\", \"-c\", \"--\", r5, ...} is a valid argv", "(u16)[r8] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, r8, sp+0x2c, environ)")
OneGadget::Gadget.add(build_id, 233270,
                      constraints: ["r6 is the GOT address of libc", "readable: r9", "writable: r8", "{\"sh\", \"-c\", \"--\", r5, ...} is a valid argv", "(u16)[r8] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, r8, sp+0x2c, environ)")
OneGadget::Gadget.add(build_id, 233272,
                      constraints: ["r6 is the GOT address of libc", "readable: r1", "writable: r8", "{\"sh\", \"-c\", \"--\", r5, ...} is a valid argv", "(u16)[r8] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, r8, sp+0x2c, environ)")
OneGadget::Gadget.add(build_id, 233274,
                      constraints: ["r6 is the GOT address of libc", "readable: r1", "writable: r0", "writable: r8", "{\"sh\", \"-c\", \"--\", r5, ...} is a valid argv", "(u16)[r8] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, r8, sp+0x2c, environ)")
OneGadget::Gadget.add(build_id, 233278,
                      constraints: ["r6 is the GOT address of libc", "writable: r8", "{\"sh\", \"-c\", \"--\", r5, ...} is a valid argv", "(u16)[r8] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, r8, sp+0x2c, environ)")
OneGadget::Gadget.add(build_id, 233280,
                      constraints: ["r6 is the GOT address of libc", "writable: r8", "{\"sh\", \"-c\", \"--\", r5, ...} is a valid argv", "(u16)[r8] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, r8, sp+0x2c, environ)")
OneGadget::Gadget.add(build_id, 233282,
                      constraints: ["r6 is the GOT address of libc", "writable: r0", "{\"sh\", \"-c\", \"--\", r5, ...} is a valid argv", "r8 == NULL || (u16)[r8] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, r8, sp+0x2c, environ)")
OneGadget::Gadget.add(build_id, 233286,
                      constraints: ["r6 is the GOT address of libc", "{\"sh\", \"-c\", \"--\", r5, ...} is a valid argv", "r8 == NULL || (u16)[r8] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, r8, sp+0x2c, environ)")
OneGadget::Gadget.add(build_id, 233288,
                      constraints: ["r6 is the GOT address of libc", "(r2 + $base+0x38f50) == NULL || {(r2 + $base+0x38f50), \"-c\", \"--\", r5, ...} is a valid argv", "r8 == NULL || (u16)[r8] == 0x0"],
                      effect: "posix_spawn(sp+0xc, \"/bin/sh\", 0, r8, sp+0x2c, environ)")
OneGadget::Gadget.add(build_id, 233320,
                      constraints: ["readable: r1", "[r3] == NULL || r3 is a valid argv", "[[r1]] == NULL || [r1] == NULL || [r1] is a valid envp", "r0 == NULL || writable: r0", "r2 == NULL || (s32)[r2+0x4] <= 0x0", "r8 == NULL || (u16)[r8] == 0x0"],
                      effect: "posix_spawn(r0, \"/bin/sh\", r2, r8, r3, [r1])")
OneGadget::Gadget.add(build_id, 233322,
                      constraints: ["readable: r1", "[[sp]] == NULL || [sp] is a valid argv", "[[r1]] == NULL || [r1] == NULL || [r1] is a valid envp", "r0 == NULL || writable: r0", "r2 == NULL || (s32)[r2+0x4] <= 0x0", "r8 == NULL || (u16)[r8] == 0x0"],
                      effect: "posix_spawn(r0, \"/bin/sh\", r2, r8, [sp], [r1])")
OneGadget::Gadget.add(build_id, 233324,
                      constraints: ["[[sp]] == NULL || [sp] is a valid argv", "[r3] == NULL || r3 == NULL || r3 is a valid envp", "r0 == NULL || writable: r0", "r2 == NULL || (s32)[r2+0x4] <= 0x0", "r8 == NULL || (u16)[r8] == 0x0"],
                      effect: "posix_spawn(r0, \"/bin/sh\", r2, r8, [sp], r3)")
OneGadget::Gadget.add(build_id, 328840,
                      constraints: ["fp is the GOT address of libc", "[$base+0x110528] == 0x0", "[$base+0x11052c] == 0x0", "r2 != 0x0", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 328840,
                      constraints: ["fp is the GOT address of libc", "[$base+0x11052c] == 0x0", "r2 == 0x0", "r7 == [$base+0x110528]", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 328840,
                      constraints: ["fp is the GOT address of libc", "[$base+0x110528] != 0x0", "[$base+0x11052c] == 0x0", "r2 != 0x0", "r7 == [$base+0x110528]", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 328844,
                      constraints: ["fp is the GOT address of libc", "[$base+0x11052c] == 0x0", "r7 == [$base+0x110528]", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 328844,
                      constraints: ["fp is the GOT address of libc", "[[$base+0x11052c]+0xa4] == 0x0", "r6 == [[$base+0x11052c]+0x38]", "r7 == [$base+0x110528]", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 328846,
                      constraints: ["fp is the GOT address of libc", "[$base+0x11052c] == 0x0", "r7 == [(r2 + $base+0x50492)+0x8]", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 328846,
                      constraints: ["fp is the GOT address of libc", "[[$base+0x11052c]+0xa4] == 0x0", "r6 == [[$base+0x11052c]+0x38]", "r7 == [(r2 + $base+0x50492)+0x8]", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 328848,
                      constraints: ["fp is the GOT address of libc", "[$base+0x11052c] == 0x0", "r7 == [r2+0x8]", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 328848,
                      constraints: ["fp is the GOT address of libc", "[[$base+0x11052c]+0xa4] == 0x0", "r6 == [[$base+0x11052c]+0x38]", "r7 == [r2+0x8]", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 328850,
                      constraints: ["fp is the GOT address of libc", "[$base+0x11052c] == 0x0", "r7 == r2", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 328850,
                      constraints: ["fp is the GOT address of libc", "[[$base+0x11052c]+0xa4] == 0x0", "r6 == [[$base+0x11052c]+0x38]", "r7 == r2", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 328874,
                      constraints: ["fp is the GOT address of libc", "[$base+0x11052c] == 0x0", "r3 == 0x0", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 328886,
                      constraints: ["fp is the GOT address of libc", "[$base+0x11052c] == 0x0", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 328886,
                      constraints: ["fp is the GOT address of libc", "[[$base+0x11052c]+0xa4] == 0x0", "r6 == [[$base+0x11052c]+0x38]", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 328888,
                      constraints: ["fp is the GOT address of libc", "[$base+0x11052c] == 0x0", "writable: (r2 + $base+0x504bc)+0x8", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 328888,
                      constraints: ["fp is the GOT address of libc", "[[$base+0x11052c]+0xa4] == 0x0", "r6 == [[$base+0x11052c]+0x38]", "writable: (r2 + $base+0x504bc)+0x8", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 328890,
                      constraints: ["fp is the GOT address of libc", "[$base+0x11052c] == 0x0", "writable: r2+0x8", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 328890,
                      constraints: ["fp is the GOT address of libc", "[[$base+0x11052c]+0xa4] == 0x0", "r6 == [[$base+0x11052c]+0x38]", "writable: r2+0x8", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 328892,
                      constraints: ["fp is the GOT address of libc", "[$base+0x11052c] == 0x0", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 328892,
                      constraints: ["fp is the GOT address of libc", "[[$base+0x11052c]+0xa4] == 0x0", "r6 == [[$base+0x11052c]+0x38]", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 328894,
                      constraints: ["fp is the GOT address of libc", "[(r2 + $base+0x504c2)+0xc] == 0x0", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 328894,
                      constraints: ["fp is the GOT address of libc", "[[(r2 + $base+0x504c2)+0xc]+0xa4] == 0x0", "r6 == [[(r2 + $base+0x504c2)+0xc]+0x38]", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 328896,
                      constraints: ["fp is the GOT address of libc", "[r2+0xc] == 0x0", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 328896,
                      constraints: ["fp is the GOT address of libc", "[[r2+0xc]+0xa4] == 0x0", "r6 == [[r2+0xc]+0x38]", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 328898,
                      constraints: ["fp is the GOT address of libc", "r7 == 0x0", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 328898,
                      constraints: ["fp is the GOT address of libc", "[r7+0xa4] == 0x0", "r6 == [r7+0x38]", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 328900,
                      constraints: ["fp is the GOT address of libc", "[r7+0xa4] == 0x0", "r6 == [r7+0x38]", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 328902,
                      constraints: ["fp is the GOT address of libc", "[r7+0xa4] == 0x0", "r6 == r1", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 328912,
                      constraints: ["fp is the GOT address of libc", "[r7+0xa4] == 0x0", "r0 == 0x0", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 328918,
                      constraints: ["fp is the GOT address of libc", "[r7+0xa4] == 0x0", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 328922,
                      constraints: ["fp is the GOT address of libc", "r7 == 0x0", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 328926,
                      constraints: ["fp is the GOT address of libc", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 328928,
                      constraints: ["fp is the GOT address of libc", "(r1 + $base+0x504ec) == NULL || {(r1 + $base+0x504ec), \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 328930,
                      constraints: ["fp is the GOT address of libc", "(r1 + $base+0x504ec) == NULL || {(r1 + $base+0x504ec), \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0", "r3 == NULL || (u16)[r3] == 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, r3, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 329090,
                      constraints: ["fp is the GOT address of libc", "[$base+0x110528] == 0x0", "[$base+0x11052c] == 0x0", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 329090,
                      constraints: ["fp is the GOT address of libc", "[$base+0x110528] == 0x0", "[[$base+0x11052c]+0xa4] == 0x0", "r6 == [[$base+0x11052c]+0x38]", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 329090,
                      constraints: ["fp is the GOT address of libc", "[$base+0x110528] != 0x0", "[$base+0x11052c] == 0x0", "r7 == [$base+0x110528]", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 329092,
                      constraints: ["fp is the GOT address of libc", "[$base+0x11052c] == 0x0", "[(r1 + $base+0x50588)+0x8] == 0x0", "writable: (r1 + $base+0x50588)", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 329092,
                      constraints: ["fp is the GOT address of libc", "[$base+0x11052c] == 0x0", "[(r1 + $base+0x50588)+0x8] != 0x0", "r7 == [(r1 + $base+0x50588)+0x8]", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 329092,
                      constraints: ["fp is the GOT address of libc", "[(r1 + $base+0x50588)+0x8] == 0x0", "[[$base+0x11052c]+0xa4] == 0x0", "r6 == [[$base+0x11052c]+0x38]", "writable: (r1 + $base+0x50588)", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 329094,
                      constraints: ["fp is the GOT address of libc", "[$base+0x11052c] == 0x0", "[r1+0x8] == 0x0", "writable: r1", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 329094,
                      constraints: ["fp is the GOT address of libc", "[$base+0x11052c] == 0x0", "[r1+0x8] != 0x0", "r7 == [r1+0x8]", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 329094,
                      constraints: ["fp is the GOT address of libc", "[[$base+0x11052c]+0xa4] == 0x0", "[r1+0x8] == 0x0", "r6 == [[$base+0x11052c]+0x38]", "writable: r1", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 329096,
                      constraints: ["fp is the GOT address of libc", "[$base+0x11052c] == 0x0", "r2 == 0x0", "writable: r1", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 329096,
                      constraints: ["fp is the GOT address of libc", "[$base+0x11052c] == 0x0", "r2 != 0x0", "r7 == r2", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 329096,
                      constraints: ["fp is the GOT address of libc", "[[$base+0x11052c]+0xa4] == 0x0", "r2 == 0x0", "r6 == [[$base+0x11052c]+0x38]", "writable: r1", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 329100,
                      constraints: ["fp is the GOT address of libc", "[$base+0x11052c] == 0x0", "writable: r1", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 329100,
                      constraints: ["fp is the GOT address of libc", "[[$base+0x11052c]+0xa4] == 0x0", "r6 == [[$base+0x11052c]+0x38]", "writable: r1", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 329102,
                      constraints: ["fp is the GOT address of libc", "[$base+0x11052c] == 0x0", "writable: r1", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 329102,
                      constraints: ["fp is the GOT address of libc", "[[$base+0x11052c]+0xa4] == 0x0", "r6 == [[$base+0x11052c]+0x38]", "writable: r1", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 329104,
                      constraints: ["fp is the GOT address of libc", "[$base+0x11052c] == 0x0", "writable: r1", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 329104,
                      constraints: ["fp is the GOT address of libc", "[[$base+0x11052c]+0xa4] == 0x0", "r6 == [[$base+0x11052c]+0x38]", "writable: r1", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 329106,
                      constraints: ["fp is the GOT address of libc", "[$base+0x11052c] == 0x0", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 329106,
                      constraints: ["fp is the GOT address of libc", "[[$base+0x11052c]+0xa4] == 0x0", "r6 == [[$base+0x11052c]+0x38]", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 329240,
                      constraints: ["fp is the GOT address of libc", "[$base+0x11052c] == 0x0", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 329240,
                      constraints: ["fp is the GOT address of libc", "[[$base+0x11052c]+0xa4] == 0x0", "r6 == [[$base+0x11052c]+0x38]", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 329242,
                      constraints: ["fp is the GOT address of libc", "[$base+0x11052c] == 0x0", "writable: (r1 + $base+0x5061e)+0x4", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 329242,
                      constraints: ["fp is the GOT address of libc", "[[$base+0x11052c]+0xa4] == 0x0", "r6 == [[$base+0x11052c]+0x38]", "writable: (r1 + $base+0x5061e)+0x4", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 329244,
                      constraints: ["fp is the GOT address of libc", "[$base+0x11052c] == 0x0", "writable: r1+0x4", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 329244,
                      constraints: ["fp is the GOT address of libc", "[[$base+0x11052c]+0xa4] == 0x0", "r6 == [[$base+0x11052c]+0x38]", "writable: r1+0x4", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 329246,
                      constraints: ["fp is the GOT address of libc", "[$base+0x11052c] == 0x0", "writable: r1+0x4", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 329246,
                      constraints: ["fp is the GOT address of libc", "[[$base+0x11052c]+0xa4] == 0x0", "r6 == [[$base+0x11052c]+0x38]", "writable: r1+0x4", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 329248,
                      constraints: ["fp is the GOT address of libc", "[$base+0x11052c] == 0x0", "writable: r1+0x4", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 329248,
                      constraints: ["fp is the GOT address of libc", "[[$base+0x11052c]+0xa4] == 0x0", "r6 == [[$base+0x11052c]+0x38]", "writable: r1+0x4", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 329250,
                      constraints: ["fp is the GOT address of libc", "[$base+0x11052c] == 0x0", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 329250,
                      constraints: ["fp is the GOT address of libc", "[[$base+0x11052c]+0xa4] == 0x0", "r6 == [[$base+0x11052c]+0x38]", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 329270,
                      constraints: ["fp is the GOT address of libc", "[$base+0x11052c] == 0x0", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 329270,
                      constraints: ["fp is the GOT address of libc", "[[$base+0x11052c]+0xa4] == 0x0", "r6 == [[$base+0x11052c]+0x38]", "{\"sh\", \"-c\", \"--\", r8, ...} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r9 == NULL || (s32)[r9+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r9, 0, sp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 559752,
                      constraints: ["[r4] == NULL || r4 == NULL || r4 is a valid argv", "[r5] == NULL || r5 == NULL || r5 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r4, r5)")
OneGadget::Gadget.add(build_id, 559804,
                      constraints: ["[r4] == NULL || r4 == NULL || r4 is a valid argv", "[r5] == NULL || r5 == NULL || r5 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r4, r5)")
OneGadget::Gadget.add(build_id, 651098,
                      constraints: ["[[sp+0x3c]] == NULL || [sp+0x3c] is a valid argv", "[r3] == NULL || r3 == NULL || r3 is a valid envp", "[sp+0x34] == NULL || writable: [sp+0x34]", "[sp+0x2c] == NULL || (s32)[[sp+0x2c]+0x4] <= 0x0"],
                      effect: "posix_spawn([sp+0x34], \"/bin/sh\", [sp+0x2c], 0, [sp+0x3c], r3)")
OneGadget::Gadget.add(build_id, 652028,
                      constraints: ["readable: r3", "[[sp+0x3c]] == NULL || [sp+0x3c] is a valid argv", "[[r3]] == NULL || [r3] == NULL || [r3] is a valid envp", "[sp+0x34] == NULL || writable: [sp+0x34]", "[sp+0x2c] == NULL || (s32)[[sp+0x2c]+0x4] <= 0x0"],
                      effect: "posix_spawn([sp+0x34], \"/bin/sh\", [sp+0x2c], 0, [sp+0x3c], [r3])")
OneGadget::Gadget.add(build_id, 652030,
                      constraints: ["[[sp+0x3c]] == NULL || [sp+0x3c] is a valid argv", "[r3] == NULL || r3 == NULL || r3 is a valid envp", "[sp+0x34] == NULL || writable: [sp+0x34]", "[sp+0x2c] == NULL || (s32)[[sp+0x2c]+0x4] <= 0x0"],
                      effect: "posix_spawn([sp+0x34], \"/bin/sh\", [sp+0x2c], 0, [sp+0x3c], r3)")

