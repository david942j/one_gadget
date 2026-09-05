require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc6-i386_2.32-0ubuntu3_amd64/lib32/libc-2.32.so
# 
# Intel 80386
# 
# GNU C Library (Ubuntu GLIBC 2.32-0ubuntu3) release release version 2.32.
# Copyright (C) 2020 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 10.2.0.
# libc ABIs: UNIQUE IFUNC ABSOLUTE
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 843521,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x34", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[ecx] == NULL || ecx == NULL || ecx is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 843524,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x34", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[ecx] == NULL || ecx == NULL || ecx is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 843527,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x2c", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[ecx] == NULL || ecx == NULL || ecx is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 843530,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x28", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 843536,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x28", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 843539,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x28", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 843541,
                      constraints: ["ebx is the GOT address of libc", "[edx] == 0x0", "writable: ebp-0x28", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 843543,
                      constraints: ["ebx is the GOT address of libc", "eax == 0x0", "writable: ebp-0x28", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 843575,
                      constraints: ["ebx is the GOT address of libc", "ecx == 0x1", "edi == 0x0", "writable: ebp-0x30", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 843579,
                      constraints: ["ebx is the GOT address of libc", "ecx == 0x1", "writable: ebp-0x30", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 843582,
                      constraints: ["ebx is the GOT address of libc", "ecx == 0x1", "writable: ebp-0x28", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 843710,
                      constraints: ["ebx is the GOT address of libc", "writable: ebp-0x28", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 843712,
                      constraints: ["ebx is the GOT address of libc", "writable: ebp-0x28", "[ebp-0x34] == NULL || {\"/bin/sh\", [ebp-0x34], NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 843715,
                      constraints: ["ebx is the GOT address of libc", "writable: ebp-0x28", "eax == NULL || {\"/bin/sh\", eax, NULL} is a valid argv", "[[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid envp"],
                      effect: "execve(\"/bin/sh\", ebp-0x28, [ebp-0x2c])")
OneGadget::Gadget.add(build_id, 1358166,
                      constraints: ["ebp is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1358168,
                      constraints: ["ebp is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1358172,
                      constraints: ["ebp is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", eax)")
OneGadget::Gadget.add(build_id, 1358173,
                      constraints: ["ebp is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", [esp])")
OneGadget::Gadget.add(build_id, 1358179,
                      constraints: ["ebp is the GOT address of libc", "eax == NULL"],
                      effect: "execl(\"/bin/sh\", eax)")
OneGadget::Gadget.add(build_id, 1358180,
                      constraints: ["ebp is the GOT address of libc", "[esp] == NULL"],
                      effect: "execl(\"/bin/sh\", [esp])")

