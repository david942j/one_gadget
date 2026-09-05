require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc6_2.27-3ubuntu1.4_i386/lib/i386-linux-gnu/libc-2.27.so
# 
# Intel 80386
# 
# GNU C Library (Ubuntu GLIBC 2.27-3ubuntu1.4) stable release version 2.27.
# Copyright (C) 2018 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 7.5.0.
# libc ABIs: UNIQUE IFUNC
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 249644,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "eax == 0x0", "{\"sh\", \"-c\", [esp+0xc], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 249657,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "edx == 0x0", "{\"sh\", \"-c\", [esp+0xc], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 250005,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "eax == 0x0", "{\"sh\", \"-c\", [esp+0xc], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 250007,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "edx == 0x0", "{\"sh\", \"-c\", [esp+0xc], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 250216,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "{\"sh\", \"-c\", [esp+0xc], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 250222,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "eax == NULL || {eax, \"-c\", [esp+0xc], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 250230,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "eax == NULL || {eax, \"-c\", [esp+0xc], [esp+0x3c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 250234,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "[esp+0x30] == NULL || {[esp+0x30], \"-c\", [esp+0xc], [esp+0x3c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 250240,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "[esp+0x30] == NULL || {[esp+0x30], eax, [esp+0xc], [esp+0x3c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 250244,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "[esp+0x30] == NULL || {[esp+0x30], [esp+0x34], [esp+0xc], [esp+0x3c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 250248,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "[esp+0x30] == NULL || {[esp+0x30], [esp+0x34], eax, [esp+0x3c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 250252,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "[esp+0x30] == NULL || {[esp+0x30], [esp+0x34], [esp+0x38], [esp+0x3c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 250253,
                      constraints: ["esi is the GOT address of libc", "[esp+0xc] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 250259,
                      constraints: ["esi is the GOT address of libc", "[esp+0xc] == NULL", "eax == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 250261,
                      constraints: ["esi is the GOT address of libc", "[esp+0x10] == NULL", "[esp] == NULL", "eax == NULL", "[esp+0x38] == NULL || {[esp+0x38], [esp+0x3c], [esp+0x40], [esp+0x44], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x38, environ)")
OneGadget::Gadget.add(build_id, 250262,
                      constraints: ["esi is the GOT address of libc", "[esp+0x14] == NULL", "[esp+0x4] == NULL", "[esp] == NULL", "[esp+0x3c] == NULL || {[esp+0x3c], [esp+0x40], [esp+0x44], [esp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 250264,
                      constraints: ["esi is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x4] == NULL", "[esp+0x8] == NULL", "[esp+0x40] == NULL || {[esp+0x40], [esp+0x44], [esp+0x48], [esp+0x4c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x40, environ)")
OneGadget::Gadget.add(build_id, 250269,
                      constraints: ["esi is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x40] == NULL || {[esp+0x40], [esp+0x44], [esp+0x48], [esp+0x4c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x40, environ)")
OneGadget::Gadget.add(build_id, 250275,
                      constraints: ["esi is the GOT address of libc", "[esp+0x18] == NULL", "eax == NULL", "[esp+0x40] == NULL || {[esp+0x40], [esp+0x44], [esp+0x48], [esp+0x4c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x40, environ)")
OneGadget::Gadget.add(build_id, 250278,
                      constraints: ["esi is the GOT address of libc", "[esp+0xc] == NULL", "eax == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 250280,
                      constraints: ["esi is the GOT address of libc", "[esp+0x10] == NULL", "[esp] == NULL", "eax == NULL", "[esp+0x38] == NULL || {[esp+0x38], [esp+0x3c], [esp+0x40], [esp+0x44], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x38, environ)")
OneGadget::Gadget.add(build_id, 250281,
                      constraints: ["esi is the GOT address of libc", "[esp+0x14] == NULL", "[esp+0x4] == NULL", "[esp] == NULL", "[esp+0x3c] == NULL || {[esp+0x3c], [esp+0x40], [esp+0x44], [esp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 250283,
                      constraints: ["esi is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x4] == NULL", "[esp+0x8] == NULL", "[esp+0x40] == NULL || {[esp+0x40], [esp+0x44], [esp+0x48], [esp+0x4c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x40, environ)")
OneGadget::Gadget.add(build_id, 250288,
                      constraints: ["esi is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x40] == NULL || {[esp+0x40], [esp+0x44], [esp+0x48], [esp+0x4c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x40, environ)")
OneGadget::Gadget.add(build_id, 250291,
                      constraints: ["esi is the GOT address of libc", "[esp+0xc] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 250293,
                      constraints: ["esi is the GOT address of libc", "[esp+0x10] == NULL", "[esp+0x38] == NULL || {[esp+0x38], [esp+0x3c], [esp+0x40], [esp+0x44], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x38, environ)")
OneGadget::Gadget.add(build_id, 250297,
                      constraints: ["esi is the GOT address of libc", "[esp] == NULL", "[esp+0x3c] == NULL || {[esp+0x3c], [esp+0x40], [esp+0x44], [esp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 250299,
                      constraints: ["esi is the GOT address of libc", "[esp+0x4] == NULL", "[esp+0x40] == NULL || {[esp+0x40], [esp+0x44], [esp+0x48], [esp+0x4c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x40, environ)")
OneGadget::Gadget.add(build_id, 250304,
                      constraints: ["esi is the GOT address of libc", "[esp+0x40] == NULL || {[esp+0x40], [esp+0x44], [esp+0x48], [esp+0x4c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x40, environ)")
OneGadget::Gadget.add(build_id, 250310,
                      constraints: ["esi is the GOT address of libc", "[esp+0x40] == NULL || {[esp+0x40], [esp+0x44], [esp+0x48], [esp+0x4c], ...} is a valid argv", "[[eax]] == NULL || [eax] == NULL || [eax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x40, [eax])")
OneGadget::Gadget.add(build_id, 250313,
                      constraints: ["esi is the GOT address of libc", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv", "[[eax]] == NULL || [eax] == NULL || [eax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x34, [eax])")
OneGadget::Gadget.add(build_id, 250323,
                      constraints: ["esi is the GOT address of libc", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv", "[[eax]] == NULL || [eax] == NULL || [eax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x34, [eax])")
OneGadget::Gadget.add(build_id, 250333,
                      constraints: ["esi is the GOT address of libc", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv", "[[eax]] == NULL || [eax] == NULL || [eax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x34, [eax])")
OneGadget::Gadget.add(build_id, 250335,
                      constraints: ["esi is the GOT address of libc", "[esp+0x38] == NULL || {[esp+0x38], [esp+0x3c], [esp+0x40], [esp+0x44], ...} is a valid argv", "[[esp]] == NULL || [esp] == NULL || [esp] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x38, [esp])")
OneGadget::Gadget.add(build_id, 250339,
                      constraints: ["esi is the GOT address of libc", "[eax] == NULL || eax == NULL || eax is a valid argv", "[[esp]] == NULL || [esp] == NULL || [esp] is a valid envp"],
                      effect: "execve(\"/bin/sh\", eax, [esp])")
OneGadget::Gadget.add(build_id, 250340,
                      constraints: ["esi is the GOT address of libc", "[[esp]] == NULL || [esp] == NULL || [esp] is a valid argv", "[[esp+0x4]] == NULL || [esp+0x4] == NULL || [esp+0x4] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [esp], [esp+0x4])")
OneGadget::Gadget.add(build_id, 424911,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 424914,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 424916,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 424920,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 424921,
                      constraints: ["esi is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", [esp])")
OneGadget::Gadget.add(build_id, 424927,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", eax)")
OneGadget::Gadget.add(build_id, 424928,
                      constraints: ["esi is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", [esp])")
OneGadget::Gadget.add(build_id, 785057,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x30", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[ecx] == NULL || ecx == NULL || ecx is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], [ebp-0x30])")
OneGadget::Gadget.add(build_id, 785060,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x30", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[ecx] == NULL || ecx == NULL || ecx is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], [ebp-0x30])")
OneGadget::Gadget.add(build_id, 785063,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x2c", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], [ebp-0x30])")
OneGadget::Gadget.add(build_id, 785070,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x2c", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], [ebp-0x30])")
OneGadget::Gadget.add(build_id, 785073,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x2c", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], [ebp-0x30])")
OneGadget::Gadget.add(build_id, 785075,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x2c", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], [ebp-0x30])")
OneGadget::Gadget.add(build_id, 785077,
                      constraints: ["ebx is the GOT address of libc", "ecx == 0x0", "writable: ebp-0x2c", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], [ebp-0x30])")
OneGadget::Gadget.add(build_id, 785114,
                      constraints: ["ebx is the GOT address of libc", "esi == 0x1", "writable: ebp-0x2c", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], [ebp-0x30])")
OneGadget::Gadget.add(build_id, 785226,
                      constraints: ["ebx is the GOT address of libc", "writable: ebp-0x2c", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], [ebp-0x30])")
OneGadget::Gadget.add(build_id, 785232,
                      constraints: ["ebx is the GOT address of libc", "writable: ebp-0x2c", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], [ebp-0x30])")
OneGadget::Gadget.add(build_id, 1277342,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1277345,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1277347,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1277351,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1277352,
                      constraints: ["ebx is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", [esp])")
OneGadget::Gadget.add(build_id, 1277358,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", eax)")
OneGadget::Gadget.add(build_id, 1277359,
                      constraints: ["ebx is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", [esp])")

