require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc0.1-2.21-9/lib/i386-kfreebsd-gnu/libc-2.21.so
# 
# Intel 80386
# 
# GNU C Library (Debian GLIBC 2.21-9) stable release version 2.21, by Roland McGrath et al.
# Copyright (C) 2015 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 4.9.3.
# Available extensions:
# 	crypt add-on version 2.1 by Michael Glad and others
# 	Native POSIX Threads Library by Ulrich Drepper et al
# 	GNU Libidn by Simon Josefsson
# 	BIND-8.2.3-T5B
# libc ABIs: UNIQUE
# For bug reporting instructions, please see:
# <http://www.debian.org/Bugs/>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 233155,
                      constraints: ["ebx is the GOT address of libc", "[esp+0xc] == NULL", "eax == 0x0", "{\"sh\", \"-c\", edi, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x28, environ)")
OneGadget::Gadget.add(build_id, 233758,
                      constraints: ["ebx is the GOT address of libc", "[esp+0xc] == NULL", "{\"sh\", \"-c\", edi, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x28, environ)")
OneGadget::Gadget.add(build_id, 233764,
                      constraints: ["ebx is the GOT address of libc", "[esp+0xc] == NULL", "eax == NULL || {eax, \"-c\", edi, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x28, environ)")
OneGadget::Gadget.add(build_id, 233768,
                      constraints: ["ebx is the GOT address of libc", "[esp+0xc] == NULL", "eax == NULL || {eax, \"-c\", [esp+0x30], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x28, environ)")
OneGadget::Gadget.add(build_id, 233776,
                      constraints: ["ebx is the GOT address of libc", "[esp+0xc] == NULL", "eax == NULL || {eax, \"-c\", [esp+0x30], [esp+0x34], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x28, environ)")
OneGadget::Gadget.add(build_id, 233780,
                      constraints: ["ebx is the GOT address of libc", "[esp+0xc] == NULL", "[esp+0x28] == NULL || {[esp+0x28], \"-c\", [esp+0x30], [esp+0x34], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x28, environ)")
OneGadget::Gadget.add(build_id, 233786,
                      constraints: ["ebx is the GOT address of libc", "[esp+0xc] == NULL", "[esp+0x28] == NULL || {[esp+0x28], eax, [esp+0x30], [esp+0x34], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x28, environ)")
OneGadget::Gadget.add(build_id, 233790,
                      constraints: ["ebx is the GOT address of libc", "[esp+0xc] == NULL", "[esp+0x28] == NULL || {[esp+0x28], [esp+0x2c], [esp+0x30], [esp+0x34], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x28, environ)")
OneGadget::Gadget.add(build_id, 233791,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x10] == NULL", "[esp+0x2c] == NULL || {[esp+0x2c], [esp+0x30], [esp+0x34], [esp+0x38], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x2c, environ)")
OneGadget::Gadget.add(build_id, 233797,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x10] == NULL", "eax == NULL", "[esp+0x2c] == NULL || {[esp+0x2c], [esp+0x30], [esp+0x34], [esp+0x38], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x2c, environ)")
OneGadget::Gadget.add(build_id, 233799,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x14] == NULL", "[esp] == NULL", "eax == NULL", "[esp+0x30] == NULL || {[esp+0x30], [esp+0x34], [esp+0x38], [esp+0x3c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 233800,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x4] == NULL", "[esp] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 233802,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x1c] == NULL", "[esp+0x4] == NULL", "[esp+0x8] == NULL", "[esp+0x38] == NULL || {[esp+0x38], [esp+0x3c], [esp+0x40], [esp+0x44], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x38, environ)")
OneGadget::Gadget.add(build_id, 233807,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x1c] == NULL", "[esp+0x38] == NULL || {[esp+0x38], [esp+0x3c], [esp+0x40], [esp+0x44], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x38, environ)")
OneGadget::Gadget.add(build_id, 233813,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x1c] == NULL", "eax == NULL", "[esp+0x38] == NULL || {[esp+0x38], [esp+0x3c], [esp+0x40], [esp+0x44], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x38, environ)")
OneGadget::Gadget.add(build_id, 233816,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x10] == NULL", "eax == NULL", "[esp+0x2c] == NULL || {[esp+0x2c], [esp+0x30], [esp+0x34], [esp+0x38], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x2c, environ)")
OneGadget::Gadget.add(build_id, 233818,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x14] == NULL", "[esp] == NULL", "eax == NULL", "[esp+0x30] == NULL || {[esp+0x30], [esp+0x34], [esp+0x38], [esp+0x3c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 233819,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x4] == NULL", "[esp] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 233821,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x1c] == NULL", "[esp+0x4] == NULL", "[esp+0x8] == NULL", "[esp+0x38] == NULL || {[esp+0x38], [esp+0x3c], [esp+0x40], [esp+0x44], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x38, environ)")
OneGadget::Gadget.add(build_id, 233826,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x1c] == NULL", "[esp+0x38] == NULL || {[esp+0x38], [esp+0x3c], [esp+0x40], [esp+0x44], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x38, environ)")
OneGadget::Gadget.add(build_id, 233829,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x10] == NULL", "[esp+0x2c] == NULL || {[esp+0x2c], [esp+0x30], [esp+0x34], [esp+0x38], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x2c, environ)")
OneGadget::Gadget.add(build_id, 233831,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x14] == NULL", "[esp+0x30] == NULL || {[esp+0x30], [esp+0x34], [esp+0x38], [esp+0x3c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 233835,
                      constraints: ["ebx is the GOT address of libc", "[esp] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 233837,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x4] == NULL", "[esp+0x38] == NULL || {[esp+0x38], [esp+0x3c], [esp+0x40], [esp+0x44], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x38, environ)")
OneGadget::Gadget.add(build_id, 233842,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x38] == NULL || {[esp+0x38], [esp+0x3c], [esp+0x40], [esp+0x44], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x38, environ)")
OneGadget::Gadget.add(build_id, 233848,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x38] == NULL || {[esp+0x38], [esp+0x3c], [esp+0x40], [esp+0x44], ...} is a valid argv", "[[eax]] == NULL || [eax] == NULL || [eax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x38, [eax])")
OneGadget::Gadget.add(build_id, 233851,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x2c] == NULL || {[esp+0x2c], [esp+0x30], [esp+0x34], [esp+0x38], ...} is a valid argv", "[[eax]] == NULL || [eax] == NULL || [eax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x2c, [eax])")
OneGadget::Gadget.add(build_id, 233861,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x2c] == NULL || {[esp+0x2c], [esp+0x30], [esp+0x34], [esp+0x38], ...} is a valid argv", "[[eax]] == NULL || [eax] == NULL || [eax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x2c, [eax])")
OneGadget::Gadget.add(build_id, 233871,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x2c] == NULL || {[esp+0x2c], [esp+0x30], [esp+0x34], [esp+0x38], ...} is a valid argv", "[[eax]] == NULL || [eax] == NULL || [eax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x2c, [eax])")
OneGadget::Gadget.add(build_id, 233873,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x30] == NULL || {[esp+0x30], [esp+0x34], [esp+0x38], [esp+0x3c], ...} is a valid argv", "[[esp]] == NULL || [esp] == NULL || [esp] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x30, [esp])")
OneGadget::Gadget.add(build_id, 233877,
                      constraints: ["ebx is the GOT address of libc", "[eax] == NULL || eax == NULL || eax is a valid argv", "[[esp]] == NULL || [esp] == NULL || [esp] is a valid envp"],
                      effect: "execve(\"/bin/sh\", eax, [esp])")
OneGadget::Gadget.add(build_id, 233878,
                      constraints: ["ebx is the GOT address of libc", "[[esp]] == NULL || [esp] == NULL || [esp] is a valid argv", "[[esp+0x4]] == NULL || [esp+0x4] == NULL || [esp+0x4] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [esp], [esp+0x4])")
OneGadget::Gadget.add(build_id, 395439,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 395442,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 395444,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 395448,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 395449,
                      constraints: ["ebx is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", [esp])")
OneGadget::Gadget.add(build_id, 395455,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", eax)")
OneGadget::Gadget.add(build_id, 395456,
                      constraints: ["ebx is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", [esp])")
OneGadget::Gadget.add(build_id, 645738,
                      constraints: ["ebx is the GOT address of libc", "esi == 0x1", "writable: (esp+0xf & 0xfffffff0)", "writable: ebp-0x1c", "[ebp+0x8] == NULL || {\"sh\", [ebp+0x8], [(esp+0xf & 0xfffffff0)+0x8], [(esp+0xf & 0xfffffff0)+0xc], ...} is a valid argv", "[[ebp+0x10]] == NULL || [ebp+0x10] == NULL || [ebp+0x10] is a valid envp"],
                      effect: "execve(\"/bin/sh\", (esp+0xf & 0xfffffff0), [ebp+0x10])")
OneGadget::Gadget.add(build_id, 645742,
                      constraints: ["ebx is the GOT address of libc", "esi == 0x1", "writable: (edx & 0xfffffff0)", "writable: ebp-0x1c", "[ebp+0x8] == NULL || {\"sh\", [ebp+0x8], [(edx & 0xfffffff0)+0x8], [(edx & 0xfffffff0)+0xc], ...} is a valid argv", "[[ebp+0x10]] == NULL || [ebp+0x10] == NULL || [ebp+0x10] is a valid envp"],
                      effect: "execve(\"/bin/sh\", (edx & 0xfffffff0), [ebp+0x10])")
OneGadget::Gadget.add(build_id, 645745,
                      constraints: ["ebx is the GOT address of libc", "esi == 0x1", "writable: ebp-0x1c", "writable: edx", "[ebp+0x8] == NULL || {\"sh\", [ebp+0x8], [edx+0x8], [edx+0xc], ...} is a valid argv", "[[ebp+0x10]] == NULL || [ebp+0x10] == NULL || [ebp+0x10] is a valid envp"],
                      effect: "execve(\"/bin/sh\", edx, [ebp+0x10])")
OneGadget::Gadget.add(build_id, 646437,
                      constraints: ["ebx is the GOT address of libc", "esi == 0x1", "writable: eax", "writable: ebp-0x1c", "[ebp+0x8] == NULL || {\"sh\", [ebp+0x8], [eax+0x8], [eax+0xc], ...} is a valid argv", "[[ebp+0x10]] == NULL || [ebp+0x10] == NULL || [ebp+0x10] is a valid envp"],
                      effect: "execve(\"/bin/sh\", eax, [ebp+0x10])")
OneGadget::Gadget.add(build_id, 646440,
                      constraints: ["ebx is the GOT address of libc", "esi == 0x1", "writable: eax", "writable: ebp-0x1c", "[ebp+0x8] == NULL || {\"sh\", [ebp+0x8], [eax+0x8], [eax+0xc], ...} is a valid argv", "[[ebp+0x10]] == NULL || [ebp+0x10] == NULL || [ebp+0x10] is a valid envp"],
                      effect: "execve(\"/bin/sh\", eax, [ebp+0x10])")

