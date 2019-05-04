# frozen_string_literal: true

require 'one_gadget/emulators/lambda'
describe OneGadget::Emulators::Lambda do
  before(:each) do
    @rsp = described_class.new('rsp')
  end

  describe '+' do
    it 'normal' do
      expect((@rsp + 0x50).to_s).to eq 'rsp+0x50'
      expect((@rsp - 0x50).to_s).to eq 'rsp-0x50'
    end

    it 'mixed' do
      rax = described_class.new('rax')
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
    expect(((@rsp + 0x50).deref - 0x30).deref.to_s).to eq '[[rsp+0x50]-0x30]'
  end

  it 'parse' do
    expect(described_class.parse('[rsp+0x50]').to_s).to eq '[rsp+0x50]'
    # ARM form
    expect(described_class.parse('[x0, 1160]').to_s).to eq '[x0+0x488]'
    expect(described_class.parse('[x22, -104]').to_s).to eq '[x22-0x68]'
    # test if OK with bang
    expect(described_class.parse('[x2, -8]!').to_s).to eq '[x2-0x8]'
    expect(described_class.parse('[rsp+80]').to_s).to eq '[rsp+0x50]'
    expect(described_class.parse('esp').to_s).to eq 'esp'
    expect(described_class.parse('esp-10').to_s).to eq 'esp-0xa'
    expect(described_class.parse('123')).to be 123
    expect(described_class.parse('0xabc123')).to be 0xabc123

    predefined = { 'rsp' => described_class.new('rsp') + 0x10 }
    expect(described_class.parse('rsp+0x20', predefined: predefined).to_s).to eq 'rsp+0x30'

    # Nested []
    expect(described_class.parse('[[rsp+0x33]]').to_s).to eq '[[rsp+0x33]]'
  end

  it 'evaluate' do
    l = described_class.parse('rax+0x30')
    expect(l.evaluate('rax' => 2)).to be 50

    expect { l.evaluate({}) }.to raise_error(OneGadget::Error::InstructionArgumentError, "Can't eval rax+0x30")
  end
end
