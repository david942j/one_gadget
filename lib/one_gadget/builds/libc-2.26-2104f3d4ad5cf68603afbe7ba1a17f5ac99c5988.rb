require 'one_gadget/gadget'
# spec/data/libc-2.26-2104f3d4ad5cf68603afbe7ba1a17f5ac99c5988.so
# 
# Advanced Micro Devices X86-64
# 
# GNU C Library (GNU libc) stable release version 2.26, by Roland McGrath et al.
# Copyright (C) 2017 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 7.2.0.
# Available extensions:
# 	crypt add-on version 2.1 by Michael Glad and others
# 	GNU Libidn by Simon Josefsson
# 	Native POSIX Threads Library by Ulrich Drepper et al
# 	BIND-8.2.3-T5B
# libc ABIs: UNIQUE IFUNC
# For bug reporting instructions, please see:
# <https://bugs.archlinux.org/>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 269970,
                      constraints: ["rax == NULL"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 270055,
                      constraints: ["[rsp+0x30] == NULL"],
                      effect: "execve(\"/bin/sh\", rsp+0x30, environ)")
OneGadget::Gadget.add(build_id, 805888,
                      constraints: ["[r13] == NULL || r13 == NULL", "[r12] == NULL || r12 == NULL"],
                      effect: "execve(\"/bin/sh\", r13, r12)")
OneGadget::Gadget.add(build_id, 805891,
                      constraints: ["[r13] == NULL || r13 == NULL", "[rdx] == NULL || rdx == NULL"],
                      effect: "execve(\"/bin/sh\", r13, rdx)")
OneGadget::Gadget.add(build_id, 805894,
                      constraints: ["[rsi] == NULL || rsi == NULL", "[rdx] == NULL || rdx == NULL"],
                      effect: "execve(\"/bin/sh\", rsi, rdx)")
OneGadget::Gadget.add(build_id, 928096,
                      constraints: ["[rsp+0x60] == NULL"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 928108,
                      constraints: ["[rsi] == NULL || rsi == NULL", "[[rax]] == NULL || [rax] == NULL"],
                      effect: "execve(\"/bin/sh\", rsi, [rax])")

