require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc0.3-i686-2.19-9/lib/i386-gnu/i686/cmov/libc-2.19.so
# 
# Intel 80386
# 
# GNU C Library (Debian GLIBC 2.19-9) stable release version 2.19, by Roland McGrath et al.
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
OneGadget::Gadget.add(build_id, 454796,
                      constraints: ["ebx is the GOT address of libc", "writable: esp+0x8", "[esp+0x30] == NULL || {[esp+0x30], [esp+0x34], [esp+0x38], [esp+0x3c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 454818,
                      constraints: ["ebx is the GOT address of libc", "writable: esp+0x4", "[esp+0x30] == NULL || {[esp+0x30], [esp+0x34], [esp+0x38], [esp+0x3c], ...} is a valid argv", "[[esp+0x8]] == NULL || [esp+0x8] == NULL || [esp+0x8] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x30, [esp+0x8])")
OneGadget::Gadget.add(build_id, 454822,
                      constraints: ["ebx is the GOT address of libc", "writable: esp+0x4", "[eax] == NULL || eax == NULL || eax is a valid argv", "[[esp+0x8]] == NULL || [esp+0x8] == NULL || [esp+0x8] is a valid envp"],
                      effect: "execve(\"/bin/sh\", eax, [esp+0x8])")
OneGadget::Gadget.add(build_id, 454826,
                      constraints: ["ebx is the GOT address of libc", "writable: esp", "[[esp+0x4]] == NULL || [esp+0x4] == NULL || [esp+0x4] is a valid argv", "[[esp+0x8]] == NULL || [esp+0x8] == NULL || [esp+0x8] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [esp+0x4], [esp+0x8])")
OneGadget::Gadget.add(build_id, 610051,
                      constraints: ["ebx is the GOT address of libc", "writable: esp+0x8", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 610055,
                      constraints: ["ebx is the GOT address of libc", "writable: esp+0x4", "[esp+0x8] == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", [esp+0x8])")
OneGadget::Gadget.add(build_id, 610061,
                      constraints: ["ebx is the GOT address of libc", "writable: esp+0x4", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", eax)")
OneGadget::Gadget.add(build_id, 610065,
                      constraints: ["ebx is the GOT address of libc", "writable: esp", "[esp+0x4] == NULL"],
                      effect: "execl(\"/bin/sh\", [esp+0x4])")

