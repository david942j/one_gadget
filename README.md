[![Downloads](https://img.shields.io/gem/dt/one_gadget)](https://rubygems.org/gems/one_gadget)


[![Gem Version](https://badge.fury.io/rb/one_gadget.svg)](https://badge.fury.io/rb/one_gadget)
[![Build Status](https://github.com/david942j/one_gadget/workflows/build/badge.svg)](https://github.com/david942j/one_gadget/actions)
[![Maintainability](https://qlty.sh/gh/david942j/projects/one_gadget/maintainability.svg)](https://qlty.sh/gh/david942j/projects/one_gadget)
[![Code Coverage](https://qlty.sh/gh/david942j/projects/one_gadget/coverage.svg)](https://qlty.sh/gh/david942j/projects/one_gadget)
[![Inline docs](https://inch-ci.org/github/david942j/one_gadget.svg?branch=master)](https://inch-ci.org/github/david942j/one_gadget)
[![Yard Docs](http://img.shields.io/badge/yard-docs-blue.svg)](https://www.rubydoc.info/github/david942j/one_gadget/)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](http://choosealicense.com/licenses/mit/)

## OneGadget

When solving CTF pwn challenges we usually want a one-gadget RCE: a single address in
libc that, jumped to, calls `execve("/bin/sh", NULL, NULL)`.

This gem finds them for you, so you don't have to dig through objdump or IDA Pro every
time :wink:

Point it at a libc -- `one_gadget /path/to/libc` -- and enjoy the magic :laughing:

## Installation

Available on RubyGems.org!
```bash
$ gem install one_gadget
```

## Supported Architectures

- [x] i386
- [x] amd64 (x86-64)
- [x] aarch64 (ARMv8)
- [x] arm (ARMv7, A32/Thumb-2)
- [x] riscv64 (RV64GC)

## Implementation

OneGadget symbolically executes the code around each candidate address to work out what
has to hold for the gadget to work.

Gadgets are found by walking the control-flow graph backward from each `exec`/`posix_spawn`
call, following conditional branches both ways. When a gadget is only reachable if a branch is
(not) taken, that decision shows up as an extra constraint, e.g. `x2 == 0x1`.

The article introducing how I develop this tool can be found [on my blog](https://david942j.blogspot.com/2017/02/project-one-gadget-in-glibc.html).

### Checked by running them

Constraints are only worth as much as they are complete, so the gadgets this repository
ships are verified by being run. [Aletheia](aletheia/README.md) loads the libc in a live
process, arranges exactly what a gadget's constraints ask for, poisons every register and
page they *don't* mention, jumps to the offset, and requires a real `/bin/sh` to come back
and list the root directory. A gadget whose constraint list is missing something fails
there instead of passing by luck -- which is how several missing constraints were found.

```bash
bundle exec rake aletheia:verify                # every libc under spec/data, level 0
bundle exec rake "aletheia:verify[1, aarch64]"  # one output level, one architecture
```

Aletheia is development tooling: it lives outside `lib/` and `bin/`, so it is not part of
the published gem.

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
$ one_gadget spec/data/libc-2.31-9fdb74e7b217d06c93172a8243f8547f947ee6d1.so
# 0xe3b31 execve("/bin/sh", r15, rdx)
# constraints:
#   [r15] == NULL || r15 == NULL || r15 is a valid argv
#   [rdx] == NULL || rdx == NULL || rdx is a valid envp
#
# 0xe3b34 execve("/bin/sh", rsi, rdx)
# constraints:
#   [rsi] == NULL || rsi == NULL || rsi is a valid argv
#   [rdx] == NULL || rdx == NULL || rdx is a valid envp
#
# 0xe3c20 execve("/bin/sh", r15, r12)
# constraints:
#   [r15] == NULL || r15 == NULL || r15 is a valid argv
#   [r12] == NULL || r12 == NULL || r12 is a valid envp
#
# 0x107cea posix_spawn(rsp+0x64, "/bin/sh", [rsp+0x38], 0, rsp+0x70, environ)
# constraints:
#   [rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv
#   [rsp+0x38] == NULL || (s32)[[rsp+0x38]+0x4] <= 0x0

```
![x86_64](https://github.com/david942j/one_gadget/blob/master/examples/x86_64.png?raw=true)

#### Given BuildID
```bash
$ one_gadget -b b417c0ba7cc5cf06d1d1bed6652cedb9253c60d0
# 0x4f322 execve("/bin/sh", rsp+0x40, environ)
# constraints:
#   [rsp+0x40] == NULL || {[rsp+0x40], [rsp+0x48], [rsp+0x50], [rsp+0x58], ...} is a valid argv
#
# 0xe56d8 execve("/bin/sh", r14, r12)
# constraints:
#   [r14] == NULL || r14 == NULL || r14 is a valid argv
#   [r12] == NULL || r12 == NULL || r12 is a valid envp
#
# 0xe5863 execve("/bin/sh", r10, rdx)
# constraints:
#   [r10] == NULL || r10 == NULL || r10 is a valid argv
#   [rdx] == NULL || rdx == NULL || rdx is a valid envp
#
# 0x10a38c execve("/bin/sh", rsp+0x70, environ)
# constraints:
#   [rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv

```
![build id](https://github.com/david942j/one_gadget/blob/master/examples/from_build_id.png?raw=true)

The gem carries the gadgets of the libcs most likely to be asked for -- the glibc of
every Ubuntu LTS still in standard support, and every libc the tests cover. Any other
BuildID is fetched from this repository, which keeps them all.

#### Gadgets Near Functions

##### Why

Consider this situation while exploiting:
1. You can write to the GOT (Global Offset Table).
2. The base address of libc is *unknown*.

Here you can overwrite the low two bytes of a GOT entry with the low two bytes of a
one-gadget. If the function sits close enough to the gadget, only one nibble is left to
guess -- at least a 1 in 16 chance of success.

##### Usage

Sorts the gadgets by how far they are from the functions you name.

```bash
$ one_gadget spec/data/libc-2.31-9fdb74e7b217d06c93172a8243f8547f947ee6d1.so --near exit,mkdir
# [OneGadget] Gadgets near exit(0x46a70):
# 0xe3b31 execve("/bin/sh", r15, rdx)
# constraints:
#   [r15] == NULL || r15 == NULL || r15 is a valid argv
#   [rdx] == NULL || rdx == NULL || rdx is a valid envp
#
# 0xe3b34 execve("/bin/sh", rsi, rdx)
# constraints:
#   [rsi] == NULL || rsi == NULL || rsi is a valid argv
#   [rdx] == NULL || rdx == NULL || rdx is a valid envp
#
# 0xe3c20 execve("/bin/sh", r15, r12)
# constraints:
#   [r15] == NULL || r15 == NULL || r15 is a valid argv
#   [r12] == NULL || r12 == NULL || r12 is a valid envp
#
# 0x107cea posix_spawn(rsp+0x64, "/bin/sh", [rsp+0x38], 0, rsp+0x70, environ)
# constraints:
#   [rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv
#   [rsp+0x38] == NULL || (s32)[[rsp+0x38]+0x4] <= 0x0
#
# [OneGadget] Gadgets near mkdir(0x10dc80):
# 0x107cea posix_spawn(rsp+0x64, "/bin/sh", [rsp+0x38], 0, rsp+0x70, environ)
# constraints:
#   [rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv
#   [rsp+0x38] == NULL || (s32)[[rsp+0x38]+0x4] <= 0x0
#
# 0xe3c20 execve("/bin/sh", r15, r12)
# constraints:
#   [r15] == NULL || r15 == NULL || r15 is a valid argv
#   [r12] == NULL || r12 == NULL || r12 is a valid envp
#
# 0xe3b34 execve("/bin/sh", rsi, rdx)
# constraints:
#   [rsi] == NULL || rsi == NULL || rsi is a valid argv
#   [rdx] == NULL || rdx == NULL || rdx is a valid envp
#
# 0xe3b31 execve("/bin/sh", r15, rdx)
# constraints:
#   [r15] == NULL || r15 == NULL || r15 is a valid argv
#   [rdx] == NULL || rdx == NULL || rdx is a valid envp
#

```
![near](https://github.com/david942j/one_gadget/blob/master/examples/near.png?raw=true)

Regular expressions work too.
```bash
$ one_gadget spec/data/libc-2.31-9fdb74e7b217d06c93172a8243f8547f947ee6d1.so --near 'write.*' --raw
# [OneGadget] Gadgets near writev(0x1144a0):
# 1080554 932896 932660 932657
#
# [OneGadget] Gadgets near write(0x10e090):
# 1080554 932896 932660 932657
#

```

Pass an ELF file instead, and OneGadget uses every function in its GOT.
```bash
$ one_gadget spec/data/libc-2.31-9fdb74e7b217d06c93172a8243f8547f947ee6d1.so --near spec/data/test_near_file.elf --raw
# [OneGadget] Gadgets near exit(0x46a70):
# 932657 932660 932896 1080554
#
# [OneGadget] Gadgets near puts(0x84450):
# 932657 932660 932896 1080554
#
# [OneGadget] Gadgets near printf(0x61cc0):
# 932657 932660 932896 1080554
#
# [OneGadget] Gadgets near strlen(0x9f660):
# 932657 932660 932896 1080554
#
# [OneGadget] Gadgets near __cxa_finalize(0x46f40):
# 932657 932660 932896 1080554
#
# [OneGadget] Gadgets near __libc_start_main(0x23fc0):
# 932657 932660 932896 1080554
#

```

#### Show More Gadgets

A libc holds far more gadgets than fit on a screen, and most of them ask more of you
than a handful of others do. `--level` chooses how much of what was found to show.

| Level | Shows | Use it when |
| --- | --- | --- |
| `0` (default) | the few gadgets whose constraints are easiest to arrange | always, first |
| `1` | every gadget, one line per address, minus any that asks for everything an easier one asks for and more | none of the level-0 gadgets fit what you control |
| `2` | everything found, including an address listed once per set of constraints it can be reached under | you want to see every way in, including the awkward ones |

Level 1 drops a gadget when an easier one already asks for everything it does; level 0
then scores what is left by how hard its constraints look and keeps only the best few;
level 2 drops nothing. On the glibc 2.31 below that is 4, 32 and 97 entries -- the last
over 96 addresses, since one of them is reachable two ways with different requirements.

Level 2 reads the libc you point at directly, where the levels below it answer from the
pre-built gadget database when it knows the file's BuildID -- the same gadgets either
way. Pass `-f` to search the file at every level.

```bash
$ one_gadget spec/data/libc-2.31-9fdb74e7b217d06c93172a8243f8547f947ee6d1.so --level 1
# 0x51df8 posix_spawn(rsp+0xc, "/bin/sh", 0, rsp+0x210, rsp+0x50, environ)
# constraints:
#   readable: r12
#   readable: r13
#   rsp & 0xf == 0x0
#   {"sh", "-c", rbx, NULL} is a valid argv
#   rsp+0x210 == NULL || (u16)[rsp+0x210] == 0x0
#
# 0x51e2b posix_spawn(rsp+0xc, "/bin/sh", 0, rbp, rsp+0x50, environ)
# constraints:
#   rsp & 0xf == 0x0
#   {"sh", "-c", rbx, NULL} is a valid argv
#   rbp == NULL || (u16)[rbp] == 0x0
#
# 0x51e32 posix_spawn(rsp+0xc, "/bin/sh", 0, rbp, rsp+0x50, environ)
# constraints:
#   rsp & 0xf == 0x0
#   rax == NULL || {"sh", rax, rbx, NULL} is a valid argv
#   rbp == NULL || (u16)[rbp] == 0x0
#
# 0x51e39 posix_spawn(rsp+0xc, "/bin/sh", 0, rbp, rsp+0x50, environ)
# constraints:
#   rsp & 0xf == 0x0
#   rcx == NULL || {rcx, rax, rbx, NULL} is a valid argv
#   rbp == NULL || (u16)[rbp] == 0x0
#
# 0x51e40 posix_spawn(rsp+0xc, "/bin/sh", rdx, rbp, rsp+0x50, environ)
# constraints:
#   rsp & 0xf == 0x0
#   rcx == NULL || {rcx, (u64)xmm1, rbx, NULL} is a valid argv
#   rdx == NULL || (s32)[rdx+0x4] <= 0x0
#   rbp == NULL || (u16)[rbp] == 0x0
#
# 0x51e45 posix_spawn(rsp+0xc, "/bin/sh", rdx, rbp, rsp+0x50, environ)
# constraints:
#   rsp & 0xf == 0x0
#   (u64)xmm0 == NULL || {(u64)xmm0, (u64)xmm1, rbx, NULL} is a valid argv
#   rdx == NULL || (s32)[rdx+0x4] <= 0x0
#   rbp == NULL || (u16)[rbp] == 0x0
#
# 0x51e55 posix_spawn(rdi, "/bin/sh", rdx, rbp, rsp+0x50, [rax])
# constraints:
#   readable: rax
#   rsp & 0xf == 0x0
#   (u64)xmm0 == NULL || {(u64)xmm0, (u64)(xmm0 >> 64), rbx, NULL} is a valid argv
#   [[rax]] == NULL || [rax] == NULL || [rax] is a valid envp
#   rdi == NULL || writable: rdi
#   rdx == NULL || (s32)[rdx+0x4] <= 0x0
#   rbp == NULL || (u16)[rbp] == 0x0
#
# 0x51e5a posix_spawn(rdi, "/bin/sh", rdx, rbp, r8, [rax])
# constraints:
#   readable: rax
#   rsp & 0xf == 0x0
#   [r8] == NULL || r8 is a valid argv
#   [[rax]] == NULL || [rax] == NULL || [rax] is a valid envp
#   rdi == NULL || writable: rdi
#   rdx == NULL || (s32)[rdx+0x4] <= 0x0
#   rbp == NULL || (u16)[rbp] == 0x0
#
# 0x84165 posix_spawn(rbx+0xe0, "/bin/sh", r12, 0, rsp+0x60, environ)
# constraints:
#   rsp & 0xf == 0x0
#   {"sh", "-c", rbp, NULL} is a valid argv
#   rbx+0xe0 == NULL || writable: rbx+0xe0
#   r12 == NULL || (s32)[r12+0x4] <= 0x0
#
# 0x8416c posix_spawn(rbx+0xe0, "/bin/sh", r12, 0, rsp+0x60, environ)
# constraints:
#   rsp & 0xf == 0x0
#   rax == NULL || {"sh", rax, rbp, NULL} is a valid argv
#   rbx+0xe0 == NULL || writable: rbx+0xe0
#   r12 == NULL || (s32)[r12+0x4] <= 0x0
#
# 0x84173 posix_spawn(rbx+0xe0, "/bin/sh", r12, 0, rsp+0x60, environ)
# constraints:
#   rsp & 0xf == 0x0
#   rcx == NULL || {rcx, rax, rbp, NULL} is a valid argv
#   rbx+0xe0 == NULL || writable: rbx+0xe0
#   r12 == NULL || (s32)[r12+0x4] <= 0x0
#
# 0x84176 posix_spawn(rbx+0xe0, "/bin/sh", rdx, 0, rsp+0x60, environ)
# constraints:
#   rsp & 0xf == 0x0
#   rcx == NULL || {rcx, rax, rbp, NULL} is a valid argv
#   rbx+0xe0 == NULL || writable: rbx+0xe0
#   rdx == NULL || (s32)[rdx+0x4] <= 0x0
#
# 0x8417b posix_spawn(rbx+0xe0, "/bin/sh", rdx, 0, rsp+0x60, environ)
# constraints:
#   rsp & 0xf == 0x0
#   rcx == NULL || {rcx, rax, [rsp+0x70], NULL} is a valid argv
#   rbx+0xe0 == NULL || writable: rbx+0xe0
#   rdx == NULL || (s32)[rdx+0x4] <= 0x0
#
# 0x84180 posix_spawn(rbx+0xe0, "/bin/sh", rdx, 0, rsp+0x60, environ)
# constraints:
#   rsp & 0xf == 0x0
#   rcx == NULL || {rcx, (u64)xmm1, [rsp+0x70], NULL} is a valid argv
#   rbx+0xe0 == NULL || writable: rbx+0xe0
#   rdx == NULL || (s32)[rdx+0x4] <= 0x0
#
# 0x8418c posix_spawn(rbx+0xe0, "/bin/sh", rdx, 0, rsp+0x60, [rax])
# constraints:
#   readable: rax
#   rsp & 0xf == 0x0
#   (u64)xmm0 == NULL || {(u64)xmm0, (u64)xmm1, [rsp+0x70], NULL} is a valid argv
#   [[rax]] == NULL || [rax] == NULL || [rax] is a valid envp
#   rbx+0xe0 == NULL || writable: rbx+0xe0
#   rdx == NULL || (s32)[rdx+0x4] <= 0x0
#
# 0x84192 posix_spawn(rbx+0xe0, "/bin/sh", rdx, rcx, rsp+0x60, [rax])
# constraints:
#   readable: rax
#   rsp & 0xf == 0x0
#   (u64)xmm0 == NULL || {(u64)xmm0, (u64)(xmm0 >> 64), [rsp+0x70], NULL} is a valid argv
#   [[rax]] == NULL || [rax] == NULL || [rax] is a valid envp
#   rbx+0xe0 == NULL || writable: rbx+0xe0
#   rdx == NULL || (s32)[rdx+0x4] <= 0x0
#   rcx == NULL || (u16)[rcx] == 0x0
#
# 0x84199 posix_spawn(rdi, "/bin/sh", rdx, rcx, rsp+0x60, [rax])
# constraints:
#   readable: rax
#   rsp & 0xf == 0x0
#   (u64)xmm0 == NULL || {(u64)xmm0, (u64)(xmm0 >> 64), [rsp+0x70], NULL} is a valid argv
#   [[rax]] == NULL || [rax] == NULL || [rax] is a valid envp
#   rdi == NULL || writable: rdi
#   rdx == NULL || (s32)[rdx+0x4] <= 0x0
#   rcx == NULL || (u16)[rcx] == 0x0
#
# 0x841a0 posix_spawn(rdi, "/bin/sh", rdx, rcx, r8, [rax])
# constraints:
#   readable: rax
#   rsp & 0xf == 0x0
#   [r8] == NULL || r8 is a valid argv
#   [[rax]] == NULL || [rax] == NULL || [rax] is a valid envp
#   rdi == NULL || writable: rdi
#   rdx == NULL || (s32)[rdx+0x4] <= 0x0
#   rcx == NULL || (u16)[rcx] == 0x0
#
# 0xe3b31 execve("/bin/sh", r15, rdx)
# constraints:
#   [r15] == NULL || r15 == NULL || r15 is a valid argv
#   [rdx] == NULL || rdx == NULL || rdx is a valid envp
#
# 0xe3b34 execve("/bin/sh", rsi, rdx)
# constraints:
#   [rsi] == NULL || rsi == NULL || rsi is a valid argv
#   [rdx] == NULL || rdx == NULL || rdx is a valid envp
#
# 0xe3c20 execve("/bin/sh", r15, r12)
# constraints:
#   [r15] == NULL || r15 == NULL || r15 is a valid argv
#   [r12] == NULL || r12 == NULL || r12 is a valid envp
#
# 0xe3d26 execve("/bin/sh", r10, rdx)
# constraints:
#   address rbp-0x78 is writable
#   [r10] == NULL || r10 == NULL || r10 is a valid argv
#   [rdx] == NULL || rdx == NULL || rdx is a valid envp
#
# 0xe3d88 execve("/bin/sh", [rbp-0x78], r12)
# constraints:
#   address rbp-0x78 is writable
#   [[rbp-0x78]] == NULL || [rbp-0x78] == NULL || [rbp-0x78] is a valid argv
#   [r12] == NULL || r12 == NULL || r12 is a valid envp
#
# 0xe3d90 execve("/bin/sh", r10, r12)
# constraints:
#   address rbp-0x78 is writable
#   [r10] == NULL || r10 == NULL || r10 is a valid argv
#   [r12] == NULL || r12 == NULL || r12 is a valid envp
#
# 0xe3d92 execve("/bin/sh", rbp-0x50, r12)
# constraints:
#   address rbp-0x50 is writable
#   r13 == NULL || {"/bin/sh", r13, NULL} is a valid argv
#   [r12] == NULL || r12 == NULL || r12 is a valid envp
#
# 0xe3d99 execve("/bin/sh", rbp-0x50, r12)
# constraints:
#   address rbp-0x50 is writable
#   rax == NULL || {rax, r13, NULL} is a valid argv
#   [r12] == NULL || r12 == NULL || r12 is a valid envp
#
# 0xe3da0 execve("/bin/sh", rbp-0x50, r12)
# constraints:
#   address rbp-0x50 is writable
#   rax == NULL || {rax, [rbp-0x48], NULL} is a valid argv
#   [r12] == NULL || r12 == NULL || r12 is a valid envp
#
# 0xe3dd7 execve("/bin/sh", rbp-0x50, r12)
# constraints:
#   address rbp-0x78 is writable
#   [rbp-0x68] == NULL || {"/bin/sh", [rbp-0x68], NULL} is a valid argv
#   [r12] == NULL || r12 == NULL || r12 is a valid envp
#
# 0xe3de1 execve("/bin/sh", rbp-0x50, r12)
# constraints:
#   address rbp-0x78 is writable
#   rax == NULL || {rax, [rbp-0x68], NULL} is a valid argv
#   [r12] == NULL || r12 == NULL || r12 is a valid envp
#
# 0x1075e7 posix_spawn(rsp+0x64, "/bin/sh", rdx, 0, rsp+0x70, r9)
# constraints:
#   [rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv
#   [r9] == NULL || r9 == NULL || r9 is a valid envp
#   rdx == NULL || (s32)[rdx+0x4] <= 0x0
#
# 0x1075f1 posix_spawn(rdi, "/bin/sh", rdx, 0, r8, r9)
# constraints:
#   [r8] == NULL || r8 is a valid argv
#   [r9] == NULL || r9 == NULL || r9 is a valid envp
#   rdi == NULL || writable: rdi
#   rdx == NULL || (s32)[rdx+0x4] <= 0x0
#
# 0x107cea posix_spawn(rsp+0x64, "/bin/sh", [rsp+0x38], 0, rsp+0x70, environ)
# constraints:
#   [rsp+0x70] == NULL || {[rsp+0x70], [rsp+0x78], [rsp+0x80], [rsp+0x88], ...} is a valid argv
#   [rsp+0x38] == NULL || (s32)[[rsp+0x38]+0x4] <= 0x0

```

#### Other Architectures

##### i386
```bash
$ one_gadget spec/data/libc-2.27-63b3d43ad45e1b0f601848c65b067f9e9b40528b.so
# 0x3cbf7 execve("/bin/sh", esp+0x40, environ)
# constraints:
#   esi is the GOT address of libc
#   [esp+0x40] == NULL || {[esp+0x40], [esp+0x44], [esp+0x48], [esp+0x4c], ...} is a valid argv
#
# 0x6729f execl("/bin/sh", eax)
# constraints:
#   esi is the GOT address of libc
#   eax == NULL
#
# 0x672a0 execl("/bin/sh", [esp])
# constraints:
#   esi is the GOT address of libc
#   [esp] == NULL
#
# 0x13573e execl("/bin/sh", eax)
# constraints:
#   ebx is the GOT address of libc
#   eax == NULL
#
# 0x13573f execl("/bin/sh", [esp])
# constraints:
#   ebx is the GOT address of libc
#   [esp] == NULL

```
![i386](https://github.com/david942j/one_gadget/blob/master/examples/i386.png?raw=true)

##### AArch64
```bash
$ one_gadget spec/data/aarch64-libc-2.27.so
# 0x3f160 execve("/bin/sh", sp+0x70, environ)
# constraints:
#   address x20+0x338 is writable
#   x22 == NULL
#   x3 == NULL || {x3, "-c", x23, NULL} is a valid argv
#
# 0x63e90 execl("/bin/sh", x1)
# constraints:
#   x1 == NULL
#
# 0xa321c execve("/bin/sh", sp+0x40, x2)
# constraints:
#   [x1] == 0x0
#   x0 == NULL || {"/bin/sh", x0, NULL} is a valid argv
#   [x2] == NULL || x2 == NULL || x2 is a valid envp
#
# 0xa32e8 execve("/bin/sh", x29+0x40, x23)
# constraints:
#   address x29+0x40 is writable
#   x0 == NULL || {"/bin/sh", x0, NULL} is a valid argv
#   [x23] == NULL || x23 == NULL || x23 is a valid envp

```
![aarch64](https://github.com/david942j/one_gadget/blob/master/examples/aarch64.png?raw=true)

##### ARM32

```bash
$ one_gadget spec/data/arm-libc-2.39.so
# 0x38f6c posix_spawn(r0, "/bin/sh", r2, r8, [sp], r3)
# constraints:
#   [[sp]] == NULL || [sp] is a valid argv
#   [r3] == NULL || r3 == NULL || r3 is a valid envp
#   r0 == NULL || writable: r0
#   r2 == NULL || (s32)[r2+0x4] <= 0x0
#   r8 == NULL || (u16)[r8] == 0x0
#
# 0x88a7c execve("/bin/sh", r4, r5)
# constraints:
#   [r4] == NULL || r4 == NULL || r4 is a valid argv
#   [r5] == NULL || r5 == NULL || r5 is a valid envp
#
# 0x9f2be posix_spawn([sp+0x34], "/bin/sh", [sp+0x2c], 0, [sp+0x3c], r3)
# constraints:
#   [[sp+0x3c]] == NULL || [sp+0x3c] is a valid argv
#   [r3] == NULL || r3 == NULL || r3 is a valid envp
#   [sp+0x34] == NULL || writable: [sp+0x34]
#   [sp+0x2c] == NULL || (s32)[[sp+0x2c]+0x4] <= 0x0

```

##### RISC-V (RV64)

```bash
$ one_gadget spec/data/riscv64-libc-2.39.so
# 0x9f73a execve("/bin/sh", s1, a2)
# constraints:
#   [s1] == NULL || s1 == NULL || s1 is a valid argv
#   [a2] == NULL || a2 == NULL || a2 is a valid envp
#
# 0x9f73c execve("/bin/sh", a1, a2)
# constraints:
#   [a1] == NULL || a1 == NULL || a1 is a valid argv
#   [a2] == NULL || a2 == NULL || a2 is a valid envp
#
# 0x9f778 execve("/bin/sh", s1, s2)
# constraints:
#   [s1] == NULL || s1 == NULL || s1 is a valid argv
#   [s2] == NULL || s2 == NULL || s2 is a valid envp
#
# 0xb5adc posix_spawn(sp+0x44, "/bin/sh", [sp+0x30], 0, sp+0x50, environ)
# constraints:
#   [sp+0x50] == NULL || {[sp+0x50], [sp+0x58], [sp+0x60], [sp+0x68], ...} is a valid argv
#   [sp+0x30] == NULL || (s32)[[sp+0x30]+0x4] <= 0x0

```

#### Combine with Script
Pass your exploit script to `one_gadget` and it runs the script once per gadget, so you
don't have to work through them by hand.

```bash
$ one_gadget spec/data/libc-2.31-9fdb74e7b217d06c93172a8243f8547f947ee6d1.so -s 'echo "offset ->"'
```

![--script](https://github.com/david942j/one_gadget/blob/master/examples/script.png?raw=true)

### In Ruby Scripts
```ruby
require 'one_gadget'
OneGadget.gadgets(file: 'spec/data/libc-2.31-9fdb74e7b217d06c93172a8243f8547f947ee6d1.so')
#=> [932657, 932660, 932896, 1080554]

# or, more briefly
one_gadget('spec/data/libc-2.31-9fdb74e7b217d06c93172a8243f8547f947ee6d1.so', level: 1)
#=> [335352, 335403, 335410, 335417, 335424, 335429, 335445, 335450, 541029, 541036, 541043, 541046, 541051, 541056, 541068, 541074, 541081, 541088, 932657, 932660, 932896, 933158, 933256, 933264, 933266, 933273, 933280, 933335, 933345, 1078759, 1078769, 1080554]

# from build id
one_gadget('b417c0ba7cc5cf06d1d1bed6652cedb9253c60d0')
#=> [324386, 939736, 940131, 1090444]

```

### To Python Lovers
```python
import subprocess
def one_gadget(filename):
  return [int(i) for i in subprocess.check_output(['one_gadget', '--raw', filename]).decode().split(' ')]

one_gadget('spec/data/libc-2.31-9fdb74e7b217d06c93172a8243f8547f947ee6d1.so')
#=> [932657, 932660, 932896, 1080554]

```

## Make OneGadget Better
Any suggestion or feature request is welcome, and pull requests even more so!

Please let me know if you come across a libc OneGadget finds nothing in. And if you like
this work, I'd be happy to be [starred](https://github.com/david942j/one_gadget/stargazers) :grimacing:
