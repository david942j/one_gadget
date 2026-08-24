require 'one_gadget/gadget'
# spec/data/arm-libc-2.23.so
# 
# ARM
# 
# GNU C Library (Ubuntu GLIBC 2.23-0ubuntu3) stable release version 2.23, by Roland McGrath et al.
# Copyright (C) 2016 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 5.3.1 20160413.
# Available extensions:
# 	crypt add-on version 2.1 by Michael Glad and others
# 	GNU Libidn by Simon Josefsson
# 	Native POSIX Threads Library by Ulrich Drepper et al
# 	BIND-8.2.3-T5B
# libc ABIs: UNIQUE
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 181210,
                      constraints: ["r8 is the GOT address of libc", "r0 == NULL", "r7 == NULL", "writable: r2", "{\"sh\", \"-c\", r6, r0, ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x24, environ)")
OneGadget::Gadget.add(build_id, 181220,
                      constraints: ["r8 is the GOT address of libc", "r0 == NULL", "r3 == NULL", "r7 == NULL", "writable: r2", "{\"sh\", \"-c\", r6, r3, ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x24, environ)")
OneGadget::Gadget.add(build_id, 181730,
                      constraints: ["r8 is the GOT address of libc", "r0 == NULL", "r3 == NULL", "r7 == NULL", "{\"sh\", \"-c\", r6, r3, ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x24, environ)")
OneGadget::Gadget.add(build_id, 181732,
                      constraints: ["r8 is the GOT address of libc", "r0 == NULL", "r3 == NULL", "r7 == NULL", "writable: (r5 + $base+0x2c5ee)", "{\"sh\", \"-c\", r6, r3, ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x24, environ)")
OneGadget::Gadget.add(build_id, 181734,
                      constraints: ["r8 is the GOT address of libc", "r0 == NULL", "r3 == NULL", "r7 == NULL", "writable: (r5 + $base+0x2c5ee)", "writable: r4", "{\"sh\", \"-c\", r6, r3, ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 181736,
                      constraints: ["r8 is the GOT address of libc", "r0 == NULL", "r3 == NULL", "r7 == NULL", "writable: (r5 + $base+0x2c5ee)", "writable: r4", "(r1 + $base+0x2c5f4) == NULL || {(r1 + $base+0x2c5f4), \"-c\", r6, r3, ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 181738,
                      constraints: ["r8 is the GOT address of libc", "r2 == NULL", "r3 == NULL", "r7 == NULL", "writable: (r5 + $base+0x2c5ee)", "writable: r4", "(r1 + $base+0x2c5f4) == NULL || {(r1 + $base+0x2c5f4), \"-c\", r6, r3, ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 181740,
                      constraints: ["r8 is the GOT address of libc", "r2 == NULL", "r3 == NULL", "r7 == NULL", "writable: r4", "writable: r5", "(r1 + $base+0x2c5f4) == NULL || {(r1 + $base+0x2c5f4), \"-c\", r6, r3, ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 181744,
                      constraints: ["r8 is the GOT address of libc", "r2 == NULL", "r3 == NULL", "r7 == NULL", "writable: r4", "writable: r5", "(r1 + $base+0x2c5f4) == NULL || {(r1 + $base+0x2c5f4), (lr + $base+0x2c5fe), r6, r3, ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 181746,
                      constraints: ["r8 is the GOT address of libc", "r2 == NULL", "r3 == NULL", "r7 == NULL", "writable: r4", "writable: r5", "r1 == NULL || {r1, (lr + $base+0x2c5fe), r6, r3, ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 181748,
                      constraints: ["r8 is the GOT address of libc", "r2 == NULL", "r3 == NULL", "r7 == NULL", "writable: r4", "writable: r5", "r1 == NULL || {r1, (lr + $base+0x2c5fe), r6, r3, ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 181750,
                      constraints: ["r8 is the GOT address of libc", "r2 == NULL", "r3 == NULL", "r7 == NULL", "writable: r4+0x4", "writable: r5", "[r4] == NULL || r4 == NULL || r4 is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 181754,
                      constraints: ["r8 is the GOT address of libc", "r1 == NULL", "r2 == NULL", "r3 == NULL", "r7 == NULL", "writable: r4+0x4", "writable: r5", "[r4] == NULL || r4 == NULL || r4 is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 181756,
                      constraints: ["r8 is the GOT address of libc", "r1 == NULL", "r2 == NULL", "r3 == NULL", "r7 == NULL", "writable: r4+0x4", "writable: r5", "[r4] == NULL || r4 == NULL || r4 is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 181758,
                      constraints: ["r8 is the GOT address of libc", "r1 == NULL", "r2 == NULL", "r3 == NULL", "r7 == NULL", "writable: r4+0x4", "writable: r5", "[r4] == NULL || r4 == NULL || r4 is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 181762,
                      constraints: ["r8 is the GOT address of libc", "r1 == NULL", "r2 == NULL", "r3 == NULL", "r7 == NULL", "writable: r4+0x8", "writable: r5", "[r4] == NULL || r4 == NULL || r4 is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 181764,
                      constraints: ["r8 is the GOT address of libc", "[sp+0x4] == NULL", "r1 == NULL", "r2 == NULL", "r7 == NULL", "writable: r4+0x8", "writable: r5", "[r4] == NULL || r4 == NULL || r4 is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 181766,
                      constraints: ["r8 is the GOT address of libc", "[sp+0x4] == NULL", "r1 == NULL", "r2 == NULL", "r7 == NULL", "writable: r5", "[r4] == NULL || r4 == NULL || r4 is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 181770,
                      constraints: ["r8 is the GOT address of libc", "[sp+0x4] == NULL", "r7 == NULL", "writable: r5", "[r4] == NULL || r4 == NULL || r4 is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 181772,
                      constraints: ["r8 is the GOT address of libc", "r3 == NULL", "r7 == NULL", "writable: r5", "[r4] == NULL || r4 == NULL || r4 is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 181776,
                      constraints: ["r8 is the GOT address of libc", "r1 == NULL", "r3 == NULL", "r7 == NULL", "writable: r5", "[r4] == NULL || r4 == NULL || r4 is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 181778,
                      constraints: ["r8 is the GOT address of libc", "r1 == NULL", "r3 == NULL", "r7 == NULL", "writable: r5", "[r4] == NULL || r4 == NULL || r4 is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 181780,
                      constraints: ["r8 is the GOT address of libc", "r1 == NULL", "r2 == NULL", "r7 == NULL", "writable: r5", "[r4] == NULL || r4 == NULL || r4 is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 181784,
                      constraints: ["r8 is the GOT address of libc", "r7 == NULL", "writable: r5", "[r4] == NULL || r4 == NULL || r4 is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 181786,
                      constraints: ["r8 is the GOT address of libc", "r7 == NULL", "writable: r5", "[r4] == NULL || r4 == NULL || r4 is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 181788,
                      constraints: ["r8 is the GOT address of libc", "r1 == NULL", "writable: r5", "[r4] == NULL || r4 == NULL || r4 is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 181790,
                      constraints: ["r8 is the GOT address of libc", "r1 == NULL", "writable: r5", "[r4] == NULL || r4 == NULL || r4 is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 181792,
                      constraints: ["r8 is the GOT address of libc", "r1 == NULL", "writable: r5", "[r4] == NULL || r4 == NULL || r4 is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 181796,
                      constraints: ["r8 is the GOT address of libc", "writable: r5", "[r4] == NULL || r4 == NULL || r4 is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 181798,
                      constraints: ["r8 is the GOT address of libc", "writable: r5", "[r4] == NULL || r4 == NULL || r4 is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 287350,
                      constraints: ["(r2 + $base+0x4627e) == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", (r2 + $base+0x4627e))")
OneGadget::Gadget.add(build_id, 287352,
                      constraints: ["(r1 + $base+0x46282) == NULL"],
                      effect: "execl(\"/bin/sh\", (r1 + $base+0x46282))")
OneGadget::Gadget.add(build_id, 544196,
                      constraints: ["r2 is the GOT address of libc", "[sp+0x48] == NULL || {[sp+0x48], [sp+0x4c], [sp+0x50], [sp+0x54], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x48, environ)")
OneGadget::Gadget.add(build_id, 553516,
                      constraints: ["[r1] == 0x0", "r0 == NULL || {\"sh\", r0, [sp-0x20], [sp-0x1c], ...} is a valid argv", "[r2] == NULL || r2 == NULL || r2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x28, r2)")
OneGadget::Gadget.add(build_id, 553518,
                      constraints: ["[r1] == 0x0", "r0 == NULL || {\"sh\", r0, [sp-0x8], [sp-0x4], ...} is a valid argv", "[r2] == NULL || r2 == NULL || r2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x10, r2)")
OneGadget::Gadget.add(build_id, 553520,
                      constraints: ["[r5+0x4] == 0x0", "r0 == NULL || {\"sh\", r0, [sp-0x8], [sp-0x4], ...} is a valid argv", "[r2] == NULL || r2 == NULL || r2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x10, r2)")
OneGadget::Gadget.add(build_id, 553522,
                      constraints: ["[r5+0x4] == 0x0", "r0 == NULL || {\"sh\", r0, [sp-0x8], [sp-0x4], ...} is a valid argv", "[r2] == NULL || r2 == NULL || r2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x10, r2)")

