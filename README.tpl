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
SHELL_OUTPUT_OF(one_gadget)
SHELL_OUTPUT_OF(one_gadget -b 60131540dadc6796cab33388349e6e4e68692053)
SHELL_OUTPUT_OF(one_gadget /lib32/libc.so.6)
SHELL_OUTPUT_OF(one_gadget /lib/x86_64-linux-gnu/libc.so.6)
# show all gadgets found
SHELL_OUTPUT_OF(one_gadget /lib/x86_64-linux-gnu/libc.so.6 --level 1)
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
RUBY_OUTPUT_OF(OneGadget.gadgets(file: '/lib/x86_64-linux-gnu/libc.so.6'))
# or in shorter way
RUBY_OUTPUT_OF(one_gadget('/lib/x86_64-linux-gnu/libc.so.6', level: 1))
# from build id
RUBY_OUTPUT_OF(one_gadget('60131540dadc6796cab33388349e6e4e68692053'))
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
