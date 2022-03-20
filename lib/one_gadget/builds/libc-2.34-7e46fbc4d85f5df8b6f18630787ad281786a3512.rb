require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc6_2.34-0ubuntu3_i386/lib/i386-linux-gnu/libc.so.6
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
OneGadget::Gadget.add(build_id, 925059,
                      constraints: ["ebx is the GOT address of libc", "writable: ebp-0x20", "[ebp-0x28] == NULL || ebp-0x28 == NULL", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 1526097,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", eax)")
OneGadget::Gadget.add(build_id, 1526098,
                      constraints: ["esi is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", [esp])")

