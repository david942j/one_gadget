require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc6_2.29-0ubuntu2_i386/lib/i386-linux-gnu/libc-2.29.so
# 
# Intel 80386
# 
# GNU C Library (Ubuntu GLIBC 2.29-0ubuntu2) stable release version 2.29.
# Copyright (C) 2019 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 8.3.0.
# libc ABIs: UNIQUE IFUNC ABSOLUTE
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 810369,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x30", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[ecx] == NULL || ecx == NULL || ecx is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x30])")
OneGadget::Gadget.add(build_id, 810372,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x30", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[ecx] == NULL || ecx == NULL || ecx is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x30])")
OneGadget::Gadget.add(build_id, 810375,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x30", "[ebp-0x2c] == NULL || {\"/bin/sh\", [ebp-0x2c], NULL} is a valid argv", "[ecx] == NULL || ecx == NULL || ecx is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x30])")
OneGadget::Gadget.add(build_id, 810378,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x28", "[ebp-0x2c] == NULL || {\"/bin/sh\", [ebp-0x2c], NULL} is a valid argv", "[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x30])")
OneGadget::Gadget.add(build_id, 810384,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x28", "[ebp-0x2c] == NULL || {\"/bin/sh\", [ebp-0x2c], NULL} is a valid argv", "[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x30])")
OneGadget::Gadget.add(build_id, 810387,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x28", "[ebp-0x2c] == NULL || {\"/bin/sh\", [ebp-0x2c], NULL} is a valid argv", "[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x30])")
OneGadget::Gadget.add(build_id, 810389,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x28", "[ebp-0x2c] == NULL || {\"/bin/sh\", [ebp-0x2c], NULL} is a valid argv", "[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x30])")
OneGadget::Gadget.add(build_id, 810391,
                      constraints: ["ebx is the GOT address of libc", "eax == 0x0", "writable: ebp-0x28", "[ebp-0x2c] == NULL || {\"/bin/sh\", [ebp-0x2c], NULL} is a valid argv", "[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x30])")
OneGadget::Gadget.add(build_id, 810423,
                      constraints: ["ebx is the GOT address of libc", "ecx == 0x1", "edi == 0x0", "writable: ebp-0x34", "[ebp-0x2c] == NULL || {\"/bin/sh\", [ebp-0x2c], NULL} is a valid argv", "[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x30])")
OneGadget::Gadget.add(build_id, 810427,
                      constraints: ["ebx is the GOT address of libc", "ecx == 0x1", "writable: ebp-0x34", "[ebp-0x2c] == NULL || {\"/bin/sh\", [ebp-0x2c], NULL} is a valid argv", "[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x30])")
OneGadget::Gadget.add(build_id, 810430,
                      constraints: ["ebx is the GOT address of libc", "ecx == 0x1", "writable: ebp-0x28", "[ebp-0x2c] == NULL || {\"/bin/sh\", [ebp-0x2c], NULL} is a valid argv", "[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x30])")
OneGadget::Gadget.add(build_id, 810543,
                      constraints: ["ebx is the GOT address of libc", "writable: ebp-0x28", "[ebp-0x2c] == NULL || {\"/bin/sh\", [ebp-0x2c], NULL} is a valid argv", "[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x30])")
OneGadget::Gadget.add(build_id, 810544,
                      constraints: ["ebx is the GOT address of libc", "writable: ebp-0x28", "[ebp-0x2c] == NULL || {\"/bin/sh\", [ebp-0x2c], NULL} is a valid argv", "[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x30])")
OneGadget::Gadget.add(build_id, 810547,
                      constraints: ["ebx is the GOT address of libc", "writable: ebp-0x28", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x30])")
OneGadget::Gadget.add(build_id, 1303047,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1303049,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1303050,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1303051,
                      constraints: ["esi is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", [esp])")
OneGadget::Gadget.add(build_id, 1303057,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", eax)")
OneGadget::Gadget.add(build_id, 1303058,
                      constraints: ["esi is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", [esp])")

