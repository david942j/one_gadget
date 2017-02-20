require 'one_gadget'

describe 'one_gadget' do
  before(:each) do
    @build_id = '60131540dadc6796cab33388349e6e4e68692053'
    @data_path = ->(file) { File.join(File.dirname(__FILE__), 'data', file) }
  end

  describe 'from file' do
    it 'libc-2.19' do
      path = @data_path['libc-2.19-cf699a15caae64f50311fc4655b86dc39a479789.so']
      expect(OneGadget.gadgets(file: path)).to eq [0x4647c, 0xe5765, 0xe66bd]
    end

    it 'libc-2.24' do
      path = @data_path['libc-2.24-8cba3297f538691eb1875be62986993c004f3f4d.so']
      expect(OneGadget.gadgets(file: path, force_file: true)).to eq [0x3f3aa, 0xb8a38, 0xd67e5]
    end
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
