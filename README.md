[![Gem Version](https://badge.fury.io/rb/one_gadget.svg)](https://badge.fury.io/rb/one_gadget)
[![Build Status](https://travis-ci.org/david942j/one_gadget.svg?branch=master)](https://travis-ci.org/david942j/one_gadget)
[![Downloads](http://ruby-gem-downloads-badge.herokuapp.com/one_gadget?type=total&color=orange)](https://rubygems.org/gems/one_gadget)
[![Code Climate](https://codeclimate.com/github/david942j/one_gadget/badges/gpa.svg)](https://codeclimate.com/github/david942j/one_gadget)
[![Issue Count](https://codeclimate.com/github/david942j/one_gadget/badges/issue_count.svg)](https://codeclimate.com/github/david942j/one_gadget)
[![Test Coverage](https://codeclimate.com/github/david942j/one_gadget/badges/coverage.svg)](https://codeclimate.com/github/david942j/one_gadget/coverage)
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
#     -r, --[no-]raw                   Output gadgets offset only, split with one space.
#     -s, --script exploit-script      Run exploit script with all possible gadgets.
#                                      The script will be run as 'exploit-script $offset'.
#         --info BuildID               Show version information given BuildID.
#         --base BASE_ADDRESS          The base address of libc.
#                                      Default: 0
#         --version                    Current gem version.

```

```bash
$ one_gadget /lib/x86_64-linux-gnu/libc.so.6
# 0x4f2c5 execve("/bin/sh", rsp+0x40, environ)
# constraints:
#   rsp & 0xf == 0
#   rcx == NULL
#
# 0x4f322 execve("/bin/sh", rsp+0x40, environ)
# constraints:
#   [rsp+0x40] == NULL
#
# 0x10a38c execve("/bin/sh", rsp+0x70, environ)
# constraints:
#   [rsp+0x70] == NULL

```
![x86_64](https://github.com/david942j/one_gadget/blob/master/examples/x86_64.png?raw=true)

#### Given BuildID
```bash
$ one_gadget -b aad7dbe330f23ea00ca63daf793b766b51aceb5d
# 0x45526 execve("/bin/sh", rsp+0x30, environ)
# constraints:
#   rax == NULL
#
# 0x4557a execve("/bin/sh", rsp+0x30, environ)
# constraints:
#   [rsp+0x30] == NULL
#
# 0xf1651 execve("/bin/sh", rsp+0x40, environ)
# constraints:
#   [rsp+0x40] == NULL
#
# 0xf24cb execve("/bin/sh", rsp+0x60, environ)
# constraints:
#   [rsp+0x60] == NULL

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
# [OneGadget] Gadgets near exit(0x43120):
# 0x4f2c5 execve("/bin/sh", rsp+0x40, environ)
# constraints:
#   rsp & 0xf == 0
#   rcx == NULL
#
# 0x4f322 execve("/bin/sh", rsp+0x40, environ)
# constraints:
#   [rsp+0x40] == NULL
#
# 0x10a38c execve("/bin/sh", rsp+0x70, environ)
# constraints:
#   [rsp+0x70] == NULL
#
# [OneGadget] Gadgets near mkdir(0x10fbb0):
# 0x10a38c execve("/bin/sh", rsp+0x70, environ)
# constraints:
#   [rsp+0x70] == NULL
#
# 0x4f322 execve("/bin/sh", rsp+0x40, environ)
# constraints:
#   [rsp+0x40] == NULL
#
# 0x4f2c5 execve("/bin/sh", rsp+0x40, environ)
# constraints:
#   rsp & 0xf == 0
#   rcx == NULL
#

```
![near](https://github.com/david942j/one_gadget/blob/master/examples/near.png?raw=true)

Regular expression is acceptable.
```bash
$ one_gadget /lib/x86_64-linux-gnu/libc.so.6 --near 'write.*' --raw
# [OneGadget] Gadgets near writev(0x1166a0):
# 1090444 324386 324293
#
# [OneGadget] Gadgets near write(0x110140):
# 1090444 324386 324293
#

```

Pass an ELF file as the argument, OneGadget will take all GOT functions for processing.
```bash
$ one_gadget /lib/x86_64-linux-gnu/libc.so.6 --near spec/data/test_near_file.elf --raw
# [OneGadget] Gadgets near exit(0x43120):
# 324293 324386 1090444
#
# [OneGadget] Gadgets near puts(0x809c0):
# 324386 324293 1090444
#
# [OneGadget] Gadgets near printf(0x64e80):
# 324386 324293 1090444
#
# [OneGadget] Gadgets near strlen(0x9dc70):
# 324386 324293 1090444
#
# [OneGadget] Gadgets near __cxa_finalize(0x43520):
# 324293 324386 1090444
#
# [OneGadget] Gadgets near __libc_start_main(0x21ab0):
# 324293 324386 1090444
#

```

#### Show All Gadgets

Sometimes `one_gadget` finds too many gadgets to show them in one screen,
by default gadgets would be filtered automatically *according to the difficulty of constraints*.

Use option `--level 1` to show all gadgets found instead of only those with higher probabilities.

```bash
$ one_gadget /lib/x86_64-linux-gnu/libc.so.6 --level 1
# 0x4f2c5 execve("/bin/sh", rsp+0x40, environ)
# constraints:
#   rsp & 0xf == 0
#   rcx == NULL
#
# 0x4f322 execve("/bin/sh", rsp+0x40, environ)
# constraints:
#   [rsp+0x40] == NULL
#
# 0xe569f execve("/bin/sh", r14, r12)
# constraints:
#   [r14] == NULL || r14 == NULL
#   [r12] == NULL || r12 == NULL
#
# 0xe5858 execve("/bin/sh", [rbp-0x88], [rbp-0x70])
# constraints:
#   [[rbp-0x88]] == NULL || [rbp-0x88] == NULL
#   [[rbp-0x70]] == NULL || [rbp-0x70] == NULL
#
# 0xe585f execve("/bin/sh", r10, [rbp-0x70])
# constraints:
#   [r10] == NULL || r10 == NULL
#   [[rbp-0x70]] == NULL || [rbp-0x70] == NULL
#
# 0xe5863 execve("/bin/sh", r10, rdx)
# constraints:
#   [r10] == NULL || r10 == NULL
#   [rdx] == NULL || rdx == NULL
#
# 0x10a38c execve("/bin/sh", rsp+0x70, environ)
# constraints:
#   [rsp+0x70] == NULL
#
# 0x10a398 execve("/bin/sh", rsi, [rax])
# constraints:
#   [rsi] == NULL || rsi == NULL
#   [[rax]] == NULL || [rax] == NULL

```

#### Other Architectures

##### i386
```bash
$ one_gadget /lib32/libc.so.6
# 0x3cbea execve("/bin/sh", esp+0x34, environ)
# constraints:
#   esi is the GOT address of libc
#   [esp+0x34] == NULL
#
# 0x3cbec execve("/bin/sh", esp+0x38, environ)
# constraints:
#   esi is the GOT address of libc
#   [esp+0x38] == NULL
#
# 0x3cbf0 execve("/bin/sh", esp+0x3c, environ)
# constraints:
#   esi is the GOT address of libc
#   [esp+0x3c] == NULL
#
# 0x3cbf7 execve("/bin/sh", esp+0x40, environ)
# constraints:
#   esi is the GOT address of libc
#   [esp+0x40] == NULL
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
#=> [324293, 324386, 1090444]

# or in shorter way
one_gadget('/lib/x86_64-linux-gnu/libc.so.6', level: 1)
#=> [324293, 324386, 939679, 940120, 940127, 940131, 1090444, 1090456]

# from build id
one_gadget('b417c0ba7cc5cf06d1d1bed6652cedb9253c60d0')
#=> [324293, 324386, 1090444]

```

### To Python Lovers
```python
import subprocess
def one_gadget(filename):
  return map(int, subprocess.check_output(['one_gadget', '--raw', filename]).split(' '))

one_gadget('/lib/x86_64-linux-gnu/libc.so.6')
#=> [324293, 324386, 1090444]

```

## Make OneGadget Better
Any suggestion or feature request is welcome! Feel free to send a pull request.

Please let me know if you find any libc that make OneGadget fail to find gadgets.
And, if you like this work, I'll be happy to be [starred](https://github.com/david942j/one_gadget/stargazers) :grimacing:
