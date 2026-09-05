require 'one_gadget/gadget'
# https://snapshot.debian.org/archive/debian-ports/20200312T150955Z/pool-x32/main/g/glibc/libc6-i386_2.31-0experimental0_x32.deb
# 
# Intel 80386
# 
# GNU C Library (Debian GLIBC 2.31-0experimental0) stable release version 2.31.
# Copyright (C) 2020 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 9.2.1 20200224.
# libc ABIs: UNIQUE IFUNC ABSOLUTE
# For bug reporting instructions, please see:
# <http://www.debian.org/Bugs/>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 837859,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x34", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[esi] == NULL || esi == NULL || esi is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], esi)")
OneGadget::Gadget.add(build_id, 837862,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x34", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[esi] == NULL || esi == NULL || esi is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], esi)")
OneGadget::Gadget.add(build_id, 837865,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x2c", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[esi] == NULL || esi == NULL || esi is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], esi)")
OneGadget::Gadget.add(build_id, 837871,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x2c", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[esi] == NULL || esi == NULL || esi is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], esi)")
OneGadget::Gadget.add(build_id, 837874,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x2c", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[esi] == NULL || esi == NULL || esi is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], esi)")
OneGadget::Gadget.add(build_id, 837876,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x2c", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[esi] == NULL || esi == NULL || esi is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], esi)")
OneGadget::Gadget.add(build_id, 837878,
                      constraints: ["ebx is the GOT address of libc", "eax == 0x0", "writable: ebp-0x2c", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[esi] == NULL || esi == NULL || esi is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], esi)")
OneGadget::Gadget.add(build_id, 837906,
                      constraints: ["ebx is the GOT address of libc", "ecx == 0x1", "writable: ebp-0x30", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[esi] == NULL || esi == NULL || esi is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], esi)")
OneGadget::Gadget.add(build_id, 837909,
                      constraints: ["ebx is the GOT address of libc", "ecx == 0x1", "writable: ebp-0x2c", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[esi] == NULL || esi == NULL || esi is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], esi)")
OneGadget::Gadget.add(build_id, 838056,
                      constraints: ["ebx is the GOT address of libc", "writable: ebp-0x2c", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[esi] == NULL || esi == NULL || esi is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], esi)")
OneGadget::Gadget.add(build_id, 838059,
                      constraints: ["ebx is the GOT address of libc", "writable: ebp-0x2c", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[esi] == NULL || esi == NULL || esi is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x2c], esi)")
OneGadget::Gadget.add(build_id, 1335094,
                      constraints: ["ebp is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1335096,
                      constraints: ["ebp is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1335100,
                      constraints: ["ebp is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1335101,
                      constraints: ["ebp is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", [esp])")
OneGadget::Gadget.add(build_id, 1335107,
                      constraints: ["ebp is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", eax)")
OneGadget::Gadget.add(build_id, 1335108,
                      constraints: ["ebp is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", [esp])")

