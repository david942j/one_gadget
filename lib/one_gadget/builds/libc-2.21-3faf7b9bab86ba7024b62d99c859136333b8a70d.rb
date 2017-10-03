require 'one_gadget/gadget'
# https://gitlab.com/libcdb/libcdb/blob/master/libc/libc0.3-2.21-8/lib/i386-gnu/libc-2.21.so
# 
# Intel 80386
# 
# GNU C Library (Debian GLIBC 2.21-8) stable release version 2.21, by Roland McGrath et al.
# Copyright (C) 2015 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 4.9.3.
# Available extensions:
# 	crypt add-on version 2.1 by Michael Glad and others
# 	GNU Libidn by Simon Josefsson
# 	BIND-8.2.3-T5B
# libc ABIs: UNIQUE
# For bug reporting instructions, please see:
# <http://www.debian.org/Bugs/>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 436370,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x30] == NULL"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 436389,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x24] == NULL", "[[eax]] == NULL || [eax] == NULL"],
                      effect: "execve(\"/bin/sh\", esp+0x24, [eax])")
OneGadget::Gadget.add(build_id, 436391,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x28] == NULL", "[[esp]] == NULL || [esp] == NULL"],
                      effect: "execve(\"/bin/sh\", esp+0x28, [esp])")
OneGadget::Gadget.add(build_id, 436395,
                      constraints: ["ebx is the GOT address of libc", "[eax] == NULL || eax == NULL", "[[esp]] == NULL || [esp] == NULL"],
                      effect: "execve(\"/bin/sh\", eax, [esp])")
OneGadget::Gadget.add(build_id, 436396,
                      constraints: ["ebx is the GOT address of libc", "[[esp]] == NULL || [esp] == NULL", "[[esp+0x4]] == NULL || [esp+0x4] == NULL"],
                      effect: "execve(\"/bin/sh\", [esp], [esp+0x4])")
OneGadget::Gadget.add(build_id, 597056,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", eax)")
OneGadget::Gadget.add(build_id, 597057,
                      constraints: ["ebx is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", [esp])")

