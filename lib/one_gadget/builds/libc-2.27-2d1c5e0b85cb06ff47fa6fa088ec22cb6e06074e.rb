require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc6-i386_2.27-3ubuntu1.2_amd64/lib32/libc-2.27.so
# 
# Intel 80386
# 
# GNU C Library (Ubuntu GLIBC 2.27-3ubuntu1.2) stable release version 2.27.
# Copyright (C) 2018 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 7.5.0.
# libc ABIs: UNIQUE IFUNC
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 248316,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "eax == 0x0", "{\"sh\", \"-c\", [esp+0xc], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 248329,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "edx == 0x0", "{\"sh\", \"-c\", [esp+0xc], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 248669,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "eax == 0x0", "{\"sh\", \"-c\", [esp+0xc], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 248671,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "edx == 0x0", "{\"sh\", \"-c\", [esp+0xc], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 248847,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "{\"sh\", \"-c\", [esp+0xc], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 248853,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "eax == NULL || {eax, \"-c\", [esp+0xc], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 248861,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "eax == NULL || {eax, \"-c\", [esp+0xc], [esp+0x3c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 248865,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "[esp+0x30] == NULL || {[esp+0x30], \"-c\", [esp+0xc], [esp+0x3c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 248871,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "[esp+0x30] == NULL || {[esp+0x30], eax, [esp+0xc], [esp+0x3c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 248875,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "[esp+0x30] == NULL || {[esp+0x30], [esp+0x34], [esp+0xc], [esp+0x3c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 248879,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "[esp+0x30] == NULL || {[esp+0x30], [esp+0x34], eax, [esp+0x3c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 248883,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "[esp+0x30] == NULL || {[esp+0x30], [esp+0x34], [esp+0x38], [esp+0x3c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 248884,
                      constraints: ["esi is the GOT address of libc", "[esp+0xc] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 248890,
                      constraints: ["esi is the GOT address of libc", "[esp+0xc] == NULL", "eax == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 248892,
                      constraints: ["esi is the GOT address of libc", "[esp+0x10] == NULL", "[esp] == NULL", "eax == NULL", "[esp+0x38] == NULL || {[esp+0x38], [esp+0x3c], [esp+0x40], [esp+0x44], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x38, environ)")
OneGadget::Gadget.add(build_id, 248893,
                      constraints: ["esi is the GOT address of libc", "[esp+0x14] == NULL", "[esp+0x4] == NULL", "[esp] == NULL", "[esp+0x3c] == NULL || {[esp+0x3c], [esp+0x40], [esp+0x44], [esp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 248895,
                      constraints: ["esi is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x4] == NULL", "[esp+0x8] == NULL", "[esp+0x40] == NULL || {[esp+0x40], [esp+0x44], [esp+0x48], [esp+0x4c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x40, environ)")
OneGadget::Gadget.add(build_id, 248900,
                      constraints: ["esi is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x40] == NULL || {[esp+0x40], [esp+0x44], [esp+0x48], [esp+0x4c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x40, environ)")
OneGadget::Gadget.add(build_id, 248906,
                      constraints: ["esi is the GOT address of libc", "[esp+0x18] == NULL", "eax == NULL", "[esp+0x40] == NULL || {[esp+0x40], [esp+0x44], [esp+0x48], [esp+0x4c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x40, environ)")
OneGadget::Gadget.add(build_id, 248909,
                      constraints: ["esi is the GOT address of libc", "[esp+0xc] == NULL", "eax == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 248911,
                      constraints: ["esi is the GOT address of libc", "[esp+0x10] == NULL", "[esp] == NULL", "eax == NULL", "[esp+0x38] == NULL || {[esp+0x38], [esp+0x3c], [esp+0x40], [esp+0x44], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x38, environ)")
OneGadget::Gadget.add(build_id, 248912,
                      constraints: ["esi is the GOT address of libc", "[esp+0x14] == NULL", "[esp+0x4] == NULL", "[esp] == NULL", "[esp+0x3c] == NULL || {[esp+0x3c], [esp+0x40], [esp+0x44], [esp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 248914,
                      constraints: ["esi is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x4] == NULL", "[esp+0x8] == NULL", "[esp+0x40] == NULL || {[esp+0x40], [esp+0x44], [esp+0x48], [esp+0x4c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x40, environ)")
OneGadget::Gadget.add(build_id, 248919,
                      constraints: ["esi is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x40] == NULL || {[esp+0x40], [esp+0x44], [esp+0x48], [esp+0x4c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x40, environ)")
OneGadget::Gadget.add(build_id, 248922,
                      constraints: ["esi is the GOT address of libc", "[esp+0xc] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 248924,
                      constraints: ["esi is the GOT address of libc", "[esp+0x10] == NULL", "[esp+0x38] == NULL || {[esp+0x38], [esp+0x3c], [esp+0x40], [esp+0x44], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x38, environ)")
OneGadget::Gadget.add(build_id, 248928,
                      constraints: ["esi is the GOT address of libc", "[esp] == NULL", "[esp+0x3c] == NULL || {[esp+0x3c], [esp+0x40], [esp+0x44], [esp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 248930,
                      constraints: ["esi is the GOT address of libc", "[esp+0x4] == NULL", "[esp+0x40] == NULL || {[esp+0x40], [esp+0x44], [esp+0x48], [esp+0x4c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x40, environ)")
OneGadget::Gadget.add(build_id, 248935,
                      constraints: ["esi is the GOT address of libc", "[esp+0x40] == NULL || {[esp+0x40], [esp+0x44], [esp+0x48], [esp+0x4c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x40, environ)")
OneGadget::Gadget.add(build_id, 248941,
                      constraints: ["esi is the GOT address of libc", "[esp+0x40] == NULL || {[esp+0x40], [esp+0x44], [esp+0x48], [esp+0x4c], ...} is a valid argv", "[[eax]] == NULL || [eax] == NULL || [eax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x40, [eax])")
OneGadget::Gadget.add(build_id, 248944,
                      constraints: ["esi is the GOT address of libc", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv", "[[eax]] == NULL || [eax] == NULL || [eax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x34, [eax])")
OneGadget::Gadget.add(build_id, 248954,
                      constraints: ["esi is the GOT address of libc", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv", "[[eax]] == NULL || [eax] == NULL || [eax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x34, [eax])")
OneGadget::Gadget.add(build_id, 248964,
                      constraints: ["esi is the GOT address of libc", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv", "[[eax]] == NULL || [eax] == NULL || [eax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x34, [eax])")
OneGadget::Gadget.add(build_id, 248966,
                      constraints: ["esi is the GOT address of libc", "[esp+0x38] == NULL || {[esp+0x38], [esp+0x3c], [esp+0x40], [esp+0x44], ...} is a valid argv", "[[esp]] == NULL || [esp] == NULL || [esp] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x38, [esp])")
OneGadget::Gadget.add(build_id, 248970,
                      constraints: ["esi is the GOT address of libc", "[eax] == NULL || eax == NULL || eax is a valid argv", "[[esp]] == NULL || [esp] == NULL || [esp] is a valid envp"],
                      effect: "execve(\"/bin/sh\", eax, [esp])")
OneGadget::Gadget.add(build_id, 248971,
                      constraints: ["esi is the GOT address of libc", "[[esp]] == NULL || [esp] == NULL || [esp] is a valid argv", "[[esp+0x4]] == NULL || [esp+0x4] == NULL || [esp+0x4] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [esp], [esp+0x4])")
OneGadget::Gadget.add(build_id, 422655,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 422658,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 422660,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 422664,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 422665,
                      constraints: ["esi is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", [esp])")
OneGadget::Gadget.add(build_id, 422671,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", eax)")
OneGadget::Gadget.add(build_id, 422672,
                      constraints: ["esi is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", [esp])")
OneGadget::Gadget.add(build_id, 780353,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x30", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[ecx] == NULL || ecx == NULL || ecx is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], [ebp-0x30])")
OneGadget::Gadget.add(build_id, 780356,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x30", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[ecx] == NULL || ecx == NULL || ecx is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], [ebp-0x30])")
OneGadget::Gadget.add(build_id, 780359,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x2c", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], [ebp-0x30])")
OneGadget::Gadget.add(build_id, 780366,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x2c", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], [ebp-0x30])")
OneGadget::Gadget.add(build_id, 780369,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x2c", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], [ebp-0x30])")
OneGadget::Gadget.add(build_id, 780371,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x2c", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], [ebp-0x30])")
OneGadget::Gadget.add(build_id, 780373,
                      constraints: ["ebx is the GOT address of libc", "ecx == 0x0", "writable: ebp-0x2c", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], [ebp-0x30])")
OneGadget::Gadget.add(build_id, 780410,
                      constraints: ["ebx is the GOT address of libc", "esi == 0x1", "writable: ebp-0x2c", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], [ebp-0x30])")
OneGadget::Gadget.add(build_id, 780522,
                      constraints: ["ebx is the GOT address of libc", "writable: ebp-0x2c", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], [ebp-0x30])")
OneGadget::Gadget.add(build_id, 780528,
                      constraints: ["ebx is the GOT address of libc", "writable: ebp-0x2c", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], [ebp-0x30])")
OneGadget::Gadget.add(build_id, 1268014,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1268017,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1268019,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1268023,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1268024,
                      constraints: ["ebx is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", [esp])")
OneGadget::Gadget.add(build_id, 1268030,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", eax)")
OneGadget::Gadget.add(build_id, 1268031,
                      constraints: ["ebx is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", [esp])")

