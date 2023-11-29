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
OneGadget::Gadget.add(build_id, 250291,
                      constraints: ["esi is the GOT address of libc", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 250293,
                      constraints: ["esi is the GOT address of libc", "[esp+0x38] == NULL || {[esp+0x38], [esp+0x3c], [esp+0x40], [esp+0x44], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x38, environ)")
OneGadget::Gadget.add(build_id, 250297,
                      constraints: ["esi is the GOT address of libc", "[esp+0x3c] == NULL || {[esp+0x3c], [esp+0x40], [esp+0x44], [esp+0x48], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 250304,
                      constraints: ["esi is the GOT address of libc", "[esp+0x40] == NULL || {[esp+0x40], [esp+0x44], [esp+0x48], [esp+0x4c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x40, environ)")
OneGadget::Gadget.add(build_id, 250339,
                      constraints: ["esi is the GOT address of libc", "[eax] == NULL || eax == NULL || eax is a valid argv", "[[esp]] == NULL || [esp] == NULL || [esp] is a valid envp"],
                      effect: "execve(\"/bin/sh\", eax, [esp])")
OneGadget::Gadget.add(build_id, 250340,
                      constraints: ["esi is the GOT address of libc", "[[esp]] == NULL || [esp] == NULL || [esp] is a valid argv", "[[esp+0x4]] == NULL || [esp+0x4] == NULL || [esp+0x4] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [esp], [esp+0x4])")
OneGadget::Gadget.add(build_id, 424927,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", eax)")
OneGadget::Gadget.add(build_id, 424928,
                      constraints: ["esi is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", [esp])")
OneGadget::Gadget.add(build_id, 1277358,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", eax)")
OneGadget::Gadget.add(build_id, 1277359,
                      constraints: ["ebx is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", [esp])")

