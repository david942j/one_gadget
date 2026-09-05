require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc6-i386_2.23-0ubuntu11.2_amd64/lib32/libc-2.23.so
# 
# Intel 80386
# 
# GNU C Library (Ubuntu GLIBC 2.23-0ubuntu11.2) stable release version 2.23, by Roland McGrath et al.
# Copyright (C) 2016 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 5.4.0 20160609.
# Available extensions:
# 	crypt add-on version 2.1 by Michael Glad and others
# 	GNU Libidn by Simon Josefsson
# 	Native POSIX Threads Library by Ulrich Drepper et al
# 	BIND-8.2.3-T5B
# libc ABIs: UNIQUE IFUNC
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 238969,
                      constraints: ["esi is the GOT address of libc", "[esp+0xc] == NULL", "eax == 0x0", "{\"sh\", \"-c\", [esp+0x8], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x24, environ)")
OneGadget::Gadget.add(build_id, 238980,
                      constraints: ["esi is the GOT address of libc", "[esp+0xc] == NULL", "eax == 0x0", "{\"sh\", \"-c\", [esp+0x8], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x24, environ)")
OneGadget::Gadget.add(build_id, 239373,
                      constraints: ["esi is the GOT address of libc", "[esp+0xc] == NULL", "eax == 0x0", "{\"sh\", \"-c\", [esp+0x8], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x24, environ)")
OneGadget::Gadget.add(build_id, 239567,
                      constraints: ["esi is the GOT address of libc", "[esp+0xc] == NULL", "{\"sh\", \"-c\", [esp+0x8], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x24, environ)")
OneGadget::Gadget.add(build_id, 239573,
                      constraints: ["esi is the GOT address of libc", "[esp+0xc] == NULL", "eax == NULL || {eax, \"-c\", [esp+0x8], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x24, environ)")
OneGadget::Gadget.add(build_id, 239581,
                      constraints: ["esi is the GOT address of libc", "[esp+0xc] == NULL", "eax == NULL || {eax, \"-c\", [esp+0x8], [esp+0x30], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x24, environ)")
OneGadget::Gadget.add(build_id, 239583,
                      constraints: ["esi is the GOT address of libc", "[esp+0xc] == NULL", "eax == NULL || {eax, \"-c\", [esp+0x8], [esp+0x30], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x24, environ)")
OneGadget::Gadget.add(build_id, 239587,
                      constraints: ["esi is the GOT address of libc", "[esp+0xc] == NULL", "[esp+0x24] == NULL || {[esp+0x24], \"-c\", [esp+0x8], [esp+0x30], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x24, environ)")
OneGadget::Gadget.add(build_id, 239593,
                      constraints: ["esi is the GOT address of libc", "[esp+0xc] == NULL", "[esp+0x24] == NULL || {[esp+0x24], eax, [esp+0x8], [esp+0x30], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x24, environ)")
OneGadget::Gadget.add(build_id, 239597,
                      constraints: ["esi is the GOT address of libc", "[esp+0xc] == NULL", "[esp+0x24] == NULL || {[esp+0x24], [esp+0x28], [esp+0x8], [esp+0x30], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x24, environ)")
OneGadget::Gadget.add(build_id, 239601,
                      constraints: ["esi is the GOT address of libc", "[esp+0xc] == NULL", "[esp+0x24] == NULL || {[esp+0x24], [esp+0x28], eax, [esp+0x30], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x24, environ)")
OneGadget::Gadget.add(build_id, 239605,
                      constraints: ["esi is the GOT address of libc", "[esp+0xc] == NULL", "[esp+0x24] == NULL || {[esp+0x24], [esp+0x28], [esp+0x2c], [esp+0x30], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x24, environ)")
OneGadget::Gadget.add(build_id, 239606,
                      constraints: ["esi is the GOT address of libc", "[esp+0x10] == NULL", "[esp+0x28] == NULL || {[esp+0x28], [esp+0x2c], [esp+0x30], [esp+0x34], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x28, environ)")
OneGadget::Gadget.add(build_id, 239612,
                      constraints: ["esi is the GOT address of libc", "[esp+0x10] == NULL", "eax == NULL", "[esp+0x28] == NULL || {[esp+0x28], [esp+0x2c], [esp+0x30], [esp+0x34], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x28, environ)")
OneGadget::Gadget.add(build_id, 239614,
                      constraints: ["esi is the GOT address of libc", "[esp+0x14] == NULL", "[esp] == NULL", "eax == NULL", "[esp+0x2c] == NULL || {[esp+0x2c], [esp+0x30], [esp+0x34], [esp+0x38], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x2c, environ)")
OneGadget::Gadget.add(build_id, 239615,
                      constraints: ["esi is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x4] == NULL", "[esp] == NULL", "[esp+0x30] == NULL || {[esp+0x30], [esp+0x34], [esp+0x38], [esp+0x3c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 239617,
                      constraints: ["esi is the GOT address of libc", "[esp+0x1c] == NULL", "[esp+0x4] == NULL", "[esp+0x8] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 239622,
                      constraints: ["esi is the GOT address of libc", "[esp+0x1c] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 239628,
                      constraints: ["esi is the GOT address of libc", "[esp+0x1c] == NULL", "eax == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 239631,
                      constraints: ["esi is the GOT address of libc", "[esp+0x10] == NULL", "eax == NULL", "[esp+0x28] == NULL || {[esp+0x28], [esp+0x2c], [esp+0x30], [esp+0x34], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x28, environ)")
OneGadget::Gadget.add(build_id, 239633,
                      constraints: ["esi is the GOT address of libc", "[esp+0x14] == NULL", "[esp] == NULL", "eax == NULL", "[esp+0x2c] == NULL || {[esp+0x2c], [esp+0x30], [esp+0x34], [esp+0x38], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x2c, environ)")
OneGadget::Gadget.add(build_id, 239634,
                      constraints: ["esi is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x4] == NULL", "[esp] == NULL", "[esp+0x30] == NULL || {[esp+0x30], [esp+0x34], [esp+0x38], [esp+0x3c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 239636,
                      constraints: ["esi is the GOT address of libc", "[esp+0x1c] == NULL", "[esp+0x4] == NULL", "[esp+0x8] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 239641,
                      constraints: ["esi is the GOT address of libc", "[esp+0x1c] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 239644,
                      constraints: ["esi is the GOT address of libc", "[esp+0x10] == NULL", "[esp+0x28] == NULL || {[esp+0x28], [esp+0x2c], [esp+0x30], [esp+0x34], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x28, environ)")
OneGadget::Gadget.add(build_id, 239646,
                      constraints: ["esi is the GOT address of libc", "[esp+0x14] == NULL", "[esp+0x2c] == NULL || {[esp+0x2c], [esp+0x30], [esp+0x34], [esp+0x38], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x2c, environ)")
OneGadget::Gadget.add(build_id, 239650,
                      constraints: ["esi is the GOT address of libc", "[esp] == NULL", "[esp+0x30] == NULL || {[esp+0x30], [esp+0x34], [esp+0x38], [esp+0x3c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 239652,
                      constraints: ["esi is the GOT address of libc", "[esp+0x4] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 239657,
                      constraints: ["esi is the GOT address of libc", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 239663,
                      constraints: ["esi is the GOT address of libc", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv", "[[eax]] == NULL || [eax] == NULL || [eax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x34, [eax])")
OneGadget::Gadget.add(build_id, 239666,
                      constraints: ["esi is the GOT address of libc", "[esp+0x28] == NULL || {[esp+0x28], [esp+0x2c], [esp+0x30], [esp+0x34], ...} is a valid argv", "[[eax]] == NULL || [eax] == NULL || [eax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x28, [eax])")
OneGadget::Gadget.add(build_id, 239676,
                      constraints: ["esi is the GOT address of libc", "[esp+0x28] == NULL || {[esp+0x28], [esp+0x2c], [esp+0x30], [esp+0x34], ...} is a valid argv", "[[eax]] == NULL || [eax] == NULL || [eax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x28, [eax])")
OneGadget::Gadget.add(build_id, 239686,
                      constraints: ["esi is the GOT address of libc", "[esp+0x28] == NULL || {[esp+0x28], [esp+0x2c], [esp+0x30], [esp+0x34], ...} is a valid argv", "[[eax]] == NULL || [eax] == NULL || [eax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x28, [eax])")
OneGadget::Gadget.add(build_id, 239688,
                      constraints: ["esi is the GOT address of libc", "[esp+0x2c] == NULL || {[esp+0x2c], [esp+0x30], [esp+0x34], [esp+0x38], ...} is a valid argv", "[[esp]] == NULL || [esp] == NULL || [esp] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x2c, [esp])")
OneGadget::Gadget.add(build_id, 239692,
                      constraints: ["esi is the GOT address of libc", "[eax] == NULL || eax == NULL || eax is a valid argv", "[[esp]] == NULL || [esp] == NULL || [esp] is a valid envp"],
                      effect: "execve(\"/bin/sh\", eax, [esp])")
OneGadget::Gadget.add(build_id, 239693,
                      constraints: ["esi is the GOT address of libc", "[[esp]] == NULL || [esp] == NULL || [esp] is a valid argv", "[[esp+0x4]] == NULL || [esp+0x4] == NULL || [esp+0x4] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [esp], [esp+0x4])")
OneGadget::Gadget.add(build_id, 389221,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 389224,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 389226,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 389230,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 389231,
                      constraints: ["esi is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", [esp])")
OneGadget::Gadget.add(build_id, 389237,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", eax)")
OneGadget::Gadget.add(build_id, 389238,
                      constraints: ["esi is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", [esp])")
OneGadget::Gadget.add(build_id, 720042,
                      constraints: ["ebx is the GOT address of libc", "esi == 0x1", "writable: (esp+0xf & 0xfffffff0)", "writable: ebp-0x1c", "[ebp+0x8] == NULL || {\"sh\", [ebp+0x8], [(esp+0xf & 0xfffffff0)+0x8], [(esp+0xf & 0xfffffff0)+0xc], ...} is a valid argv", "[[ebp+0x10]] == NULL || [ebp+0x10] == NULL || [ebp+0x10] is a valid envp"],
                      effect: "execve(\"/bin/sh\", (esp+0xf & 0xfffffff0), [ebp+0x10])")
OneGadget::Gadget.add(build_id, 720046,
                      constraints: ["ebx is the GOT address of libc", "esi == 0x1", "writable: (eax & 0xfffffff0)", "writable: ebp-0x1c", "[ebp+0x8] == NULL || {\"sh\", [ebp+0x8], [(eax & 0xfffffff0)+0x8], [(eax & 0xfffffff0)+0xc], ...} is a valid argv", "[[ebp+0x10]] == NULL || [ebp+0x10] == NULL || [ebp+0x10] is a valid envp"],
                      effect: "execve(\"/bin/sh\", (eax & 0xfffffff0), [ebp+0x10])")
OneGadget::Gadget.add(build_id, 720049,
                      constraints: ["ebx is the GOT address of libc", "esi == 0x1", "writable: eax", "writable: ebp-0x1c", "[ebp+0x8] == NULL || {\"sh\", [ebp+0x8], [eax+0x8], [eax+0xc], ...} is a valid argv", "[[ebp+0x10]] == NULL || [ebp+0x10] == NULL || [ebp+0x10] is a valid envp"],
                      effect: "execve(\"/bin/sh\", eax, [ebp+0x10])")
OneGadget::Gadget.add(build_id, 720749,
                      constraints: ["ebx is the GOT address of libc", "esi == 0x1", "writable: eax", "writable: ebp-0x1c", "[ebp+0x8] == NULL || {\"sh\", [ebp+0x8], [eax+0x8], [eax+0xc], ...} is a valid argv", "[[ebp+0x10]] == NULL || [ebp+0x10] == NULL || [ebp+0x10] is a valid envp"],
                      effect: "execve(\"/bin/sh\", eax, [ebp+0x10])")
OneGadget::Gadget.add(build_id, 720752,
                      constraints: ["ebx is the GOT address of libc", "esi == 0x1", "writable: eax", "writable: ebp-0x1c", "[ebp+0x8] == NULL || {\"sh\", [ebp+0x8], [eax+0x8], [eax+0xc], ...} is a valid argv", "[[ebp+0x10]] == NULL || [ebp+0x10] == NULL || [ebp+0x10] is a valid envp"],
                      effect: "execve(\"/bin/sh\", eax, [ebp+0x10])")
OneGadget::Gadget.add(build_id, 1170716,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1170719,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1170721,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1170725,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1170726,
                      constraints: ["esi is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", [esp])")
OneGadget::Gadget.add(build_id, 1170732,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", eax)")
OneGadget::Gadget.add(build_id, 1170733,
                      constraints: ["esi is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", [esp])")

