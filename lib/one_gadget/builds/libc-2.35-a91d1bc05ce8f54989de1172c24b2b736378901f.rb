require 'one_gadget/gadget'
# http://ports.ubuntu.com/ubuntu-ports/pool/main/g/glibc/libc6_2.35-0ubuntu3.14_armhf.deb
# 
# ARM
# 
# GNU C Library (Ubuntu GLIBC 2.35-0ubuntu3.14) stable release version 2.35.
# Copyright (C) 2022 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 11.4.0.
# libc ABIs: UNIQUE ABSOLUTE
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 217450,
                      constraints: ["r9 is the GOT address of libc", "readable: r7", "readable: sl", "writable: r0", "writable: r8", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5 == NULL || writable: r5", "(u16)[r8] == 0x0"],
                      effect: "posix_spawn(r5, \"/bin/sh\", 0, r8, sp+0x30, environ)")
OneGadget::Gadget.add(build_id, 217454,
                      constraints: ["r9 is the GOT address of libc", "readable: r7", "readable: sl", "writable: r8", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5 == NULL || writable: r5", "(u16)[r8] == 0x0"],
                      effect: "posix_spawn(r5, \"/bin/sh\", 0, r8, sp+0x30, environ)")
OneGadget::Gadget.add(build_id, 217456,
                      constraints: ["r9 is the GOT address of libc", "readable: r1", "readable: sl", "writable: r8", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5 == NULL || writable: r5", "(u16)[r8] == 0x0"],
                      effect: "posix_spawn(r5, \"/bin/sh\", 0, r8, sp+0x30, environ)")
OneGadget::Gadget.add(build_id, 217458,
                      constraints: ["r9 is the GOT address of libc", "readable: r1", "readable: sl", "writable: r0", "writable: r8", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5 == NULL || writable: r5", "(u16)[r8] == 0x0"],
                      effect: "posix_spawn(r5, \"/bin/sh\", 0, r8, sp+0x30, environ)")
OneGadget::Gadget.add(build_id, 217462,
                      constraints: ["r9 is the GOT address of libc", "readable: sl", "writable: r8", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5 == NULL || writable: r5", "(u16)[r8] == 0x0"],
                      effect: "posix_spawn(r5, \"/bin/sh\", 0, r8, sp+0x30, environ)")
OneGadget::Gadget.add(build_id, 217464,
                      constraints: ["r9 is the GOT address of libc", "readable: r1", "writable: r8", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5 == NULL || writable: r5", "(u16)[r8] == 0x0"],
                      effect: "posix_spawn(r5, \"/bin/sh\", 0, r8, sp+0x30, environ)")
OneGadget::Gadget.add(build_id, 217466,
                      constraints: ["r9 is the GOT address of libc", "readable: r1", "writable: r0", "writable: r8", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5 == NULL || writable: r5", "(u16)[r8] == 0x0"],
                      effect: "posix_spawn(r5, \"/bin/sh\", 0, r8, sp+0x30, environ)")
OneGadget::Gadget.add(build_id, 217470,
                      constraints: ["r9 is the GOT address of libc", "writable: r8", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5 == NULL || writable: r5", "(u16)[r8] == 0x0"],
                      effect: "posix_spawn(r5, \"/bin/sh\", 0, r8, sp+0x30, environ)")
OneGadget::Gadget.add(build_id, 217472,
                      constraints: ["r9 is the GOT address of libc", "writable: r8", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5 == NULL || writable: r5", "(u16)[r8] == 0x0"],
                      effect: "posix_spawn(r5, \"/bin/sh\", 0, r8, sp+0x30, environ)")
OneGadget::Gadget.add(build_id, 217474,
                      constraints: ["r9 is the GOT address of libc", "writable: r0", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5 == NULL || writable: r5", "r8 == NULL || (u16)[r8] == 0x0"],
                      effect: "posix_spawn(r5, \"/bin/sh\", 0, r8, sp+0x30, environ)")
OneGadget::Gadget.add(build_id, 217478,
                      constraints: ["r9 is the GOT address of libc", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5 == NULL || writable: r5", "r8 == NULL || (u16)[r8] == 0x0"],
                      effect: "posix_spawn(r5, \"/bin/sh\", 0, r8, sp+0x30, environ)")
OneGadget::Gadget.add(build_id, 217480,
                      constraints: ["r9 is the GOT address of libc", "(r2 + $base+0x35190) == NULL || {(r2 + $base+0x35190), \"-c\", r6, NULL} is a valid argv", "r5 == NULL || writable: r5", "r8 == NULL || (u16)[r8] == 0x0"],
                      effect: "posix_spawn(r5, \"/bin/sh\", 0, r8, sp+0x30, environ)")
OneGadget::Gadget.add(build_id, 217506,
                      constraints: ["readable: r1", "[r3] == NULL || r3 is a valid argv", "[[r1]] == NULL || [r1] == NULL || [r1] is a valid envp", "r0 == NULL || writable: r0", "r2 == NULL || (s32)[r2+0x4] <= 0x0", "r8 == NULL || (u16)[r8] == 0x0"],
                      effect: "posix_spawn(r0, \"/bin/sh\", r2, r8, r3, [r1])")
OneGadget::Gadget.add(build_id, 217508,
                      constraints: ["readable: r1", "[[sp]] == NULL || [sp] is a valid argv", "[[r1]] == NULL || [r1] == NULL || [r1] is a valid envp", "r0 == NULL || writable: r0", "r2 == NULL || (s32)[r2+0x4] <= 0x0", "r8 == NULL || (u16)[r8] == 0x0"],
                      effect: "posix_spawn(r0, \"/bin/sh\", r2, r8, [sp], [r1])")
OneGadget::Gadget.add(build_id, 217510,
                      constraints: ["[[sp]] == NULL || [sp] is a valid argv", "[r3] == NULL || r3 == NULL || r3 is a valid envp", "r0 == NULL || writable: r0", "r2 == NULL || (s32)[r2+0x4] <= 0x0", "r8 == NULL || (u16)[r8] == 0x0"],
                      effect: "posix_spawn(r0, \"/bin/sh\", r2, r8, [sp], r3)")
OneGadget::Gadget.add(build_id, 322958,
                      constraints: ["r7 is the GOT address of libc", "[$base+0x11f778] == 0x0", "[(r2 + $base+0x4ed94)+0xc] == r3-0x580", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 322958,
                      constraints: ["r7 is the GOT address of libc", "[(r2 + $base+0x4ed94)+0xc] == r3-0x580", "[[$base+0x11f778]+0xa4] == 0x0", "sl == [[$base+0x11f778]+0x38]", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 322960,
                      constraints: ["r7 is the GOT address of libc", "[$base+0x11f778] == 0x0", "[(r2 + $base+0x4ed94)+0xc] == r3-0x580", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 322960,
                      constraints: ["r7 is the GOT address of libc", "[(r2 + $base+0x4ed94)+0xc] == r3-0x580", "[[$base+0x11f778]+0xa4] == 0x0", "sl == [[$base+0x11f778]+0x38]", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 322962,
                      constraints: ["r7 is the GOT address of libc", "[$base+0x11f778] == 0x0", "[r2+0xc] == r3-0x580", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 322962,
                      constraints: ["r7 is the GOT address of libc", "[[$base+0x11f778]+0xa4] == 0x0", "[r2+0xc] == r3-0x580", "sl == [[$base+0x11f778]+0x38]", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 322966,
                      constraints: ["r7 is the GOT address of libc", "[$base+0x11f778] == 0x0", "[r2+0xc] == r1", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 322966,
                      constraints: ["r7 is the GOT address of libc", "[[$base+0x11f778]+0xa4] == 0x0", "[r2+0xc] == r1", "sl == [[$base+0x11f778]+0x38]", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 322968,
                      constraints: ["r7 is the GOT address of libc", "[$base+0x11f778] == 0x0", "r0 == r1", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 322968,
                      constraints: ["r7 is the GOT address of libc", "[[$base+0x11f778]+0xa4] == 0x0", "r0 == r1", "sl == [[$base+0x11f778]+0x38]", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 322990,
                      constraints: ["r7 is the GOT address of libc", "[$base+0x11f778] == 0x0", "r3 == 0x0", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 323002,
                      constraints: ["r7 is the GOT address of libc", "[$base+0x11f778] == 0x0", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 323002,
                      constraints: ["r7 is the GOT address of libc", "[[$base+0x11f778]+0xa4] == 0x0", "sl == [[$base+0x11f778]+0x38]", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 323004,
                      constraints: ["r7 is the GOT address of libc", "[$base+0x11f778] == 0x0", "writable: (r2 + $base+0x4edc0)+0xc", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 323004,
                      constraints: ["r7 is the GOT address of libc", "[[$base+0x11f778]+0xa4] == 0x0", "sl == [[$base+0x11f778]+0x38]", "writable: (r2 + $base+0x4edc0)+0xc", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 323006,
                      constraints: ["r7 is the GOT address of libc", "[$base+0x11f778] == 0x0", "writable: r2+0xc", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 323006,
                      constraints: ["r7 is the GOT address of libc", "[[$base+0x11f778]+0xa4] == 0x0", "sl == [[$base+0x11f778]+0x38]", "writable: r2+0xc", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 323008,
                      constraints: ["r7 is the GOT address of libc", "[$base+0x11f778] == 0x0", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 323008,
                      constraints: ["r7 is the GOT address of libc", "[[$base+0x11f778]+0xa4] == 0x0", "sl == [[$base+0x11f778]+0x38]", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 323010,
                      constraints: ["r7 is the GOT address of libc", "[(r1 + $base+0x4edc6)] == 0x0", "writable: (r1 + $base+0x4edc6)+0x8", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 323010,
                      constraints: ["r7 is the GOT address of libc", "[[(r1 + $base+0x4edc6)]+0xa4] == 0x0", "sl == [[(r1 + $base+0x4edc6)]+0x38]", "writable: (r1 + $base+0x4edc6)+0x8", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 323012,
                      constraints: ["r7 is the GOT address of libc", "[r1] == 0x0", "writable: r1+0x8", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 323012,
                      constraints: ["r7 is the GOT address of libc", "[[r1]+0xa4] == 0x0", "sl == [[r1]+0x38]", "writable: r1+0x8", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 323014,
                      constraints: ["r7 is the GOT address of libc", "[r1] == 0x0", "writable: r1+0x8", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 323014,
                      constraints: ["r7 is the GOT address of libc", "[[r1]+0xa4] == 0x0", "sl == [[r1]+0x38]", "writable: r1+0x8", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 323018,
                      constraints: ["r7 is the GOT address of libc", "r9 == 0x0", "writable: r1+0x8", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 323018,
                      constraints: ["r7 is the GOT address of libc", "[r9+0xa4] == 0x0", "sl == [r9+0x38]", "writable: r1+0x8", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 323020,
                      constraints: ["r7 is the GOT address of libc", "r9 == 0x0", "writable: r1+0x8", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 323020,
                      constraints: ["r7 is the GOT address of libc", "[r9+0xa4] == 0x0", "sl == [r9+0x38]", "writable: r1+0x8", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 323022,
                      constraints: ["r7 is the GOT address of libc", "r9 == 0x0", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 323022,
                      constraints: ["r7 is the GOT address of libc", "[r9+0xa4] == 0x0", "sl == [r9+0x38]", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 323028,
                      constraints: ["r7 is the GOT address of libc", "[r9+0xa4] == 0x0", "sl == [r9+0x38]", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 323030,
                      constraints: ["r7 is the GOT address of libc", "[r9+0xa4] == 0x0", "sl == [r9+0x38]", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 323032,
                      constraints: ["r7 is the GOT address of libc", "[r4+0xa4] == 0x0", "sl == [r4+0x38]", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 323034,
                      constraints: ["r7 is the GOT address of libc", "[r4+0xa4] == 0x0", "sl == [r4+0x38]", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 323036,
                      constraints: ["r7 is the GOT address of libc", "[r4+0xa4] == 0x0", "sl == r1", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 323046,
                      constraints: ["r7 is the GOT address of libc", "[r4+0xa4] == 0x0", "r0 == 0x0", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 323050,
                      constraints: ["r7 is the GOT address of libc", "[r4+0xa4] == 0x0", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 323054,
                      constraints: ["r7 is the GOT address of libc", "r4 == 0x0", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 323058,
                      constraints: ["r7 is the GOT address of libc", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 323060,
                      constraints: ["r7 is the GOT address of libc", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 323062,
                      constraints: ["r7 is the GOT address of libc", "(r3 + $base+0x4ee00) == NULL || {(r3 + $base+0x4ee00), \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 323066,
                      constraints: ["r7 is the GOT address of libc", "(r3 + $base+0x4ee00) == NULL || {(r3 + $base+0x4ee00), \"-c\", r6, NULL} is a valid argv", "r0 == NULL || writable: r0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 323086,
                      constraints: ["readable: r2", "[sp+0x38] == NULL || {[sp+0x38], [sp+0x3c], [sp+0x40], [sp+0x44], ...} is a valid argv", "[[r2]] == NULL || [r2] == NULL || [r2] is a valid envp", "r0 == NULL || writable: r0", "r8 == NULL || (s32)[r8+0x4] <= 0x0", "r3 == NULL || (u16)[r3] == 0x0"],
                      effect: "posix_spawn(r0, \"/bin/sh\", r8, r3, sp+0x38, [r2])")
OneGadget::Gadget.add(build_id, 323364,
                      constraints: ["r7 is the GOT address of libc", "[$base+0x11f778] == 0x0", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 323364,
                      constraints: ["r7 is the GOT address of libc", "[[$base+0x11f778]+0xa4] == 0x0", "sl == [[$base+0x11f778]+0x38]", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 323366,
                      constraints: ["r7 is the GOT address of libc", "[$base+0x11f778] == 0x0", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 323366,
                      constraints: ["r7 is the GOT address of libc", "[[$base+0x11f778]+0xa4] == 0x0", "sl == [[$base+0x11f778]+0x38]", "{\"sh\", \"-c\", r6, NULL} is a valid argv", "r5+0xa0 == NULL || writable: r5+0xa0", "r8 == NULL || (s32)[r8+0x4] <= 0x0"],
                      effect: "posix_spawn(r5+0xa0, \"/bin/sh\", r8, 0, sp+0x38, environ)")
OneGadget::Gadget.add(build_id, 559174,
                      constraints: ["[r4] == NULL || r4 == NULL || r4 is a valid argv", "[r6] == NULL || r6 == NULL || r6 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r4, r6)")
OneGadget::Gadget.add(build_id, 559226,
                      constraints: ["[r4] == NULL || r4 == NULL || r4 is a valid argv", "[r6] == NULL || r6 == NULL || r6 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r4, r6)")
OneGadget::Gadget.add(build_id, 646716,
                      constraints: ["[[sp+0x2c]] == NULL || [sp+0x2c] is a valid argv", "[r3] == NULL || r3 == NULL || r3 is a valid envp", "[sp+0x28] == NULL || writable: [sp+0x28]", "s18 == NULL || (s32)[s18+0x4] <= 0x0"],
                      effect: "posix_spawn([sp+0x28], \"/bin/sh\", s18, 0, [sp+0x2c], r3)")
OneGadget::Gadget.add(build_id, 647604,
                      constraints: ["readable: r3", "[[sp+0x2c]] == NULL || [sp+0x2c] is a valid argv", "[[r3]] == NULL || [r3] == NULL || [r3] is a valid envp", "[sp+0x28] == NULL || writable: [sp+0x28]", "s18 == NULL || (s32)[s18+0x4] <= 0x0"],
                      effect: "posix_spawn([sp+0x28], \"/bin/sh\", s18, 0, [sp+0x2c], [r3])")
OneGadget::Gadget.add(build_id, 647606,
                      constraints: ["[[sp+0x2c]] == NULL || [sp+0x2c] is a valid argv", "[r3] == NULL || r3 == NULL || r3 is a valid envp", "[sp+0x28] == NULL || writable: [sp+0x28]", "s18 == NULL || (s32)[s18+0x4] <= 0x0"],
                      effect: "posix_spawn([sp+0x28], \"/bin/sh\", s18, 0, [sp+0x2c], r3)")

