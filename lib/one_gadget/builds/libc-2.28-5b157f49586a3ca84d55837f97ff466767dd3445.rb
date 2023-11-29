require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc6_2.28-0ubuntu1_amd64/lib/x86_64-linux-gnu/libc-2.28.so
# 
# Advanced Micro Devices X86-64
# 
# GNU C Library (Ubuntu GLIBC 2.28-0ubuntu1) stable release version 2.28.
# Copyright (C) 2018 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 8.2.0.
# libc ABIs: UNIQUE IFUNC ABSOLUTE
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 328056,
                      constraints: ["rsp & 0xf == 0", "writable: rsp+0x8", "{\"sh\", \"-c\", r12, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 328063,
                      constraints: ["rsp & 0xf == 0", "writable: rsp+0x8", "rcx == NULL || {rcx, \"-c\", r12, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 328070,
                      constraints: ["rsp & 0xf == 0", "writable: rsp+0x8", "rcx == NULL || {rcx, rax, r12, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 328163,
                      constraints: ["[rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x40, environ)")
OneGadget::Gadget.add(build_id, 328175,
                      constraints: ["[rsi] == NULL || rsi == NULL || rsi is a valid argv", "[[rax]] == NULL || [rax] == NULL || [rax] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, [rax])")
OneGadget::Gadget.add(build_id, 913902,
                      constraints: ["[r15] == NULL || r15 == NULL || r15 is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", r15, r13)")
OneGadget::Gadget.add(build_id, 913905,
                      constraints: ["[r15] == NULL || r15 == NULL || r15 is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", r15, rdx)")
OneGadget::Gadget.add(build_id, 913908,
                      constraints: ["[rsi] == NULL || rsi == NULL || rsi is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rsi, rdx)")
OneGadget::Gadget.add(build_id, 914335,
                      constraints: ["[rcx] == NULL || rcx == NULL || rcx is a valid argv", "[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp"],
                      effect: "execve(\"/bin/sh\", rcx, [rbp-0x70])")
OneGadget::Gadget.add(build_id, 914339,
                      constraints: ["[rcx] == NULL || rcx == NULL || rcx is a valid argv", "[rdx] == NULL || rdx == NULL || rdx is a valid envp"],
                      effect: "execve(\"/bin/sh\", rcx, rdx)")
OneGadget::Gadget.add(build_id, 914411,
                      constraints: ["writable: rbp-0x48", "rbx == NULL || {\"/bin/sh\", rbx, NULL} is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r13)")
OneGadget::Gadget.add(build_id, 914421,
                      constraints: ["writable: rbp-0x48", "rax == NULL || {rax, rbx, NULL} is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r13)")
OneGadget::Gadget.add(build_id, 914425,
                      constraints: ["writable: rbp-0x50", "rax == NULL || {rax, [rbp-0x48], NULL} is a valid argv", "[r13] == NULL || r13 == NULL || r13 is a valid envp"],
                      effect: "execve(\"/bin/sh\", rbp-0x50, r13)")
OneGadget::Gadget.add(build_id, 1064784,
                      constraints: ["[rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", rsp+0x70, environ)")

