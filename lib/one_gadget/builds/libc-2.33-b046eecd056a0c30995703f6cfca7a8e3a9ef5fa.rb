require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/glibc-2.33-2-x86_64.pkg.tar/usr/lib/libc-2.33.so
# 
# Advanced Micro Devices X86-64
# 
# GNU C Library (GNU libc) release release version 2.33.
# Copyright (C) 2021 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 10.2.0.
# libc ABIs: UNIQUE IFUNC ABSOLUTE
# For bug reporting instructions, please see:
# <https://bugs.archlinux.org/>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 302265,
                      constraints: ["rax == NULL", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0", "rcx == NULL || (u16)[rcx] == NULL"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, rsp+0x50, environ)")
OneGadget::Gadget.add(build_id, 302287,
                      constraints: ["[r8] == NULL", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0", "rcx == NULL || (u16)[rcx] == NULL"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 485930,
                      constraints: ["[r8] == NULL", "rbx+0xe0 == NULL || writable: rbx+0xe0", "r12 == NULL || (s32)[r12+0x4] <= 0"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", r12, 0, r8, environ)")
OneGadget::Gadget.add(build_id, 485947,
                      constraints: ["[r8] == NULL", "rbx+0xe0 == NULL || writable: rbx+0xe0", "rdx == NULL || (s32)[rdx+0x4] <= 0", "rcx == NULL || (u16)[rcx] == NULL"],
                      effect: "posix_spawn(rbx+0xe0, \"/bin/sh\", rdx, rcx, r8, environ)")
OneGadget::Gadget.add(build_id, 838938,
                      constraints: ["[r12] == NULL || r12 == NULL", "[r13] == NULL || r13 == NULL"],
                      effect: "execve(\"/bin/sh\", r12, r13)")
OneGadget::Gadget.add(build_id, 838941,
                      constraints: ["[r12] == NULL || r12 == NULL", "[rdx] == NULL || rdx == NULL"],
                      effect: "execve(\"/bin/sh\", r12, rdx)")
OneGadget::Gadget.add(build_id, 838944,
                      constraints: ["[rsi] == NULL || rsi == NULL", "[rdx] == NULL || rdx == NULL"],
                      effect: "execve(\"/bin/sh\", rsi, rdx)")
OneGadget::Gadget.add(build_id, 839034,
                      constraints: ["writable: rbp-0x38", "[rbp-0x40] == NULL || rbp-0x40 == NULL", "[r13] == NULL || r13 == NULL"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r13)")
OneGadget::Gadget.add(build_id, 839041,
                      constraints: ["writable: rbp-0x40", "[rbp-0x40] == NULL || rbp-0x40 == NULL", "[r13] == NULL || r13 == NULL"],
                      effect: "execve(\"/bin/sh\", rbp-0x40, r13)")
OneGadget::Gadget.add(build_id, 960106,
                      constraints: ["[rsp+0x70] == NULL", "[[rsp+0xf0]] == NULL || [rsp+0xf0] == NULL", "[rsp+0x40] == NULL || (s32)[[rsp+0x40]+0x4] <= 0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", [rsp+0x40], 0, rsp+0x70, [rsp+0xf0])")
OneGadget::Gadget.add(build_id, 960114,
                      constraints: ["[rsp+0x70] == NULL", "[r9] == NULL || r9 == NULL", "[rsp+0x40] == NULL || (s32)[[rsp+0x40]+0x4] <= 0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", [rsp+0x40], 0, rsp+0x70, r9)")
OneGadget::Gadget.add(build_id, 960119,
                      constraints: ["[rsp+0x70] == NULL", "[r9] == NULL || r9 == NULL", "rdx == NULL || (s32)[rdx+0x4] <= 0"],
                      effect: "posix_spawn(rsp+0x64, \"/bin/sh\", rdx, 0, rsp+0x70, r9)")
OneGadget::Gadget.add(build_id, 960129,
                      constraints: ["[r8] == NULL", "[r9] == NULL || r9 == NULL", "rdi == NULL || writable: rdi", "rdx == NULL || (s32)[rdx+0x4] <= 0"],
                      effect: "posix_spawn(rdi, \"/bin/sh\", rdx, 0, r8, r9)")

