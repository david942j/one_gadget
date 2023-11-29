require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc6-i386_2.34-0ubuntu3_amd64/lib32/libc.so.6
# 
# Intel 80386
# 
# GNU C Library (Ubuntu GLIBC 2.34-0ubuntu3) stable release version 2.34.
# Copyright (C) 2021 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 10.3.0.
# libc ABIs: UNIQUE IFUNC ABSOLUTE
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 919216,
                      constraints: ["ebx is the GOT address of libc", "writable: ebp-0x20", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 919219,
                      constraints: ["ebx is the GOT address of libc", "writable: ebp-0x20", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 1511121,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", eax)")
OneGadget::Gadget.add(build_id, 1511122,
                      constraints: ["esi is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", [esp])")

