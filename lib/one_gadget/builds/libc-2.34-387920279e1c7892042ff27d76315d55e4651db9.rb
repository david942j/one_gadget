require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc6_2.34-0ubuntu3.2_i386/lib/i386-linux-gnu/libc.so.6
# 
# Intel 80386
# 
# GNU C Library (Ubuntu GLIBC 2.34-0ubuntu3.2) stable release version 2.34.
# Copyright (C) 2021 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 10.3.0.
# libc ABIs: UNIQUE IFUNC ABSOLUTE
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 908513,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x34", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[ecx] == NULL || ecx == NULL || ecx is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 908516,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x34", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[ecx] == NULL || ecx == NULL || ecx is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 908519,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x2c", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[ecx] == NULL || ecx == NULL || ecx is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 908522,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x28", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 908528,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x28", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 908531,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x28", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 908533,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x28", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 908535,
                      constraints: ["ebx is the GOT address of libc", "eax == 0x0", "writable: ebp-0x28", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 908567,
                      constraints: ["ebx is the GOT address of libc", "ecx == 0x1", "edi == 0x0", "writable: ebp-0x30", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 908571,
                      constraints: ["ebx is the GOT address of libc", "ecx == 0x1", "writable: ebp-0x30", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 908574,
                      constraints: ["ebx is the GOT address of libc", "ecx == 0x1", "writable: ebp-0x28", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 908702,
                      constraints: ["ebx is the GOT address of libc", "writable: ebp-0x28", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 908704,
                      constraints: ["ebx is the GOT address of libc", "writable: ebp-0x28", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 908707,
                      constraints: ["ebx is the GOT address of libc", "writable: ebp-0x28", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 1509924,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1509926,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1509930,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1509931,
                      constraints: ["esi is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", [esp])")
OneGadget::Gadget.add(build_id, 1509937,
                      constraints: ["esi is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", eax)")
OneGadget::Gadget.add(build_id, 1509938,
                      constraints: ["esi is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", [esp])")

