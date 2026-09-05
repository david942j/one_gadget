require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/lib32-glibc-2.21-4-x86_64.pkg.tar/usr/lib32/libc-2.21.so
# 
# Intel 80386
# 
# GNU C Library (GNU libc) stable release version 2.21, by Roland McGrath et al.
# Copyright (C) 2015 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 5.1.0.
# Available extensions:
# 	crypt add-on version 2.1 by Michael Glad and others
# 	GNU Libidn by Simon Josefsson
# 	Native POSIX Threads Library by Ulrich Drepper et al
# 	BIND-8.2.3-T5B
# libc ABIs: UNIQUE IFUNC
# For bug reporting instructions, please see:
# <https://bugs.archlinux.org/>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 240093,
                      constraints: ["edi is the GOT address of libc", "[esp+0x8] == NULL", "eax == 0x0", "{\"sh\", \"-c\", [esp+0xc], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x24, environ)")
OneGadget::Gadget.add(build_id, 240095,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x8] == NULL", "eax == 0x0", "{\"sh\", \"-c\", [esp+0xc], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x24, environ)")
OneGadget::Gadget.add(build_id, 240106,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x8] == NULL", "eax == 0x0", "{\"sh\", \"-c\", [esp+0xc], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x24, environ)")
OneGadget::Gadget.add(build_id, 240756,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x8] == NULL", "{\"sh\", \"-c\", [esp+0xc], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x24, environ)")
OneGadget::Gadget.add(build_id, 240762,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x8] == NULL", "eax == NULL || {eax, \"-c\", [esp+0xc], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x24, environ)")
OneGadget::Gadget.add(build_id, 240770,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x8] == NULL", "eax == NULL || {eax, \"-c\", [esp+0xc], [esp+0x30], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x24, environ)")
OneGadget::Gadget.add(build_id, 240774,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x8] == NULL", "[esp+0x24] == NULL || {[esp+0x24], \"-c\", [esp+0xc], [esp+0x30], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x24, environ)")
OneGadget::Gadget.add(build_id, 240780,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x8] == NULL", "[esp+0x24] == NULL || {[esp+0x24], eax, [esp+0xc], [esp+0x30], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x24, environ)")
OneGadget::Gadget.add(build_id, 240784,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x8] == NULL", "[esp+0x24] == NULL || {[esp+0x24], [esp+0x28], [esp+0xc], [esp+0x30], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x24, environ)")
OneGadget::Gadget.add(build_id, 240788,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x8] == NULL", "[esp+0x24] == NULL || {[esp+0x24], [esp+0x28], eax, [esp+0x30], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x24, environ)")
OneGadget::Gadget.add(build_id, 240792,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x8] == NULL", "[esp+0x24] == NULL || {[esp+0x24], [esp+0x28], [esp+0x2c], [esp+0x30], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x24, environ)")
OneGadget::Gadget.add(build_id, 240798,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x8] == NULL", "eax == NULL", "[esp+0x24] == NULL || {[esp+0x24], [esp+0x28], [esp+0x2c], [esp+0x30], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x24, environ)")
OneGadget::Gadget.add(build_id, 240799,
                      constraints: ["ebx is the GOT address of libc", "[esp+0xc] == NULL", "eax == NULL", "[esp+0x28] == NULL || {[esp+0x28], [esp+0x2c], [esp+0x30], [esp+0x34], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x28, environ)")
OneGadget::Gadget.add(build_id, 240801,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x10] == NULL", "[esp] == NULL", "eax == NULL", "[esp+0x2c] == NULL || {[esp+0x2c], [esp+0x30], [esp+0x34], [esp+0x38], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x2c, environ)")
OneGadget::Gadget.add(build_id, 240802,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x14] == NULL", "[esp+0x4] == NULL", "[esp] == NULL", "[esp+0x30] == NULL || {[esp+0x30], [esp+0x34], [esp+0x38], [esp+0x3c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 240804,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x4] == NULL", "[esp+0x8] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 240809,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 240815,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "eax == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 240818,
                      constraints: ["ebx is the GOT address of libc", "[esp+0xc] == NULL", "eax == NULL", "[esp+0x28] == NULL || {[esp+0x28], [esp+0x2c], [esp+0x30], [esp+0x34], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x28, environ)")
OneGadget::Gadget.add(build_id, 240820,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x10] == NULL", "[esp] == NULL", "eax == NULL", "[esp+0x2c] == NULL || {[esp+0x2c], [esp+0x30], [esp+0x34], [esp+0x38], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x2c, environ)")
OneGadget::Gadget.add(build_id, 240821,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x14] == NULL", "[esp+0x4] == NULL", "[esp] == NULL", "[esp+0x30] == NULL || {[esp+0x30], [esp+0x34], [esp+0x38], [esp+0x3c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 240823,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x4] == NULL", "[esp+0x8] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 240828,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 240831,
                      constraints: ["ebx is the GOT address of libc", "[esp+0xc] == NULL", "[esp+0x28] == NULL || {[esp+0x28], [esp+0x2c], [esp+0x30], [esp+0x34], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x28, environ)")
OneGadget::Gadget.add(build_id, 240833,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x10] == NULL", "[esp+0x2c] == NULL || {[esp+0x2c], [esp+0x30], [esp+0x34], [esp+0x38], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x2c, environ)")
OneGadget::Gadget.add(build_id, 240837,
                      constraints: ["ebx is the GOT address of libc", "[esp] == NULL", "[esp+0x30] == NULL || {[esp+0x30], [esp+0x34], [esp+0x38], [esp+0x3c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 240839,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x4] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 240844,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 240850,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv", "[[eax]] == NULL || [eax] == NULL || [eax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x34, [eax])")
OneGadget::Gadget.add(build_id, 240853,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x28] == NULL || {[esp+0x28], [esp+0x2c], [esp+0x30], [esp+0x34], ...} is a valid argv", "[[eax]] == NULL || [eax] == NULL || [eax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x28, [eax])")
OneGadget::Gadget.add(build_id, 240863,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x28] == NULL || {[esp+0x28], [esp+0x2c], [esp+0x30], [esp+0x34], ...} is a valid argv", "[[eax]] == NULL || [eax] == NULL || [eax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x28, [eax])")
OneGadget::Gadget.add(build_id, 240873,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x28] == NULL || {[esp+0x28], [esp+0x2c], [esp+0x30], [esp+0x34], ...} is a valid argv", "[[eax]] == NULL || [eax] == NULL || [eax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x28, [eax])")
OneGadget::Gadget.add(build_id, 240875,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x2c] == NULL || {[esp+0x2c], [esp+0x30], [esp+0x34], [esp+0x38], ...} is a valid argv", "[[esp]] == NULL || [esp] == NULL || [esp] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x2c, [esp])")
OneGadget::Gadget.add(build_id, 240879,
                      constraints: ["ebx is the GOT address of libc", "[eax] == NULL || eax == NULL || eax is a valid argv", "[[esp]] == NULL || [esp] == NULL || [esp] is a valid envp"],
                      effect: "execve(\"/bin/sh\", eax, [esp])")
OneGadget::Gadget.add(build_id, 240880,
                      constraints: ["ebx is the GOT address of libc", "[[esp]] == NULL || [esp] == NULL || [esp] is a valid argv", "[[esp+0x4]] == NULL || [esp+0x4] == NULL || [esp+0x4] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [esp], [esp+0x4])")
OneGadget::Gadget.add(build_id, 402644,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 402647,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 402649,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 402653,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 402654,
                      constraints: ["ebx is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", [esp])")
OneGadget::Gadget.add(build_id, 402660,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", eax)")
OneGadget::Gadget.add(build_id, 402661,
                      constraints: ["ebx is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", [esp])")
OneGadget::Gadget.add(build_id, 733226,
                      constraints: ["ebx is the GOT address of libc", "esi == 0x1", "writable: (esp+0xf & 0xfffffff0)", "writable: ebp-0x1c", "[ebp+0x8] == NULL || {\"sh\", [ebp+0x8], [(esp+0xf & 0xfffffff0)+0x8], [(esp+0xf & 0xfffffff0)+0xc], ...} is a valid argv", "[[ebp+0x10]] == NULL || [ebp+0x10] == NULL || [ebp+0x10] is a valid envp"],
                      effect: "execve(\"/bin/sh\", (esp+0xf & 0xfffffff0), [ebp+0x10])")
OneGadget::Gadget.add(build_id, 733230,
                      constraints: ["ebx is the GOT address of libc", "esi == 0x1", "writable: (eax & 0xfffffff0)", "writable: ebp-0x1c", "[ebp+0x8] == NULL || {\"sh\", [ebp+0x8], [(eax & 0xfffffff0)+0x8], [(eax & 0xfffffff0)+0xc], ...} is a valid argv", "[[ebp+0x10]] == NULL || [ebp+0x10] == NULL || [ebp+0x10] is a valid envp"],
                      effect: "execve(\"/bin/sh\", (eax & 0xfffffff0), [ebp+0x10])")
OneGadget::Gadget.add(build_id, 733233,
                      constraints: ["ebx is the GOT address of libc", "esi == 0x1", "writable: eax", "writable: ebp-0x1c", "[ebp+0x8] == NULL || {\"sh\", [ebp+0x8], [eax+0x8], [eax+0xc], ...} is a valid argv", "[[ebp+0x10]] == NULL || [ebp+0x10] == NULL || [ebp+0x10] is a valid envp"],
                      effect: "execve(\"/bin/sh\", eax, [ebp+0x10])")
OneGadget::Gadget.add(build_id, 733949,
                      constraints: ["ebx is the GOT address of libc", "esi == 0x1", "writable: eax", "writable: ebp-0x1c", "[ebp+0x8] == NULL || {\"sh\", [ebp+0x8], [eax+0x8], [eax+0xc], ...} is a valid argv", "[[ebp+0x10]] == NULL || [ebp+0x10] == NULL || [ebp+0x10] is a valid envp"],
                      effect: "execve(\"/bin/sh\", eax, [ebp+0x10])")
OneGadget::Gadget.add(build_id, 733952,
                      constraints: ["ebx is the GOT address of libc", "esi == 0x1", "writable: eax", "writable: ebp-0x1c", "[ebp+0x8] == NULL || {\"sh\", [ebp+0x8], [eax+0x8], [eax+0xc], ...} is a valid argv", "[[ebp+0x10]] == NULL || [ebp+0x10] == NULL || [ebp+0x10] is a valid envp"],
                      effect: "execve(\"/bin/sh\", eax, [ebp+0x10])")
OneGadget::Gadget.add(build_id, 1187651,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1187654,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1187656,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1187660,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1187661,
                      constraints: ["esi is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", [esp])")
OneGadget::Gadget.add(build_id, 1187667,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", eax)")
OneGadget::Gadget.add(build_id, 1187668,
                      constraints: ["esi is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", [esp])")

