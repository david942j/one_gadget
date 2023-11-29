require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/glibc-2.19-2-i686.pkg.tar/usr/lib/libc-2.19.so
# 
# Intel 80386
# 
# GNU C Library (GNU libc) stable release version 2.19, by Roland McGrath et al.
# Copyright (C) 2014 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 4.8.2 20140206 (prerelease).
# Compiled on a Linux 3.13.2 system on 2014-02-14.
# Available extensions:
# 	crypt add-on version 2.1 by Michael Glad and others
# 	GNU Libidn by Simon Josefsson
# 	Native POSIX Threads Library by Ulrich Drepper et al
# 	BIND-8.2.3-T5B
# libc ABIs: UNIQUE IFUNC
# For bug reporting instructions, please see:
# <https://bugs.archlinux.org/>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 255467,
                      constraints: ["ebx is the GOT address of libc", "writable: esp", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 255474,
                      constraints: ["ebx is the GOT address of libc", "writable: esp+0x4", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 255483,
                      constraints: ["ebx is the GOT address of libc", "writable: esp+0x8", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 255519,
                      constraints: ["ebx is the GOT address of libc", "writable: esp+0x4", "[eax] == NULL || eax == NULL || eax is a valid argv", "[[esp+0x8]] == NULL || [esp+0x8] == NULL || [esp+0x8] is a valid envp"],
                      effect: "execve(\"/bin/sh\", eax, [esp+0x8])")
OneGadget::Gadget.add(build_id, 255523,
                      constraints: ["ebx is the GOT address of libc", "writable: esp", "[[esp+0x4]] == NULL || [esp+0x4] == NULL || [esp+0x4] is a valid argv", "[[esp+0x8]] == NULL || [esp+0x8] == NULL || [esp+0x8] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [esp+0x4], [esp+0x8])")
OneGadget::Gadget.add(build_id, 417007,
                      constraints: ["ebx is the GOT address of libc", "writable: esp+0x8", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 417011,
                      constraints: ["ebx is the GOT address of libc", "writable: esp+0x4", "[esp+0x8] == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", [esp+0x8])")
OneGadget::Gadget.add(build_id, 417017,
                      constraints: ["ebx is the GOT address of libc", "writable: esp+0x4", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", eax)")
OneGadget::Gadget.add(build_id, 417021,
                      constraints: ["ebx is the GOT address of libc", "writable: esp", "[esp+0x4] == NULL"],
                      effect: "execl(\"/bin/sh\", [esp+0x4])")

