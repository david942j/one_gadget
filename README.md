[![Build Status](https://travis-ci.org/david942j/one_gadget.svg?branch=master)](https://travis-ci.org/david942j/one_gadget)
[![Downloads](http://ruby-gem-downloads-badge.herokuapp.com/one_gadget?type=total&color=orange)](https://rubygems.org/gems/one_gadget)
[![Code Climate](https://codeclimate.com/github/david942j/one_gadget/badges/gpa.svg)](https://codeclimate.com/github/david942j/one_gadget)
[![Issue Count](https://codeclimate.com/github/david942j/one_gadget/badges/issue_count.svg)](https://codeclimate.com/github/david942j/one_gadget)
[![Test Coverage](https://codeclimate.com/github/david942j/one_gadget/badges/coverage.svg)](https://codeclimate.com/github/david942j/one_gadget/coverage)
[![Inline docs](https://inch-ci.org/github/david942j/one_gadget.svg?branch=master)](https://inch-ci.org/github/david942j/one_gadget)
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

Since OneGadget version 1.5.0,
much more one-gadgets have been found.
And gadgets become too many to show them all,
they would be selected automatically according to the difficulty of constraints.
Therefore, gadgets shown will be less than previous versions (before v1.5.0).
But you can use option `--level 1` to show all gadgets found.

### Command Line Interface

```bash
$ one_gadget
# Usage: one_gadget [file] [options]
#     -b, --build-id BuildID           BuildID[sha1] of libc.
#     -f, --[no-]force-file            Force search gadgets in file instead of build id first.
#     -l, --level OUTPUT_LEVEL         The output level.
#                                      OneGadget automatically selects gadgets with higher successful probability.
#                                      Increase this level to ask OneGadget show more gadgets it found.
#                                      Default: 0
#     -r, --[no-]raw                   Output gadgets offset only, split with one space.
#     -s, --script exploit-script      Run exploit script with all possible gadgets.
#                                      The script will be run as 'exploit-script $offset'.
#         --info BuildID               Show version information given BuildID.
#         --version                    Current gem version.

```

```bash
$ one_gadget -b 60131540dadc6796cab33388349e6e4e68692053
# 0x45216	execve("/bin/sh", rsp+0x30, environ)
# constraints:
#   rax == NULL
#
# 0x4526a	execve("/bin/sh", rsp+0x30, environ)
# constraints:
#   [rsp+0x30] == NULL
#
# 0xef6c4	execve("/bin/sh", rsp+0x50, environ)
# constraints:
#   [rsp+0x50] == NULL
#
# 0xf0567	execve("/bin/sh", rsp+0x70, environ)
# constraints:
#   [rsp+0x70] == NULL

$ one_gadget /lib32/libc.so.6
# 0x3cbea	execve("/bin/sh", esp+0x34, environ)
# constraints:
#   esi is the GOT address of libc
#   [esp+0x34] == NULL
#
# 0x3cbec	execve("/bin/sh", esp+0x38, environ)
# constraints:
#   esi is the GOT address of libc
#   [esp+0x38] == NULL
#
# 0x3cbf0	execve("/bin/sh", esp+0x3c, environ)
# constraints:
#   esi is the GOT address of libc
#   [esp+0x3c] == NULL
#
# 0x3cbf7	execve("/bin/sh", esp+0x40, environ)
# constraints:
#   esi is the GOT address of libc
#   [esp+0x40] == NULL
#
# 0x6729f	execl("/bin/sh", eax)
# constraints:
#   esi is the GOT address of libc
#   eax == NULL
#
# 0x672a0	execl("/bin/sh", [esp])
# constraints:
#   esi is the GOT address of libc
#   [esp] == NULL
#
# 0x13573e	execl("/bin/sh", eax)
# constraints:
#   ebx is the GOT address of libc
#   eax == NULL
#
# 0x13573f	execl("/bin/sh", [esp])
# constraints:
#   ebx is the GOT address of libc
#   [esp] == NULL

$ one_gadget /lib/x86_64-linux-gnu/libc.so.6
# 0x4f2c5	execve("/bin/sh", rsp+0x40, environ)
# constraints:
#   rcx == NULL
#
# 0x4f322	execve("/bin/sh", rsp+0x40, environ)
# constraints:
#   [rsp+0x40] == NULL
#
# 0x10a38c	execve("/bin/sh", rsp+0x70, environ)
# constraints:
#   [rsp+0x70] == NULL

```
#### Show All Gadgets

```bash
$ one_gadget /lib/x86_64-linux-gnu/libc.so.6 --level 1
# 0x4f2c5	execve("/bin/sh", rsp+0x40, environ)
# constraints:
#   rcx == NULL
#
# 0x4f322	execve("/bin/sh", rsp+0x40, environ)
# constraints:
#   [rsp+0x40] == NULL
#
# 0xe569f	execve("/bin/sh", r14, r12)
# constraints:
#   [r14] == NULL || r14 == NULL
#   [r12] == NULL || r12 == NULL
#
# 0xe5858	execve("/bin/sh", [rbp-0x88], [rbp-0x70])
# constraints:
#   [[rbp-0x88]] == NULL || [rbp-0x88] == NULL
#   [[rbp-0x70]] == NULL || [rbp-0x70] == NULL
#
# 0xe585f	execve("/bin/sh", r10, [rbp-0x70])
# constraints:
#   [r10] == NULL || r10 == NULL
#   [[rbp-0x70]] == NULL || [rbp-0x70] == NULL
#
# 0xe5863	execve("/bin/sh", r10, rdx)
# constraints:
#   [r10] == NULL || r10 == NULL
#   [rdx] == NULL || rdx == NULL
#
# 0x10a38c	execve("/bin/sh", rsp+0x70, environ)
# constraints:
#   [rsp+0x70] == NULL
#
# 0x10a398	execve("/bin/sh", rsi, [rax])
# constraints:
#   [rsi] == NULL || rsi == NULL
#   [[rax]] == NULL || [rax] == NULL

```

#### Other Architectures

```bash
$ one_gadget spec/data/aarch64-libc-2.27.so
# 0x3f15c	execve("/bin/sh", sp+0x70, environ)
# constraints:
#   x3+0x7c0 == NULL
#
# 0x3f16c	execve("/bin/sh", sp+0x70, environ)
# constraints:
#   x3 == NULL
#
# 0x3f184	execve("/bin/sh", sp+0x70, environ)
# constraints:
#   [sp+0x70] == NULL
#
# 0x3f1a8	execve("/bin/sh", x21, environ)
# constraints:
#   [x21] == NULL || x21 == NULL
#
# 0x63e7c	execl("/bin/sh", "sh", x2+0x7c8)
# constraints:
#   x2+0x7c8 == NULL
#
# 0x63e88	execl("/bin/sh", x1+0x7c0)
# constraints:
#   x1+0x7c0 == NULL
#
# 0x63e90	execl("/bin/sh", x1)
# constraints:
#   x1 == NULL

```

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
one_gadget('60131540dadc6796cab33388349e6e4e68692053')
#=> [283158, 283242, 980676, 984423]

```

### To Python Lovers
```python
import subprocess
def one_gadget(filename):
  return map(int, subprocess.check_output(['one_gadget', '--raw', filename]).split(' '))

one_gadget('/lib/x86_64-linux-gnu/libc.so.6')
# [283942, 284026, 988753, 992459]
```

## Screenshots

### Search Gadgets in Glibc

#### 64 bit
![from file](https://github.com/david942j/one_gadget/blob/master/examples/from_file.png?raw=true)

#### 32 bit
![from file](https://github.com/david942j/one_gadget/blob/master/examples/from_file_32bit.png?raw=true)

### Fetch Gadgets from Database
![build id](https://github.com/david942j/one_gadget/blob/master/examples/from_build_id.png?raw=true)

## Make OneGadget Better
Any suggestion or feature request is welcome! Feel free to send a pull request.

Please let me know if you find any libc that make OneGadget fail to find gadgets.
And, if you like this work, I'll be happy to be [starred](https://github.com/david942j/one_gadget/stargazers) :grimacing:
