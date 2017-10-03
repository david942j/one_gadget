require 'one_gadget/gadget'
# https://gitlab.com/libcdb/libcdb/blob/master/libc/glibc-2.20-8.fc21.i686/lib/libc-2.20.so
# 
# Intel 80386
# 
# GNU C Library (GNU libc) stable release version 2.20, by Roland McGrath et al.
# Copyright (C) 2014 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 4.9.2 20150212 (Red Hat 4.9.2-6).
# Available extensions:
# 	The C stubs add-on version 2.1.2.
# 	crypt add-on version 2.1 by Michael Glad and others
# 	GNU Libidn by Simon Josefsson
# 	Native POSIX Threads Library by Ulrich Drepper et al
# 	BIND-8.2.3-T5B
# 	RT using linux kernel aio
# libc ABIs: UNIQUE IFUNC
# For bug reporting instructions, please see:
# <http://www.gnu.org/software/libc/bugs.html>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 247414,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x28] == NULL"],
                      effect: "execve(\"/bin/sh\", esp+0x28, environ)")
OneGadget::Gadget.add(build_id, 247416,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x2c] == NULL"],
                      effect: "execve(\"/bin/sh\", esp+0x2c, environ)")
OneGadget::Gadget.add(build_id, 247420,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x30] == NULL"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 247427,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x34] == NULL"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 247462,
                      constraints: ["ebx is the GOT address of libc", "[eax] == NULL || eax == NULL", "[[esp]] == NULL || [esp] == NULL"],
                      effect: "execve(\"/bin/sh\", eax, [esp])")
OneGadget::Gadget.add(build_id, 247463,
                      constraints: ["ebx is the GOT address of libc", "[[esp]] == NULL || [esp] == NULL", "[[esp+0x4]] == NULL || [esp+0x4] == NULL"],
                      effect: "execve(\"/bin/sh\", [esp], [esp+0x4])")
OneGadget::Gadget.add(build_id, 413860,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", eax)")
OneGadget::Gadget.add(build_id, 413861,
                      constraints: ["ebx is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", [esp])")

