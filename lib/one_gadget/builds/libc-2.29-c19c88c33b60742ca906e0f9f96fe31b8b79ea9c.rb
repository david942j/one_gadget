require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/glibc-2.29-1-x86_64.pkg.tar/usr/lib/libc-2.29.so
# 
# Advanced Micro Devices X86-64
# 
# GNU C Library (GNU libc) stable release version 2.29.
# Copyright (C) 2019 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 8.2.1 20181127.
# libc ABIs: UNIQUE IFUNC ABSOLUTE
# For bug reporting instructions, please see:
# <https://bugs.archlinux.org/>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 281245,
                      constraints: ["rax == NULL", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0", "rcx == NULL || (u16)[rcx] == NULL"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 281267,
                      constraints: ["[r8] == NULL", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0", "rcx == NULL || (u16)[rcx] == NULL"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 465972,
                      constraints: ["[r8] == NULL", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0", "rcx == NULL || (u16)[rcx] == NULL"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 465987,
                      constraints: ["[r8] == NULL", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0", "rcx == NULL || (u16)[rcx] == NULL"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 819914,
                      constraints: ["[r13] == NULL || r13 == NULL", "[r12] == NULL || r12 == NULL"],
                      effect: "execve(\"/bin/sh\", r13, r12)")
OneGadget::Gadget.add(build_id, 819917,
                      constraints: ["[r13] == NULL || r13 == NULL", "[rdx] == NULL || rdx == NULL"],
                      effect: "execve(\"/bin/sh\", r13, rdx)")
OneGadget::Gadget.add(build_id, 819920,
                      constraints: ["[rsi] == NULL || rsi == NULL", "[rdx] == NULL || rdx == NULL"],
                      effect: "execve(\"/bin/sh\", rsi, rdx)")
OneGadget::Gadget.add(build_id, 820010,
                      constraints: ["writable: rbp-0x38", "[rbp-0x40] == NULL || rbp-0x40 == NULL", "[r12] == NULL || r12 == NULL"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r12)")
OneGadget::Gadget.add(build_id, 820014,
                      constraints: ["writable: rbp-0x40", "[rbp-0x40] == NULL || rbp-0x40 == NULL", "[r12] == NULL || r12 == NULL"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r12)")
OneGadget::Gadget.add(build_id, 944400,
                      constraints: ["[rsp+0x60] == NULL"],
                      effect: "execve(\"/bin/sh\", rsp+0x60, environ)")
OneGadget::Gadget.add(build_id, 944412,
                      constraints: ["[rsi] == NULL || rsi == NULL", "[[rax]] == NULL || [rax] == NULL"],
                      effect: "execve(\"/bin/sh\", rsi, [rax])")

