require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc6-i386_2.27-3ubuntu1.4_amd64/lib32/libc-2.27.so
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
OneGadget::Gadget.add(build_id, 248460,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "eax == 0x0", "{\"sh\", \"-c\", [esp+0xc], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 248473,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "edx == 0x0", "{\"sh\", \"-c\", [esp+0xc], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 248813,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "eax == 0x0", "{\"sh\", \"-c\", [esp+0xc], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 248815,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "edx == 0x0", "{\"sh\", \"-c\", [esp+0xc], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 248991,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "{\"sh\", \"-c\", [esp+0xc], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 248997,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "eax == NULL || {eax, \"-c\", [esp+0xc], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 249005,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "eax == NULL || {eax, \"-c\", [esp+0xc], [esp+0x3c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 249009,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "[esp+0x30] == NULL || {[esp+0x30], \"-c\", [esp+0xc], [esp+0x3c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 249015,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "[esp+0x30] == NULL || {[esp+0x30], eax, [esp+0xc], [esp+0x3c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 249019,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "[esp+0x30] == NULL || {[esp+0x30], [esp+0x34], [esp+0xc], [esp+0x3c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 249023,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "[esp+0x30] == NULL || {[esp+0x30], [esp+0x34], eax, [esp+0x3c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 249027,
                      constraints: ["esi is the GOT address of libc", "[esp+0x8] == NULL", "[esp+0x30] == NULL || {[esp+0x30], [esp+0x34], [esp+0x38], [esp+0x3c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 249028,
                      constraints: ["esi is the GOT address of libc", "[esp+0xc] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 249034,
                      constraints: ["esi is the GOT address of libc", "[esp+0xc] == NULL", "eax == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 249036,
                      constraints: ["esi is the GOT address of libc", "[esp+0x10] == NULL", "[esp] == NULL", "eax == NULL", "[esp+0x38] == NULL || {[esp+0x38], [esp+0x3c], [esp+0x40], [esp+0x44], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x38, environ)")
OneGadget::Gadget.add(build_id, 249037,
                      constraints: ["esi is the GOT address of libc", "[esp+0x14] == NULL", "[esp+0x4] == NULL", "[esp] == NULL", "[esp+0x3c] == NULL || {[esp+0x3c], [esp+0x40], [esp+0x44], [esp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 249039,
                      constraints: ["esi is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x4] == NULL", "[esp+0x8] == NULL", "[esp+0x40] == NULL || {[esp+0x40], [esp+0x44], [esp+0x48], [esp+0x4c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x40, environ)")
OneGadget::Gadget.add(build_id, 249044,
                      constraints: ["esi is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x40] == NULL || {[esp+0x40], [esp+0x44], [esp+0x48], [esp+0x4c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x40, environ)")
OneGadget::Gadget.add(build_id, 249050,
                      constraints: ["esi is the GOT address of libc", "[esp+0x18] == NULL", "eax == NULL", "[esp+0x40] == NULL || {[esp+0x40], [esp+0x44], [esp+0x48], [esp+0x4c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x40, environ)")
OneGadget::Gadget.add(build_id, 249053,
                      constraints: ["esi is the GOT address of libc", "[esp+0xc] == NULL", "eax == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 249055,
                      constraints: ["esi is the GOT address of libc", "[esp+0x10] == NULL", "[esp] == NULL", "eax == NULL", "[esp+0x38] == NULL || {[esp+0x38], [esp+0x3c], [esp+0x40], [esp+0x44], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x38, environ)")
OneGadget::Gadget.add(build_id, 249056,
                      constraints: ["esi is the GOT address of libc", "[esp+0x14] == NULL", "[esp+0x4] == NULL", "[esp] == NULL", "[esp+0x3c] == NULL || {[esp+0x3c], [esp+0x40], [esp+0x44], [esp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 249058,
                      constraints: ["esi is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x4] == NULL", "[esp+0x8] == NULL", "[esp+0x40] == NULL || {[esp+0x40], [esp+0x44], [esp+0x48], [esp+0x4c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x40, environ)")
OneGadget::Gadget.add(build_id, 249063,
                      constraints: ["esi is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x40] == NULL || {[esp+0x40], [esp+0x44], [esp+0x48], [esp+0x4c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x40, environ)")
OneGadget::Gadget.add(build_id, 249066,
                      constraints: ["esi is the GOT address of libc", "[esp+0xc] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 249068,
                      constraints: ["esi is the GOT address of libc", "[esp+0x10] == NULL", "[esp+0x38] == NULL || {[esp+0x38], [esp+0x3c], [esp+0x40], [esp+0x44], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x38, environ)")
OneGadget::Gadget.add(build_id, 249072,
                      constraints: ["esi is the GOT address of libc", "[esp] == NULL", "[esp+0x3c] == NULL || {[esp+0x3c], [esp+0x40], [esp+0x44], [esp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 249074,
                      constraints: ["esi is the GOT address of libc", "[esp+0x4] == NULL", "[esp+0x40] == NULL || {[esp+0x40], [esp+0x44], [esp+0x48], [esp+0x4c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x40, environ)")
OneGadget::Gadget.add(build_id, 249079,
                      constraints: ["esi is the GOT address of libc", "[esp+0x40] == NULL || {[esp+0x40], [esp+0x44], [esp+0x48], [esp+0x4c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x40, environ)")
OneGadget::Gadget.add(build_id, 249085,
                      constraints: ["esi is the GOT address of libc", "[esp+0x40] == NULL || {[esp+0x40], [esp+0x44], [esp+0x48], [esp+0x4c], ...} is a valid argv", "[[eax]] == NULL || [eax] == NULL || [eax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x40, [eax])")
OneGadget::Gadget.add(build_id, 249088,
                      constraints: ["esi is the GOT address of libc", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv", "[[eax]] == NULL || [eax] == NULL || [eax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x34, [eax])")
OneGadget::Gadget.add(build_id, 249098,
                      constraints: ["esi is the GOT address of libc", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv", "[[eax]] == NULL || [eax] == NULL || [eax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x34, [eax])")
OneGadget::Gadget.add(build_id, 249108,
                      constraints: ["esi is the GOT address of libc", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv", "[[eax]] == NULL || [eax] == NULL || [eax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x34, [eax])")
OneGadget::Gadget.add(build_id, 249110,
                      constraints: ["esi is the GOT address of libc", "[esp+0x38] == NULL || {[esp+0x38], [esp+0x3c], [esp+0x40], [esp+0x44], ...} is a valid argv", "[[esp]] == NULL || [esp] == NULL || [esp] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x38, [esp])")
OneGadget::Gadget.add(build_id, 249114,
                      constraints: ["esi is the GOT address of libc", "[eax] == NULL || eax == NULL || eax is a valid argv", "[[esp]] == NULL || [esp] == NULL || [esp] is a valid envp"],
                      effect: "execve(\"/bin/sh\", eax, [esp])")
OneGadget::Gadget.add(build_id, 249115,
                      constraints: ["esi is the GOT address of libc", "[[esp]] == NULL || [esp] == NULL || [esp] is a valid argv", "[[esp+0x4]] == NULL || [esp+0x4] == NULL || [esp+0x4] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [esp], [esp+0x4])")
OneGadget::Gadget.add(build_id, 422799,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 422802,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 422804,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 422808,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 422809,
                      constraints: ["esi is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", [esp])")
OneGadget::Gadget.add(build_id, 422815,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", eax)")
OneGadget::Gadget.add(build_id, 422816,
                      constraints: ["esi is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", [esp])")
OneGadget::Gadget.add(build_id, 780129,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x30", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[ecx] == NULL || ecx == NULL || ecx is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], [ebp-0x30])")
OneGadget::Gadget.add(build_id, 780132,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x30", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[ecx] == NULL || ecx == NULL || ecx is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], [ebp-0x30])")
OneGadget::Gadget.add(build_id, 780135,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x2c", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], [ebp-0x30])")
OneGadget::Gadget.add(build_id, 780142,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x2c", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], [ebp-0x30])")
OneGadget::Gadget.add(build_id, 780145,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x2c", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], [ebp-0x30])")
OneGadget::Gadget.add(build_id, 780147,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x2c", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], [ebp-0x30])")
OneGadget::Gadget.add(build_id, 780149,
                      constraints: ["ebx is the GOT address of libc", "ecx == 0x0", "writable: ebp-0x2c", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], [ebp-0x30])")
OneGadget::Gadget.add(build_id, 780186,
                      constraints: ["ebx is the GOT address of libc", "esi == 0x1", "writable: ebp-0x2c", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], [ebp-0x30])")
OneGadget::Gadget.add(build_id, 780298,
                      constraints: ["ebx is the GOT address of libc", "writable: ebp-0x2c", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], [ebp-0x30])")
OneGadget::Gadget.add(build_id, 780304,
                      constraints: ["ebx is the GOT address of libc", "writable: ebp-0x2c", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], [ebp-0x30])")
OneGadget::Gadget.add(build_id, 1267246,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1267249,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1267251,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1267255,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1267256,
                      constraints: ["ebx is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", [esp])")
OneGadget::Gadget.add(build_id, 1267262,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", eax)")
OneGadget::Gadget.add(build_id, 1267263,
                      constraints: ["ebx is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", [esp])")

