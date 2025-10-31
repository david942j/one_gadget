[![Downloads](https://img.shields.io/endpoint?url=https://gem-badge-h3lg.onrender.com/downloads/one_gadget)](https://rubygems.org/gems/one_gadget)
[![Gem Version](https://badge.fury.io/rb/one_gadget.svg)](https://badge.fury.io/rb/one_gadget)
[![Build Status](https://github.com/david942j/one_gadget/workflows/build/badge.svg)](https://github.com/david942j/one_gadget/actions)
[![Maintainability](https://qlty.sh/gh/david942j/projects/one_gadget/maintainability.svg)](https://qlty.sh/gh/david942j/projects/one_gadget)
[![Code Coverage](https://qlty.sh/gh/david942j/projects/one_gadget/coverage.svg)](https://qlty.sh/gh/david942j/projects/one_gadget)
[![Inline docs](https://inch-ci.org/github/david942j/one_gadget.svg?branch=master)](https://inch-ci.org/github/david942j/one_gadget)
[![Yard Docs](http://img.shields.io/badge/yard-docs-blue.svg)](https://www.rubydoc.info/github/david942j/one_gadget/)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](http://choosealicense.com/licenses/mit/)

## OneGadget

When playing ctf pwn challenges we usually need the one-gadget RCE (remote code execution),
which leads to call `execve('/bin/sh', NULL, NULL)`.

This gem provides such gadgets finder, no need to use objdump or IDA-pro every time like a fool :wink:

To use this tool, type `one_gadget /path/to/libc` in command line and enjoy the magic :laughing:

## Installation

Available on RubyGems.org!
```bash
$ gem install one_gadget
```

Note: requires ruby version >= 2.1.0, you can use `ruby --version` to check.

## Supported Architectures

- [x] i386
- [x] amd64 (x86-64)
- [x] aarch64 (ARMv8)

## Implementation

OneGadget uses symbolic execution to find the constraints of gadgets to be successful.

The article introducing how I develop this tool can be found [on my blog](https://david942j.blogspot.com/2017/02/project-one-gadget-in-glibc.html).

## Usage

### Command Line Interface

```bash
$ one_gadget
# Usage: one_gadget <FILE|-b BuildID> [options]
#     -b, --build-id BuildID           BuildID[sha1] of libc.
#     -f, --[no-]force-file            Force search gadgets in file instead of build id first.
#     -l, --level OUTPUT_LEVEL         The output level.
#                                      OneGadget automatically selects gadgets with higher successful probability.
#                                      Increase this level to ask OneGadget show more gadgets it found.
#                                      Default: 0
#     -n, --near FUNCTIONS/FILE        Order gadgets by their distance to the given functions or to the GOT functions of the given file.
#     -o, --output-format FORMAT       Output format. FORMAT should be one of <pretty|raw|json>.
#                                      Default: pretty
#     -r, --raw                        Alias of -o raw. Output gadgets offset only, split with one space.
#     -s, --script exploit-script      Run exploit script with all possible gadgets.
#                                      The script will be run as 'exploit-script $offset'.
#         --info BuildID               Show version information given BuildID.
#         --base BASE_ADDRESS          The base address of libc.
#                                      Default: 0
#         --version                    Current gem version.

```

```bash
$ one_gadget /lib/x86_64-linux-gnu/libc.so.6
# 0xe3afe execve("/bin/sh", r15, r12)
# constraints:
#   [r15] == NULL || r15 == NULL || r15 is a valid argv
#   [r12] == NULL || r12 == NULL || r12 is a valid envp
#
# 0xe3b01 execve("/bin/sh", r15, rdx)
# constraints:
#   [r15] == NULL || r15 == NULL || r15 is a valid argv
#   [rdx] == NULL || rdx == NULL || rdx is a valid envp
#
# 0xe3b04 execve("/bin/sh", rsi, rdx)
# constraints:
#   [rsi] == NULL || rsi == NULL || rsi is a valid argv
#   [rdx] == NULL || rdx == NULL || rdx is a valid envp

```
![x86_64](https://github.com/david942j/one_gadget/blob/master/examples/x86_64.png?raw=true)

#### Given BuildID
```bash
$ one_gadget -b aad7dbe330f23ea00ca63daf793b766b51aceb5d
# 0x4557a execve("/bin/sh", rsp+0x30, environ)
# constraints:
#   [rsp+0x30] == NULL || {[rsp+0x30], [rsp+0x38], [rsp+0x40], [rsp+0x48], ...} is a valid argv
#
# 0xf1651 execve("/bin/sh", rsp+0x40, environ)
# constraints:
#   [rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv
#
# 0xf24cb execve("/bin/sh", rsp+0x60, environ)
# constraints:
#   [rsp+0x60] == NULL || {[rsp+0x60], [rsp+0x68], [rsp+0x70], [rsp+0x78], ...} is a valid argv

```
![build id](https://github.com/david942j/one_gadget/blob/master/examples/from_build_id.png?raw=true)

#### Gadgets Near Functions

##### Why

Consider this scenario when exploiting:
1. Able to write on GOT (Global Offset Table)
2. Base address of libc is *unknown*

In this scenario you can choose to write two low-byte on a GOT entry with one-gadget's two low-byte.
If the function offset on GOT is close enough with the one-gadget,
you will have at least 1/16 chance of success.

##### Usage

Reorder gadgets according to the distance of given functions.

```bash
$ one_gadget /lib/x86_64-linux-gnu/libc.so.6 --near exit,mkdir
# [OneGadget] Gadgets near exit(0x46a40):
# 0xe3afe execve("/bin/sh", r15, r12)
# constraints:
#   [r15] == NULL || r15 == NULL || r15 is a valid argv
#   [r12] == NULL || r12 == NULL || r12 is a valid envp
#
# 0xe3b01 execve("/bin/sh", r15, rdx)
# constraints:
#   [r15] == NULL || r15 == NULL || r15 is a valid argv
#   [rdx] == NULL || rdx == NULL || rdx is a valid envp
#
# 0xe3b04 execve("/bin/sh", rsi, rdx)
# constraints:
#   [rsi] == NULL || rsi == NULL || rsi is a valid argv
#   [rdx] == NULL || rdx == NULL || rdx is a valid envp
#
# [OneGadget] Gadgets near mkdir(0x10de70):
# 0xe3b04 execve("/bin/sh", rsi, rdx)
# constraints:
#   [rsi] == NULL || rsi == NULL || rsi is a valid argv
#   [rdx] == NULL || rdx == NULL || rdx is a valid envp
#
# 0xe3b01 execve("/bin/sh", r15, rdx)
# constraints:
#   [r15] == NULL || r15 == NULL || r15 is a valid argv
#   [rdx] == NULL || rdx == NULL || rdx is a valid envp
#
# 0xe3afe execve("/bin/sh", r15, r12)
# constraints:
#   [r15] == NULL || r15 == NULL || r15 is a valid argv
#   [r12] == NULL || r12 == NULL || r12 is a valid envp
#

```
![near](https://github.com/david942j/one_gadget/blob/master/examples/near.png?raw=true)

Regular expression is acceptable.
```bash
$ one_gadget /lib/x86_64-linux-gnu/libc.so.6 --near 'write.*' --raw
# [OneGadget] Gadgets near writev(0x114690):
# 932612 932609 932606
#
# [OneGadget] Gadgets near write(0x10e280):
# 932612 932609 932606
#

```

Pass an ELF file as the argument, OneGadget will take all GOT functions for processing.
```bash
$ one_gadget /lib/x86_64-linux-gnu/libc.so.6 --near spec/data/test_near_file.elf --raw
# [OneGadget] Gadgets near exit(0x46a40):
# 932606 932609 932612
#
# [OneGadget] Gadgets near puts(0x84420):
# 932606 932609 932612
#
# [OneGadget] Gadgets near printf(0x61c90):
# 932606 932609 932612
#
# [OneGadget] Gadgets near strlen(0x9f630):
# 932606 932609 932612
#
# [OneGadget] Gadgets near __cxa_finalize(0x46f10):
# 932606 932609 932612
#
# [OneGadget] Gadgets near __libc_start_main(0x23f90):
# 932606 932609 932612
#

```

#### Show All Gadgets

Sometimes `one_gadget` finds too many gadgets to show them in one screen,
by default gadgets would be filtered automatically *according to the difficulty of constraints*.

Use option `--level 1` to show all gadgets found instead of only those with higher probabilities.

```bash
$ one_gadget /lib/x86_64-linux-gnu/libc.so.6 --level 1
# 0x51dfb posix_spawn(rsp+0xc, "/bin/sh", 0, rbp, rsp+0x50, environ)
# constraints:
#   address rsp+0x60 is writable
#   rsp & 0xf == 0
#   {"sh", "-c", rbx, NULL} is a valid argv
#   rbp == NULL || (u16)[rbp] == NULL
#
# 0x51e02 posix_spawn(rsp+0xc, "/bin/sh", 0, rbp, rsp+0x50, environ)
# constraints:
#   address rsp+0x60 is writable
#   rsp & 0xf == 0
#   rax == NULL || {"sh", rax, rbx, NULL} is a valid argv
#   rbp == NULL || (u16)[rbp] == NULL
#
# 0x51e09 posix_spawn(rsp+0xc, "/bin/sh", 0, rbp, rsp+0x50, environ)
# constraints:
#   address rsp+0x60 is writable
#   rsp & 0xf == 0
#   rcx == NULL || {rcx, rax, rbx, NULL} is a valid argv
#   rbp == NULL || (u16)[rbp] == NULL
#
# 0x51e10 posix_spawn(rsp+0xc, "/bin/sh", rdx, rbp, rsp+0x50, environ)
# constraints:
#   address rsp+0x60 is writable
#   rsp & 0xf == 0
#   rcx == NULL || {rcx, (u64)xmm1, rbx, NULL} is a valid argv
#   rdx == NULL || (s32)[rdx+0x4] <= 0
#   rbp == NULL || (u16)[rbp] == NULL
#
# 0x51e15 posix_spawn(rsp+0xc, "/bin/sh", rdx, rbp, rsp+0x50, environ)
# constraints:
#   address rsp+0x60 is writable
#   rsp & 0xf == 0
#   (u64)xmm0 == NULL || {(u64)xmm0, (u64)xmm1, rbx, NULL} is a valid argv
#   rdx == NULL || (s32)[rdx+0x4] <= 0
#   rbp == NULL || (u16)[rbp] == NULL
#
# 0x51e25 posix_spawn(rdi, "/bin/sh", rdx, rbp, rsp+0x50, [rax])
# constraints:
#   address rsp+0x60 is writable
#   rsp & 0xf == 0
#   (u64)xmm0 == NULL || {(u64)xmm0, (u64)(xmm0 >> 64), rbx, NULL} is a valid argv
#   [[rax]] == NULL || [rax] == NULL || [rax] is a valid envp
#   rdi == NULL || writable: rdi
#   rdx == NULL || (s32)[rdx+0x4] <= 0
#   rbp == NULL || (u16)[rbp] == NULL
#
# 0x51e2a posix_spawn(rdi, "/bin/sh", rdx, rbp, r8, [rax])
# constraints:
#   address rsp+0x60 is writable
#   rsp & 0xf == 0
#   [r8] == NULL || r8 is a valid argv
#   [[rax]] == NULL || [rax] == NULL || [rax] is a valid envp
#   rdi == NULL || writable: rdi
#   rdx == NULL || (s32)[rdx+0x4] <= 0
#   rbp == NULL || (u16)[rbp] == NULL
#
# 0x51e2d posix_spawn(rdi, "/bin/sh", rdx, rcx, r8, [rax])
# constraints:
#   address rsp+0x60 is writable
#   rsp & 0xf == 0
#   [r8] == NULL || r8 is a valid argv
#   [[rax]] == NULL || [rax] == NULL || [rax] is a valid envp
#   rdi == NULL || writable: rdi
#   rdx == NULL || (s32)[rdx+0x4] <= 0
#   rcx == NULL || (u16)[rcx] == NULL
#
# 0x51e32 posix_spawn(rdi, "/bin/sh", rdx, rcx, r8, [rax])
# constraints:
#   address rsp+0x68 is writable
#   rsp & 0xf == 0
#   [r8] == NULL || r8 is a valid argv
#   [[rax]] == NULL || [rax] == NULL || [rax] is a valid envp
#   rdi == NULL || writable: rdi
#   rdx == NULL || (s32)[rdx+0x4] <= 0
#   rcx == NULL || (u16)[rcx] == NULL
#
# 0x84135 posix_spawn(rbx+0xe0, "/bin/sh", r12, 0, rsp+0x60, environ)
# constraints:
#   address rsp+0x70 is writable
#   rsp & 0xf == 0
#   {"sh", "-c", rbp, NULL} is a valid argv
#   rbx+0xe0 == NULL || writable: rbx+0xe0
#   r12 == NULL || (s32)[r12+0x4] <= 0
#
# 0x8413c posix_spawn(rbx+0xe0, "/bin/sh", r12, 0, rsp+0x60, environ)
# constraints:
#   address rsp+0x70 is writable
#   rsp & 0xf == 0
#   rax == NULL || {"sh", rax, rbp, NULL} is a valid argv
#   rbx+0xe0 == NULL || writable: rbx+0xe0
#   r12 == NULL || (s32)[r12+0x4] <= 0
#
# 0x84143 posix_spawn(rbx+0xe0, "/bin/sh", r12, 0, rsp+0x60, environ)
# constraints:
#   address rsp+0x70 is writable
#   rsp & 0xf == 0
#   rcx == NULL || {rcx, rax, rbp, NULL} is a valid argv
#   rbx+0xe0 == NULL || writable: rbx+0xe0
#   r12 == NULL || (s32)[r12+0x4] <= 0
#
# 0x84146 posix_spawn(rbx+0xe0, "/bin/sh", rdx, 0, rsp+0x60, environ)
# constraints:
#   address rsp+0x70 is writable
#   rsp & 0xf == 0
#   rcx == NULL || {rcx, rax, rbp, NULL} is a valid argv
#   rbx+0xe0 == NULL || writable: rbx+0xe0
#   rdx == NULL || (s32)[rdx+0x4] <= 0
#
# 0x8414b posix_spawn(rbx+0xe0, "/bin/sh", rdx, 0, rsp+0x60, environ)
# constraints:
#   address rsp+0x78 is writable
#   rsp & 0xf == 0
#   rcx == NULL || {rcx, rax, [rsp+0x70], NULL} is a valid argv
#   rbx+0xe0 == NULL || writable: rbx+0xe0
#   rdx == NULL || (s32)[rdx+0x4] <= 0
#
# 0x84150 posix_spawn(rbx+0xe0, "/bin/sh", rdx, 0, rsp+0x60, environ)
# constraints:
#   address rsp+0x78 is writable
#   rsp & 0xf == 0
#   rcx == NULL || {rcx, (u64)xmm1, [rsp+0x70], NULL} is a valid argv
#   rbx+0xe0 == NULL || writable: rbx+0xe0
#   rdx == NULL || (s32)[rdx+0x4] <= 0
#
# 0x8415c posix_spawn(rbx+0xe0, "/bin/sh", rdx, 0, rsp+0x60, [rax])
# constraints:
#   address rsp+0x78 is writable
#   rsp & 0xf == 0
#   (u64)xmm0 == NULL || {(u64)xmm0, (u64)xmm1, [rsp+0x70], NULL} is a valid argv
#   [[rax]] == NULL || [rax] == NULL || [rax] is a valid envp
#   rbx+0xe0 == NULL || writable: rbx+0xe0
#   rdx == NULL || (s32)[rdx+0x4] <= 0
#
# 0x84162 posix_spawn(rbx+0xe0, "/bin/sh", rdx, rcx, rsp+0x60, [rax])
# constraints:
#   address rsp+0x78 is writable
#   rsp & 0xf == 0
#   (u64)xmm0 == NULL || {(u64)xmm0, (u64)(xmm0 >> 64), [rsp+0x70], NULL} is a valid argv
#   [[rax]] == NULL || [rax] == NULL || [rax] is a valid envp
#   rbx+0xe0 == NULL || writable: rbx+0xe0
#   rdx == NULL || (s32)[rdx+0x4] <= 0
#   rcx == NULL || (u16)[rcx] == NULL
#
# 0x84169 posix_spawn(rdi, "/bin/sh", rdx, rcx, rsp+0x60, [rax])
# constraints:
#   address rsp+0x78 is writable
#   rsp & 0xf == 0
#   (u64)xmm0 == NULL || {(u64)xmm0, (u64)(xmm0 >> 64), [rsp+0x70], NULL} is a valid argv
#   [[rax]] == NULL || [rax] == NULL || [rax] is a valid envp
#   rdi == NULL || writable: rdi
#   rdx == NULL || (s32)[rdx+0x4] <= 0
#   rcx == NULL || (u16)[rcx] == NULL
#
# 0x84170 posix_spawn(rdi, "/bin/sh", rdx, rcx, r8, [rax])
# constraints:
#   address rsp+0x78 is writable
#   rsp & 0xf == 0
#   [r8] == NULL || r8 is a valid argv
#   [[rax]] == NULL || [rax] == NULL || [rax] is a valid envp
#   rdi == NULL || writable: rdi
#   rdx == NULL || (s32)[rdx+0x4] <= 0
#   rcx == NULL || (u16)[rcx] == NULL
#
# 0xe3afe execve("/bin/sh", r15, r12)
# constraints:
#   [r15] == NULL || r15 == NULL || r15 is a valid argv
#   [r12] == NULL || r12 == NULL || r12 is a valid envp
#
# 0xe3b01 execve("/bin/sh", r15, rdx)
# constraints:
#   [r15] == NULL || r15 == NULL || r15 is a valid argv
#   [rdx] == NULL || rdx == NULL || rdx is a valid envp
#
# 0xe3b04 execve("/bin/sh", rsi, rdx)
# constraints:
#   [rsi] == NULL || rsi == NULL || rsi is a valid argv
#   [rdx] == NULL || rdx == NULL || rdx is a valid envp
#
# 0xe3cf3 execve("/bin/sh", r10, r12)
# constraints:
#   address rbp-0x78 is writable
#   [r10] == NULL || r10 == NULL || r10 is a valid argv
#   [r12] == NULL || r12 == NULL || r12 is a valid envp
#
# 0xe3cf6 execve("/bin/sh", r10, rdx)
# constraints:
#   address rbp-0x78 is writable
#   [r10] == NULL || r10 == NULL || r10 is a valid argv
#   [rdx] == NULL || rdx == NULL || rdx is a valid envp
#
# 0xe3d62 execve("/bin/sh", rbp-0x50, r12)
# constraints:
#   address rbp-0x48 is writable
#   r13 == NULL || {"/bin/sh", r13, NULL} is a valid argv
#   [r12] == NULL || r12 == NULL || r12 is a valid envp
#
# 0xe3d69 execve("/bin/sh", rbp-0x50, r12)
# constraints:
#   address rbp-0x48 is writable
#   rax == NULL || {rax, r13, NULL} is a valid argv
#   [r12] == NULL || r12 == NULL || r12 is a valid envp
#
# 0xe3d70 execve("/bin/sh", rbp-0x50, r12)
# constraints:
#   address rbp-0x50 is writable
#   rax == NULL || {rax, [rbp-0x48], NULL} is a valid argv
#   [r12] == NULL || r12 == NULL || r12 is a valid envp
#
# 0xe3da7 execve("/bin/sh", rbp-0x50, r12)
# constraints:
#   address rbp-0x50 is writable
#   [rbp-0x68] == NULL || {"/bin/sh", [rbp-0x68], NULL} is a valid argv
#   [r12] == NULL || r12 == NULL || r12 is a valid envp
#
# 0xe3db1 execve("/bin/sh", rbp-0x50, r12)
# constraints:
#   address rbp-0x50 is writable
#   rax == NULL || {rax, [rbp-0x68], NULL} is a valid argv
#   [r12] == NULL || r12 == NULL || r12 is a valid envp
#
# 0xe3db5 execve("/bin/sh", r10, r12)
# constraints:
#   addresses r10+0x10, rbp-0x50 are writable
#   [r10] == NULL || r10 == NULL || r10 is a valid argv
#   [r12] == NULL || r12 == NULL || r12 is a valid envp
#
# 0xe3dbd execve("/bin/sh", r10, r12)
# constraints:
#   addresses r10+0x10, rbp-0x48 are writable
#   [r10] == NULL || r10 == NULL || r10 is a valid argv
#   [r12] == NULL || r12 == NULL || r12 is a valid envp
#
# 0x1077ca posix_spawn(rsp+0x64, "/bin/sh", [rsp+0x38], 0, rsp+0x70, [rsp+0xf0])
# constraints:
#   [rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv
#   [[rsp+0xf0]] == NULL || [rsp+0xf0] == NULL || [rsp+0xf0] is a valid envp
#   [rsp+0x38] == NULL || (s32)[[rsp+0x38]+0x4] <= 0
#
# 0x1077d2 posix_spawn(rsp+0x64, "/bin/sh", [rsp+0x38], 0, rsp+0x70, r9)
# constraints:
#   [rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv
#   [r9] == NULL || r9 == NULL || r9 is a valid envp
#   [rsp+0x38] == NULL || (s32)[[rsp+0x38]+0x4] <= 0
#
# 0x1077d7 posix_spawn(rsp+0x64, "/bin/sh", rdx, 0, rsp+0x70, r9)
# constraints:
#   [rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv
#   [r9] == NULL || r9 == NULL || r9 is a valid envp
#   rdx == NULL || (s32)[rdx+0x4] <= 0
#
# 0x1077e1 posix_spawn(rdi, "/bin/sh", rdx, 0, r8, r9)
# constraints:
#   [r8] == NULL || r8 is a valid argv
#   [r9] == NULL || r9 == NULL || r9 is a valid envp
#   rdi == NULL || writable: rdi
#   rdx == NULL || (s32)[rdx+0x4] <= 0

```

#### Other Architectures

##### i386
```bash
$ one_gadget /lib32/libc.so.6
# 0xc890b execve("/bin/sh", [ebp-0x2c], esi)
# constraints:
#   address ebp-0x20 is writable
#   ebx is the GOT address of libc
#   [[ebp-0x2c]] == NULL || [ebp-0x2c] == NULL || [ebp-0x2c] is a valid argv
#   [esi] == NULL || esi == NULL || esi is a valid envp
#
# 0x1421b3 execl("/bin/sh", eax)
# constraints:
#   ebp is the GOT address of libc
#   eax == NULL
#
# 0x1421b4 execl("/bin/sh", [esp])
# constraints:
#   ebp is the GOT address of libc
#   [esp] == NULL

```
![i386](https://github.com/david942j/one_gadget/blob/master/examples/i386.png?raw=true)

##### AArch64
```bash
$ one_gadget spec/data/aarch64-libc-2.27.so
# 0x3f160 execve("/bin/sh", sp+0x70, environ)
# constraints:
#   address x20+0x338 is writable
#   x3 == NULL
#
# 0x3f184 execve("/bin/sh", sp+0x70, environ)
# constraints:
#   addresses x19+0x4, x20+0x338 are writable
#   [sp+0x70] == NULL
#
# 0x3f1a8 execve("/bin/sh", x21, environ)
# constraints:
#   addresses x19+0x4, x20+0x338 are writable
#   [x21] == NULL || x21 == NULL
#
# 0x63e90 execl("/bin/sh", x1)
# constraints:
#   x1 == NULL

```
![aarch64](https://github.com/david942j/one_gadget/blob/master/examples/aarch64.png?raw=true)

#### Combine with Script
Pass your exploit script as `one_gadget`'s arguments, it can
try all gadgets one by one, so you don't need to try every possible gadgets manually.

```bash
$ one_gadget ./spec/data/libc-2.19.so -s 'echo "offset ->"'
```

![--script](https://github.com/david942j/one_gadget/blob/master/examples/script.png?raw=true)

### In Ruby Scripts
```ruby
require 'one_gadget'
OneGadget.gadgets(file: '/lib/x86_64-linux-gnu/libc.so.6')
#=> [932606, 932609, 932612]

# or in shorter way
one_gadget('/lib/x86_64-linux-gnu/libc.so.6', level: 1)
#=> [335355, 335362, 335369, 335376, 335381, 335397, 335402, 335405, 335410, 540981, 540988, 540995, 540998, 541003, 541008, 541020, 541026, 541033, 541040, 932606, 932609, 932612, 933107, 933110, 933218, 933225, 933232, 933287, 933297, 933301, 933309, 1079242, 1079250, 1079255, 1079265]

# from build id
one_gadget('b417c0ba7cc5cf06d1d1bed6652cedb9253c60d0')
#=> [324286, 324293, 324386, 1090444]

```

### To Python Lovers
```python
import subprocess
def one_gadget(filename):
  return [int(i) for i in subprocess.check_output(['one_gadget', '--raw', filename]).decode().split(' ')]

one_gadget('/lib/x86_64-linux-gnu/libc.so.6')
#=> [932606, 932609, 932612]

```

## Make OneGadget Better
Any suggestion or feature request is welcome! Feel free to send a pull request.

Please let me know if you find any libc that make OneGadget fail to find gadgets.
And, if you like this work, I'll be happy to be [starred](https://github.com/david942j/one_gadget/stargazers) :grimacing:
