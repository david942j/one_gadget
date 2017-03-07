require 'one_gadget/helper'

describe OneGadget::Helper do
  before(:all) do
    OneGadget::Helper.color_on!
    @libcpath = File.join(File.dirname(__FILE__), 'data', 'libc-2.23-60131540dadc6796cab33388349e6e4e68692053.so')
  end
  it 'abspath' do
    expect(OneGadget::Helper.abspath('./spec/data/libc-2.23-60131540dadc6796cab33388349e6e4e68692053.so'))
      .to eq @libcpath
  end

  it 'build_id_of' do
    expect(OneGadget::Helper.build_id_of(@libcpath)).to eq '60131540dadc6796cab33388349e6e4e68692053'
  end

  it 'colorize' do
    expect(OneGadget::Helper.colorize('123', sev: :integer)).to eq "\e[1m\e[34m123\e[0m"
  end

  it 'url_request' do
    expect(OneGadget::Helper.url_request('oao')).to be nil
  end

  it 'architecture' do
    expect(OneGadget::Helper.architecture(@libcpath)).to be :amd64
    expect(OneGadget::Helper.architecture(__FILE__)).to be :unknown
  end
end
