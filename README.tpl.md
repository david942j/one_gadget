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
SHELL_OUTPUT_OF(one_gadget)
```

```bash
SHELL_OUTPUT_OF(one_gadget /lib/x86_64-linux-gnu/libc.so.6)
```
![x86_64](https://github.com/david942j/one_gadget/blob/master/examples/x86_64.png?raw=true)

#### Given BuildID
```bash
SHELL_OUTPUT_OF(one_gadget -b aad7dbe330f23ea00ca63daf793b766b51aceb5d)
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
SHELL_OUTPUT_OF(one_gadget /lib/x86_64-linux-gnu/libc.so.6 --near exit,mkdir)
```
![near](https://github.com/david942j/one_gadget/blob/master/examples/near.png?raw=true)

Regular expression is acceptable.
```bash
SHELL_OUTPUT_OF(one_gadget /lib/x86_64-linux-gnu/libc.so.6 --near 'write.*' --raw)
```

Pass an ELF file as the argument, OneGadget will take all GOT functions for processing.
```bash
SHELL_OUTPUT_OF(one_gadget /lib/x86_64-linux-gnu/libc.so.6 --near spec/data/test_near_file.elf --raw)
```

#### Show All Gadgets

Sometimes `one_gadget` finds too many gadgets to show them in one screen,
by default gadgets would be filtered automatically *according to the difficulty of constraints*.

Use option `--level 1` to show all gadgets found instead of only those with higher probabilities.

```bash
SHELL_OUTPUT_OF(one_gadget /lib/x86_64-linux-gnu/libc.so.6 --level 1)
```

#### Other Architectures

##### i386
```bash
SHELL_OUTPUT_OF(one_gadget /lib32/libc.so.6)
```
![i386](https://github.com/david942j/one_gadget/blob/master/examples/i386.png?raw=true)

##### AArch64
```bash
SHELL_OUTPUT_OF(one_gadget spec/data/aarch64-libc-2.27.so)
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
RUBY_OUTPUT_OF(OneGadget.gadgets(file: '/lib/x86_64-linux-gnu/libc.so.6'))
# or in shorter way
RUBY_OUTPUT_OF(one_gadget('/lib/x86_64-linux-gnu/libc.so.6', level: 1))
# from build id
RUBY_OUTPUT_OF(one_gadget('b417c0ba7cc5cf06d1d1bed6652cedb9253c60d0'))
```

### To Python Lovers
```python
import subprocess
def one_gadget(filename):
  return map(int, subprocess.check_output(['one_gadget', '--raw', filename]).split(' '))

RUBY_OUTPUT_OF(one_gadget('/lib/x86_64-linux-gnu/libc.so.6'))
```

## Make OneGadget Better
Any suggestion or feature request is welcome! Feel free to send a pull request.

Please let me know if you find any libc that make OneGadget fail to find gadgets.
And, if you like this work, I'll be happy to be [starred](https://github.com/david942j/one_gadget/stargazers) :grimacing:
