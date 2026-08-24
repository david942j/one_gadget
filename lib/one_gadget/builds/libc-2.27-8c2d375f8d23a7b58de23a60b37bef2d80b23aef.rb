require 'one_gadget/gadget'
# spec/data/arm-libc-2.27.so
# 
# ARM
# 
# GNU C Library (Ubuntu GLIBC 2.27-3ubuntu1) stable release version 2.27.
# Copyright (C) 2018 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 7.3.0.
# libc ABIs: UNIQUE
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 184722,
                      constraints: ["r5 is the GOT address of libc", "r0 == NULL", "r8 == NULL", "writable: r4", "{\"sh\", \"-c\", fp, r0, ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x20, environ)")
OneGadget::Gadget.add(build_id, 184732,
                      constraints: ["r5 is the GOT address of libc", "r0 == NULL", "r3 == NULL", "r8 == NULL", "writable: r4", "{\"sh\", \"-c\", fp, r3, ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x20, environ)")
OneGadget::Gadget.add(build_id, 185174,
                      constraints: ["r5 is the GOT address of libc", "r0 == NULL", "r3 == NULL", "r8 == NULL", "{\"sh\", \"-c\", fp, r3, ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x20, environ)")
OneGadget::Gadget.add(build_id, 185176,
                      constraints: ["r5 is the GOT address of libc", "r0 == NULL", "r3 == NULL", "r8 == NULL", "writable: (r1 + $base+0x2d364)", "{\"sh\", \"-c\", fp, r3, ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x20, environ)")
OneGadget::Gadget.add(build_id, 185178,
                      constraints: ["r5 is the GOT address of libc", "r0 == NULL", "r3 == NULL", "r8 == NULL", "writable: (r1 + $base+0x2d364)", "writable: r4", "{\"sh\", \"-c\", fp, r3, ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 185182,
                      constraints: ["r5 is the GOT address of libc", "r0 == NULL", "r3 == NULL", "r8 == NULL", "writable: (r1 + $base+0x2d364)", "writable: r4", "(ip + $base+0x2d36a) == NULL || {(ip + $base+0x2d36a), \"-c\", fp, r3, ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 185184,
                      constraints: ["r5 is the GOT address of libc", "r2 == NULL", "r3 == NULL", "r8 == NULL", "writable: (r1 + $base+0x2d364)", "writable: r4", "(ip + $base+0x2d36a) == NULL || {(ip + $base+0x2d36a), \"-c\", fp, r3, ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 185186,
                      constraints: ["r5 is the GOT address of libc", "r2 == NULL", "r3 == NULL", "r8 == NULL", "writable: r1", "writable: r4", "(ip + $base+0x2d36a) == NULL || {(ip + $base+0x2d36a), \"-c\", fp, r3, ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 185188,
                      constraints: ["r5 is the GOT address of libc", "r2 == NULL", "r3 == NULL", "r8 == NULL", "writable: r1", "writable: r4", "(ip + $base+0x2d36a) == NULL || {(ip + $base+0x2d36a), (r7 + $base+0x2d374), fp, r3, ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 185190,
                      constraints: ["r5 is the GOT address of libc", "r2 == NULL", "r3 == NULL", "r8 == NULL", "writable: r1", "writable: r4", "(ip + $base+0x2d36a) == NULL || {(ip + $base+0x2d36a), (r7 + $base+0x2d374), fp, r3, ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 185192,
                      constraints: ["r5 is the GOT address of libc", "r2 == NULL", "r3 == NULL", "r8 == NULL", "writable: r1", "writable: r4", "ip == NULL || {ip, (r7 + $base+0x2d374), fp, r3, ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 185194,
                      constraints: ["r5 is the GOT address of libc", "r1+0x8 == NULL", "r2 == NULL", "r3 == NULL", "r8 == NULL", "writable: r4", "writable: r6", "ip == NULL || {ip, (r7 + $base+0x2d374), fp, r3, ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 185196,
                      constraints: ["r5 is the GOT address of libc", "r1 == NULL", "r2 == NULL", "r3 == NULL", "r8 == NULL", "writable: r4", "writable: r6", "ip == NULL || {ip, (r7 + $base+0x2d374), fp, r3, ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 185200,
                      constraints: ["r5 is the GOT address of libc", "r1 == NULL", "r2 == NULL", "r3 == NULL", "r8 == NULL", "writable: r4+0x4", "writable: r6", "[r4] == NULL || r4 == NULL || r4 is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 185202,
                      constraints: ["r5 is the GOT address of libc", "r1 == NULL", "r2 == NULL", "r3 == NULL", "r8 == NULL", "writable: r4+0x4", "writable: r6", "[r4] == NULL || r4 == NULL || r4 is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 185204,
                      constraints: ["r5 is the GOT address of libc", "r1 == NULL", "r2 == NULL", "r3 == NULL", "r8 == NULL", "writable: r4+0x4", "writable: r6", "[r4] == NULL || r4 == NULL || r4 is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 185206,
                      constraints: ["r5 is the GOT address of libc", "[sp+0x4] == NULL", "r1 == NULL", "r2 == NULL", "r8 == NULL", "writable: r4+0x4", "writable: r6", "[r4] == NULL || r4 == NULL || r4 is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 185210,
                      constraints: ["r5 is the GOT address of libc", "[sp+0x4] == NULL", "r1 == NULL", "r2 == NULL", "r8 == NULL", "writable: r4+0x4", "writable: r6", "[r4] == NULL || r4 == NULL || r4 is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 185212,
                      constraints: ["r5 is the GOT address of libc", "[sp+0x4] == NULL", "r1 == NULL", "r2 == NULL", "r8 == NULL", "writable: r6", "[r4] == NULL || r4 == NULL || r4 is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 185216,
                      constraints: ["r5 is the GOT address of libc", "[sp+0x4] == NULL", "r8 == NULL", "writable: r6", "[r4] == NULL || r4 == NULL || r4 is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 185218,
                      constraints: ["r5 is the GOT address of libc", "r3 == NULL", "r8 == NULL", "writable: r6", "[r4] == NULL || r4 == NULL || r4 is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 185222,
                      constraints: ["r5 is the GOT address of libc", "r1 == NULL", "r3 == NULL", "r8 == NULL", "writable: r6", "[r4] == NULL || r4 == NULL || r4 is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 185224,
                      constraints: ["r5 is the GOT address of libc", "r1 == NULL", "r3 == NULL", "r8 == NULL", "writable: r6", "[r4] == NULL || r4 == NULL || r4 is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 185226,
                      constraints: ["r5 is the GOT address of libc", "r1 == NULL", "r2 == NULL", "r8 == NULL", "writable: r6", "[r4] == NULL || r4 == NULL || r4 is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 185230,
                      constraints: ["r5 is the GOT address of libc", "r8 == NULL", "writable: r6", "[r4] == NULL || r4 == NULL || r4 is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 185232,
                      constraints: ["r5 is the GOT address of libc", "r8 == NULL", "writable: r6", "[r4] == NULL || r4 == NULL || r4 is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 185234,
                      constraints: ["r5 is the GOT address of libc", "r1 == NULL", "writable: r6", "[r4] == NULL || r4 == NULL || r4 is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 185236,
                      constraints: ["r5 is the GOT address of libc", "r1 == NULL", "writable: r6", "[r4] == NULL || r4 == NULL || r4 is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 185238,
                      constraints: ["r5 is the GOT address of libc", "r1 == NULL", "writable: r6", "[r4] == NULL || r4 == NULL || r4 is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 185242,
                      constraints: ["r5 is the GOT address of libc", "writable: r6", "[r4] == NULL || r4 == NULL || r4 is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 185244,
                      constraints: ["r5 is the GOT address of libc", "writable: r6", "[r4] == NULL || r4 == NULL || r4 is a valid argv"],
                      effect: "execve(\"/bin/sh\", r4, environ)")
OneGadget::Gadget.add(build_id, 293470,
                      constraints: ["(r2 + $base+0x47a68) == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", (r2 + $base+0x47a68))")
OneGadget::Gadget.add(build_id, 293472,
                      constraints: ["(r2 + $base+0x47a68) == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", (r2 + $base+0x47a68))")
OneGadget::Gadget.add(build_id, 293474,
                      constraints: ["(r1 + $base+0x47a6c) == NULL"],
                      effect: "execl(\"/bin/sh\", (r1 + $base+0x47a6c))")
OneGadget::Gadget.add(build_id, 474922,
                      constraints: ["[r1] == 0x0", "readable: [(r3 + $base+0x73f2e)+0x148]", "r0 == NULL || {\"/bin/sh\", r0, NULL} is a valid argv", "[r2] == NULL || r2 == NULL || r2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x10, r2)")
OneGadget::Gadget.add(build_id, 474924,
                      constraints: ["r3 is the GOT address of libc", "[r1] == 0x0", "r0 == NULL || {\"/bin/sh\", r0, NULL} is a valid argv", "[r2] == NULL || r2 == NULL || r2 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp-0x10, r2)")
OneGadget::Gadget.add(build_id, 474936,
                      constraints: ["r4 == 0x0", "readable: r6", "writable: r7", "r0 == NULL || {\"/bin/sh\", r0, NULL} is a valid argv", "[r8] == NULL || r8 == NULL || r8 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r7, r8)")
OneGadget::Gadget.add(build_id, 474938,
                      constraints: ["r4 == 0x0", "writable: r7", "r0 == NULL || {\"/bin/sh\", r0, NULL} is a valid argv", "[r8] == NULL || r8 == NULL || r8 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r7, r8)")
OneGadget::Gadget.add(build_id, 474940,
                      constraints: ["r4 == 0x0", "writable: r7", "r0 == NULL || {\"/bin/sh\", r0, NULL} is a valid argv", "[r8] == NULL || r8 == NULL || r8 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r7, r8)")
OneGadget::Gadget.add(build_id, 474960,
                      constraints: ["r2 == 0x0", "r3 == 0x1", "writable: r7", "r0 == NULL || {\"/bin/sh\", r0, NULL} is a valid argv", "[r8] == NULL || r8 == NULL || r8 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r7, r8)")
OneGadget::Gadget.add(build_id, 474964,
                      constraints: ["r3 == 0x1", "writable: r7", "r0 == NULL || {\"/bin/sh\", r0, NULL} is a valid argv", "[r8] == NULL || r8 == NULL || r8 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r7, r8)")
OneGadget::Gadget.add(build_id, 475002,
                      constraints: ["[r4] == NULL || r4 == NULL || r4 is a valid argv", "[r8] == NULL || r8 == NULL || r8 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r4, r8)")
OneGadget::Gadget.add(build_id, 475030,
                      constraints: ["writable: r7", "r0 == NULL || {\"/bin/sh\", r0, NULL} is a valid argv", "[r8] == NULL || r8 == NULL || r8 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r7, r8)")
OneGadget::Gadget.add(build_id, 475032,
                      constraints: ["writable: r7", "(r3 + $base+0x73fa2) == NULL || {(r3 + $base+0x73fa2), r0, NULL} is a valid argv", "[r8] == NULL || r8 == NULL || r8 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r7, r8)")
OneGadget::Gadget.add(build_id, 475034,
                      constraints: ["writable: r7", "(r3 + $base+0x73fa2) == NULL || {(r3 + $base+0x73fa2), r0, r2, [r7+0xc], ...} is a valid argv", "[r8] == NULL || r8 == NULL || r8 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r7, r8)")
OneGadget::Gadget.add(build_id, 475036,
                      constraints: ["writable: r7", "(r3 + $base+0x73fa2) == NULL || {(r3 + $base+0x73fa2), [r7+0x4], r2, [r7+0xc], ...} is a valid argv", "[r8] == NULL || r8 == NULL || r8 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r7, r8)")
OneGadget::Gadget.add(build_id, 475038,
                      constraints: ["writable: r7", "[r4] == NULL || r4 == NULL || r4 is a valid argv", "[r8] == NULL || r8 == NULL || r8 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r4, r8)")
OneGadget::Gadget.add(build_id, 475040,
                      constraints: ["writable: r7", "[r4] == NULL || r4 == NULL || r4 is a valid argv", "[r8] == NULL || r8 == NULL || r8 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r4, r8)")
OneGadget::Gadget.add(build_id, 475042,
                      constraints: ["writable: r7", "[r4] == NULL || r4 == NULL || r4 is a valid argv", "[r8] == NULL || r8 == NULL || r8 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r4, r8)")
OneGadget::Gadget.add(build_id, 475044,
                      constraints: ["[r4] == NULL || r4 == NULL || r4 is a valid argv", "[r8] == NULL || r8 == NULL || r8 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r4, r8)")

