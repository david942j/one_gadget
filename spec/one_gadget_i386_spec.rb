require 'one_gadget'

describe 'one_gadget' do
  before(:each) do
    @build_id = '926eb99d49cab2e5622af38ab07395f5b32035e9'
    @libcpath19 = File.join(File.dirname(__FILE__), 'data', 'libc-2.19-fd51b20e670e9a9f60dc3b06dc9761fb08c9358b.so')
    @libcpath23 = File.join(File.dirname(__FILE__), 'data', 'libc-2.23-926eb99d49cab2e5622af38ab07395f5b32035e9.so')
  end

  it 'from file libc-2.19' do
    expect(OneGadget.gadgets(file: @libcpath19, force_file: true)).to eq [0x3fd27, 0x64c64, 0x64c6a, 0x64c6e]
  end

  it 'from file libc-2.23' do
    expect(OneGadget.gadgets(file: @libcpath23, force_file: true)).to eq [0x3ac69, 0x5fbc5, 0x5fbc6]
  end

  describe 'from build id' do
    it 'normal' do
      # only check not empty because the gadgets might add frequently.
      expect(OneGadget.gadgets(build_id: @build_id)).not_to be_empty
    end
  end
end
