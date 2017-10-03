require 'one_gadget/gadget'
# https://gitlab.com/libcdb/libcdb/blob/master/libc/libc0.3-2.19-4/lib/i386-gnu/libc-2.19.so
# 
# Intel 80386
# 
# GNU C Library (Debian GLIBC 2.19-4) stable release version 2.19, by Roland McGrath et al.
# Copyright (C) 2014 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 4.8.3.
# Available extensions:
# 	crypt add-on version 2.1 by Michael Glad and others
# 	GNU Libidn by Simon Josefsson
# 	BIND-8.2.3-T5B
# libc ABIs: UNIQUE
# For bug reporting instructions, please see:
# <http://www.debian.org/Bugs/>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 453596,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x30] == NULL"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 453622,
                      constraints: ["ebx is the GOT address of libc", "[eax] == NULL || eax == NULL", "[[esp+0x8]] == NULL || [esp+0x8] == NULL"],
                      effect: "execve(\"/bin/sh\", eax, [esp+0x8])")
OneGadget::Gadget.add(build_id, 453626,
                      constraints: ["ebx is the GOT address of libc", "[[esp+0x4]] == NULL || [esp+0x4] == NULL", "[[esp+0x8]] == NULL || [esp+0x8] == NULL"],
                      effect: "execve(\"/bin/sh\", [esp+0x4], [esp+0x8])")
OneGadget::Gadget.add(build_id, 610151,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x8] == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", [esp+0x8])")
OneGadget::Gadget.add(build_id, 610157,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", eax)")
OneGadget::Gadget.add(build_id, 610161,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x4] == NULL"],
                      effect: "execl(\"/bin/sh\", [esp+0x4])")

