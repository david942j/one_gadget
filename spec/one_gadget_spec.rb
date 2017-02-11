require 'one_gadget'

describe 'one_gadget' do
  before(:each) do
    @build_id = '60131540dadc6796cab33388349e6e4e68692053'
    @libcpath = File.join(File.dirname(__FILE__), 'data', 'libc-2.19.so')
  end

  it 'from file' do
    expect(OneGadget.gadgets(file: @libcpath)).to eq [0x4647c, 0xe5765, 0xe66bd]
  end

  describe 'from build id' do
    it 'normal' do
      # only check not empty because the gadgets might add frequently.
      expect(OneGadget.gadgets(build_id: @build_id)).not_to be_empty
    end

    it 'invalid' do
      expect { OneGadget.gadgets(build_id: '^_^') }.to raise_error(ArgumentError, 'invalid BuildID format: "^_^"')
    end

    it 'fetch from remote' do
      entry = OneGadget::Gadget::ClassMethods::BUILDS.delete(@build_id)
      OneGadget::Gadget::ClassMethods::BUILDS[:a] = 1
      expect(OneGadget.gadgets(build_id: @build_id)).not_to be_empty
      OneGadget::Gadget::ClassMethods::BUILDS.delete(:a)
      OneGadget::Gadget::ClassMethods::BUILDS[@build_id] = entry unless entry.nil?
    end
  end
end
