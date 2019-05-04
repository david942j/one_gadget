# frozen_string_literal: true

require 'one_gadget'

describe 'one_gadget_i386' do
  describe 'from file' do
    before(:each) do
      skip_unless_objdump
    end

    it 'libc-2.19' do
      path = data_path('libc-2.19-fd51b20e670e9a9f60dc3b06dc9761fb08c9358b.so')
      expect(OneGadget.gadgets(file: path, force_file: true)).to eq [0x3fd27, 0x64c64, 0x64c6a, 0x64c6e]
    end

    it 'libc-2.23' do
      ans = [0x3ac5c, 0x3ac5e, 0x3ac62, 0x3ac69, 0x5fbc5, 0x5fbc6]
      path = data_path('libc-2.23-926eb99d49cab2e5622af38ab07395f5b32035e9.so')
      expect(OneGadget.gadgets(file: path, force_file: true)).to eq ans
    end

    it 'libc-2.26' do
      ans = [0x3cc2f, 0x3cc31, 0x3cc35, 0x3cc3c, 0x66e7f, 0x66e80, 0x132fbe, 0x132fbf]
      path = data_path('libc-2.26-f65648a832414f2144ce795d75b6045a1ec2e252.so')
      expect(OneGadget.gadgets(file: path, force_file: true)).to eq ans
    end

    it 'libc-2.27' do
      ans = [0x3cbea, 0x3cbec, 0x3cbf0, 0x3cbf7, 0x6729f, 0x672a0, 0x13573e, 0x13573f]
      path = data_path('libc-2.27-63b3d43ad45e1b0f601848c65b067f9e9b40528b.so')
      expect(OneGadget.gadgets(file: path, force_file: true)).to eq ans
    end

    it 'special filename' do
      expect(OneGadget.gadgets(file: data_path('filename$with+special&keys'))).not_to be_empty
    end
  end

  describe 'from build id' do
    before(:all) do
      @build_id = '926eb99d49cab2e5622af38ab07395f5b32035e9'
    end

    it 'normal' do
      # only check not empty because the gadgets might add frequently.
      expect(OneGadget.gadgets(build_id: @build_id)).not_to be_empty
    end
  end
end
