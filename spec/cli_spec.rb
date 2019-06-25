# frozen_string_literal: true

require 'one_gadget/cli'
require 'one_gadget/version'

describe OneGadget::CLI do
  let(:b_param) { %w[-b b417c0ba7cc5cf06d1d1bed6652cedb9253c60d0] }
  let(:libc_file) { data_path('libc-2.27-b417c0ba7cc5cf06d1d1bed6652cedb9253c60d0.so') }

  it 'version' do
    expect { described_class.work(['--version']) }.to output("OneGadget Version #{OneGadget::VERSION}\n").to_stdout
  end

  it 'error' do
    expect { hook_logger { described_class.work(b_param + ['file']) } }.to output(<<-EOS).to_stdout
[OneGadget] Either FILE or BuildID can be passed
    EOS
  end

  it 'info' do
    expect { hook_logger { described_class.work(%w[--info b417c]) } }.to output(<<-EOS).to_stdout
[OneGadget] Information of b417c:
            https://gitlab.com/libcdb/libcdb/blob/master/libc/libc6_2.27-3ubuntu1_amd64/lib/x86_64-linux-gnu/libc-2.27.so

            Advanced Micro Devices X86-64

            GNU C Library (Ubuntu GLIBC 2.27-3ubuntu1) stable release version 2.27.
            Copyright (C) 2018 Free Software Foundation, Inc.
            This is free software; see the source for copying conditions.
            There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
            PARTICULAR PURPOSE.
            Compiled by GNU CC version 7.3.0.
            libc ABIs: UNIQUE IFUNC
            For bug reporting instructions, please see:
            <https://bugs.launchpad.net/ubuntu/+source/glibc/+bugs>.
    EOS
  end

  it 'build id' do
    expect { described_class.work(b_param) }.to output(<<-EOS).to_stdout
0x4f2c5 execve("/bin/sh", rsp+0x40, environ)
constraints:
  rsp & 0xf == 0
  rcx == NULL

0x4f322 execve("/bin/sh", rsp+0x40, environ)
constraints:
  [rsp+0x40] == NULL

0x10a38c execve("/bin/sh", rsp+0x70, environ)
constraints:
  [rsp+0x70] == NULL
    EOS
  end

  it 'build id with raw' do
    expect { described_class.work(b_param + %w[--raw --level 1]) }.to output(<<-EOS).to_stdout
324293 324386 939679 940120 940127 940131 1090444 1090456
    EOS
  end

  it 'file with raw' do
    skip_unless_objdump

    expect { described_class.work(%w[--force --raw --level 1] + [libc_file]) }.to output(<<-EOS).to_stdout
324293 324386 939679 940120 940127 940131 1090444 1090456
    EOS
  end

  it 'script' do
    skip_on_windows

    expect { hook_logger { described_class.work(b_param + %w[-s true]) } }.to output(<<-EOS).to_stdout
[OneGadget] Trying 0x4f2c5...
[OneGadget] Trying 0x4f322...
[OneGadget] Trying 0x10a38c...
    EOS
  end

  context 'near' do
    before do
      skip_unless_objdump
    end

    it 'function' do
      file = data_path('libc-2.24-8cba3297f538691eb1875be62986993c004f3f4d.so')
      expect { hook_logger { described_class.work(%w[-n system -l 1] + [file]) } }.to output(<<-EOS).to_stdout
[OneGadget] Gadgets near system(0x3f4d0):
0x3f3aa execve("/bin/sh", rsp+0x30, environ)
constraints:
  [rsp+0x30] == NULL

0x3f356 execve("/bin/sh", rsp+0x30, environ)
constraints:
  rax == NULL

0xb8a38 execve("/bin/sh", r13, r12)
constraints:
  [r13] == NULL || r13 == NULL
  [r12] == NULL || r12 == NULL

0xd67e5 execve("/bin/sh", rsp+0x70, environ)
constraints:
  [rsp+0x70] == NULL

0xd67f1 execve("/bin/sh", rsi, [rax])
constraints:
  [rsi] == NULL || rsi == NULL
  [[rax]] == NULL || [rax] == NULL

      EOS
    end

    it 'functions' do
      file = data_path('libc-2.24-8cba3297f538691eb1875be62986993c004f3f4d.so')
      expect { hook_logger { described_class.work(%w[-n wscanf,pwrite -l 1 -r] + [file]) } }.to output(<<-EOS).to_stdout
[OneGadget] Gadgets near pwrite(0xd9b70):
878577 878565 756280 258986 258902

[OneGadget] Gadgets near wscanf(0x6afe0):
258986 258902 756280 878565 878577

      EOS
    end

    it 'file' do
      bin_file = data_path('test_near_file.elf')
      lib_file = data_path('libc-2.24-8cba3297f538691eb1875be62986993c004f3f4d.so')
      argv = ['-n', bin_file, '-l1', '-r', lib_file]
      expect { hook_logger { described_class.work(argv) } }.to output(<<-EOS).to_stdout
[OneGadget] Gadgets near exit(0x359d0):
258902 258986 756280 878565 878577

[OneGadget] Gadgets near puts(0x68fe0):
258986 258902 756280 878565 878577

[OneGadget] Gadgets near printf(0x4f1e0):
258986 258902 756280 878565 878577

[OneGadget] Gadgets near strlen(0x80420):
756280 258986 258902 878565 878577

[OneGadget] Gadgets near __cxa_finalize(0x35c70):
258902 258986 756280 878565 878577

[OneGadget] Gadgets near __libc_start_main(0x201a0):
258902 258986 756280 878565 878577

      EOS
    end

    it 'empty' do
      argv = %w[--near no_such_function] + [libc_file]
      expect { hook_logger { described_class.work(argv) } }.to output(<<-EOS).to_stdout
[OneGadget] No functions for processing
      EOS
    end

    it 'file only' do
      argv = b_param + %w[--near system]
      expect { hook_logger { described_class.work(argv) } }.to output(<<-EOS).to_stdout
[OneGadget] Libc file must be given when using --near option
      EOS
    end
  end
end
