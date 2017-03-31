require 'one_gadget/gadget'
# Intel 80386
# 
# GNU C Library (GNU libc) development release version 2.21.90, by Roland McGrath et al.
# Copyright (C) 2015 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 5.0.0 20150319 (Red Hat 5.0.0-0.21).
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
OneGadget::Gadget.add(build_id, 256284,
                      constraints: ["ebx is the address of `rw-p` area of libc", "[esp+0x34] == NULL"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 420820,
                      constraints: ["ebx is the address of `rw-p` area of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", eax)")
OneGadget::Gadget.add(build_id, 420821,
                      constraints: ["ebx is the address of `rw-p` area of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", [esp])")
OneGadget::Gadget.add(build_id, 1306035,
                      constraints: ["esi is the address of `rw-p` area of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", eax)")
OneGadget::Gadget.add(build_id, 1306036,
                      constraints: ["esi is the address of `rw-p` area of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", [esp])")

