require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc0.1-i386-2.21-6/lib32/libc-2.21.so
# 
# Intel 80386
# 
# GNU C Library (Debian GLIBC 2.21-6) stable release version 2.21, by Roland McGrath et al.
# Copyright (C) 2015 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 4.9.3.
# Available extensions:
# 	crypt add-on version 2.1 by Michael Glad and others
# 	Native POSIX Threads Library by Ulrich Drepper et al
# 	GNU Libidn by Simon Josefsson
# 	BIND-8.2.3-T5B
# libc ABIs: UNIQUE
# For bug reporting instructions, please see:
# <http://www.debian.org/Bugs/>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 233507,
                      constraints: ["ebx is the GOT address of libc", "[esp+0xc] == NULL", "eax == 0x0", "{\"sh\", \"-c\", edi, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x28, environ)")
OneGadget::Gadget.add(build_id, 234110,
                      constraints: ["ebx is the GOT address of libc", "[esp+0xc] == NULL", "{\"sh\", \"-c\", edi, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x28, environ)")
OneGadget::Gadget.add(build_id, 234116,
                      constraints: ["ebx is the GOT address of libc", "[esp+0xc] == NULL", "eax == NULL || {eax, \"-c\", edi, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x28, environ)")
OneGadget::Gadget.add(build_id, 234120,
                      constraints: ["ebx is the GOT address of libc", "[esp+0xc] == NULL", "eax == NULL || {eax, \"-c\", [esp+0x30], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x28, environ)")
OneGadget::Gadget.add(build_id, 234128,
                      constraints: ["ebx is the GOT address of libc", "[esp+0xc] == NULL", "eax == NULL || {eax, \"-c\", [esp+0x30], [esp+0x34], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x28, environ)")
OneGadget::Gadget.add(build_id, 234132,
                      constraints: ["ebx is the GOT address of libc", "[esp+0xc] == NULL", "[esp+0x28] == NULL || {[esp+0x28], \"-c\", [esp+0x30], [esp+0x34], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x28, environ)")
OneGadget::Gadget.add(build_id, 234138,
                      constraints: ["ebx is the GOT address of libc", "[esp+0xc] == NULL", "[esp+0x28] == NULL || {[esp+0x28], eax, [esp+0x30], [esp+0x34], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x28, environ)")
OneGadget::Gadget.add(build_id, 234142,
                      constraints: ["ebx is the GOT address of libc", "[esp+0xc] == NULL", "[esp+0x28] == NULL || {[esp+0x28], [esp+0x2c], [esp+0x30], [esp+0x34], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x28, environ)")
OneGadget::Gadget.add(build_id, 234143,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x10] == NULL", "[esp+0x2c] == NULL || {[esp+0x2c], [esp+0x30], [esp+0x34], [esp+0x38], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x2c, environ)")
OneGadget::Gadget.add(build_id, 234149,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x10] == NULL", "eax == NULL", "[esp+0x2c] == NULL || {[esp+0x2c], [esp+0x30], [esp+0x34], [esp+0x38], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x2c, environ)")
OneGadget::Gadget.add(build_id, 234151,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x14] == NULL", "[esp] == NULL", "eax == NULL", "[esp+0x30] == NULL || {[esp+0x30], [esp+0x34], [esp+0x38], [esp+0x3c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 234152,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x4] == NULL", "[esp] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 234154,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x1c] == NULL", "[esp+0x4] == NULL", "[esp+0x8] == NULL", "[esp+0x38] == NULL || {[esp+0x38], [esp+0x3c], [esp+0x40], [esp+0x44], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x38, environ)")
OneGadget::Gadget.add(build_id, 234159,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x1c] == NULL", "[esp+0x38] == NULL || {[esp+0x38], [esp+0x3c], [esp+0x40], [esp+0x44], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x38, environ)")
OneGadget::Gadget.add(build_id, 234165,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x1c] == NULL", "eax == NULL", "[esp+0x38] == NULL || {[esp+0x38], [esp+0x3c], [esp+0x40], [esp+0x44], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x38, environ)")
OneGadget::Gadget.add(build_id, 234168,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x10] == NULL", "eax == NULL", "[esp+0x2c] == NULL || {[esp+0x2c], [esp+0x30], [esp+0x34], [esp+0x38], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x2c, environ)")
OneGadget::Gadget.add(build_id, 234170,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x14] == NULL", "[esp] == NULL", "eax == NULL", "[esp+0x30] == NULL || {[esp+0x30], [esp+0x34], [esp+0x38], [esp+0x3c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 234171,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x18] == NULL", "[esp+0x4] == NULL", "[esp] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 234173,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x1c] == NULL", "[esp+0x4] == NULL", "[esp+0x8] == NULL", "[esp+0x38] == NULL || {[esp+0x38], [esp+0x3c], [esp+0x40], [esp+0x44], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x38, environ)")
OneGadget::Gadget.add(build_id, 234178,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x1c] == NULL", "[esp+0x38] == NULL || {[esp+0x38], [esp+0x3c], [esp+0x40], [esp+0x44], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x38, environ)")
OneGadget::Gadget.add(build_id, 234181,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x10] == NULL", "[esp+0x2c] == NULL || {[esp+0x2c], [esp+0x30], [esp+0x34], [esp+0x38], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x2c, environ)")
OneGadget::Gadget.add(build_id, 234183,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x14] == NULL", "[esp+0x30] == NULL || {[esp+0x30], [esp+0x34], [esp+0x38], [esp+0x3c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 234187,
                      constraints: ["ebx is the GOT address of libc", "[esp] == NULL", "[esp+0x34] == NULL || {[esp+0x34], [esp+0x38], [esp+0x3c], [esp+0x40], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x34, environ)")
OneGadget::Gadget.add(build_id, 234189,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x4] == NULL", "[esp+0x38] == NULL || {[esp+0x38], [esp+0x3c], [esp+0x40], [esp+0x44], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x38, environ)")
OneGadget::Gadget.add(build_id, 234194,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x38] == NULL || {[esp+0x38], [esp+0x3c], [esp+0x40], [esp+0x44], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x38, environ)")
OneGadget::Gadget.add(build_id, 234200,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x38] == NULL || {[esp+0x38], [esp+0x3c], [esp+0x40], [esp+0x44], ...} is a valid argv", "[[eax]] == NULL || [eax] == NULL || [eax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x38, [eax])")
OneGadget::Gadget.add(build_id, 234203,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x2c] == NULL || {[esp+0x2c], [esp+0x30], [esp+0x34], [esp+0x38], ...} is a valid argv", "[[eax]] == NULL || [eax] == NULL || [eax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x2c, [eax])")
OneGadget::Gadget.add(build_id, 234213,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x2c] == NULL || {[esp+0x2c], [esp+0x30], [esp+0x34], [esp+0x38], ...} is a valid argv", "[[eax]] == NULL || [eax] == NULL || [eax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x2c, [eax])")
OneGadget::Gadget.add(build_id, 234223,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x2c] == NULL || {[esp+0x2c], [esp+0x30], [esp+0x34], [esp+0x38], ...} is a valid argv", "[[eax]] == NULL || [eax] == NULL || [eax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x2c, [eax])")
OneGadget::Gadget.add(build_id, 234225,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x30] == NULL || {[esp+0x30], [esp+0x34], [esp+0x38], [esp+0x3c], ...} is a valid argv", "[[esp]] == NULL || [esp] == NULL || [esp] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x30, [esp])")
OneGadget::Gadget.add(build_id, 234229,
                      constraints: ["ebx is the GOT address of libc", "[eax] == NULL || eax == NULL || eax is a valid argv", "[[esp]] == NULL || [esp] == NULL || [esp] is a valid envp"],
                      effect: "execve(\"/bin/sh\", eax, [esp])")
OneGadget::Gadget.add(build_id, 234230,
                      constraints: ["ebx is the GOT address of libc", "[[esp]] == NULL || [esp] == NULL || [esp] is a valid argv", "[[esp+0x4]] == NULL || [esp+0x4] == NULL || [esp+0x4] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [esp], [esp+0x4])")
OneGadget::Gadget.add(build_id, 393711,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 393714,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 393716,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 393720,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 393721,
                      constraints: ["ebx is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", [esp])")
OneGadget::Gadget.add(build_id, 393727,
                      constraints: ["ebx is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", eax)")
OneGadget::Gadget.add(build_id, 393728,
                      constraints: ["ebx is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", [esp])")
OneGadget::Gadget.add(build_id, 643962,
                      constraints: ["ebx is the GOT address of libc", "esi == 0x1", "writable: (esp+0xf & 0xfffffff0)", "writable: ebp-0x1c", "[ebp+0x8] == NULL || {\"sh\", [ebp+0x8], [(esp+0xf & 0xfffffff0)+0x8], [(esp+0xf & 0xfffffff0)+0xc], ...} is a valid argv", "[[ebp+0x10]] == NULL || [ebp+0x10] == NULL || [ebp+0x10] is a valid envp"],
                      effect: "execve(\"/bin/sh\", (esp+0xf & 0xfffffff0), [ebp+0x10])")
OneGadget::Gadget.add(build_id, 643966,
                      constraints: ["ebx is the GOT address of libc", "esi == 0x1", "writable: (edx & 0xfffffff0)", "writable: ebp-0x1c", "[ebp+0x8] == NULL || {\"sh\", [ebp+0x8], [(edx & 0xfffffff0)+0x8], [(edx & 0xfffffff0)+0xc], ...} is a valid argv", "[[ebp+0x10]] == NULL || [ebp+0x10] == NULL || [ebp+0x10] is a valid envp"],
                      effect: "execve(\"/bin/sh\", (edx & 0xfffffff0), [ebp+0x10])")
OneGadget::Gadget.add(build_id, 643969,
                      constraints: ["ebx is the GOT address of libc", "esi == 0x1", "writable: ebp-0x1c", "writable: edx", "[ebp+0x8] == NULL || {\"sh\", [ebp+0x8], [edx+0x8], [edx+0xc], ...} is a valid argv", "[[ebp+0x10]] == NULL || [ebp+0x10] == NULL || [ebp+0x10] is a valid envp"],
                      effect: "execve(\"/bin/sh\", edx, [ebp+0x10])")
OneGadget::Gadget.add(build_id, 644661,
                      constraints: ["ebx is the GOT address of libc", "esi == 0x1", "writable: eax", "writable: ebp-0x1c", "[ebp+0x8] == NULL || {\"sh\", [ebp+0x8], [eax+0x8], [eax+0xc], ...} is a valid argv", "[[ebp+0x10]] == NULL || [ebp+0x10] == NULL || [ebp+0x10] is a valid envp"],
                      effect: "execve(\"/bin/sh\", eax, [ebp+0x10])")
OneGadget::Gadget.add(build_id, 644664,
                      constraints: ["ebx is the GOT address of libc", "esi == 0x1", "writable: eax", "writable: ebp-0x1c", "[ebp+0x8] == NULL || {\"sh\", [ebp+0x8], [eax+0x8], [eax+0xc], ...} is a valid argv", "[[ebp+0x10]] == NULL || [ebp+0x10] == NULL || [ebp+0x10] is a valid envp"],
                      effect: "execve(\"/bin/sh\", eax, [ebp+0x10])")

