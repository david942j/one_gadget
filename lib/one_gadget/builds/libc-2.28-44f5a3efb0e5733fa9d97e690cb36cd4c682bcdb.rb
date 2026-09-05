require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc6-i386_2.28-0ubuntu1_amd64/lib32/libc-2.28.so
# 
# Intel 80386
# 
# GNU C Library (Ubuntu GLIBC 2.28-0ubuntu1) stable release version 2.28.
# Copyright (C) 2018 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 8.2.0.
# libc ABIs: UNIQUE IFUNC ABSOLUTE
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 255571,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "eax == 0x0", "{\"sh\", \"-c\", ebp, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 255573,
                      constraints: ["esi is the GOT address of libc", "(u32)eax <= 0xfffff000", "[esp+0x8] == NULL", "edx == 0x0", "{\"sh\", \"-c\", ebp, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 255584,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "edx == 0x0", "{\"sh\", \"-c\", ebp, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 255588,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "edx == 0x0", "{\"sh\", \"-c\", ebp, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 255973,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "eax == 0x0", "{\"sh\", \"-c\", ebp, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 255975,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "edx == 0x0", "{\"sh\", \"-c\", ebp, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 256159,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "{\"sh\", \"-c\", ebp, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 256165,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "eax == NULL || {eax, \"-c\", ebp, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 256169,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "eax == NULL || {eax, \"-c\", [esp+0x38], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 256173,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "[esp+0x30] == NULL || {[esp+0x30], \"-c\", [esp+0x38], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 256179,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "[esp+0x30] == NULL || {[esp+0x30], eax, [esp+0x38], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 256183,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "[esp+0x30] == NULL || {[esp+0x30], [esp+0x34], [esp+0x38], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 256191,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "[esp+0x30] == NULL || {[esp+0x30], [esp+0x34], [esp+0x38], [esp+0x3c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 256192,
                      constraints: ["esi is the GOT address of libc", "[esp+0xc] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 256198,
                      constraints: ["esi is the GOT address of libc", "[esp+0xc] == NULL", "eax == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 256200,
                      constraints: ["esi is the GOT address of libc", "[esp+0x10] == NULL", "[esp] == NULL", "eax == NULL", "[esp+0x38] == NULL || {[esp+0x38], [esp+0x3c], [esp+0x40], [esp+0x44], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x38, environ)")
OneGadget::Gadget.add(build_id, 256201,
                      constraints: ["esi is the GOT address of libc", "[esp+0x14] == NULL", "[esp+0x4] == NULL", "[esp] == NULL", "[esp+0x3c] == NULL || {[esp+0x3c], [esp+0x40], [esp+0x44], [esp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 256203,
                      constraints: ["esi is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x4] == NULL", "[esp+0x8] == NULL", "[esp+0x40] == NULL || {[esp+0x40], [esp+0x44], [esp+0x48], [esp+0x4c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x40, environ)")
OneGadget::Gadget.add(build_id, 256208,
                      constraints: ["esi is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x40] == NULL || {[esp+0x40], [esp+0x44], [esp+0x48], [esp+0x4c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x40, environ)")
OneGadget::Gadget.add(build_id, 256211,
                      constraints: ["esi is the GOT address of libc", "[esp+0xc] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 256217,
                      constraints: ["esi is the GOT address of libc", "[esp+0xc] == NULL", "eax == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 256219,
                      constraints: ["esi is the GOT address of libc", "[esp+0x10] == NULL", "[esp] == NULL", "eax == NULL", "[esp+0x38] == NULL || {[esp+0x38], [esp+0x3c], [esp+0x40], [esp+0x44], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x38, environ)")
OneGadget::Gadget.add(build_id, 256220,
                      constraints: ["esi is the GOT address of libc", "[esp+0x14] == NULL", "[esp+0x4] == NULL", "[esp] == NULL", "[esp+0x3c] == NULL || {[esp+0x3c], [esp+0x40], [esp+0x44], [esp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 256222,
                      constraints: ["esi is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x4] == NULL", "[esp+0x8] == NULL", "[esp+0x40] == NULL || {[esp+0x40], [esp+0x44], [esp+0x48], [esp+0x4c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x40, environ)")
OneGadget::Gadget.add(build_id, 256227,
                      constraints: ["esi is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x40] == NULL || {[esp+0x40], [esp+0x44], [esp+0x48], [esp+0x4c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x40, environ)")
OneGadget::Gadget.add(build_id, 256230,
                      constraints: ["esi is the GOT address of libc", "[esp+0xc] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 256232,
                      constraints: ["esi is the GOT address of libc", "[esp+0x10] == NULL", "[esp+0x38] == NULL || {[esp+0x38], [esp+0x3c], [esp+0x40], [esp+0x44], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x38, environ)")
OneGadget::Gadget.add(build_id, 256236,
                      constraints: ["esi is the GOT address of libc", "[esp] == NULL", "[esp+0x3c] == NULL || {[esp+0x3c], [esp+0x40], [esp+0x44], [esp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 256238,
                      constraints: ["esi is the GOT address of libc", "[esp+0x4] == NULL", "[esp+0x40] == NULL || {[esp+0x40], [esp+0x44], [esp+0x48], [esp+0x4c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x40, environ)")
OneGadget::Gadget.add(build_id, 256243,
                      constraints: ["esi is the GOT address of libc", "[esp+0x40] == NULL || {[esp+0x40], [esp+0x44], [esp+0x48], [esp+0x4c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x40, environ)")
OneGadget::Gadget.add(build_id, 256249,
                      constraints: ["esi is the GOT address of libc", "[esp+0x40] == NULL || {[esp+0x40], [esp+0x44], [esp+0x48], [esp+0x4c], ...} is a valid argv", "[[eax]] == NULL || [eax] == NULL || [eax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x40, [eax])")
OneGadget::Gadget.add(build_id, 256252,
                      constraints: ["esi is the GOT address of libc", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv", "[[eax]] == NULL || [eax] == NULL || [eax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x34, [eax])")
OneGadget::Gadget.add(build_id, 256262,
                      constraints: ["esi is the GOT address of libc", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv", "[[eax]] == NULL || [eax] == NULL || [eax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x34, [eax])")
OneGadget::Gadget.add(build_id, 256272,
                      constraints: ["esi is the GOT address of libc", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv", "[[eax]] == NULL || [eax] == NULL || [eax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x34, [eax])")
OneGadget::Gadget.add(build_id, 256274,
                      constraints: ["esi is the GOT address of libc", "[esp+0x38] == NULL || {[esp+0x38], [esp+0x3c], [esp+0x40], [esp+0x44], ...} is a valid argv", "[[esp]] == NULL || [esp] == NULL || [esp] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x38, [esp])")
OneGadget::Gadget.add(build_id, 256278,
                      constraints: ["esi is the GOT address of libc", "[eax] == NULL || eax == NULL || eax is a valid argv", "[[esp]] == NULL || [esp] == NULL || [esp] is a valid envp"],
                      effect: "execve(\"/bin/sh\", eax, [esp])")
OneGadget::Gadget.add(build_id, 256279,
                      constraints: ["esi is the GOT address of libc", "[[esp]] == NULL || [esp] == NULL || [esp] is a valid argv", "[[esp+0x4]] == NULL || [esp+0x4] == NULL || [esp+0x4] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [esp], [esp+0x4])")
OneGadget::Gadget.add(build_id, 429838,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 429840,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 429844,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 429845,
                      constraints: ["esi is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", [esp])")
OneGadget::Gadget.add(build_id, 429851,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", eax)")
OneGadget::Gadget.add(build_id, 429852,
                      constraints: ["esi is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", [esp])")
OneGadget::Gadget.add(build_id, 789057,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x30", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[ecx] == NULL || ecx == NULL || ecx is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x30])")
OneGadget::Gadget.add(build_id, 789060,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x30", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[ecx] == NULL || ecx == NULL || ecx is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x30])")
OneGadget::Gadget.add(build_id, 789063,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x30", "[ebp-0x2c] == NULL || {\"/bin/sh\", [ebp-0x2c], NULL} is a valid argv", "[ecx] == NULL || ecx == NULL || ecx is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x30])")
OneGadget::Gadget.add(build_id, 789066,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x28", "[ebp-0x2c] == NULL || {\"/bin/sh\", [ebp-0x2c], NULL} is a valid argv", "[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x30])")
OneGadget::Gadget.add(build_id, 789072,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x28", "[ebp-0x2c] == NULL || {\"/bin/sh\", [ebp-0x2c], NULL} is a valid argv", "[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x30])")
OneGadget::Gadget.add(build_id, 789075,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x28", "[ebp-0x2c] == NULL || {\"/bin/sh\", [ebp-0x2c], NULL} is a valid argv", "[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x30])")
OneGadget::Gadget.add(build_id, 789077,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x28", "[ebp-0x2c] == NULL || {\"/bin/sh\", [ebp-0x2c], NULL} is a valid argv", "[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x30])")
OneGadget::Gadget.add(build_id, 789079,
                      constraints: ["ebx is the GOT address of libc", "eax == 0x0", "writable: ebp-0x28", "[ebp-0x2c] == NULL || {\"/bin/sh\", [ebp-0x2c], NULL} is a valid argv", "[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x30])")
OneGadget::Gadget.add(build_id, 789111,
                      constraints: ["ebx is the GOT address of libc", "ecx == 0x1", "edi == 0x0", "writable: ebp-0x34", "[ebp-0x2c] == NULL || {\"/bin/sh\", [ebp-0x2c], NULL} is a valid argv", "[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x30])")
OneGadget::Gadget.add(build_id, 789115,
                      constraints: ["ebx is the GOT address of libc", "ecx == 0x1", "writable: ebp-0x34", "[ebp-0x2c] == NULL || {\"/bin/sh\", [ebp-0x2c], NULL} is a valid argv", "[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x30])")
OneGadget::Gadget.add(build_id, 789118,
                      constraints: ["ebx is the GOT address of libc", "ecx == 0x1", "writable: ebp-0x28", "[ebp-0x2c] == NULL || {\"/bin/sh\", [ebp-0x2c], NULL} is a valid argv", "[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x30])")
OneGadget::Gadget.add(build_id, 789231,
                      constraints: ["ebx is the GOT address of libc", "writable: ebp-0x28", "[ebp-0x2c] == NULL || {\"/bin/sh\", [ebp-0x2c], NULL} is a valid argv", "[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x30])")
OneGadget::Gadget.add(build_id, 789232,
                      constraints: ["ebx is the GOT address of libc", "writable: ebp-0x28", "[ebp-0x2c] == NULL || {\"/bin/sh\", [ebp-0x2c], NULL} is a valid argv", "[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x30])")
OneGadget::Gadget.add(build_id, 789235,
                      constraints: ["ebx is the GOT address of libc", "writable: ebp-0x28", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x30])")
OneGadget::Gadget.add(build_id, 1279695,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1279697,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1279698,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1279699,
                      constraints: ["esi is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", [esp])")
OneGadget::Gadget.add(build_id, 1279705,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", eax)")
OneGadget::Gadget.add(build_id, 1279706,
                      constraints: ["esi is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", [esp])")

