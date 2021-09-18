require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc6-i386_2.33-0ubuntu7_amd64/lib32/libc-2.33.so
# 
# Intel 80386
# 
# GNU C Library (Ubuntu GLIBC 2.33-0ubuntu7) release release version 2.33.
# Copyright (C) 2021 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 10.3.0.
# libc ABIs: UNIQUE IFUNC ABSOLUTE
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 840579,
                      constraints: ["ebx is the GOT address of libc", "writable: ebp-0x20", "[ebp-0x28] == NULL || ebp-0x28 == NULL", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 1357603,
                      constraints: ["ebp is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", eax)")
OneGadget::Gadget.add(build_id, 1357604,
                      constraints: ["ebp is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", [esp])")

