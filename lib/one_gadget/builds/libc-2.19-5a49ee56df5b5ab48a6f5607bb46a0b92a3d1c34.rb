require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc6_2.19-0ubuntu6.9_i386/lib/i386-linux-gnu/libc-2.19.so
# 
# Intel 80386
# 
# GNU C Library (Ubuntu EGLIBC 2.19-0ubuntu6.9) stable release version 2.19, by Roland McGrath et al.
# Copyright (C) 2014 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 4.8.4.
# Compiled on a Linux 3.13.11 system on 2016-05-26.
# Available extensions:
# 	crypt add-on version 2.1 by Michael Glad and others
# 	GNU Libidn by Simon Josefsson
# 	Native POSIX Threads Library by Ulrich Drepper et al
# 	BIND-8.2.3-T5B
# libc ABIs: UNIQUE IFUNC
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/eglibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 261847,
                      constraints: ["edi is the GOT address of libc", "[esp+0x18] == NULL", "eax == 0x0", "{\"sh\", \"-c\", [esp+0x1c], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 261849,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "eax == 0x0", "{\"sh\", \"-c\", [esp+0x1c], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 261860,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "eax == 0x0", "{\"sh\", \"-c\", [esp+0x1c], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262455,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "{\"sh\", \"-c\", [esp+0x1c], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262461,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "eax == NULL || {eax, \"-c\", [esp+0x1c], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262465,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x34] == NULL || {[esp+0x34], \"-c\", [esp+0x1c], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262471,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x34] == NULL || {[esp+0x34], eax, [esp+0x1c], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262475,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x1c], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262479,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], eax, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262487,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x8] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], eax, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262494,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x8] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], eax, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262502,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x8] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], eax, [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262506,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x8] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262512,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x8] == NULL", "eax == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262516,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x4] == NULL", "[esp+0x8] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262521,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262527,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "eax == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262535,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x8] == NULL", "eax == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262539,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x4] == NULL", "[esp+0x8] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262546,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x4] == NULL", "[esp+0x8] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262551,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262555,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262563,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262570,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262574,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x4] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262579,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262585,
                      constraints: ["ebx is the GOT address of libc", "readable: eax", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv", "[[eax]] == NULL || [eax] == NULL || [eax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x34, [eax])")
OneGadget::Gadget.add(build_id, 262595,
                      constraints: ["ebx is the GOT address of libc", "readable: eax", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv", "[[eax]] == NULL || [eax] == NULL || [eax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x34, [eax])")
OneGadget::Gadget.add(build_id, 262605,
                      constraints: ["ebx is the GOT address of libc", "readable: eax", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv", "[[eax]] == NULL || [eax] == NULL || [eax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x34, [eax])")
OneGadget::Gadget.add(build_id, 262607,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv", "[eax] == NULL || eax == NULL || eax is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x34, eax)")
OneGadget::Gadget.add(build_id, 262611,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv", "[[esp+0x8]] == NULL || [esp+0x8] == NULL || [esp+0x8] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x34, [esp+0x8])")
OneGadget::Gadget.add(build_id, 262615,
                      constraints: ["ebx is the GOT address of libc", "[eax] == NULL || eax == NULL || eax is a valid argv", "[[esp+0x8]] == NULL || [esp+0x8] == NULL || [esp+0x8] is a valid envp"],
                      effect: "execve(\"/bin/sh\", eax, [esp+0x8])")
OneGadget::Gadget.add(build_id, 262619,
                      constraints: ["ebx is the GOT address of libc", "[[esp+0x4]] == NULL || [esp+0x4] == NULL || [esp+0x4] is a valid argv", "[[esp+0x8]] == NULL || [esp+0x8] == NULL || [esp+0x8] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [esp+0x4], [esp+0x8])")
OneGadget::Gadget.add(build_id, 415381,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 415385,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x8] == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", [esp+0x8])")
OneGadget::Gadget.add(build_id, 415391,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", eax)")
OneGadget::Gadget.add(build_id, 415395,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x4] == NULL"],
                      effect: "execl(\"/bin/sh\", [esp+0x4])")
OneGadget::Gadget.add(build_id, 746970,
                      constraints: ["ebx is the GOT address of libc", "esi == 0x1", "writable: (esp+0x1b & 0xfffffff0)", "writable: ebp-0x1c", "[ebp+0x8] == NULL || {\"sh\", [ebp+0x8], [(esp+0x1b & 0xfffffff0)+0x8], [(esp+0x1b & 0xfffffff0)+0xc], ...} is a valid argv", "[[ebp+0x10]] == NULL || [ebp+0x10] == NULL || [ebp+0x10] is a valid envp"],
                      effect: "execve(\"/bin/sh\", (esp+0x1b & 0xfffffff0), [ebp+0x10])")
OneGadget::Gadget.add(build_id, 746974,
                      constraints: ["ebx is the GOT address of libc", "esi == 0x1", "writable: (edx & 0xfffffff0)", "writable: ebp-0x1c", "[ebp+0x8] == NULL || {\"sh\", [ebp+0x8], [(edx & 0xfffffff0)+0x8], [(edx & 0xfffffff0)+0xc], ...} is a valid argv", "[[ebp+0x10]] == NULL || [ebp+0x10] == NULL || [ebp+0x10] is a valid envp"],
                      effect: "execve(\"/bin/sh\", (edx & 0xfffffff0), [ebp+0x10])")
OneGadget::Gadget.add(build_id, 746977,
                      constraints: ["ebx is the GOT address of libc", "esi == 0x1", "writable: ebp-0x1c", "writable: edx", "[ebp+0x8] == NULL || {\"sh\", [ebp+0x8], [edx+0x8], [edx+0xc], ...} is a valid argv", "[[ebp+0x10]] == NULL || [ebp+0x10] == NULL || [ebp+0x10] is a valid envp"],
                      effect: "execve(\"/bin/sh\", edx, [ebp+0x10])")
OneGadget::Gadget.add(build_id, 747910,
                      constraints: ["ebx is the GOT address of libc", "esi == 0x1", "writable: eax", "writable: ebp-0x1c", "[ebp+0x8] == NULL || {\"sh\", [ebp+0x8], [eax+0x8], [eax+0xc], ...} is a valid argv", "[[ebp+0x10]] == NULL || [ebp+0x10] == NULL || [ebp+0x10] is a valid envp"],
                      effect: "execve(\"/bin/sh\", eax, [ebp+0x10])")
OneGadget::Gadget.add(build_id, 1208726,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1208730,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x8] == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", [esp+0x8])")
OneGadget::Gadget.add(build_id, 1208736,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", eax)")
OneGadget::Gadget.add(build_id, 1208740,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x4] == NULL"],
                      effect: "execl(\"/bin/sh\", [esp+0x4])")

