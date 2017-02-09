[![Build Status](https://travis-ci.org/david942j/one_gadget.svg?branch=master)](https://travis-ci.org/david942j/one_gadget)
[![Code Climate](https://codeclimate.com/github/david942j/one_gadget/badges/gpa.svg)](https://codeclimate.com/github/david942j/one_gadget)
[![Issue Count](https://codeclimate.com/github/david942j/one_gadget/badges/issue_count.svg)](https://codeclimate.com/github/david942j/one_gadget)
[![Test Coverage](https://codeclimate.com/github/david942j/one_gadget/badges/coverage.svg)](https://codeclimate.com/github/david942j/one_gadget/coverage)
[![Inline docs](https://inch-ci.org/github/david942j/one_gadget.svg?branch=master)](https://inch-ci.org/github/david942j/one_gadget)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](http://choosealicense.com/licenses/mit/)

## One Gadget

When playing ctf pwn challenges we usually needs the one-gadget of execve('/bin/sh', NULL, NULL).

This gem provides such gadget finder, no need to use IDA-pro every time like a fool.

Also provides the command-line tool `one_gadget` for easy usage.

Note: only supports x86-64 now.

## Install

I'll push to rubygems.org..

## Usage

### Command Line Tool

```bash
one_gadget
# Usage: one_gadget [file] [--build-id <BuildID>]
#    -b, --build-id BuildID           BuildID[sha1] of libc

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
```

### In exploit script
```ruby
require 'one_gadget'
OneGadget.gadgets(filepath: '/lib/x86_64-linux-gnu/libc.so.6')
# => [283242, 980676, 984423]
```

## Screenshots

### Search gadgets from file
![from file](https://github.com/david942j/one_gadget/blob/master/examples/from_file.png?raw=true)

### Fetch gadgets from database
![build id](https://github.com/david942j/one_gadget/blob/master/examples/from_build_id.png?raw=true)

