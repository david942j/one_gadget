# frozen_string_literal: true

require 'tempfile'

require 'one_gadget/gadget'
require 'one_gadget/helper'

describe OneGadget::Gadget do
  context 'inspect' do
    it 'simple' do
      gadget = OneGadget::Gadget::Gadget.new(0x1234, constraints: ['[rsp+0x30] == NULL', 'rax == 0'],
                                                     effect: 'execve("/bin/sh", rsp+0x30, rax)')
      expect(gadget.inspect).to eq <<-EOS
0x1234 execve("/bin/sh", rsp+0x30, rax)
constraints:
  [rsp+0x30] == NULL
  rax == 0
      EOS
    end

    it 'merge constraints' do
      gadget = OneGadget::Gadget::Gadget.new(0x1234, constraints: ['writable: x3', 'rax == 0'],
                                                     effect: 'execve("/bin/sh", rsp+0x30, rax)')
      expect(gadget.inspect).to eq <<-EOS
0x1234 execve("/bin/sh", rsp+0x30, rax)
constraints:
  address x3 is writable
  rax == 0
      EOS

      gadget.constraints << 'writable: rbx+0x20'
      expect(gadget.inspect).to eq <<-EOS
0x1234 execve("/bin/sh", rsp+0x30, rax)
constraints:
  addresses x3, rbx+0x20 are writable
  rax == 0
      EOS
    end
  end

  context 'to_obj' do
    it 'simple' do
      gadget = OneGadget::Gadget::Gadget.new(0x1234, constraints: ['[rsp+0x30] == NULL', 'rax == 0'],
                                                     effect: 'execve("/bin/sh", rsp+0x30, rax)')
      expect(gadget.to_obj).to eq({
                                    value: 0x1234,
                                    effect: 'execve("/bin/sh", rsp+0x30, rax)',
                                    constraints: ['[rsp+0x30] == NULL', 'rax == 0']
                                  })
    end

    it 'to_json' do
      gadget = OneGadget::Gadget::Gadget.new(0x1234, constraints: ['everything is fine'],
                                                     effect: 'side')
      expect(gadget.to_json).to eq('{"value":4660,"effect":"side","constraints":["everything is fine"]}')
    end
  end

  context 'caveats' do
    # What the gadget costs beyond its constraints. Each line names the close as
    # the code performs it, and says what the descriptor must avoid.
    it 'names the close and what its descriptor must not be' do
      gadget = OneGadget::Gadget::Gadget.new(0x1234, effect: 'execve("/bin/sh", rsp+0x50, environ)',
                                                     closed_fds: ['[rsp+0x44]'])
      expect(gadget.caveats).to eq ['close([rsp+0x44]): prevent it from being 0 (stdin) or 1 ' \
                                    '(stdout) to sound an interactive shell.']
    end

    it 'prints them in their own section, one line each' do
      gadget = OneGadget::Gadget::Gadget.new(0x1234, effect: 'execve("/bin/sh", rsp+0x30, environ)',
                                                     constraints: ['rax == NULL'],
                                                     closed_fds: ['[rsp+0x44]', 'r12'])
      lines = gadget.inspect.gsub(/\e\[[0-9;]*m/, '').lines.map(&:chomp)
      expect(lines).to include 'caveats:'
      expect(lines.grep(/\A  close\(/).size).to eq 2
    end

    it 'carries them into the serialized form, and omits the keys when there are none' do
      plain = OneGadget::Gadget::Gadget.new(0x1234, effect: 'e', constraints: [])
      expect(plain.to_obj.keys).to eq %i[value effect constraints]

      gadget = OneGadget::Gadget::Gadget.new(0x1234, effect: 'e', constraints: [],
                                                     closed_fds: ['[rsp+0x44]'])
      expect(gadget.to_obj[:closed_fds]).to eq ['[rsp+0x44]']
      expect(gadget.to_obj[:caveats].size).to eq 1
    end
  end

  context 'score' do
    def new(cons)
      OneGadget::Gadget::Gadget.new(0, constraints: cons)
    end

    let(:eps) { 0.000001 }

    it 'empty' do
      expect(new([]).score).to be_within(eps).of 1.0
    end

    it 'level 1' do
      expect(new(['[rsp+0x30] == NULL']).score).to be_within(eps).of 0.9
      expect(new(['[esp+0x34] == NULL']).score).to be_within(eps).of 0.9
      expect(new(['[rbp+0x30] == NULL']).score).to be_within(eps).of 0.9
      expect(new(['rax == NULL']).score).to be_within(eps).of 0.9
      expect(new(['x1 == NULL']).score).to be_within(eps).of 0.9
      expect(new(['[rsi] == NULL || rsi == NULL']).score).to be_within(eps).of 0.9
      expect(new(['ebx is the GOT address of libc']).score).to be_within(eps).of 0.9
      expect(new(['[rsi] == NULL || ebx is the GOT address of libc']).score).to be_within(eps).of 0.9
    end

    it 'level 2' do
      expect(new(['[[sp+0x38]] == NULL']).score).to be_within(eps).of 0.81
      expect(new(['[rax] == NULL']).score).to be_within(eps).of 0.81
      expect(new(['[rsi] == NULL']).score).to be_within(eps).of 0.81
      expect(new(['[x4+0xad0] == NULL']).score).to be_within(eps).of 0.81
      expect(new(['writable: x20+0x338']).score).to be_within(eps).of 0.81
    end

    it 'branch conditions' do
      expect(new(['x2 == 0x1']).score).to be_within(eps).of 0.4          # equality
      expect(new(['(u64)x0 >= 0x400']).score).to be_within(eps).of 0.6   # inequality
      expect(new(['[x1+0x8] != 0']).score).to be_within(eps).of 0.54     # deref penalised
      expect(new(['(x3 & 0x10) == 0']).score).to be_within(eps).of 0.4 # bit-test, parses to x3+0x10
      expect(new(['(x0 & x1) != 0']).score).to be_within(eps).of 0.6 # distinct regs: lhs unparseable
      expect(new(['(s64)(x0 + 0x10) < 0']).score).to be_within(eps).of 0.6 # cmn compare: lhs unparseable
    end

    it 'level 3' do
      expect(new(['[[x4+0xad0]] == NULL']).score).to be_within(eps).of 0.9**3
      expect(new(['x4+0xad0 == NULL']).score).to be_within(eps).of 0.1
    end

    it 'more than one' do
      expect(new([
                   'rax == NULL',
                   'rbx+0x333 == NULL'
                 ]).score).to be_within(eps).of 0.9 * 0.1
    end
  end

  it 'remote' do
    id = 'remote_has_this'
    allow(OneGadget::Helper).to receive(:remote_builds).and_return([id])
    allow(OneGadget::Helper).to receive(:url_request).and_call_original
    allow(OneGadget::Helper).to receive(:url_request).with(/.rb$/).and_return('')

    expect { hook_logger { described_class.builds(id) } }.to output(<<-EOS).to_stdout
[OneGadget] The desired one-gadget can be found in lastest version!
            Update with: $ gem update one_gadget && gem cleanup one_gadget
    EOS
    OneGadget::Gadget::ClassMethods::BUILDS.delete(id)
  end

  context 'builds_info' do
    it 'normal' do
      expect(described_class.builds_info('58c735bc7b19b0aeb395cce70cf63bd62ac75e4a').join("\n")).to eq <<-EOS.strip
https://gitlab.com/david942j/libcdb/blob/master/libc/glibc-2.25-1-x86_64.pkg.tar/usr/lib/libc-2.25.so

Advanced Micro Devices X86-64

GNU C Library (GNU libc) stable release version 2.25, by Roland McGrath et al.
Copyright (C) 2017 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.
There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.
Compiled by GNU CC version 6.3.1 20170306.
Available extensions:
	crypt add-on version 2.1 by Michael Glad and others
	GNU Libidn by Simon Josefsson
	Native POSIX Threads Library by Ulrich Drepper et al
	BIND-8.2.3-T5B
libc ABIs: UNIQUE IFUNC
For bug reporting instructions, please see:
<https://bugs.archlinux.org/>.
      EOS
    end

    it 'multiple matches' do
      expect { hook_logger { described_class.builds_info('58c') } }.to output(<<-EOS).to_stdout
[OneGadget] Multiple BuildIDs match /^58c/
[OneGadget] Candidates are:
            libc-2.19 58cabb8c6f68b05a1c1c9a707a43f22c3a55a3e9
            libc-2.25 58c735bc7b19b0aeb395cce70cf63bd62ac75e4a
      EOS
    end
  end
end
