[![Build Status](https://travis-ci.org/david942j/one_gadget.svg?branch=master)](https://travis-ci.org/david942j/one_gadget)
[![Downloads](http://ruby-gem-downloads-badge.herokuapp.com/one_gadget?type=total&color=orange)](https://rubygems.org/gems/one_gadget)
[![Code Climate](https://codeclimate.com/github/david942j/one_gadget/badges/gpa.svg)](https://codeclimate.com/github/david942j/one_gadget)
[![Issue Count](https://codeclimate.com/github/david942j/one_gadget/badges/issue_count.svg)](https://codeclimate.com/github/david942j/one_gadget)
[![Test Coverage](https://codeclimate.com/github/david942j/one_gadget/badges/coverage.svg)](https://codeclimate.com/github/david942j/one_gadget/coverage)
[![Inline docs](https://inch-ci.org/github/david942j/one_gadget.svg?branch=master)](https://inch-ci.org/github/david942j/one_gadget)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](http://choosealicense.com/licenses/mit/)

## One Gadget

When playing ctf pwn challenges we usually need the one-gadget RCE (remote code execution),
which leads to call `execve('/bin/sh', NULL, NULL)`.

This gem provides such gadgets finder, no need to use objdump or IDA-pro every time like a fool :wink:

To use this tool, just type `one_gadget /path/to/libc` in command line and enjoy the magic :laughing:

Note: Supports amd64 and i386!

## Install

Available on RubyGems.org!
```bash
$ gem install one_gadget
```

Note: require ruby version >= 2.1.0, you can use `ruby --version` to check.

## Implementation

OneGadget uses simple self-implement symbolic execution to find the constraints of gadgets to be successful.

The article introducing how I develop this tool can be found [in my blog](https://david942j.blogspot.com/2017/02/project-one-gadget-in-glibc.html).

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
# 0x3a7cc	execve("/bin/sh", esp+0x28, environ)
# constraints:
#   esi is the GOT address of libc
#   [esp+0x28] == NULL
#
# 0x3a7ce	execve("/bin/sh", esp+0x2c, environ)
# constraints:
#   esi is the GOT address of libc
#   [esp+0x2c] == NULL
#
# 0x3a7d2	execve("/bin/sh", esp+0x30, environ)
# constraints:
#   esi is the GOT address of libc
#   [esp+0x30] == NULL
#
# 0x3a7d9	execve("/bin/sh", esp+0x34, environ)
# constraints:
#   esi is the GOT address of libc
#   [esp+0x34] == NULL
#
# 0x5f875	execl("/bin/sh", eax)
# constraints:
#   esi is the GOT address of libc
#   eax == NULL
#
# 0x5f876	execl("/bin/sh", [esp])
# constraints:
#   esi is the GOT address of libc
#   [esp] == NULL

$ one_gadget /lib/x86_64-linux-gnu/libc.so.6
# 0x45526	execve("/bin/sh", rsp+0x30, environ)
# constraints:
#   rax == NULL
#
# 0x4557a	execve("/bin/sh", rsp+0x30, environ)
# constraints:
#   [rsp+0x30] == NULL
#
# 0xf1651	execve("/bin/sh", rsp+0x40, environ)
# constraints:
#   [rsp+0x40] == NULL
#
# 0xf24cb	execve("/bin/sh", rsp+0x60, environ)
# constraints:
#   [rsp+0x60] == NULL

# show all gadgets found
$ one_gadget /lib/x86_64-linux-gnu/libc.so.6 --level 1
# 0x45526	execve("/bin/sh", rsp+0x30, environ)
# constraints:
#   rax == NULL
#
# 0x4557a	execve("/bin/sh", rsp+0x30, environ)
# constraints:
#   [rsp+0x30] == NULL
#
# 0xcde41	execve("/bin/sh", r15, r13)
# constraints:
#   [r15] == NULL || r15 == NULL
#   [r13] == NULL || r13 == NULL
#
# 0xce0e1	execve("/bin/sh", [rbp-0x78], [rbp-0x50])
# constraints:
#   [[rbp-0x78]] == NULL || [rbp-0x78] == NULL
#   [[rbp-0x50]] == NULL || [rbp-0x50] == NULL
#
# 0xce0e5	execve("/bin/sh", r9, [rbp-0x50])
# constraints:
#   [r9] == NULL || r9 == NULL
#   [[rbp-0x50]] == NULL || [rbp-0x50] == NULL
#
# 0xce0e9	execve("/bin/sh", r9, rdx)
# constraints:
#   [r9] == NULL || r9 == NULL
#   [rdx] == NULL || rdx == NULL
#
# 0xf1651	execve("/bin/sh", rsp+0x40, environ)
# constraints:
#   [rsp+0x40] == NULL
#
# 0xf165d	execve("/bin/sh", rsi, [rax])
# constraints:
#   [rsi] == NULL || rsi == NULL
#   [[rax]] == NULL || [rax] == NULL
#
# 0xf24cb	execve("/bin/sh", rsp+0x60, environ)
# constraints:
#   [rsp+0x60] == NULL

```

#### Combine with exploit script
Pass your exploit script as `one_gadget`'s arguments, it can
try all gadgets one by one, so you don't need to try every possible gadgets manually.

```bash
$ one_gadget ./spec/data/libc-2.19.so -s 'echo "offset ->"'
```

![--script](https://github.com/david942j/one_gadget/blob/master/examples/script.png?raw=true)

### Directly use in script
```ruby
require 'one_gadget'
OneGadget.gadgets(file: '/lib/x86_64-linux-gnu/libc.so.6')
#=> [283942, 284026, 988753, 992459]

# or in shorter way
one_gadget('/lib/x86_64-linux-gnu/libc.so.6', level: 1)
#=> [283942, 284026, 843329, 844001, 844005, 844009, 988753, 988765, 992459]

# from build id
one_gadget('60131540dadc6796cab33388349e6e4e68692053')
#=> [283158, 283242, 980676, 984423]

```

## Screenshots

### Search gadgets in libc

#### 64 bit
![from file](https://github.com/david942j/one_gadget/blob/master/examples/from_file.png?raw=true)

#### 32 bit
![from file](https://github.com/david942j/one_gadget/blob/master/examples/from_file_32bit.png?raw=true)

### Fetch gadgets from database
![build id](https://github.com/david942j/one_gadget/blob/master/examples/from_build_id.png?raw=true)

## Make OneGadget Better
Any suggestion or feature request is welcome! Feel free to send a pull request.

Please let me know if you find any libc that make OneGadget fail to find gadgets.
And, if you like this work, I'll be happy to be [starred](https://github.com/david942j/one_gadget/stargazers) :grimacing:
