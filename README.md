[![Build Status](https://travis-ci.org/david942j/one_gadget.svg?branch=master)](https://travis-ci.org/david942j/one_gadget)
[![Code Climate](https://codeclimate.com/github/david942j/one_gadget/badges/gpa.svg)](https://codeclimate.com/github/david942j/one_gadget)
[![Issue Count](https://codeclimate.com/github/david942j/one_gadget/badges/issue_count.svg)](https://codeclimate.com/github/david942j/one_gadget)
[![Test Coverage](https://codeclimate.com/github/david942j/one_gadget/badges/coverage.svg)](https://codeclimate.com/github/david942j/one_gadget/coverage)
[![Inline docs](https://inch-ci.org/github/david942j/one_gadget.svg?branch=master)](https://inch-ci.org/github/david942j/one_gadget)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](http://choosealicense.com/licenses/mit/)

## One Gadget

When playing ctf pwn challenges we usually needs the one-gadget of `execve('/bin/sh', NULL, NULL)`.

This gem provides such gadget finder, no need to use IDA-pro every time like a fool.

Also provides the command-line tool `one_gadget` for easy usage.

Note: only supports x86-64 now.

Note2: still work in progress, the gem version might update frequently :p.

## Install

Available on RubyGems.org!
```bash
gem install one_gadget
```

## Usage

### Command Line Tool

```bash
one_gadget
# Usage: one_gadget [file] [options]
#     -b, --build-id BuildID           BuildID[sha1] of libc.
#     -f, --[no-]force-file            Force search gadgets in file instead of build id first.
#     -r, --[no-]raw                   Output gadgets offset only, split with one space.
#     -s, --script exploit-script      Run exploit script with all possible gadgets.
#                                      The script will be run as 'exploit-script $offset'.

one_gadget -b 60131540dadc6796cab33388349e6e4e68692053
# offset: 0x4526a
# constraints:
#   [rsp+0x30] == NULL
#
# offset: 0xef6c4
# constraints:
#   [rsp+0x50] == NULL
#
# offset: 0xf0567
# constraints:
#   [rsp+0x70] == NULL
#
# offset: 0xf5b10
# constraints:
#   [rbp-0xf8] == NULL
#   rcx == NULL
```

#### Combine with exploit script
Pass your exploit script as `one_gadget`'s arguments, it can
try all gadgets one by one, so you don't need to try every possible gadgets manually.

```bash
one_gadget ./spec/data/libc-2.19.so -s 'echo "offset ->"'
```

![--script](https://github.com/david942j/one_gadget/blob/master/examples/script.png?raw=true)

### Directly use in script
```ruby
require 'one_gadget'
OneGadget.gadgets(file: '/lib/x86_64-linux-gnu/libc.so.6')
# => [283242, 980676, 984423, 1006352]
```

## Screenshots

### Search gadgets from file
![from file](https://github.com/david942j/one_gadget/blob/master/examples/from_file.png?raw=true)

### Fetch gadgets from database
![build id](https://github.com/david942j/one_gadget/blob/master/examples/from_build_id.png?raw=true)

