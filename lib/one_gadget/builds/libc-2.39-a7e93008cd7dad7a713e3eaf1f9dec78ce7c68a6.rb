require 'one_gadget/gadget'
# http://archive.ubuntu.com/ubuntu/pool/main/g/glibc/libc6_2.39-0ubuntu8.8_i386.deb
# 
# Intel 80386
# 
# GNU C Library (Ubuntu GLIBC 2.39-0ubuntu8.8) stable release version 2.39.
# Copyright (C) 2024 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 13.3.0.
# libc ABIs: UNIQUE IFUNC ABSOLUTE
# Minimum supported kernel: 3.2.0
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 929183,
                      constraints: ["edi is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x30", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[ecx] == NULL || ecx == NULL || ecx is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], ecx)")
OneGadget::Gadget.add(build_id, 929184,
                      constraints: ["edi is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x30", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[ecx] == NULL || ecx == NULL || ecx is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], ecx)")
OneGadget::Gadget.add(build_id, 929186,
                      constraints: ["edi is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x30", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[esi] == NULL || esi == NULL || esi is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], esi)")
OneGadget::Gadget.add(build_id, 929187,
                      constraints: ["edi is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x30", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[esi] == NULL || esi == NULL || esi is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], esi)")
OneGadget::Gadget.add(build_id, 929189,
                      constraints: ["edi is the GOT address of libc", "[ebx] == 0x0", "writable: ebp-0x30", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[esi] == NULL || esi == NULL || esi is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], esi)")
OneGadget::Gadget.add(build_id, 929192,
                      constraints: ["edi is the GOT address of libc", "[ebx] == 0x0", "writable: ebp-0x30", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[esi] == NULL || esi == NULL || esi is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], esi)")
OneGadget::Gadget.add(build_id, 929195,
                      constraints: ["[ebp-0x2c] is the GOT address of libc", "[ebx] == 0x0", "writable: ebp-0x30", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[esi] == NULL || esi == NULL || esi is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], esi)")
OneGadget::Gadget.add(build_id, 929197,
                      constraints: ["[ebp-0x2c] is the GOT address of libc", "edi == 0x0", "writable: ebp-0x30", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[esi] == NULL || esi == NULL || esi is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], esi)")
OneGadget::Gadget.add(build_id, 929204,
                      constraints: ["[ebp-0x2c] is the GOT address of libc", "edi == 0x0", "writable: ebp-0x30", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[esi] == NULL || esi == NULL || esi is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], esi)")
OneGadget::Gadget.add(build_id, 929207,
                      constraints: ["[ebp-0x2c] is the GOT address of libc", "edi == 0x0", "writable: ebp-0x30", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[esi] == NULL || esi == NULL || esi is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], esi)")
OneGadget::Gadget.add(build_id, 929209,
                      constraints: ["[ebp-0x2c] is the GOT address of libc", "edi == 0x0", "writable: ebp-0x30", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[esi] == NULL || esi == NULL || esi is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], esi)")
OneGadget::Gadget.add(build_id, 929230,
                      constraints: ["[ebp-0x2c] is the GOT address of libc", "ecx == 0x0", "edx == 0x1", "writable: ebp-0x30", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[esi] == NULL || esi == NULL || esi is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], esi)")
OneGadget::Gadget.add(build_id, 929234,
                      constraints: ["[ebp-0x2c] is the GOT address of libc", "edx == 0x1", "writable: ebp-0x30", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[esi] == NULL || esi == NULL || esi is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], esi)")
OneGadget::Gadget.add(build_id, 929405,
                      constraints: ["[ebp-0x2c] is the GOT address of libc", "writable: ebp-0x30", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[esi] == NULL || esi == NULL || esi is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], esi)")
OneGadget::Gadget.add(build_id, 929408,
                      constraints: ["[ebp-0x2c] is the GOT address of libc", "writable: ebp-0x30", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[esi] == NULL || esi == NULL || esi is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], esi)")
OneGadget::Gadget.add(build_id, 929411,
                      constraints: ["ecx is the GOT address of libc", "writable: ebp-0x30", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[esi] == NULL || esi == NULL || esi is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], esi)")
OneGadget::Gadget.add(build_id, 929414,
                      constraints: ["ecx is the GOT address of libc", "writable: ebp-0x30", "[ebp-0x24] == NULL || {\"/bin/sh\", [ebp-0x24], NULL} is a valid argv", "[esi] == NULL || esi == NULL || esi is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], esi)")
OneGadget::Gadget.add(build_id, 929417,
                      constraints: ["ecx is the GOT address of libc", "writable: ebp-0x30", "[eax] == NULL || eax == NULL || eax is a valid argv", "[esi] == NULL || esi == NULL || esi is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], esi)")
OneGadget::Gadget.add(build_id, 929424,
                      constraints: ["ecx is the GOT address of libc", "writable: ebp-0x30", "[eax] == NULL || eax == NULL || eax is a valid argv", "[esi] == NULL || esi == NULL || esi is a valid envp"],
                      effect: "execve(\"/bin/sh\", [ebp-0x30], esi)")
OneGadget::Gadget.add(build_id, 1564564,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1564566,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1564570,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1564571,
                      constraints: ["esi is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", [esp])")
OneGadget::Gadget.add(build_id, 1564577,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", eax)")
OneGadget::Gadget.add(build_id, 1564578,
                      constraints: ["esi is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", [esp])")

