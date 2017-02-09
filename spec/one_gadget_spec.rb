require 'one_gadget'

describe 'one_gadget' do
  before(:all) do
    # To force require all again.
    OneGadget::Gadget::ClassMethods::BUILDS.clear
    @build_id = '60131540dadc6796cab33388349e6e4e68692053'
    @libcpath = File.join(File.dirname(__FILE__), 'data', 'libc-2.19.so')
  end

  it 'from file' do
    expect(OneGadget.gadgets(filepath: @libcpath)).to eq []
  end

  describe 'from build id' do
    it 'normal' do
      # only check not empty because the gadgets might add frequently.
      expect(OneGadget.gadgets(build_id: @build_id)).not_to be_empty
    end

    it 'invalid' do
      expect { OneGadget.gadgets(build_id: '^_^') }.to raise_error(ArgumentError, 'invalid BuildID format: "^_^"')
    end
  end
end
