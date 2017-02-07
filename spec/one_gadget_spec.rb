require 'one_gadget'

describe 'one_gadget' do
  it 'from file' do
    expect(one_gadget(file: 'oao')).to eq 'Nothing :p'
  end

  it 'from build id' do
    expect(one_gadget(build_id: 'oao')).to eq 'Nothing :p'
  end
end
