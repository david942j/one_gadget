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

  context 'prune settled constraints' do
    def cons(list)
      OneGadget::Gadget::Gadget.new(0, constraints: list).constraints
    end

    it 'drops a readability the dereference beside it already states' do
      expect(cons(['readable: x1', '[x1] == 0x0'])).to eq ['[x1] == 0x0']
      expect(cons(['readable: rbp-0x50', '[rbp-0x50] == 0x1'])).to eq ['[rbp-0x50] == 0x1']
    end

    it 'drops a readability implied by reading the pointer at that address' do
      expect(cons(['readable: x1', 'readable: [x1]'])).to eq ['readable: [x1]']
    end

    it 'keeps a readability when the dereference is only one of several options' do
      list = ['readable: r8', '[r8] == 0x0 || r8 is a valid envp']
      expect(cons(list)).to eq list
    end

    it 'rules out a NULL option beside a readability it cannot hold with' do
      # The dereference is optional, so it states nothing and the readability
      # stays; the readability is not, so "r8 == NULL" can never be taken.
      expect(cons(['readable: r8', '[r8] == NULL || r8 == NULL || r8 is a valid envp']))
        .to eq ['readable: r8', '[r8] == NULL || r8 is a valid envp']
    end

    it 'drops a NULL option for an address required to be mapped' do
      expect(cons(['writable: r8', 'r8 == NULL || (u16)[r8] == 0x0']))
        .to eq ['writable: r8', '(u16)[r8] == 0x0']
      expect(cons(['readable: rax', '[rax] == NULL || rax == NULL || rax is a valid argv']))
        .to eq ['readable: rax', '[rax] == NULL || rax is a valid argv']
    end

    it 'keeps a NULL option when the address is only optionally mapped' do
      list = ['rax == NULL || writable: rax']
      expect(cons(list)).to eq list
    end

    it 'leaves a constraint whose every option is ruled out' do
      list = ['writable: rax', 'rax == NULL']
      expect(cons(list)).to eq list
    end

    it 'drops a non-NULL requirement on an address already required to be mapped' do
      expect(cons(['rax != 0x0', 'writable: rax'])).to eq ['writable: rax']
      expect(cons(['x1 != NULL', 'readable: x1'])).to eq ['readable: x1']
    end

    it 'drops a non-NULL requirement the dereference beside it already states' do
      expect(cons(['[$base+0x10] != 0x0', '[[$base+0x10]+0xa4] == 0x0']))
        .to eq ['[[$base+0x10]+0xa4] == 0x0']
    end

    it 'keeps a non-NULL requirement when the dereference could clear the first page' do
      list = ['[$base+0x10] != 0x0', '[[$base+0x10]+0x2000] == 0x0']
      expect(cons(list)).to eq list
    end

    it 'keeps a non-NULL requirement when the dereference is only one of several options' do
      list = ['r8 != 0x0', '[r8] == 0x0 || r8 is a valid envp']
      expect(cons(list)).to eq list
    end

    it 'drops a comparison the value pinned beside it already answers' do
      expect(cons(['r0 == NULL', '(u32)r0 <= 0xfffff000'])).to eq ['r0 == NULL']
      expect(cons(['[rbp-0x50] == 0x1', '(s32)[rbp-0x50] >= 0x0'])).to eq ['[rbp-0x50] == 0x1']
    end

    # A pinned value answers every comparison against it, so the only other
    # outcome is a contradiction -- these two cannot both hold. That says the
    # gadget is impossible, which this pass leaves for someone else to notice
    # rather than quietly dropping half of it.
    it 'leaves a comparison the pinned value contradicts' do
      list = ['[rbp-0x50] == 0x1', '(s32)[rbp-0x50] <= 0x0']
      expect(cons(list)).to eq list
    end

    it 'keeps everything when only part of a value is pinned' do
      # (u16)X == 0 says nothing about the bits above it.
      list = ['(u16)[r8] == 0x0', '(u32)[r8] <= 0x5']
      expect(cons(list)).to eq list
    end

    it 'settles what dropping an option exposes' do
      # Dropping "r1 == NULL" leaves "writable: r2" holding outright, which then
      # rules out the NULL option for r2, whose dereference then states the
      # readability asked for separately.
      expect(cons(['writable: r1', 'r1 == NULL || writable: r2', 'readable: r2', 'r2 == NULL || [r2] == 0x0']))
        .to eq ['writable: r1', 'writable: r2', '[r2] == 0x0']
    end
  end

  context 'met_by?' do
    def gadget(cons)
      OneGadget::Gadget::Gadget.new(0, constraints: cons)
    end

    it 'holds when the other list names every constraint' do
      easier = gadget(['rax == NULL'])
      harder = gadget(['rax == NULL', 'writable: rbx'])
      expect(easier.met_by?(harder)).to be true
      expect(harder.met_by?(easier)).to be false
    end

    # libc-2.31 0x51e2b offers "rbp == NULL || (u16)[rbp] == 0x0"; 0x51e23 asks
    # for the second option outright, so it asks for everything 0x51e2b does.
    it 'holds when an option is required outright' do
      easier = gadget(['rbp == NULL || (u16)[rbp] == 0x0'])
      harder = gadget(['writable: rbp', '(u16)[rbp] == 0x0'])
      expect(easier.met_by?(harder)).to be true
    end

    it 'does not hold when only a different option is required' do
      easier = gadget(['rbp == NULL || (u16)[rbp] == 0x0'])
      harder = gadget(['writable: rbp', '[rbp+0x8] == 0x0'])
      expect(easier.met_by?(harder)).to be false
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
      expect(new(['(x3 & 0x10) == 0']).score).to be_within(eps).of 0.4  # bit-test, nothing dereferenced
      expect(new(['(x0 & x1) != 0']).score).to be_within(eps).of 0.6    # ..and neither is a distinct-register one
      expect(new(['(s64)(x0 + 0x10) < 0']).score).to be_within(eps).of 0.6 # nor a cmn compare
    end

    # The stack pointer's low bits holding a fixed value is free -- the caller
    # picks where the stack sits. A masked *value* renders similarly but is a
    # requirement the caller has to arrange, and scores as the relation it is.
    it 'tells stack alignment from a masked value' do
      expect(new(['rsp & 0xf == 0x0']).score).to be_within(eps).of 0.95
      expect(new(['sp & 0xf == 0x8']).score).to be_within(eps).of 0.95
      expect(new(['(eax & 0xf000) == 0x2000']).score).to be_within(eps).of 0.4
    end

    # A pointer a gadget masks before writing through is scored by what it is
    # derived from: rounding the stack pointer down still lands on the stack,
    # while rounding an attacker register down is as hard as the register was.
    it 'scores a masked pointer by the register it derives from' do
      expect(new(['writable: (rsp+0xf & 0xfffffffffffffff0)']).score).to be_within(eps).of 0.95
      expect(new(['writable: (rax & 0xfffffffffffffff0)']).score).to be_within(eps).of 0.81
      expect(new(['{"sh", r15, [(rsi & 0xfffffffffffffff0)+0x10], ...} is a valid argv']).score)
        .to be_within(eps).of 0.2
    end

    it 'level 3' do
      expect(new(['[[x4+0xad0]] == NULL']).score).to be_within(eps).of 0.9**3
      expect(new(['x4+0xad0 == NULL']).score).to be_within(eps).of 0.1
      # Both loads count: the offset one nests in the lambda representation, so
      # only the rendering states the depth the caller actually has to arrange.
      expect(new(['[[x0+0x438]+0xe8] == 0x0']).score).to be_within(eps).of 0.4 * 0.9**2
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
