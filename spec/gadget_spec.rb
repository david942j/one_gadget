require 'one_gadget/gadget'
require 'one_gadget/helper'

describe OneGadget::Gadget do
  before(:all) do
    @build_id = 'fake_id'
    OneGadget::Helper.color_off! # disable colorize for easy testing.
    OneGadget::Gadget.add(@build_id, 0x1234, constraints: ['[rsp+0x30] == NULL', 'rax == 0'],
                                             effect: 'execve("/bin/sh", rsp+0x30, rax)')
  end

  after(:all) do
    OneGadget::Gadget::ClassMethods::BUILDS.delete @build_id
  end

  it 'inspect' do
    expect(described_class.builds(@build_id).map(&:inspect).join).to eq <<-EOS
0x1234	execve("/bin/sh", rsp+0x30, rax)
constraints:
  [rsp+0x30] == NULL
  rax == 0
    EOS
  end

  context 'builds_info' do
    it 'normal' do
      expect(described_class.builds_info('58c735bc7b19b0aeb395cce70cf63bd62ac75e4a').join("\n")).to eq <<-EOS.strip
https://gitlab.com/libcdb/libcdb/blob/master/libc/glibc-2.25-1-x86_64.pkg.tar/usr/lib/libc-2.25.so

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
