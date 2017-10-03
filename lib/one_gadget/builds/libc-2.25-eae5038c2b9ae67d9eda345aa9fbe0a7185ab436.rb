require 'one_gadget/gadget'
# https://gitlab.com/libcdb/libcdb/blob/master/libc/lib32-glibc-2.25-1-x86_64.pkg.tar/usr/lib32/libc-2.25.so
# 
# Intel 80386
# 
# GNU C Library (GNU libc) stable release version 2.25, by Roland McGrath et al.
# Copyright (C) 2017 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 6.3.1 20170109.
# Available extensions:
# 	crypt add-on version 2.1 by Michael Glad and others
# 	GNU Libidn by Simon Josefsson
# 	Native POSIX Threads Library by Ulrich Drepper et al
# 	BIND-8.2.3-T5B
# libc ABIs: UNIQUE IFUNC
# For bug reporting instructions, please see:
# <https://bugs.archlinux.org/>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 246097,
                      constraints: ["esi is the GOT address of libc", "[esp+0x34] == NULL"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 246099,
                      constraints: ["esi is the GOT address of libc", "[esp+0x38] == NULL"],
                      effect: "execve(\"/bin/sh\", esp+0x38, environ)")
OneGadget::Gadget.add(build_id, 246103,
                      constraints: ["esi is the GOT address of libc", "[esp+0x3c] == NULL"],
                      effect: "execve(\"/bin/sh\", esp+0x3c, environ)")
OneGadget::Gadget.add(build_id, 246110,
                      constraints: ["esi is the GOT address of libc", "[esp+0x40] == NULL"],
                      effect: "execve(\"/bin/sh\", esp+0x40, environ)")
OneGadget::Gadget.add(build_id, 246145,
                      constraints: ["esi is the GOT address of libc", "[eax] == NULL || eax == NULL", "[[esp]] == NULL || [esp] == NULL"],
                      effect: "execve(\"/bin/sh\", eax, [esp])")
OneGadget::Gadget.add(build_id, 246146,
                      constraints: ["esi is the GOT address of libc", "[[esp]] == NULL || [esp] == NULL", "[[esp+0x4]] == NULL || [esp+0x4] == NULL"],
                      effect: "execve(\"/bin/sh\", [esp], [esp+0x4])")
OneGadget::Gadget.add(build_id, 401983,
                      constraints: ["edi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", eax)")
OneGadget::Gadget.add(build_id, 401984,
                      constraints: ["edi is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", [esp])")
OneGadget::Gadget.add(build_id, 1223445,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", eax)")
OneGadget::Gadget.add(build_id, 1223446,
                      constraints: ["esi is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", [esp])")

