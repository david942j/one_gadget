require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc6-i386_2.31-0ubuntu9.7_amd64/lib32/libc-2.31.so
# 
# Intel 80386
# 
# GNU C Library (Ubuntu GLIBC 2.31-0ubuntu9.7) stable release version 2.31.
# Copyright (C) 2020 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 9.3.0.
# libc ABIs: UNIQUE IFUNC ABSOLUTE
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 821315,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x34", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[esi] == NULL || esi == NULL || esi is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], esi)")
OneGadget::Gadget.add(build_id, 821318,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x34", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[esi] == NULL || esi == NULL || esi is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], esi)")
OneGadget::Gadget.add(build_id, 821321,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x2c", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[esi] == NULL || esi == NULL || esi is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], esi)")
OneGadget::Gadget.add(build_id, 821327,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x2c", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[esi] == NULL || esi == NULL || esi is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], esi)")
OneGadget::Gadget.add(build_id, 821330,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x2c", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[esi] == NULL || esi == NULL || esi is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], esi)")
OneGadget::Gadget.add(build_id, 821332,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x2c", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[esi] == NULL || esi == NULL || esi is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], esi)")
OneGadget::Gadget.add(build_id, 821334,
                      constraints: ["ebx is the GOT address of libc", "eax == 0x0", "writable: ebp-0x2c", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[esi] == NULL || esi == NULL || esi is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], esi)")
OneGadget::Gadget.add(build_id, 821362,
                      constraints: ["ebx is the GOT address of libc", "ecx == 0x1", "writable: ebp-0x30", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[esi] == NULL || esi == NULL || esi is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], esi)")
OneGadget::Gadget.add(build_id, 821365,
                      constraints: ["ebx is the GOT address of libc", "ecx == 0x1", "writable: ebp-0x2c", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[esi] == NULL || esi == NULL || esi is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], esi)")
OneGadget::Gadget.add(build_id, 821512,
                      constraints: ["ebx is the GOT address of libc", "writable: ebp-0x2c", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[esi] == NULL || esi == NULL || esi is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], esi)")
OneGadget::Gadget.add(build_id, 821515,
                      constraints: ["ebx is the GOT address of libc", "writable: ebp-0x2c", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[esi] == NULL || esi == NULL || esi is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], esi)")
OneGadget::Gadget.add(build_id, 1318742,
                      constraints: ["ebp is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1318744,
                      constraints: ["ebp is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1318748,
                      constraints: ["ebp is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1318749,
                      constraints: ["ebp is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", [esp])")
OneGadget::Gadget.add(build_id, 1318755,
                      constraints: ["ebp is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", eax)")
OneGadget::Gadget.add(build_id, 1318756,
                      constraints: ["ebp is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", [esp])")

