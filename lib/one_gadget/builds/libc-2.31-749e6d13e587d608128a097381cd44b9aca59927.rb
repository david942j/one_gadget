require 'one_gadget/gadget'
# http://ports.ubuntu.com/ubuntu-ports/pool/main/g/glibc/libc6_2.31-0ubuntu9.18_arm64.deb
# 
# AArch64
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
OneGadget::Gadget.add(build_id, 262332,
                      constraints: ["[x21+0x350] != 0x1", "[x21+0x3e8] != 0x1", "readable: x20", "readable: x23", "writable: x1", "x1 == x20", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "sp+0x238 == NULL || (u16)[sp+0x238] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, sp+0x238, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262332,
                      constraints: ["[x21+0x350] == 0x1", "[x21+0x3e8] != 0x1", "readable: x20", "readable: x23", "writable: x1", "x1 == x20", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "sp+0x238 == NULL || (u16)[sp+0x238] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, sp+0x238, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262332,
                      constraints: ["[x21+0x350] != 0x1", "[x21+0x3e8] == 0x1", "readable: x20", "readable: x23", "writable: x1", "x1 == x20", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "sp+0x238 == NULL || (u16)[sp+0x238] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, sp+0x238, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262332,
                      constraints: ["[x21+0x350] == 0x1", "[x21+0x3e8] == 0x1", "readable: x20", "readable: x23", "writable: x1", "x1 == x20", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "sp+0x238 == NULL || (u16)[sp+0x238] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, sp+0x238, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262336,
                      constraints: ["[x21+0x350] != 0x1", "[x21+0x3e8] != 0x1", "readable: x20", "readable: x23", "writable: x1", "x1 == x20", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "sp+0x238 == NULL || (u16)[sp+0x238] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, sp+0x238, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262336,
                      constraints: ["[x21+0x350] == 0x1", "[x21+0x3e8] != 0x1", "readable: x20", "readable: x23", "writable: x1", "x1 == x20", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "sp+0x238 == NULL || (u16)[sp+0x238] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, sp+0x238, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262336,
                      constraints: ["[x21+0x350] != 0x1", "[x21+0x3e8] == 0x1", "readable: x20", "readable: x23", "writable: x1", "x1 == x20", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "sp+0x238 == NULL || (u16)[sp+0x238] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, sp+0x238, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262336,
                      constraints: ["[x21+0x350] == 0x1", "[x21+0x3e8] == 0x1", "readable: x20", "readable: x23", "writable: x1", "x1 == x20", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "sp+0x238 == NULL || (u16)[sp+0x238] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, sp+0x238, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262340,
                      constraints: ["[x21+0x350] != 0x1", "[x21+0x3e8] != 0x1", "readable: x20", "readable: x23", "x1 == x20", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "sp+0x238 == NULL || (u16)[sp+0x238] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, sp+0x238, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262340,
                      constraints: ["[x21+0x350] == 0x1", "[x21+0x3e8] != 0x1", "readable: x20", "readable: x23", "x1 == x20", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "sp+0x238 == NULL || (u16)[sp+0x238] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, sp+0x238, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262340,
                      constraints: ["[x21+0x350] != 0x1", "[x21+0x3e8] == 0x1", "readable: x20", "readable: x23", "x1 == x20", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "sp+0x238 == NULL || (u16)[sp+0x238] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, sp+0x238, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262340,
                      constraints: ["[x21+0x350] == 0x1", "[x21+0x3e8] == 0x1", "readable: x20", "readable: x23", "x1 == x20", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "sp+0x238 == NULL || (u16)[sp+0x238] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, sp+0x238, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262352,
                      constraints: ["[x21+0x350] != 0x1", "[x21+0x3e8] != 0x1", "readable: x20", "readable: x23", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "sp+0x238 == NULL || (u16)[sp+0x238] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, sp+0x238, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262352,
                      constraints: ["[x21+0x350] == 0x1", "[x21+0x3e8] != 0x1", "readable: x20", "readable: x23", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "sp+0x238 == NULL || (u16)[sp+0x238] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, sp+0x238, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262352,
                      constraints: ["[x21+0x350] != 0x1", "[x21+0x3e8] == 0x1", "readable: x20", "readable: x23", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "sp+0x238 == NULL || (u16)[sp+0x238] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, sp+0x238, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262352,
                      constraints: ["[x21+0x350] == 0x1", "[x21+0x3e8] == 0x1", "readable: x20", "readable: x23", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "sp+0x238 == NULL || (u16)[sp+0x238] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, sp+0x238, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262356,
                      constraints: ["[x0+0x8] != 0x1", "[x21+0x3e8] != 0x1", "readable: x20", "readable: x23", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "sp+0x238 == NULL || (u16)[sp+0x238] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, sp+0x238, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262356,
                      constraints: ["[x0+0x8] == 0x1", "[x21+0x3e8] != 0x1", "readable: x20", "readable: x23", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "sp+0x238 == NULL || (u16)[sp+0x238] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, sp+0x238, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262356,
                      constraints: ["[x0+0x8] != 0x1", "[x21+0x3e8] == 0x1", "readable: x20", "readable: x23", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "sp+0x238 == NULL || (u16)[sp+0x238] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, sp+0x238, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262356,
                      constraints: ["[x0+0x8] == 0x1", "[x21+0x3e8] == 0x1", "readable: x20", "readable: x23", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "sp+0x238 == NULL || (u16)[sp+0x238] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, sp+0x238, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262360,
                      constraints: ["[x21+0x3e8] != 0x1", "readable: x20", "readable: x23", "x0 != 0x1", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "sp+0x238 == NULL || (u16)[sp+0x238] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, sp+0x238, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262360,
                      constraints: ["[x21+0x3e8] != 0x1", "readable: x20", "readable: x23", "x0 == 0x1", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "sp+0x238 == NULL || (u16)[sp+0x238] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, sp+0x238, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262360,
                      constraints: ["[x21+0x3e8] == 0x1", "readable: x20", "readable: x23", "x0 != 0x1", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "sp+0x238 == NULL || (u16)[sp+0x238] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, sp+0x238, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262360,
                      constraints: ["[x21+0x3e8] == 0x1", "readable: x20", "readable: x23", "x0 == 0x1", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "sp+0x238 == NULL || (u16)[sp+0x238] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, sp+0x238, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262368,
                      constraints: ["[x21+0x3e8] != 0x1", "readable: x20", "readable: x23", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "sp+0x238 == NULL || (u16)[sp+0x238] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, sp+0x238, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262368,
                      constraints: ["[x21+0x3e8] == 0x1", "readable: x20", "readable: x23", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "sp+0x238 == NULL || (u16)[sp+0x238] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, sp+0x238, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262372,
                      constraints: ["[x21+0x3e8] != 0x1", "readable: x20", "readable: x23", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "sp+0x238 == NULL || (u16)[sp+0x238] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, sp+0x238, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262372,
                      constraints: ["[x21+0x3e8] == 0x1", "readable: x20", "readable: x23", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "sp+0x238 == NULL || (u16)[sp+0x238] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, sp+0x238, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262376,
                      constraints: ["[x21+0x3e8] != 0x1", "readable: x20", "readable: x23", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "sp+0x238 == NULL || (u16)[sp+0x238] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, sp+0x238, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262376,
                      constraints: ["[x21+0x3e8] == 0x1", "readable: x20", "readable: x23", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "sp+0x238 == NULL || (u16)[sp+0x238] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, sp+0x238, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262380,
                      constraints: ["[x21+0x3e8] != 0x1", "readable: x20", "readable: x23", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "sp+0x238 == NULL || (u16)[sp+0x238] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, sp+0x238, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262380,
                      constraints: ["[x21+0x3e8] == 0x1", "readable: x20", "readable: x23", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "sp+0x238 == NULL || (u16)[sp+0x238] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, sp+0x238, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262384,
                      constraints: ["[x0+0xa0] != 0x1", "readable: x20", "readable: x23", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "sp+0x238 == NULL || (u16)[sp+0x238] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, sp+0x238, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262384,
                      constraints: ["[x0+0xa0] == 0x1", "readable: x20", "readable: x23", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "sp+0x238 == NULL || (u16)[sp+0x238] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, sp+0x238, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262388,
                      constraints: ["readable: x20", "readable: x23", "x0 != 0x1", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "sp+0x238 == NULL || (u16)[sp+0x238] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, sp+0x238, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262388,
                      constraints: ["readable: x20", "readable: x23", "x0 == 0x1", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "sp+0x238 == NULL || (u16)[sp+0x238] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, sp+0x238, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262396,
                      constraints: ["readable: x20", "readable: x23", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "sp+0x238 == NULL || (u16)[sp+0x238] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, sp+0x238, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262400,
                      constraints: ["readable: x20", "readable: x23", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "sp+0x238 == NULL || (u16)[sp+0x238] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, sp+0x238, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262404,
                      constraints: ["readable: x20", "readable: x23", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "sp+0x238 == NULL || (u16)[sp+0x238] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, sp+0x238, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262408,
                      constraints: ["readable: x20", "readable: x23", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "sp+0x238 == NULL || (u16)[sp+0x238] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, sp+0x238, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262412,
                      constraints: ["readable: x20", "readable: x23", "writable: x19", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "(u16)[x19] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, x19, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262416,
                      constraints: ["readable: x20", "readable: x23", "writable: x0", "writable: x19", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "(u16)[x19] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, x19, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262420,
                      constraints: ["readable: x20", "readable: x23", "writable: x19", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "(u16)[x19] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, x19, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262424,
                      constraints: ["readable: x1", "readable: x20", "writable: x19", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "(u16)[x19] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, x19, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262428,
                      constraints: ["readable: x1", "readable: x20", "writable: x0", "writable: x19", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "(u16)[x19] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, x19, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262432,
                      constraints: ["readable: x20", "writable: x19", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "(u16)[x19] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, x19, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262436,
                      constraints: ["readable: x1", "writable: x19", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "(u16)[x19] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, x19, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262440,
                      constraints: ["readable: x1", "writable: x0", "writable: x19", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "(u16)[x19] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, x19, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262444,
                      constraints: ["writable: x19", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "(u16)[x19] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, x19, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262448,
                      constraints: ["writable: x19", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "(u16)[x19] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, x19, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262452,
                      constraints: ["writable: x0", "{\"sh\", \"-c\", x24, NULL} is a valid argv", "x19 == NULL || (u16)[x19] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, x19, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262456,
                      constraints: ["{\"sh\", \"-c\", x24, NULL} is a valid argv", "x19 == NULL || (u16)[x19] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, x19, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262460,
                      constraints: ["{\"sh\", \"-c\", [sp+0x90], [sp+0x98], ...} is a valid argv", "x19 == NULL || (u16)[x19] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, x19, sp+0x80, environ)")
OneGadget::Gadget.add(build_id, 262476,
                      constraints: ["readable: x0", "x7+0x80 == NULL || {x7+0x80, x6+0x88, [sp+0x90], [sp+0x98], ...} is a valid argv", "[[x0]] == NULL || [x0] == NULL || [x0] is a valid envp", "x19 == NULL || (u16)[x19] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, x19, sp+0x80, [x0])")
OneGadget::Gadget.add(build_id, 262480,
                      constraints: ["readable: x0", "x7 == NULL || {x7, x6+0x88, [sp+0x90], [sp+0x98], ...} is a valid argv", "[[x0]] == NULL || [x0] == NULL || [x0] is a valid envp", "x19 == NULL || (u16)[x19] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, x19, sp+0x80, [x0])")
OneGadget::Gadget.add(build_id, 262484,
                      constraints: ["readable: x0", "x7 == NULL || {x7, x6, [sp+0x90], [sp+0x98], ...} is a valid argv", "[[x0]] == NULL || [x0] == NULL || [x0] is a valid envp", "x19 == NULL || (u16)[x19] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, x19, sp+0x80, [x0])")
OneGadget::Gadget.add(build_id, 262488,
                      constraints: ["readable: x0", "x7 == NULL || {x7, x6, [sp+0x90], [sp+0x98], ...} is a valid argv", "[[x0]] == NULL || [x0] == NULL || [x0] is a valid envp", "x3 == NULL || (u16)[x3] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, x3, sp+0x80, [x0])")
OneGadget::Gadget.add(build_id, 262492,
                      constraints: ["readable: x0", "[x4] == NULL || x4 is a valid argv", "[[x0]] == NULL || [x0] == NULL || [x0] is a valid envp", "x3 == NULL || (u16)[x3] == 0x0"],
                      effect: "posix_spawn(sp+0x44, \"/bin/sh\", 0, x3, x4, [x0])")
OneGadget::Gadget.add(build_id, 415252,
                      constraints: ["[x0+0x10] == x24-0x700", "[x22+0x568] == 0x0", "writable: x22+0x574", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0xa8, environ)")
OneGadget::Gadget.add(build_id, 415252,
                      constraints: ["[[x22+0x568]+0xe8] == 0x0", "[x0+0x10] == x24-0x700", "w25 == [[x22+0x568]+0x70]", "writable: x22+0x574", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0xa8, environ)")
OneGadget::Gadget.add(build_id, 415256,
                      constraints: ["[x0+0x10] == x3", "[x22+0x568] == 0x0", "writable: x22+0x574", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0xa8, environ)")
OneGadget::Gadget.add(build_id, 415256,
                      constraints: ["[[x22+0x568]+0xe8] == 0x0", "[x0+0x10] == x3", "w25 == [[x22+0x568]+0x70]", "writable: x22+0x574", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0xa8, environ)")
OneGadget::Gadget.add(build_id, 415260,
                      constraints: ["[x0+0x10] == x3", "[x22+0x568] == 0x0", "writable: x22+0x574", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0xa8, environ)")
OneGadget::Gadget.add(build_id, 415260,
                      constraints: ["[[x22+0x568]+0xe8] == 0x0", "[x0+0x10] == x3", "w25 == [[x22+0x568]+0x70]", "writable: x22+0x574", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0xa8, environ)")
OneGadget::Gadget.add(build_id, 415264,
                      constraints: ["[x22+0x568] == 0x0", "writable: x22+0x574", "x1 == x3", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0xa8, environ)")
OneGadget::Gadget.add(build_id, 415264,
                      constraints: ["[[x22+0x568]+0xe8] == 0x0", "w25 == [[x22+0x568]+0x70]", "writable: x22+0x574", "x1 == x3", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0xa8, environ)")
OneGadget::Gadget.add(build_id, 415292,
                      constraints: ["[x22+0x568] == 0x0", "w0 == 0x0", "writable: x22+0x574", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0xa8, environ)")
OneGadget::Gadget.add(build_id, 415292,
                      constraints: ["[[x22+0x568]+0xe8] == 0x0", "w0 == 0x0", "w25 == [[x22+0x568]+0x70]", "writable: x22+0x574", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0xa8, environ)")
OneGadget::Gadget.add(build_id, 415296,
                      constraints: ["[x22+0x568] == 0x0", "w0 == 0x0", "writable: x22+0x574", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0xa8, environ)")
OneGadget::Gadget.add(build_id, 415296,
                      constraints: ["[[x22+0x568]+0xe8] == 0x0", "w0 == 0x0", "w25 == [[x22+0x568]+0x70]", "writable: x22+0x574", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0xa8, environ)")
OneGadget::Gadget.add(build_id, 415300,
                      constraints: ["[x22+0x568] == 0x0", "writable: x22+0x574", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0xa8, environ)")
OneGadget::Gadget.add(build_id, 415300,
                      constraints: ["[[x22+0x568]+0xe8] == 0x0", "w25 == [[x22+0x568]+0x70]", "writable: x22+0x574", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0xa8, environ)")
OneGadget::Gadget.add(build_id, 415304,
                      constraints: ["[x22+0x568] == 0x0", "writable: x0+0x10", "writable: x22+0x574", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0xa8, environ)")
OneGadget::Gadget.add(build_id, 415304,
                      constraints: ["[[x22+0x568]+0xe8] == 0x0", "w25 == [[x22+0x568]+0x70]", "writable: x0+0x10", "writable: x22+0x574", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0xa8, environ)")
OneGadget::Gadget.add(build_id, 415308,
                      constraints: ["[x22+0x568] == 0x0", "writable: x22+0x574", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0xa8, environ)")
OneGadget::Gadget.add(build_id, 415308,
                      constraints: ["[[x22+0x568]+0xe8] == 0x0", "w25 == [[x22+0x568]+0x70]", "writable: x22+0x574", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0xa8, environ)")
OneGadget::Gadget.add(build_id, 415312,
                      constraints: ["[x22+0x568] == 0x0", "writable: x1+0xc", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0xa8, environ)")
OneGadget::Gadget.add(build_id, 415312,
                      constraints: ["[[x22+0x568]+0xe8] == 0x0", "w25 == [[x22+0x568]+0x70]", "writable: x1+0xc", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0xa8, environ)")
OneGadget::Gadget.add(build_id, 415316,
                      constraints: ["writable: x1+0xc", "x28 == 0x0", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0xa8, environ)")
OneGadget::Gadget.add(build_id, 415316,
                      constraints: ["[x28+0xe8] == 0x0", "w25 == [x28+0x70]", "writable: x1+0xc", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0xa8, environ)")
OneGadget::Gadget.add(build_id, 415320,
                      constraints: ["writable: x1+0xc", "x28 == 0x0", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0xa8, environ)")
OneGadget::Gadget.add(build_id, 415320,
                      constraints: ["[x28+0xe8] == 0x0", "w25 == [x28+0x70]", "writable: x1+0xc", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0xa8, environ)")
OneGadget::Gadget.add(build_id, 415324,
                      constraints: ["writable: x1+0xc", "x28 == 0x0", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0xa8, environ)")
OneGadget::Gadget.add(build_id, 415324,
                      constraints: ["[x28+0xe8] == 0x0", "w25 == [x28+0x70]", "writable: x1+0xc", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0xa8, environ)")
OneGadget::Gadget.add(build_id, 415328,
                      constraints: ["x28 == 0x0", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0xa8, environ)")
OneGadget::Gadget.add(build_id, 415328,
                      constraints: ["[x28+0xe8] == 0x0", "w25 == [x28+0x70]", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0xa8, environ)")
OneGadget::Gadget.add(build_id, 415332,
                      constraints: ["[x28+0xe8] == 0x0", "w25 == [x28+0x70]", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0xa8, environ)")
OneGadget::Gadget.add(build_id, 415336,
                      constraints: ["[x28+0xe8] == 0x0", "w25 == [x28+0x70]", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0xa8, environ)")
OneGadget::Gadget.add(build_id, 415340,
                      constraints: ["[x28+0xe8] == 0x0", "w25 == w1", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0xa8, environ)")
OneGadget::Gadget.add(build_id, 415356,
                      constraints: ["[x28+0xe8] == 0x0", "w0 == 0x0", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0xa8, environ)")
OneGadget::Gadget.add(build_id, 415360,
                      constraints: ["[x28+0xe8] == 0x0", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0xa8, environ)")
OneGadget::Gadget.add(build_id, 415364,
                      constraints: ["x28 == 0x0", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0xa8, environ)")
OneGadget::Gadget.add(build_id, 415368,
                      constraints: ["{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0xa8, environ)")
OneGadget::Gadget.add(build_id, 415388,
                      constraints: ["readable: x0", "x9 == NULL || {x9, x8+0x88, x20, NULL} is a valid argv", "[[x0]] == NULL || [x0] == NULL || [x0] is a valid envp", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0xa8, [x0])")
OneGadget::Gadget.add(build_id, 415392,
                      constraints: ["readable: x0", "x9 == NULL || {x9, x8, x20, NULL} is a valid argv", "[[x0]] == NULL || [x0] == NULL || [x0] is a valid envp", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0xa8, [x0])")
OneGadget::Gadget.add(build_id, 415880,
                      constraints: ["[x22+0x568] == 0x0", "writable: x22+0x574", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0xa8, environ)")
OneGadget::Gadget.add(build_id, 415880,
                      constraints: ["[[x22+0x568]+0xe8] == 0x0", "w25 == [[x22+0x568]+0x70]", "writable: x22+0x574", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0xa8, environ)")
OneGadget::Gadget.add(build_id, 415884,
                      constraints: ["[x22+0x568] == 0x0", "writable: x22+0x574", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0xa8, environ)")
OneGadget::Gadget.add(build_id, 415884,
                      constraints: ["[[x22+0x568]+0xe8] == 0x0", "w25 == [[x22+0x568]+0x70]", "writable: x22+0x574", "{\"sh\", \"-c\", x20, NULL} is a valid argv", "x19+0xe0 == NULL || writable: x19+0xe0", "x21 == NULL || (s32)[x21+0x4] <= 0x0"],
                      effect: "posix_spawn(x19+0xe0, \"/bin/sh\", x21, 0, sp+0xa8, environ)")
OneGadget::Gadget.add(build_id, 674080,
                      constraints: ["[x1] == 0x0", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x20, x2)")
OneGadget::Gadget.add(build_id, 674084,
                      constraints: ["[x1] == 0x0", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp+0x40, x2)")
OneGadget::Gadget.add(build_id, 674088,
                      constraints: ["[x1] == 0x0", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp+0x40, x2)")
OneGadget::Gadget.add(build_id, 674092,
                      constraints: ["[x1] == 0x0", "writable: x29+0x40", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x2)")
OneGadget::Gadget.add(build_id, 674096,
                      constraints: ["[x1] == 0x0", "writable: x29+0x40", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x2)")
OneGadget::Gadget.add(build_id, 674100,
                      constraints: ["[x1] == 0x0", "readable: [x19+0xed8]", "writable: x29+0x40", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x2] == NULL || x2 == NULL || x2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x2)")
OneGadget::Gadget.add(build_id, 674104,
                      constraints: ["[x1] == 0x0", "readable: [x19+0xed8]", "writable: x29+0x40", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x20] == NULL || x20 == NULL || x20 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x20)")
OneGadget::Gadget.add(build_id, 674108,
                      constraints: ["[x1] == 0x0", "readable: x3", "writable: x29+0x40", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x20] == NULL || x20 == NULL || x20 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x20)")
OneGadget::Gadget.add(build_id, 674112,
                      constraints: ["[x1] == 0x0", "readable: x3", "writable: x29+0x40", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x20] == NULL || x20 == NULL || x20 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x20)")
OneGadget::Gadget.add(build_id, 674116,
                      constraints: ["readable: x3", "writable: x29+0x40", "x4 == 0x0", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x20] == NULL || x20 == NULL || x20 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x20)")
OneGadget::Gadget.add(build_id, 674120,
                      constraints: ["readable: x3", "writable: x29+0x40", "x4 == 0x0", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x20] == NULL || x20 == NULL || x20 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x20)")
OneGadget::Gadget.add(build_id, 674124,
                      constraints: ["writable: x29+0x40", "x4 == 0x0", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x20] == NULL || x20 == NULL || x20 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x20)")
OneGadget::Gadget.add(build_id, 674128,
                      constraints: ["writable: x29+0x40", "x4 == 0x0", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x20] == NULL || x20 == NULL || x20 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x20)")
OneGadget::Gadget.add(build_id, 674132,
                      constraints: ["writable: x29+0x40", "x4 == 0x0", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x20] == NULL || x20 == NULL || x20 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x20)")
OneGadget::Gadget.add(build_id, 674136,
                      constraints: ["writable: x29+0x40", "x4 == 0x0", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x20] == NULL || x20 == NULL || x20 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x20)")
OneGadget::Gadget.add(build_id, 674140,
                      constraints: ["writable: x29+0x40", "x4 == 0x0", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x20] == NULL || x20 == NULL || x20 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x20)")
OneGadget::Gadget.add(build_id, 674144,
                      constraints: ["writable: x29+0x40", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x20] == NULL || x20 == NULL || x20 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x20)")
OneGadget::Gadget.add(build_id, 674232,
                      constraints: ["(u64)x5 < 0x400", "x3 == 0x1", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x20] == NULL || x20 == NULL || x20 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp+0x10, x20)")
OneGadget::Gadget.add(build_id, 674232,
                      constraints: ["(u64)x5 >= 0x400", "x3 == 0x1", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x20] == NULL || x20 == NULL || x20 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp+0x10, x20)")
OneGadget::Gadget.add(build_id, 674244,
                      constraints: ["x3 == 0x1", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x20] == NULL || x20 == NULL || x20 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp+0x10, x20)")
OneGadget::Gadget.add(build_id, 674248,
                      constraints: ["writable: x21", "x3 == 0x1", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x20] == NULL || x20 == NULL || x20 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x21, x20)")
OneGadget::Gadget.add(build_id, 674356,
                      constraints: ["x3 == 0x1", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x20] == NULL || x20 == NULL || x20 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp+0x10, x20)")
OneGadget::Gadget.add(build_id, 674360,
                      constraints: ["x3 == 0x1", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x20] == NULL || x20 == NULL || x20 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp+0x10, x20)")
OneGadget::Gadget.add(build_id, 674364,
                      constraints: ["writable: x21", "x3 == 0x1", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x20] == NULL || x20 == NULL || x20 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x21, x20)")
OneGadget::Gadget.add(build_id, 674412,
                      constraints: ["writable: x29+0x40", "x0 == NULL || {\"/bin/sh\", x0, NULL} is a valid argv", "[x20] == NULL || x20 == NULL || x20 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x29+0x40, x20)")
OneGadget::Gadget.add(build_id, 784144,
                      constraints: ["x0 == 0x0", "[sp+0xc0] == NULL || {[sp+0xc0], [sp+0xc8], [sp+0xd0], [sp+0xd8], ...} is a valid argv", "[sp+0x98] == NULL || (s32)[[sp+0x98]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0xb4, \"/bin/sh\", [sp+0x98], 0, sp+0xc0, environ)")
OneGadget::Gadget.add(build_id, 784304,
                      constraints: ["([sp+0x138] + 0x1) != 0x0", "[sp+0xc0] == NULL || {[sp+0xc0], [sp+0xc8], [sp+0xd0], [sp+0xd8], ...} is a valid argv", "[[sp+0x140]] == NULL || [sp+0x140] == NULL || [sp+0x140] is a valid envp", "[sp+0x98] == NULL || (s32)[[sp+0x98]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0xb4, \"/bin/sh\", [sp+0x98], 0, sp+0xc0, [sp+0x140])")
OneGadget::Gadget.add(build_id, 784308,
                      constraints: ["(x0 + 0x1) != 0x0", "[sp+0xc0] == NULL || {[sp+0xc0], [sp+0xc8], [sp+0xd0], [sp+0xd8], ...} is a valid argv", "[[sp+0x140]] == NULL || [sp+0x140] == NULL || [sp+0x140] is a valid envp", "[sp+0x98] == NULL || (s32)[[sp+0x98]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0xb4, \"/bin/sh\", [sp+0x98], 0, sp+0xc0, [sp+0x140])")
OneGadget::Gadget.add(build_id, 784316,
                      constraints: ["[sp+0xc0] == NULL || {[sp+0xc0], [sp+0xc8], [sp+0xd0], [sp+0xd8], ...} is a valid argv", "[[sp+0x140]] == NULL || [sp+0x140] == NULL || [sp+0x140] is a valid envp", "[sp+0x98] == NULL || (s32)[[sp+0x98]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0xb4, \"/bin/sh\", [sp+0x98], 0, sp+0xc0, [sp+0x140])")
OneGadget::Gadget.add(build_id, 784320,
                      constraints: ["[sp+0xc0] == NULL || {[sp+0xc0], [sp+0xc8], [sp+0xd0], [sp+0xd8], ...} is a valid argv", "[x5] == NULL || x5 == NULL || x5 is a valid envp", "[sp+0x98] == NULL || (s32)[[sp+0x98]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0xb4, \"/bin/sh\", [sp+0x98], 0, sp+0xc0, x5)")
OneGadget::Gadget.add(build_id, 785512,
                      constraints: ["[sp+0xc0] == NULL || {[sp+0xc0], [sp+0xc8], [sp+0xd0], [sp+0xd8], ...} is a valid argv", "[sp+0x98] == NULL || (s32)[[sp+0x98]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0xb4, \"/bin/sh\", [sp+0x98], 0, sp+0xc0, environ)")
OneGadget::Gadget.add(build_id, 785520,
                      constraints: ["readable: x0", "[sp+0xc0] == NULL || {[sp+0xc0], [sp+0xc8], [sp+0xd0], [sp+0xd8], ...} is a valid argv", "[[x0]] == NULL || [x0] == NULL || [x0] is a valid envp", "[sp+0x98] == NULL || (s32)[[sp+0x98]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0xb4, \"/bin/sh\", [sp+0x98], 0, sp+0xc0, [x0])")
OneGadget::Gadget.add(build_id, 785524,
                      constraints: ["[sp+0xc0] == NULL || {[sp+0xc0], [sp+0xc8], [sp+0xd0], [sp+0xd8], ...} is a valid argv", "[x5] == NULL || x5 == NULL || x5 is a valid envp", "[sp+0x98] == NULL || (s32)[[sp+0x98]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0xb4, \"/bin/sh\", [sp+0x98], 0, sp+0xc0, x5)")
OneGadget::Gadget.add(build_id, 785580,
                      constraints: ["([sp+0x138] + 0x1) != 0x0", "[sp+0xc0] == NULL || {[sp+0xc0], [sp+0xc8], [sp+0xd0], [sp+0xd8], ...} is a valid argv", "[[sp+0x140]] == NULL || [sp+0x140] == NULL || [sp+0x140] is a valid envp", "[sp+0x98] == NULL || (s32)[[sp+0x98]+0x4] <= 0x0"],
                      effect: "posix_spawn(sp+0xb4, \"/bin/sh\", [sp+0x98], 0, sp+0xc0, [sp+0x140])")

