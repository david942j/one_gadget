require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc0.3-2.22-13/lib/i386-gnu/libc-2.22.so
# 
# Intel 80386
# 
# GNU C Library (Debian GLIBC 2.22-13) stable release version 2.22, by Roland McGrath et al.
# Copyright (C) 2015 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 5.4.0 20160609.
# Available extensions:
# 	crypt add-on version 2.1 by Michael Glad and others
# 	GNU Libidn by Simon Josefsson
# 	BIND-8.2.3-T5B
# libc ABIs: UNIQUE
# For bug reporting instructions, please see:
# <http://www.debian.org/Bugs/>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 437040,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x30] == NULL || {[esp+0x30], [esp+0x34], [esp+0x38], [esp+0x3c], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", esp+0x30, environ)")
OneGadget::Gadget.add(build_id, 437046,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x30] == NULL || {[esp+0x30], [esp+0x34], [esp+0x38], [esp+0x3c], ...} is a valid argv", "[[eax]] == NULL || [eax] == NULL || [eax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x30, [eax])")
OneGadget::Gadget.add(build_id, 437049,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x24] == NULL || {[esp+0x24], [esp+0x28], [esp+0x2c], [esp+0x30], ...} is a valid argv", "[[eax]] == NULL || [eax] == NULL || [eax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x24, [eax])")
OneGadget::Gadget.add(build_id, 437059,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x24] == NULL || {[esp+0x24], [esp+0x28], [esp+0x2c], [esp+0x30], ...} is a valid argv", "[[eax]] == NULL || [eax] == NULL || [eax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x24, [eax])")
OneGadget::Gadget.add(build_id, 437061,
                      constraints: ["ebx is the GOT address of libc", "[esp+0x28] == NULL || {[esp+0x28], [esp+0x2c], [esp+0x30], [esp+0x34], ...} is a valid argv", "[[esp]] == NULL || [esp] == NULL || [esp] is a valid envp"],
                      effect: "execve(\"/bin/sh\", esp+0x28, [esp])")
OneGadget::Gadget.add(build_id, 437065,
                      constraints: ["ebx is the GOT address of libc", "[eax] == NULL || eax == NULL || eax is a valid argv", "[[esp]] == NULL || [esp] == NULL || [esp] is a valid envp"],
                      effect: "execve(\"/bin/sh\", eax, [esp])")
OneGadget::Gadget.add(build_id, 437066,
                      constraints: ["ebx is the GOT address of libc", "[[esp]] == NULL || [esp] == NULL || [esp] is a valid argv", "[[esp+0x4]] == NULL || [esp+0x4] == NULL || [esp+0x4] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [esp], [esp+0x4])")
OneGadget::Gadget.add(build_id, 867800,
                      constraints: ["ebx is the GOT address of libc", "esi == 0x1", "writable: (esp+0xf & 0xfffffff0)", "writable: ebp-0x1c", "[ebp+0x8] == NULL || {\"sh\", [ebp+0x8], [(esp+0xf & 0xfffffff0)+0x8], [(esp+0xf & 0xfffffff0)+0xc], ...} is a valid argv", "[[ebp+0x10]] == NULL || [ebp+0x10] == NULL || [ebp+0x10] is a valid envp"],
                      effect: "execve(\"/bin/sh\", (esp+0xf & 0xfffffff0), [ebp+0x10])")
OneGadget::Gadget.add(build_id, 867804,
                      constraints: ["ebx is the GOT address of libc", "esi == 0x1", "writable: (eax & 0xfffffff0)", "writable: ebp-0x1c", "[ebp+0x8] == NULL || {\"sh\", [ebp+0x8], [(eax & 0xfffffff0)+0x8], [(eax & 0xfffffff0)+0xc], ...} is a valid argv", "[[ebp+0x10]] == NULL || [ebp+0x10] == NULL || [ebp+0x10] is a valid envp"],
                      effect: "execve(\"/bin/sh\", (eax & 0xfffffff0), [ebp+0x10])")
OneGadget::Gadget.add(build_id, 867807,
                      constraints: ["ebx is the GOT address of libc", "esi == 0x1", "writable: eax", "writable: ebp-0x1c", "[ebp+0x8] == NULL || {\"sh\", [ebp+0x8], [eax+0x8], [eax+0xc], ...} is a valid argv", "[[ebp+0x10]] == NULL || [ebp+0x10] == NULL || [ebp+0x10] is a valid envp"],
                      effect: "execve(\"/bin/sh\", eax, [ebp+0x10])")
OneGadget::Gadget.add(build_id, 868523,
                      constraints: ["ebx is the GOT address of libc", "esi == 0x1", "writable: eax", "writable: ebp-0x1c", "[ebp+0x8] == NULL || {\"sh\", [ebp+0x8], [eax+0x8], [eax+0xc], ...} is a valid argv", "[[ebp+0x10]] == NULL || [ebp+0x10] == NULL || [ebp+0x10] is a valid envp"],
                      effect: "execve(\"/bin/sh\", eax, [ebp+0x10])")
OneGadget::Gadget.add(build_id, 868526,
                      constraints: ["ebx is the GOT address of libc", "esi == 0x1", "writable: eax", "writable: ebp-0x1c", "[ebp+0x8] == NULL || {\"sh\", [ebp+0x8], [eax+0x8], [eax+0xc], ...} is a valid argv", "[[ebp+0x10]] == NULL || [ebp+0x10] == NULL || [ebp+0x10] is a valid envp"],
                      effect: "execve(\"/bin/sh\", eax, [ebp+0x10])")
OneGadget::Gadget.add(build_id, 868536,
                      constraints: ["ebx is the GOT address of libc", "esi == 0x1", "writable: eax", "writable: ebp-0x1c", "[ebp+0x8] == NULL || {\"sh\", [ebp+0x8], [eax+0x8], [eax+0xc], ...} is a valid argv", "[[ebp+0x10]] == NULL || [ebp+0x10] == NULL || [ebp+0x10] is a valid envp"],
                      effect: "execve(\"/bin/sh\", eax, [ebp+0x10])")

