require 'one_gadget/gadget'
# Intel 80386
# 
# GNU C Library (Debian GLIBC 2.21-1) stable release version 2.21, by Roland McGrath et al.
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
OneGadget::Gadget.add(build_id, 436354,
                      constraints: ["ebx is the address of `rw-p` area of libc", "[esp+0x30] == NULL"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 596320,
                      constraints: ["ebx is the address of `rw-p` area of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", eax)")
OneGadget::Gadget.add(build_id, 596321,
                      constraints: ["ebx is the address of `rw-p` area of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", [esp])")

