require 'one_gadget/emulators/lambda'
describe OneGadget::Emulators::Lambda do
  before(:each) do
    @rsp = OneGadget::Emulators::Lambda.new('rsp')
  end

  describe '+' do
    it 'normal' do
      expect((@rsp + 0x50).to_s).to eq 'rsp+0x50'
      expect((@rsp - 0x50).to_s).to eq 'rsp-0x50'
    end

    it 'mixed' do
      rax = OneGadget::Emulators::Lambda.new('rax')
      rax += 0x50
      expect(rax.to_s).to eq 'rax+0x50'
      rax += 0x50
      expect(rax.to_s).to eq 'rax+0xa0'
      rax -= 0xa0
      expect(rax.to_s).to eq 'rax'
    end
  end

  it 'dereference' do 
    drsp = @rsp.deref
    expect(@rsp.to_s).to eq 'rsp'
    expect(drsp.to_s).to eq '[rsp]'
    expect(drsp.deref.to_s).to eq '[[rsp]]'
    drsp.deref!
    expect(drsp.to_s).to eq '[[rsp]]'
  end

  it 'mixed' do
    expect((((@rsp+0x50).deref - 0x30).deref).to_s).to eq '[[rsp+0x50]-0x30]'
  end
end
