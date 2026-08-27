require 'one_gadget/gadget'
# http://ports.ubuntu.com/ubuntu-ports/pool/main/g/glibc/libc6_2.35-0ubuntu3.14_arm64.deb
# 
# ARM 64-bit architecture
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
OneGadget::Gadget.add(build_id, 289972,
                      constraints: ["readable: x21", "x0 != 0x1", "{\"sh\", \"-c\", x22, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 289972,
                      constraints: ["readable: x21", "x0 == 0x1", "{\"sh\", \"-c\", x22, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 289976,
                      constraints: ["readable: x21", "x0 != 0x1", "{\"sh\", \"-c\", x22, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 289976,
                      constraints: ["readable: x21", "x0 == 0x1", "{\"sh\", \"-c\", x22, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 289980,
                      constraints: ["readable: x21", "x0 != 0x1", "{\"sh\", \"-c\", x22, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 289980,
                      constraints: ["readable: x21", "x0 == 0x1", "{\"sh\", \"-c\", x22, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 289988,
                      constraints: ["readable: x21", "{\"sh\", \"-c\", x22, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 289992,
                      constraints: ["readable: x21", "{\"sh\", \"-c\", x22, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 289996,
                      constraints: ["readable: x21", "{\"sh\", \"-c\", x22, NULL} is a valid argv", "sp+0x1f8 == NULL || (u16)[sp+0x1f8] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, sp+0x1f8, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 290000,
                      constraints: ["readable: x21", "writable: x20", "{\"sh\", \"-c\", x22, NULL} is a valid argv", "(u16)[x20] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, x20, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 290004,
                      constraints: ["readable: x21", "writable: x0", "writable: x20", "{\"sh\", \"-c\", x22, NULL} is a valid argv", "(u16)[x20] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, x20, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 290008,
                      constraints: ["readable: x21", "writable: x20", "{\"sh\", \"-c\", x22, NULL} is a valid argv", "(u16)[x20] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, x20, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 290012,
                      constraints: ["readable: x1", "writable: x20", "{\"sh\", \"-c\", x22, NULL} is a valid argv", "(u16)[x20] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, x20, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 290016,
                      constraints: ["readable: x1", "writable: x0", "writable: x20", "{\"sh\", \"-c\", x22, NULL} is a valid argv", "(u16)[x20] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, x20, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 290020,
                      constraints: ["writable: x20", "{\"sh\", \"-c\", x22, NULL} is a valid argv", "(u16)[x20] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, x20, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 290024,
                      constraints: ["writable: x0", "writable: x20", "{\"sh\", \"-c\", x22, NULL} is a valid argv", "(u16)[x20] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, x20, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 290028,
                      constraints: ["readable: x1", "writable: x0", "writable: x20", "{\"sh\", \"-c\", x22, NULL} is a valid argv", "(u16)[x20] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, x20, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 290032,
                      constraints: ["writable: x20", "{\"sh\", \"-c\", x22, NULL} is a valid argv", "(u16)[x20] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, x20, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 290036,
                      constraints: ["writable: x0", "{\"sh\", \"-c\", x22, NULL} is a valid argv", "x20 == NULL || (u16)[x20] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, x20, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 290040,
                      constraints: ["writable: x0", "{\"sh\", \"-c\", x22, NULL} is a valid argv", "x20 == NULL || (u16)[x20] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, x20, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 290044,
                      constraints: ["{\"sh\", \"-c\", x22, NULL} is a valid argv", "x20 == NULL || (u16)[x20] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, x20, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 290048,
                      constraints: ["{\"sh\", \"-c\", [sp+0x50], [sp+0x58], ...} is a valid argv", "x20 == NULL || (u16)[x20] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, x20, sp+0x40, environ)")
OneGadget::Gadget.add(build_id, 290064,
                      constraints: ["readable: x0", "x7+0xd10 == NULL || {x7+0xd10, x6+0xd18, [sp+0x50], [sp+0x58], ...} is a valid argv", "[[x0]] == NULL || [x0] == NULL || [x0] is a valid envp", "x20 == NULL || (u16)[x20] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, x20, sp+0x40, [x0])")
OneGadget::Gadget.add(build_id, 290068,
                      constraints: ["readable: x0", "x7 == NULL || {x7, x6+0xd18, [sp+0x50], [sp+0x58], ...} is a valid argv", "[[x0]] == NULL || [x0] == NULL || [x0] is a valid envp", "x20 == NULL || (u16)[x20] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, x20, sp+0x40, [x0])")
OneGadget::Gadget.add(build_id, 290072,
                      constraints: ["readable: x0", "x7 == NULL || {x7, x6, [sp+0x50], [sp+0x58], ...} is a valid argv", "[[x0]] == NULL || [x0] == NULL || [x0] is a valid envp", "x20 == NULL || (u16)[x20] == 0x0"],
                      effect: "posix_spawn(sp+0x4, \"/bin/sh\", 0, x20, sp+0x40, [x0])")
OneGadget::Gadget.add(build_id, 448392,
                      constraints: ["[x0+0x10] == x1-0x7c0", "[x22+0x728] == 0x0", "writable: x22+0x734", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 448392,
                      constraints: ["[[x22+0x728]+0xe8] == 0x0", "[x0+0x10] == x1-0x7c0", "w25 == [[x22+0x728]+0x70]", "writable: x22+0x734", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 448396,
                      constraints: ["[x0+0x10] == x27", "[x22+0x728] == 0x0", "writable: x22+0x734", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 448396,
                      constraints: ["[[x22+0x728]+0xe8] == 0x0", "[x0+0x10] == x27", "w25 == [[x22+0x728]+0x70]", "writable: x22+0x734", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 448400,
                      constraints: ["[x0+0x10] == x27", "[x22+0x728] == 0x0", "writable: x22+0x734", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 448400,
                      constraints: ["[[x22+0x728]+0xe8] == 0x0", "[x0+0x10] == x27", "w25 == [[x22+0x728]+0x70]", "writable: x22+0x734", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 448404,
                      constraints: ["[x22+0x728] == 0x0", "writable: x22+0x734", "x1 == x27", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 448404,
                      constraints: ["[[x22+0x728]+0xe8] == 0x0", "w25 == [[x22+0x728]+0x70]", "writable: x22+0x734", "x1 == x27", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 448432,
                      constraints: ["[x22+0x728] == 0x0", "w0 == 0x0", "writable: x22+0x734", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 448432,
                      constraints: ["[[x22+0x728]+0xe8] == 0x0", "w0 == 0x0", "w25 == [[x22+0x728]+0x70]", "writable: x22+0x734", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 448436,
                      constraints: ["[x22+0x728] == 0x0", "w0 == 0x0", "writable: x22+0x734", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 448436,
                      constraints: ["[[x22+0x728]+0xe8] == 0x0", "w0 == 0x0", "w25 == [[x22+0x728]+0x70]", "writable: x22+0x734", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 448440,
                      constraints: ["[x22+0x728] == 0x0", "writable: x22+0x734", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 448440,
                      constraints: ["[[x22+0x728]+0xe8] == 0x0", "w25 == [[x22+0x728]+0x70]", "writable: x22+0x734", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 448444,
                      constraints: ["[x22+0x728] == 0x0", "writable: x0+0x10", "writable: x22+0x734", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 448444,
                      constraints: ["[[x22+0x728]+0xe8] == 0x0", "w25 == [[x22+0x728]+0x70]", "writable: x0+0x10", "writable: x22+0x734", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 448448,
                      constraints: ["[x22+0x728] == 0x0", "writable: x22+0x734", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 448448,
                      constraints: ["[[x22+0x728]+0xe8] == 0x0", "w25 == [[x22+0x728]+0x70]", "writable: x22+0x734", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 448452,
                      constraints: ["[x22+0x728] == 0x0", "writable: x1+0xc", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 448452,
                      constraints: ["[[x22+0x728]+0xe8] == 0x0", "w25 == [[x22+0x728]+0x70]", "writable: x1+0xc", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 448456,
                      constraints: ["writable: x1+0xc", "x27 == 0x0", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 448456,
                      constraints: ["[x27+0xe8] == 0x0", "w25 == [x27+0x70]", "writable: x1+0xc", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 448460,
                      constraints: ["writable: x1+0xc", "x27 == 0x0", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 448460,
                      constraints: ["[x27+0xe8] == 0x0", "w25 == [x27+0x70]", "writable: x1+0xc", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 448464,
                      constraints: ["writable: x1+0xc", "x27 == 0x0", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 448464,
                      constraints: ["[x27+0xe8] == 0x0", "w25 == [x27+0x70]", "writable: x1+0xc", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 448468,
                      constraints: ["x27 == 0x0", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 448468,
                      constraints: ["[x27+0xe8] == 0x0", "w25 == [x27+0x70]", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 448472,
                      constraints: ["[x27+0xe8] == 0x0", "w25 == [x27+0x70]", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 448476,
                      constraints: ["[x27+0xe8] == 0x0", "w25 == w1", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 448492,
                      constraints: ["[x27+0xe8] == 0x0", "w0 == 0x0", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 448496,
                      constraints: ["[x27+0xe8] == 0x0", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 448500,
                      constraints: ["x27 == 0x0", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 448504,
                      constraints: ["{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 448524,
                      constraints: ["readable: x0", "x8 == NULL || {x8, x7+0xd18, x20, NULL} is a valid argv", "[[x0]] == NULL || [x0] == NULL || [x0] is a valid envp", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x48, [x0])")
OneGadget::Gadget.add(build_id, 448528,
                      constraints: ["readable: x0", "x8 == NULL || {x8, x7, x20, NULL} is a valid argv", "[[x0]] == NULL || [x0] == NULL || [x0] is a valid envp", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x48, [x0])")
OneGadget::Gadget.add(build_id, 448952,
                      constraints: ["[x22+0x728] == 0x0", "writable: x22+0x734", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 448952,
                      constraints: ["[[x22+0x728]+0xe8] == 0x0", "w25 == [[x22+0x728]+0x70]", "writable: x22+0x734", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 765476,
                      constraints: ["writable: x29-0x20", "x4 == 0x0", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x19] == NULL || x19 == NULL || x19 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29-0x20, x19)")
OneGadget::Gadget.add(build_id, 765480,
                      constraints: ["writable: x29-0x20", "x4 == 0x0", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x19] == NULL || x19 == NULL || x19 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29-0x20, x19)")
OneGadget::Gadget.add(build_id, 765484,
                      constraints: ["writable: x29-0x20", "x4 == 0x0", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x19] == NULL || x19 == NULL || x19 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29-0x20, x19)")
OneGadget::Gadget.add(build_id, 765488,
                      constraints: ["writable: x29-0x20", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x19] == NULL || x19 == NULL || x19 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29-0x20, x19)")
OneGadget::Gadget.add(build_id, 765572,
                      constraints: ["(u64)x5 < 0x400", "x3 == 0x1", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x19] == NULL || x19 == NULL || x19 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp+0x10, x19)")
OneGadget::Gadget.add(build_id, 765572,
                      constraints: ["(u64)x5 >= 0x400", "x3 == 0x1", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x19] == NULL || x19 == NULL || x19 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp+0x10, x19)")
OneGadget::Gadget.add(build_id, 765576,
                      constraints: ["(u64)x5 < 0x400", "x3 == 0x1", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x19] == NULL || x19 == NULL || x19 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp+0x10, x19)")
OneGadget::Gadget.add(build_id, 765576,
                      constraints: ["(u64)x5 >= 0x400", "x3 == 0x1", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x19] == NULL || x19 == NULL || x19 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp+0x10, x19)")
OneGadget::Gadget.add(build_id, 765584,
                      constraints: ["x3 == 0x1", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x19] == NULL || x19 == NULL || x19 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp+0x10, x19)")
OneGadget::Gadget.add(build_id, 765588,
                      constraints: ["writable: x20", "x3 == 0x1", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x19] == NULL || x19 == NULL || x19 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x20, x19)")
OneGadget::Gadget.add(build_id, 765696,
                      constraints: ["x3 == 0x1", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x19] == NULL || x19 == NULL || x19 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp+0x10, x19)")
OneGadget::Gadget.add(build_id, 765700,
                      constraints: ["x3 == 0x1", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x19] == NULL || x19 == NULL || x19 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp+0x10, x19)")
OneGadget::Gadget.add(build_id, 765704,
                      constraints: ["writable: x20", "x3 == 0x1", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x19] == NULL || x19 == NULL || x19 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x20, x19)")
OneGadget::Gadget.add(build_id, 765756,
                      constraints: ["writable: x29-0x20", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x19] == NULL || x19 == NULL || x19 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29-0x20, x19)")

