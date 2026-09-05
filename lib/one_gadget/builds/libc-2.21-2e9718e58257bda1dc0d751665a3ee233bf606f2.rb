require 'one_gadget/gadget'
# https://gitlab.com/david942j/libcdb/blob/master/libc/libc6_2.21-0ubuntu4.3_arm64/lib/aarch64-linux-gnu/libc-2.21.so
# 
# ARM 64-bit architecture
# 
# GNU C Library (Ubuntu GLIBC 2.21-0ubuntu4.3) stable release version 2.21, by Roland McGrath et al.
# Copyright (C) 2015 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.
# There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.
# Compiled by GNU CC version 4.9.3.
# Available extensions:
# 	crypt add-on version 2.1 by Michael Glad and others
# 	GNU Libidn by Simon Josefsson
# 	Native POSIX Threads Library by Ulrich Drepper et al
# 	BIND-8.2.3-T5B
# libc ABIs: UNIQUE
# For bug reporting instructions, please see:
# <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.

build_id = File.basename(__FILE__, '.rb').split('-').last
OneGadget::Gadget.add(build_id, 252156,
                      constraints: ["(u64)x0 <= 0xfffffffffffff000", "w0 == 0x0", "writable: x19+0x2a0", "x21 == NULL", "{\"sh\", \"-c\", x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 252164,
                      constraints: ["w0 == 0x0", "writable: x19+0x2a0", "x21 == NULL", "{\"sh\", \"-c\", x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 252168,
                      constraints: ["w0 == 0x0", "writable: x19+0x2a0", "x21 == NULL", "{\"sh\", \"-c\", x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 252888,
                      constraints: ["writable: x19+0x2a0", "x21 == NULL", "{\"sh\", \"-c\", x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 252892,
                      constraints: ["writable: x19+0x2a0", "writable: x20+0x4", "x21 == NULL", "{\"sh\", \"-c\", x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 252896,
                      constraints: ["writable: x19+0x2a0", "writable: x20+0x4", "x21 == NULL", "x4+0x5d8 == NULL || {x4+0x5d8, \"-c\", x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 252900,
                      constraints: ["writable: x19+0x2a0", "writable: x20+0x4", "x21 == NULL", "x4+0x5d8 == NULL || {x4+0x5d8, x3+0x5e0, x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 252904,
                      constraints: ["writable: x19+0x2a0", "writable: x20+0x4", "x21 == NULL", "x4 == NULL || {x4, x3+0x5e0, x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 252908,
                      constraints: ["writable: x19+0x2a0", "writable: x20+0x4", "x21 == NULL", "x4 == NULL || {x4, x3, x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 252912,
                      constraints: ["writable: x19+0x2a0", "writable: x20+0x4", "x2 == NULL", "x21 == NULL", "x4 == NULL || {x4, x3, x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 252916,
                      constraints: ["writable: x19+0x2a0", "writable: x20+0x4", "x1 == NULL", "x2 == NULL", "x21 == NULL", "x4 == NULL || {x4, x3, x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 252920,
                      constraints: ["writable: x19+0x2a0", "writable: x20+0x4", "x1 == NULL", "x2 == NULL", "x21 == NULL", "x4 == NULL || {x4, x3, x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 252924,
                      constraints: ["writable: x19+0x2a0", "writable: x20+0x4", "x1 == NULL", "x2 == NULL", "x21 == NULL", "[sp+0x58] == NULL || {[sp+0x58], x3, x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 252928,
                      constraints: ["writable: x19+0x2a0", "writable: x20+0x4", "x1 == NULL", "x2 == NULL", "x21 == NULL", "[sp+0x58] == NULL || {[sp+0x58], [sp+0x60], x23, NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 252932,
                      constraints: ["writable: x19+0x2a0", "writable: x20+0x4", "x1 == NULL", "x2 == NULL", "x21 == NULL", "[sp+0x58] == NULL || {[sp+0x58], [sp+0x60], [sp+0x68], NULL} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 252936,
                      constraints: ["writable: x19+0x2a0", "writable: x20+0x4", "x1 == NULL", "x2 == NULL", "x21 == NULL", "[sp+0x58] == NULL || {[sp+0x58], [sp+0x60], [sp+0x68], [sp+0x70], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 252940,
                      constraints: ["writable: x19+0x2a0", "writable: x20+0x4", "x21 == NULL", "[sp+0x58] == NULL || {[sp+0x58], [sp+0x60], [sp+0x68], [sp+0x70], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 252944,
                      constraints: ["writable: x19+0x2a0", "writable: x20+0x4", "x2 == NULL", "x21 == NULL", "[sp+0x58] == NULL || {[sp+0x58], [sp+0x60], [sp+0x68], [sp+0x70], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 252948,
                      constraints: ["writable: x19+0x2a0", "writable: x20+0x4", "x1 == NULL", "x2 == NULL", "x21 == NULL", "[sp+0x58] == NULL || {[sp+0x58], [sp+0x60], [sp+0x68], [sp+0x70], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 252952,
                      constraints: ["writable: x19+0x2a0", "writable: x20+0x4", "x1 == NULL", "x2 == NULL", "x21 == NULL", "[sp+0x58] == NULL || {[sp+0x58], [sp+0x60], [sp+0x68], [sp+0x70], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 252956,
                      constraints: ["writable: x19+0x2a0", "writable: x20+0x4", "x21 == NULL", "[sp+0x58] == NULL || {[sp+0x58], [sp+0x60], [sp+0x68], [sp+0x70], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 252960,
                      constraints: ["writable: x19+0x2a0", "writable: x20+0x4", "x21 == NULL", "[sp+0x58] == NULL || {[sp+0x58], [sp+0x60], [sp+0x68], [sp+0x70], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 252964,
                      constraints: ["writable: x19+0x2a0", "writable: x20+0x4", "x1 == NULL", "[sp+0x58] == NULL || {[sp+0x58], [sp+0x60], [sp+0x68], [sp+0x70], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 252968,
                      constraints: ["writable: x19+0x2a0", "writable: x20+0x4", "x1 == NULL", "[sp+0x58] == NULL || {[sp+0x58], [sp+0x60], [sp+0x68], [sp+0x70], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 252972,
                      constraints: ["writable: x19+0x2a0", "writable: x20+0x4", "[sp+0x58] == NULL || {[sp+0x58], [sp+0x60], [sp+0x68], [sp+0x70], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 252976,
                      constraints: ["writable: x20+0x4", "[sp+0x58] == NULL || {[sp+0x58], [sp+0x60], [sp+0x68], [sp+0x70], ...} is a valid argv"],
                      effect: "execve(\"/bin/sh\", sp+0x58, environ)")
OneGadget::Gadget.add(build_id, 408388,
                      constraints: ["x2+0x5e0 == NULL"],
                      effect: "execl(\"/bin/sh\", \"sh\", x2+0x5e0)")
OneGadget::Gadget.add(build_id, 408392,
                      constraints: ["x1+0x5d8 == NULL"],
                      effect: "execl(\"/bin/sh\", x1+0x5d8)")
OneGadget::Gadget.add(build_id, 647772,
                      constraints: ["w21 == 0x1", "x23 == NULL || {\"sh\", x23, [sp+0x10], [sp+0x18], ...} is a valid argv", "[x20] == NULL || x20 == NULL || x20 is a valid envp"],
                      effect: "execve(\"/bin/sh\", sp, x20)")
OneGadget::Gadget.add(build_id, 647776,
                      constraints: ["w21 == 0x1", "writable: x1", "x23 == NULL || {\"sh\", x23, [x1+0x10], [x1+0x18], ...} is a valid argv", "[x20] == NULL || x20 == NULL || x20 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x1, x20)")
OneGadget::Gadget.add(build_id, 648408,
                      constraints: ["w21 == 0x1", "writable: x0", "x23 == NULL || {\"sh\", x23, [x0+0x10], [x0+0x18], ...} is a valid argv", "[x20] == NULL || x20 == NULL || x20 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x0, x20)")
OneGadget::Gadget.add(build_id, 648412,
                      constraints: ["w21 == 0x1", "writable: x0", "x23 == NULL || {\"sh\", x23, [x0+0x10], [x0+0x18], ...} is a valid argv", "[x20] == NULL || x20 == NULL || x20 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x0, x20)")
OneGadget::Gadget.add(build_id, 648416,
                      constraints: ["w21 == 0x1", "writable: x1", "x0 != 0x0", "x23 == NULL || {\"sh\", x23, [x1+0x10], [x1+0x18], ...} is a valid argv", "[x20] == NULL || x20 == NULL || x20 is a valid envp"],
                      effect: "execve(\"/bin/sh\", x1, x20)")

