# frozen_string_literal: true

require 'one_gadget/one_gadget'

describe 'one_gadget_aarch64' do
  describe 'from file' do
    before(:each) do
      skip_unless_objdump
    end

    it 'libc-2.23' do
      path = data_path('aarch64-libc-2.23.so')
      expect(OneGadget.gadgets(file: path, force_file: true, level: 1))
        .to eq [0x3d6d0, 0x3d6dc, 0x3d718, 0x60c1c, 0x60c20]
    end

    it 'libc-2.24' do
      path = data_path('aarch64-libc-2.24.so')
      expect(OneGadget.gadgets(file: path, force_file: true)).to eq [0x3c934, 0x3c970]
    end

    it 'libc-2.27' do
      path = data_path('aarch64-libc-2.27.so')
      expect(OneGadget.gadgets(file: path, force_file: true)).to eq [0x3f160, 0x3f184, 0x3f1a8, 0x63e90]
    end
  end

  it 'objdump not installed' do
    allow(OneGadget::Helper).to receive(:objdump_arch).and_return(nil)
    path = data_path('aarch64-libc-2.27.so')
    expect { hook_logger { OneGadget.gadgets(file: path, force_file: true) } }.to output(<<-EOS).to_stdout
[OneGadget] UnsupportedArchitectureError: Objdump that supports architecture "aarch64" is not found!
            Please install the package 'binutils-multiarch' and try one_gadget again!

            For Ubuntu users:
              $ [sudo] apt install binutils-multiarch
    EOS
  end
end
