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

OneGadget use simple self-implement symbolic execution to find the constraints of gadgets.

The article introducing how I develop this tool can be found [here](https://david942j.blogspot.com/2017/02/project-one-gadget-in-glibc.html).

## Usage

### Command Line Interface

```bash
$ one_gadget
# Usage: one_gadget [file] [options]
#     -b, --build-id BuildID           BuildID[sha1] of libc.
#     -f, --[no-]force-file            Force search gadgets in file instead of build id first.
#     -r, --[no-]raw                   Output gadgets offset only, split with one space.
#     -s, --script exploit-script      Run exploit script with all possible gadgets.
#                                      The script will be run as 'exploit-script $offset'.
#         --version                    Current gem version.

$ one_gadget -b 60131540dadc6796cab33388349e6e4e68692053
# 0x4526a	execve("/bin/sh", rsp+0x30, environ)
# constraints:
#   [rsp+0x30] == NULL
#
# 0xcc543	execve("/bin/sh", rcx, r12)
# constraints:
#   [rcx] == NULL || rcx == NULL
#   [r12] == NULL || r12 == NULL
#
# 0xcc618	execve("/bin/sh", rax, r12)
# constraints:
#   [rax] == NULL || rax == NULL
#   [r12] == NULL || r12 == NULL
#
# 0xef6c4	execve("/bin/sh", rsp+0x50, environ)
# constraints:
#   [rsp+0x50] == NULL
#
# 0xf0567	execve("/bin/sh", rsp+0x70, environ)
# constraints:
#   [rsp+0x70] == NULL
#
# 0xf5b10	execve("/bin/sh", rcx, [rbp-0xf8])
# constraints:
#   [rcx] == NULL || rcx == NULL
#   [[rbp-0xf8]] == NULL || [rbp-0xf8] == NULL

$ one_gadget /lib/i386-linux-gnu/libc.so.6
# 0x3ac69	execve("/bin/sh", esp+0x34, environ)
# constraints:
#   esi is the GOT address of libc
#   [esp+0x34] == NULL
#
# 0x5fbc5	execl("/bin/sh", eax)
# constraints:
#   esi is the GOT address of libc
#   eax == NULL
#
# 0x5fbc6	execl("/bin/sh", [esp])
# constraints:
#   esi is the GOT address of libc
#   [esp] == NULL

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
#=> [283242, 836931, 837144, 980676, 984423, 1006352]

# or in shorter way
one_gadget('/lib/x86_64-linux-gnu/libc.so.6')
#=> [283242, 836931, 837144, 980676, 984423, 1006352]

# from build id
one_gadget('60131540dadc6796cab33388349e6e4e68692053')
#=> [283242, 836931, 837144, 980676, 984423, 1006352]

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
And, if you like this work, I'll be happy to be [stared](https://github.com/david942j/one_gadget/stargazers) :grimacing:
