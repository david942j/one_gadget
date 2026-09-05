require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc6_2.19-0ubuntu6.6_i386/lib/i386-linux-gnu/libc-2.19.so
# 
# Intel 80386
# 
# GNU C Library (Ubuntu EGLIBC 2.19-0ubuntu6.6) stable release version 2.19, by Roland McGrath et al.
# Copyright (C) 2014 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 4.8.2.
# Compiled on a Linux 3.13.11 system on 2015-02-25.
# Available extensions:
# 	crypt add-on version 2.1 by Michael Glad and others
# 	GNU Libidn by Simon Josefsson
# 	Native POSIX Threads Library by Ulrich Drepper et al
# 	BIND-8.2.3-T5B
# libc ABIs: UNIQUE IFUNC
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/eglibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 261463,
                      constraints: ["edi is the GOT address of libc", "[esp+0x18] == NULL", "eax == 0x0", "{\"sh\", \"-c\", [esp+0x1c], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 261465,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "eax == 0x0", "{\"sh\", \"-c\", [esp+0x1c], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 261476,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "eax == 0x0", "{\"sh\", \"-c\", [esp+0x1c], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262079,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "{\"sh\", \"-c\", [esp+0x1c], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262085,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "eax == NULL || {eax, \"-c\", [esp+0x1c], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262089,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x34] == NULL || {[esp+0x34], \"-c\", [esp+0x1c], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262095,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x34] == NULL || {[esp+0x34], eax, [esp+0x1c], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262099,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x1c], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262103,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], eax, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262111,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x8] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], eax, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262118,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x8] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], eax, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262126,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x8] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], eax, [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262130,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x8] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262136,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x8] == NULL", "eax == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262140,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x4] == NULL", "[esp+0x8] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262145,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262151,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "eax == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262159,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x8] == NULL", "eax == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262163,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x4] == NULL", "[esp+0x8] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262170,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x4] == NULL", "[esp+0x8] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262175,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262179,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262187,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262194,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262198,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x4] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262203,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 262209,
                      constraints: ["ebx is the GOT address of libc", "readable: eax", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv", "[[eax]] == NULL || [eax] == NULL || [eax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x34, [eax])")
OneGadget::Gadget.add(build_id, 262219,
                      constraints: ["ebx is the GOT address of libc", "readable: eax", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv", "[[eax]] == NULL || [eax] == NULL || [eax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x34, [eax])")
OneGadget::Gadget.add(build_id, 262229,
                      constraints: ["ebx is the GOT address of libc", "readable: eax", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv", "[[eax]] == NULL || [eax] == NULL || [eax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x34, [eax])")
OneGadget::Gadget.add(build_id, 262231,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv", "[eax] == NULL || eax == NULL || eax is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x34, eax)")
OneGadget::Gadget.add(build_id, 262235,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv", "[[esp+0x8]] == NULL || [esp+0x8] == NULL || [esp+0x8] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x34, [esp+0x8])")
OneGadget::Gadget.add(build_id, 262239,
                      constraints: ["ebx is the GOT address of libc", "[eax] == NULL || eax == NULL || eax is a valid argv", "[[esp+0x8]] == NULL || [esp+0x8] == NULL || [esp+0x8] is a valid envp"],
                      effect: "execve(\"/bin/sh\", eax, [esp+0x8])")
OneGadget::Gadget.add(build_id, 262243,
                      constraints: ["ebx is the GOT address of libc", "[[esp+0x4]] == NULL || [esp+0x4] == NULL || [esp+0x4] is a valid argv", "[[esp+0x8]] == NULL || [esp+0x8] == NULL || [esp+0x8] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [esp+0x4], [esp+0x8])")
OneGadget::Gadget.add(build_id, 414981,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 414985,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x8] == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", [esp+0x8])")
OneGadget::Gadget.add(build_id, 414991,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", eax)")
OneGadget::Gadget.add(build_id, 414995,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x4] == NULL"],
                      effect: "execl(\"/bin/sh\", [esp+0x4])")
OneGadget::Gadget.add(build_id, 746106,
                      constraints: ["ebx is the GOT address of libc", "esi == 0x1", "writable: (esp+0x1b & 0xfffffff0)", "writable: ebp-0x1c", "[ebp+0x8] == NULL || {\"sh\", [ebp+0x8], [(esp+0x1b & 0xfffffff0)+0x8], [(esp+0x1b & 0xfffffff0)+0xc], ...} is a valid argv", "[[ebp+0x10]] == NULL || [ebp+0x10] == NULL || [ebp+0x10] is a valid envp"],
                      effect: "execve(\"/bin/sh\", (esp+0x1b & 0xfffffff0), [ebp+0x10])")
OneGadget::Gadget.add(build_id, 746110,
                      constraints: ["ebx is the GOT address of libc", "esi == 0x1", "writable: (edx & 0xfffffff0)", "writable: ebp-0x1c", "[ebp+0x8] == NULL || {\"sh\", [ebp+0x8], [(edx & 0xfffffff0)+0x8], [(edx & 0xfffffff0)+0xc], ...} is a valid argv", "[[ebp+0x10]] == NULL || [ebp+0x10] == NULL || [ebp+0x10] is a valid envp"],
                      effect: "execve(\"/bin/sh\", (edx & 0xfffffff0), [ebp+0x10])")
OneGadget::Gadget.add(build_id, 746113,
                      constraints: ["ebx is the GOT address of libc", "esi == 0x1", "writable: ebp-0x1c", "writable: edx", "[ebp+0x8] == NULL || {\"sh\", [ebp+0x8], [edx+0x8], [edx+0xc], ...} is a valid argv", "[[ebp+0x10]] == NULL || [ebp+0x10] == NULL || [ebp+0x10] is a valid envp"],
                      effect: "execve(\"/bin/sh\", edx, [ebp+0x10])")
OneGadget::Gadget.add(build_id, 747046,
                      constraints: ["ebx is the GOT address of libc", "esi == 0x1", "writable: eax", "writable: ebp-0x1c", "[ebp+0x8] == NULL || {\"sh\", [ebp+0x8], [eax+0x8], [eax+0xc], ...} is a valid argv", "[[ebp+0x10]] == NULL || [ebp+0x10] == NULL || [ebp+0x10] is a valid envp"],
                      effect: "execve(\"/bin/sh\", eax, [ebp+0x10])")
OneGadget::Gadget.add(build_id, 1209094,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1209098,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x8] == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", [esp+0x8])")
OneGadget::Gadget.add(build_id, 1209104,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", eax)")
OneGadget::Gadget.add(build_id, 1209108,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x4] == NULL"],
                      effect: "execl(\"/bin/sh\", [esp+0x4])")

