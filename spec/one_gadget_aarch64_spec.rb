require 'mkmf'

require 'one_gadget/one_gadget'

describe 'one_gadget_aarch64' do
  before(:all) do
    @data_path = ->(file) { File.join(__dir__, 'data', file) }
  end

  describe 'from file' do
    # TODO: move to spec_helper
    before(:each) do
      skip 'binutils not installed' if find_executable0('objdump').nil?
    end

    it 'libc-2.23' do
      path = @data_path['aarch64-libc-2.23.so']
      expect(OneGadget.gadgets(file: path, force_file: true, level: 1))
        .to eq [0x3d6d0, 0x3d6d8, 0x3d718, 0x60c1c, 0x60c20]
    end

    it 'libc-2.24' do
      path = @data_path['aarch64-libc-2.24.so']
      expect(OneGadget.gadgets(file: path, force_file: true)).to eq [0x3c928, 0x3c930, 0x3c970, 0x61484, 0x61488]
    end

    it 'libc-2.27' do
      path = @data_path['aarch64-libc-2.27.so']
      expect(OneGadget.gadgets(file: path, force_file: true))
        .to eq [0x3f15c, 0x3f16c, 0x3f184, 0x3f1a8, 0x63e7c, 0x63e88, 0x63e90]
    end
  end

  it 'objdump not installed' do
    allow(OneGadget::Helper).to receive(:sym_to_objdump_arch).and_return(nil)
    path = @data_path['aarch64-libc-2.27.so']
    expect { hook_logger { OneGadget.gadgets(file: path, force_file: true) } }.to output(<<-EOS).to_stdout
[OneGadget] UnsupportedArchitectureError: Objdump that supported architecture "aarch64" is not found!
            Please install the package 'binutils-multiarch' and try one_gadget again!

            For Ubuntu users:
              $ [sudo] apt install binutils-multiarch
    EOS
  end
end
