# frozen_string_literal: true

require 'one_gadget/one_gadget'

describe 'one_gadget_arm' do
  describe 'from file' do
    before(:each) do
      skip_unless_objdump
    end

    it 'libc-2.23' do
      path = data_path('arm-libc-2.23.so')
      expect(OneGadget.gadgets(file: path, force_file: true)).to eq [0x2c626, 0x84dc4]
    end

    it 'libc-2.27' do
      path = data_path('arm-libc-2.27.so')
      expect(OneGadget.gadgets(file: path, force_file: true)).to eq [0x2d39c, 0x73f7a]
    end

    it 'libc-2.39' do
      path = data_path('arm-libc-2.39.so')
      expect(OneGadget.gadgets(file: path, force_file: true)).to eq [0x88a48]
    end

    it 'resolves environ through the GOT base register' do
      path = data_path('arm-libc-2.23.so')
      gadgets = OneGadget.gadgets(file: path, force_file: true, details: true)
      expect(gadgets.map(&:effect)).to include('execve("/bin/sh", r4, environ)')
    end
  end

  it 'objdump not installed' do
    allow(OneGadget::Helper).to receive(:objdump_arch).and_return(nil)
    path = data_path('arm-libc-2.27.so')
    expect { hook_logger { OneGadget.gadgets(file: path, force_file: true) } }.to output(<<-EOS).to_stdout
[OneGadget] UnsupportedArchitectureError: Objdump that supports architecture "arm" is not found!
            Please install the package 'binutils-multiarch' and try one_gadget again!

            For Ubuntu users:
              $ [sudo] apt install binutils-multiarch
    EOS
  end
end
