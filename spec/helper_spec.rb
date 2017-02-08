require 'one_gadget/helper'

describe OneGadget::Helper do
  before(:all) do
    @libcpath = File.join(File.dirname(__FILE__), 'data', 'libc-2.23.so')
  end
  it 'abspath' do
    expect(OneGadget::Helper.abspath('./spec/data/libc-2.23.so')).to eq @libcpath
  end

  it 'build_id_of' do
    expect(OneGadget::Helper.build_id_of(@libcpath)).to eq '60131540dadc6796cab33388349e6e4e68692053'
  end
end
