# frozen_string_literal: true

require 'one_gadget/emulators/riscv64'
require 'one_gadget/error'

describe OneGadget::Emulators::Riscv64 do
  before(:each) do
    @processor = described_class.new
  end

  it 'reads pc-relative addresses off the instruction that names them' do
    # The pair objdump resolves to 171fc0 in its own comment, which this must agree
    # with: 0x9f48e + 0xd3000 = 0x17248e, then -1230 back to 0x171fc0.
    @processor.process('9f48e: auipc a5,0xd3')
    expect(@processor.registers['a5'].to_s).to eq '$base+0x17248e'
    @processor.process('9f492: addi a5,a5,-1230')
    expect(@processor.registers['a5'].to_s).to eq '$base+0x171fc0'
  end

  it 'loads an upper immediate as a value, not an address' do
    @processor.process('9f440: lui a6,0x80000')
    expect(@processor.registers['a6']).to be 0x80000000
    # every bit above the register width is dropped rather than carried
    @processor.process('9f444: lui a6,0xfffffffffffff')
    expect(@processor.registers['a6']).to eq 0xfffffffffffff000
  end

  it 'reads a literal, a move and the arithmetic' do
    @processor.process('9f434: li a5,0')
    expect(@processor.registers['a5']).to be 0
    @processor.process('9f43a: mv a7,a1')
    expect(@processor.registers['a7'].to_s).to eq 'a1'
    @processor.process('9f450: addi a4,a7,8') # immediates are decimal here
    expect(@processor.registers['a4'].to_s).to eq 'a1+0x8'
    @processor.process('9f452: sub a4,a4,a5')
    expect(@processor.registers['a4'].to_s).to eq 'a1+0x8'
    @processor.process('9f456: add a3,a4,a4')
    expect(@processor.registers['a3'].to_s).to eq '(a1+0x8 + a1+0x8)'
  end

  it 'holds zero in the hardwired register' do
    expect(@processor.registers['zero']).to be 0
  end

  it 'aborts on an instruction it does not model' do
    expect(@processor.process('9f466: amoadd.w a5,a4,(a3)')).to be false
    expect(@processor.refused_line).to eq '9f466: amoadd.w a5,a4,(a3)'
  end

  it 'takes a0-a7 as the arguments of a call' do
    @processor.process('9f434: li a2,7')
    expect(@processor.argument(2)).to be 7
    expect(@processor.argument(0).to_s).to eq 'a0'
  end
end
