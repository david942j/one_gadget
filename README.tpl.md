[![Downloads](https://img.shields.io/gem/dt/one_gadget)](https://rubygems.org/gems/one_gadget)


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

## Supported Architectures

- [x] i386
- [x] amd64 (x86-64)
- [x] aarch64 (ARMv8)
- [x] arm (ARMv7, A32/Thumb-2)
- [x] riscv64 (RV64GC)

## Implementation

OneGadget uses symbolic execution to find the constraints of gadgets to be successful.

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
SHELL_OUTPUT_OF(one_gadget)
```

```bash
SHELL_OUTPUT_OF(one_gadget spec/data/libc-2.31-9fdb74e7b217d06c93172a8243f8547f947ee6d1.so)
```
![x86_64](https://github.com/david942j/one_gadget/blob/master/examples/x86_64.png?raw=true)

#### Given BuildID
```bash
SHELL_OUTPUT_OF(one_gadget -b b417c0ba7cc5cf06d1d1bed6652cedb9253c60d0)
```
![build id](https://github.com/david942j/one_gadget/blob/master/examples/from_build_id.png?raw=true)

The gem carries the gadgets of the libcs most likely to be asked for -- the glibc of
every Ubuntu LTS still in standard support, and every libc the tests cover. Any other
BuildID is fetched from this repository, which keeps them all.

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
SHELL_OUTPUT_OF(one_gadget spec/data/libc-2.31-9fdb74e7b217d06c93172a8243f8547f947ee6d1.so --near exit,mkdir)
```
![near](https://github.com/david942j/one_gadget/blob/master/examples/near.png?raw=true)

Regular expression is acceptable.
```bash
SHELL_OUTPUT_OF(one_gadget spec/data/libc-2.31-9fdb74e7b217d06c93172a8243f8547f947ee6d1.so --near 'write.*' --raw)
```

Pass an ELF file as the argument, OneGadget will take all GOT functions for processing.
```bash
SHELL_OUTPUT_OF(one_gadget spec/data/libc-2.31-9fdb74e7b217d06c93172a8243f8547f947ee6d1.so --near spec/data/test_near_file.elf --raw)
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
SHELL_OUTPUT_OF(one_gadget spec/data/libc-2.31-9fdb74e7b217d06c93172a8243f8547f947ee6d1.so --level 1)
```

#### Other Architectures

##### i386
```bash
SHELL_OUTPUT_OF(one_gadget spec/data/libc-2.27-63b3d43ad45e1b0f601848c65b067f9e9b40528b.so)
```
![i386](https://github.com/david942j/one_gadget/blob/master/examples/i386.png?raw=true)

##### AArch64
```bash
SHELL_OUTPUT_OF(one_gadget spec/data/aarch64-libc-2.27.so)
```
![aarch64](https://github.com/david942j/one_gadget/blob/master/examples/aarch64.png?raw=true)

##### ARM32

```bash
SHELL_OUTPUT_OF(one_gadget spec/data/arm-libc-2.39.so)
```

##### RISC-V (RV64)

```bash
SHELL_OUTPUT_OF(one_gadget spec/data/riscv64-libc-2.39.so)
```

#### Combine with Script
Pass your exploit script as `one_gadget`'s arguments, it can
try all gadgets one by one, so you don't need to try every possible gadgets manually.

```bash
$ one_gadget spec/data/libc-2.31-9fdb74e7b217d06c93172a8243f8547f947ee6d1.so -s 'echo "offset ->"'
```

![--script](https://github.com/david942j/one_gadget/blob/master/examples/script.png?raw=true)

### In Ruby Scripts
```ruby
require 'one_gadget'
RUBY_OUTPUT_OF(OneGadget.gadgets(file: 'spec/data/libc-2.31-9fdb74e7b217d06c93172a8243f8547f947ee6d1.so'))
# or in shorter way
RUBY_OUTPUT_OF(one_gadget('spec/data/libc-2.31-9fdb74e7b217d06c93172a8243f8547f947ee6d1.so', level: 1))
# from build id
RUBY_OUTPUT_OF(one_gadget('b417c0ba7cc5cf06d1d1bed6652cedb9253c60d0'))
```

### To Python Lovers
```python
import subprocess
def one_gadget(filename):
  return [int(i) for i in subprocess.check_output(['one_gadget', '--raw', filename]).decode().split(' ')]

RUBY_OUTPUT_OF(one_gadget('spec/data/libc-2.31-9fdb74e7b217d06c93172a8243f8547f947ee6d1.so'))
```

## Make OneGadget Better
Any suggestion or feature request is welcome! Feel free to send a pull request.

Please let me know if you find any libc that make OneGadget fail to find gadgets.
And, if you like this work, I'll be happy to be [starred](https://github.com/david942j/one_gadget/stargazers) :grimacing:
