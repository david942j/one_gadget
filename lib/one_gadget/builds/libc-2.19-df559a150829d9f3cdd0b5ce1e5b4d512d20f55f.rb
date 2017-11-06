require 'one_gadget/gadget'
# https://gitlab.com/libcdb/libcdb/blob/master/libc/glibc-32bit-2.19-16.2.5.x86_64/lib/libc-2.19.so
# 
# Intel 80386
# 
# GNU C Library (GNU libc) stable release version 2.19 (git 9a869d822025), by Roland McGrath et al.
# Copyright (C) 2014 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Configured for i686-suse-linux.
# Compiled by GNU CC version 4.8.3 20140627 [gcc-4_8-branch revision 212064].
# Compiled on a Linux 3.16.0 system.
# Available extensions:
# 	crypt add-on version 2.1 by Michael Glad and others
# 	GNU Libidn by Simon Josefsson
# 	NoVersion patch for broken glibc 2.0 binaries
# 	Native POSIX Threads Library by Ulrich Drepper et al
# 	BIND-8.2.3-T5B
# libc ABIs: UNIQUE IFUNC
# For bug reporting instructions, please see:
# <http://bugs.opensuse.org>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 255203,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x34] == NULL"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 255239,
                      constraints: ["ebx is the GOT address of libc", "[eax] == NULL || eax == NULL", "[[esp+0x8]] == NULL || [esp+0x8] == NULL"],
                      effect: "execve(\"/bin/sh\", eax, [esp+0x8])")
OneGadget::Gadget.add(build_id, 255243,
                      constraints: ["ebx is the GOT address of libc", "[[esp+0x4]] == NULL || [esp+0x4] == NULL", "[[esp+0x8]] == NULL || [esp+0x8] == NULL"],
                      effect: "execve(\"/bin/sh\", [esp+0x4], [esp+0x8])")
OneGadget::Gadget.add(build_id, 416851,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x8] == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", [esp+0x8])")
OneGadget::Gadget.add(build_id, 416857,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", eax)")
OneGadget::Gadget.add(build_id, 416861,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x4] == NULL"],
                      effect: "execl(\"/bin/sh\", [esp+0x4])")

