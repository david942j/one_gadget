require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc6-i386-2.22-0experimental1/lib32/libc-2.22.so
# 
# Intel 80386
# 
# GNU C Library (Debian GLIBC 2.22-0experimental1) stable release version 2.22, by Roland McGrath et al.
# Copyright (C) 2015 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 5.3.1 20151207.
# Available extensions:
# 	crypt add-on version 2.1 by Michael Glad and others
# 	GNU Libidn by Simon Josefsson
# 	Native POSIX Threads Library by Ulrich Drepper et al
# 	BIND-8.2.3-T5B
# libc ABIs: UNIQUE IFUNC
# For bug reporting instructions, please see:
# <http://www.debian.org/Bugs/>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 239593,
                      constraints: ["edi is the GOT address of libc", "[esp+0xc] == NULL", "eax == 0x0", "{\"sh\", \"-c\", [esp+0x8], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x24, environ)")
OneGadget::Gadget.add(build_id, 239595,
                      constraints: ["ebx is the GOT address of libc", "[esp+0xc] == NULL", "eax == 0x0", "{\"sh\", \"-c\", [esp+0x8], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x24, environ)")
OneGadget::Gadget.add(build_id, 239606,
                      constraints: ["ebx is the GOT address of libc", "[esp+0xc] == NULL", "eax == 0x0", "{\"sh\", \"-c\", [esp+0x8], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x24, environ)")
OneGadget::Gadget.add(build_id, 240205,
                      constraints: ["ebx is the GOT address of libc", "[esp+0xc] == NULL", "{\"sh\", \"-c\", [esp+0x8], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x24, environ)")
OneGadget::Gadget.add(build_id, 240211,
                      constraints: ["ebx is the GOT address of libc", "[esp+0xc] == NULL", "eax == NULL || {eax, \"-c\", [esp+0x8], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x24, environ)")
OneGadget::Gadget.add(build_id, 240219,
                      constraints: ["ebx is the GOT address of libc", "[esp+0xc] == NULL", "eax == NULL || {eax, \"-c\", [esp+0x8], [esp+0x30], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x24, environ)")
OneGadget::Gadget.add(build_id, 240223,
                      constraints: ["ebx is the GOT address of libc", "[esp+0xc] == NULL", "[esp+0x24] == NULL || {[esp+0x24], \"-c\", [esp+0x8], [esp+0x30], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x24, environ)")
OneGadget::Gadget.add(build_id, 240229,
                      constraints: ["ebx is the GOT address of libc", "[esp+0xc] == NULL", "[esp+0x24] == NULL || {[esp+0x24], eax, [esp+0x8], [esp+0x30], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x24, environ)")
OneGadget::Gadget.add(build_id, 240233,
                      constraints: ["ebx is the GOT address of libc", "[esp+0xc] == NULL", "[esp+0x24] == NULL || {[esp+0x24], [esp+0x28], [esp+0x8], [esp+0x30], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x24, environ)")
OneGadget::Gadget.add(build_id, 240237,
                      constraints: ["ebx is the GOT address of libc", "[esp+0xc] == NULL", "[esp+0x24] == NULL || {[esp+0x24], [esp+0x28], eax, [esp+0x30], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x24, environ)")
OneGadget::Gadget.add(build_id, 240241,
                      constraints: ["ebx is the GOT address of libc", "[esp+0xc] == NULL", "[esp+0x24] == NULL || {[esp+0x24], [esp+0x28], [esp+0x2c], [esp+0x30], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x24, environ)")
OneGadget::Gadget.add(build_id, 240242,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x10] == NULL", "[esp+0x28] == NULL || {[esp+0x28], [esp+0x2c], [esp+0x30], [esp+0x34], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x28, environ)")
OneGadget::Gadget.add(build_id, 240248,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x10] == NULL", "eax == NULL", "[esp+0x28] == NULL || {[esp+0x28], [esp+0x2c], [esp+0x30], [esp+0x34], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x28, environ)")
OneGadget::Gadget.add(build_id, 240250,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x14] == NULL", "[esp] == NULL", "eax == NULL", "[esp+0x2c] == NULL || {[esp+0x2c], [esp+0x30], [esp+0x34], [esp+0x38], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x2c, environ)")
OneGadget::Gadget.add(build_id, 240251,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x4] == NULL", "[esp] == NULL", "[esp+0x30] == NULL || {[esp+0x30], [esp+0x34], [esp+0x38], [esp+0x3c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 240253,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x1c] == NULL", "[esp+0x4] == NULL", "[esp+0x8] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 240258,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x1c] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 240264,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x1c] == NULL", "eax == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 240267,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x10] == NULL", "eax == NULL", "[esp+0x28] == NULL || {[esp+0x28], [esp+0x2c], [esp+0x30], [esp+0x34], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x28, environ)")
OneGadget::Gadget.add(build_id, 240269,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x14] == NULL", "[esp] == NULL", "eax == NULL", "[esp+0x2c] == NULL || {[esp+0x2c], [esp+0x30], [esp+0x34], [esp+0x38], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x2c, environ)")
OneGadget::Gadget.add(build_id, 240270,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x4] == NULL", "[esp] == NULL", "[esp+0x30] == NULL || {[esp+0x30], [esp+0x34], [esp+0x38], [esp+0x3c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 240272,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x1c] == NULL", "[esp+0x4] == NULL", "[esp+0x8] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 240277,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x1c] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 240280,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x10] == NULL", "[esp+0x28] == NULL || {[esp+0x28], [esp+0x2c], [esp+0x30], [esp+0x34], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x28, environ)")
OneGadget::Gadget.add(build_id, 240282,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x14] == NULL", "[esp+0x2c] == NULL || {[esp+0x2c], [esp+0x30], [esp+0x34], [esp+0x38], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x2c, environ)")
OneGadget::Gadget.add(build_id, 240286,
                      constraints: ["ebx is the GOT address of libc", "[esp] == NULL", "[esp+0x30] == NULL || {[esp+0x30], [esp+0x34], [esp+0x38], [esp+0x3c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 240288,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x4] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 240293,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 240299,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv", "[[eax]] == NULL || [eax] == NULL || [eax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x34, [eax])")
OneGadget::Gadget.add(build_id, 240302,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x28] == NULL || {[esp+0x28], [esp+0x2c], [esp+0x30], [esp+0x34], ...} is a valid argv", "[[eax]] == NULL || [eax] == NULL || [eax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x28, [eax])")
OneGadget::Gadget.add(build_id, 240312,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x28] == NULL || {[esp+0x28], [esp+0x2c], [esp+0x30], [esp+0x34], ...} is a valid argv", "[[eax]] == NULL || [eax] == NULL || [eax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x28, [eax])")
OneGadget::Gadget.add(build_id, 240322,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x28] == NULL || {[esp+0x28], [esp+0x2c], [esp+0x30], [esp+0x34], ...} is a valid argv", "[[eax]] == NULL || [eax] == NULL || [eax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x28, [eax])")
OneGadget::Gadget.add(build_id, 240324,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x2c] == NULL || {[esp+0x2c], [esp+0x30], [esp+0x34], [esp+0x38], ...} is a valid argv", "[[esp]] == NULL || [esp] == NULL || [esp] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x2c, [esp])")
OneGadget::Gadget.add(build_id, 240328,
                      constraints: ["ebx is the GOT address of libc", "[eax] == NULL || eax == NULL || eax is a valid argv", "[[esp]] == NULL || [esp] == NULL || [esp] is a valid envp"],
                      effect: "execve(\"/bin/sh\", eax, [esp])")
OneGadget::Gadget.add(build_id, 240329,
                      constraints: ["ebx is the GOT address of libc", "[[esp]] == NULL || [esp] == NULL || [esp] is a valid argv", "[[esp+0x4]] == NULL || [esp+0x4] == NULL || [esp+0x4] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [esp], [esp+0x4])")
OneGadget::Gadget.add(build_id, 399331,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 399334,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 399336,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 399340,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 399341,
                      constraints: ["ebx is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", [esp])")
OneGadget::Gadget.add(build_id, 399347,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", eax)")
OneGadget::Gadget.add(build_id, 399348,
                      constraints: ["ebx is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", [esp])")
OneGadget::Gadget.add(build_id, 730634,
                      constraints: ["ebx is the GOT address of libc", "esi == 0x1", "writable: (esp+0xf & 0xfffffff0)", "writable: ebp-0x1c", "[ebp+0x8] == NULL || {\"sh\", [ebp+0x8], [(esp+0xf & 0xfffffff0)+0x8], [(esp+0xf & 0xfffffff0)+0xc], ...} is a valid argv", "[[ebp+0x10]] == NULL || [ebp+0x10] == NULL || [ebp+0x10] is a valid envp"],
                      effect: "execve(\"/bin/sh\", (esp+0xf & 0xfffffff0), [ebp+0x10])")
OneGadget::Gadget.add(build_id, 730638,
                      constraints: ["ebx is the GOT address of libc", "esi == 0x1", "writable: (eax & 0xfffffff0)", "writable: ebp-0x1c", "[ebp+0x8] == NULL || {\"sh\", [ebp+0x8], [(eax & 0xfffffff0)+0x8], [(eax & 0xfffffff0)+0xc], ...} is a valid argv", "[[ebp+0x10]] == NULL || [ebp+0x10] == NULL || [ebp+0x10] is a valid envp"],
                      effect: "execve(\"/bin/sh\", (eax & 0xfffffff0), [ebp+0x10])")
OneGadget::Gadget.add(build_id, 730641,
                      constraints: ["ebx is the GOT address of libc", "esi == 0x1", "writable: eax", "writable: ebp-0x1c", "[ebp+0x8] == NULL || {\"sh\", [ebp+0x8], [eax+0x8], [eax+0xc], ...} is a valid argv", "[[ebp+0x10]] == NULL || [ebp+0x10] == NULL || [ebp+0x10] is a valid envp"],
                      effect: "execve(\"/bin/sh\", eax, [ebp+0x10])")
OneGadget::Gadget.add(build_id, 731341,
                      constraints: ["ebx is the GOT address of libc", "esi == 0x1", "writable: eax", "writable: ebp-0x1c", "[ebp+0x8] == NULL || {\"sh\", [ebp+0x8], [eax+0x8], [eax+0xc], ...} is a valid argv", "[[ebp+0x10]] == NULL || [ebp+0x10] == NULL || [ebp+0x10] is a valid envp"],
                      effect: "execve(\"/bin/sh\", eax, [ebp+0x10])")
OneGadget::Gadget.add(build_id, 731344,
                      constraints: ["ebx is the GOT address of libc", "esi == 0x1", "writable: eax", "writable: ebp-0x1c", "[ebp+0x8] == NULL || {\"sh\", [ebp+0x8], [eax+0x8], [eax+0xc], ...} is a valid argv", "[[ebp+0x10]] == NULL || [ebp+0x10] == NULL || [ebp+0x10] is a valid envp"],
                      effect: "execve(\"/bin/sh\", eax, [ebp+0x10])")
OneGadget::Gadget.add(build_id, 1182732,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1182735,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1182737,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1182741,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1182742,
                      constraints: ["esi is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", [esp])")
OneGadget::Gadget.add(build_id, 1182748,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", eax)")
OneGadget::Gadget.add(build_id, 1182749,
                      constraints: ["esi is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", [esp])")

