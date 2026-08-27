require 'one_gadget/gadget'
# http://archive.ubuntu.com/ubuntu/pool/main/g/glibc/libc6_2.35-0ubuntu3.14_i386.deb
# 
# Intel 80386
# 
# GNU C Library (Ubuntu GLIBC 2.35-0ubuntu3.14) stable release version 2.35.
# Copyright (C) 2022 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 11.4.0.
# libc ABIs: UNIQUE IFUNC ABSOLUTE
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 912865,
                      constraints: ["ebx is the GOT address of libc", "[[ebp+0xc]] == 0x0", "writable: ebp-0x34", "[ebp+0x8] == NULL || {\"/bin/sh\", [ebp+0x8], NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 912868,
                      constraints: ["ebx is the GOT address of libc", "[[ebp+0xc]] == 0x0", "writable: ebp-0x34", "[ebp+0x8] == NULL || {\"/bin/sh\", [ebp+0x8], NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 912871,
                      constraints: ["ebx is the GOT address of libc", "[[ebp+0xc]] == 0x0", "writable: ebp-0x34", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 912874,
                      constraints: ["ebx is the GOT address of libc", "[[ebp+0xc]] == 0x0", "writable: ebp-0x34", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[esi] == NULL || esi == NULL || esi is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 912877,
                      constraints: ["ebx is the GOT address of libc", "[[ebp+0xc]] == 0x0", "writable: ebp-0x30", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[esi] == NULL || esi == NULL || esi is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 912880,
                      constraints: ["ebx is the GOT address of libc", "[eax] == 0x0", "writable: ebp-0x30", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[esi] == NULL || esi == NULL || esi is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 912883,
                      constraints: ["ebx is the GOT address of libc", "[eax] == 0x0", "writable: ebp-0x30", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 912885,
                      constraints: ["ebx is the GOT address of libc", "edi == 0x0", "writable: ebp-0x30", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 912892,
                      constraints: ["ebx is the GOT address of libc", "edi == 0x0", "writable: ebp-0x30", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 912895,
                      constraints: ["ebx is the GOT address of libc", "edi == 0x0", "writable: ebp-0x30", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 912897,
                      constraints: ["ebx is the GOT address of libc", "edi == 0x0", "writable: ebp-0x30", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 912925,
                      constraints: ["ebx is the GOT address of libc", "ecx == 0x1", "esi == 0x0", "writable: ebp-0x30", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 912929,
                      constraints: ["ebx is the GOT address of libc", "ecx == 0x1", "writable: ebp-0x30", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 913054,
                      constraints: ["ebx is the GOT address of libc", "writable: ebp-0x30", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 913056,
                      constraints: ["ebx is the GOT address of libc", "writable: ebp-0x30", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 913059,
                      constraints: ["ebx is the GOT address of libc", "writable: ebp-0x30", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 1517940,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1517942,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1517946,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1517947,
                      constraints: ["esi is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", [esp])")
OneGadget::Gadget.add(build_id, 1517953,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", eax)")
OneGadget::Gadget.add(build_id, 1517954,
                      constraints: ["esi is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", [esp])")

