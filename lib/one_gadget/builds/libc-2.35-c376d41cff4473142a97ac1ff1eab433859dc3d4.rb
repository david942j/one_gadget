require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc6_2.35-0ubuntu3_i386/lib/i386-linux-gnu/libc.so.6
# 
# Intel 80386
# 
# GNU C Library (Ubuntu GLIBC 2.35-0ubuntu3) stable release version 2.35.
# Copyright (C) 2022 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 11.2.0.
# libc ABIs: UNIQUE IFUNC ABSOLUTE
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 912705,
                      constraints: ["ebx is the GOT address of libc", "[[ebp+0xc]] == 0x0", "writable: ebp-0x34", "[ebp+0x8] == NULL || {\"/bin/sh\", [ebp+0x8], NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 912708,
                      constraints: ["ebx is the GOT address of libc", "[[ebp+0xc]] == 0x0", "writable: ebp-0x34", "[ebp+0x8] == NULL || {\"/bin/sh\", [ebp+0x8], NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 912711,
                      constraints: ["ebx is the GOT address of libc", "[[ebp+0xc]] == 0x0", "writable: ebp-0x34", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 912714,
                      constraints: ["ebx is the GOT address of libc", "[[ebp+0xc]] == 0x0", "writable: ebp-0x34", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[esi] == NULL || esi == NULL || esi is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 912717,
                      constraints: ["ebx is the GOT address of libc", "[[ebp+0xc]] == 0x0", "writable: ebp-0x30", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[esi] == NULL || esi == NULL || esi is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 912720,
                      constraints: ["ebx is the GOT address of libc", "[eax] == 0x0", "writable: ebp-0x30", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[esi] == NULL || esi == NULL || esi is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 912723,
                      constraints: ["ebx is the GOT address of libc", "[eax] == 0x0", "writable: ebp-0x30", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 912725,
                      constraints: ["ebx is the GOT address of libc", "edi == 0x0", "writable: ebp-0x30", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 912732,
                      constraints: ["ebx is the GOT address of libc", "edi == 0x0", "writable: ebp-0x30", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 912735,
                      constraints: ["ebx is the GOT address of libc", "edi == 0x0", "writable: ebp-0x30", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 912737,
                      constraints: ["ebx is the GOT address of libc", "edi == 0x0", "writable: ebp-0x30", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 912765,
                      constraints: ["ebx is the GOT address of libc", "ecx == 0x1", "esi == 0x0", "writable: ebp-0x30", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 912769,
                      constraints: ["ebx is the GOT address of libc", "ecx == 0x1", "writable: ebp-0x30", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 912894,
                      constraints: ["ebx is the GOT address of libc", "writable: ebp-0x30", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 912896,
                      constraints: ["ebx is the GOT address of libc", "writable: ebp-0x30", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 912899,
                      constraints: ["ebx is the GOT address of libc", "writable: ebp-0x30", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 1517620,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1517622,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1517626,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1517627,
                      constraints: ["esi is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", [esp])")
OneGadget::Gadget.add(build_id, 1517633,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", eax)")
OneGadget::Gadget.add(build_id, 1517634,
                      constraints: ["esi is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", [esp])")

