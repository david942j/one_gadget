require 'one_gadget'

describe 'one_gadget' do
  before(:all) do
    @build_id = '60131540dadc6796cab33388349e6e4e68692053'
    @libcpath = File.join(Dir.pwd, 'spec', 'data', 'libc-2.19.so')
  end

  it 'from file' do
    expect(OneGadget.gadgets(filepath: @libcpath)).to eq []
  end

  describe 'from build id' do
    it 'from build id' do
      expect(OneGadget.gadgets(build_id: @build_id)).to eq [0x4526a]
    end

    it 'invalid id' do
      expect { OneGadget.gadgets(build_id: '^_^') }.to raise_error(ArgumentError, 'invalid BuildID format: ^_^')
    end
  end
end
