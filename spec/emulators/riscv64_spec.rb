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

  describe 'conditional branches' do
    # Feed the branch, then a follow-up line whose address decides taken
    # (== target) vs not-taken (!= target).
    def branch_constraint(branch, target, follow_addr)
      @processor.process("1000: #{branch} #{format('%x', target)} <x>")
      @processor.process("#{format('%x', follow_addr)}: nop")
      @processor.constraints
    end

    it 'compares and branches in the one instruction' do
      expect(branch_constraint('bne a2,a4,', 0x2000, 0x1004)).to eq ['a2 == a4'] # not taken
      @processor = described_class.new
      expect(branch_constraint('beq a2,a4,', 0x2000, 0x2000)).to eq ['a2 == a4'] # taken
    end

    it 'reads a comparison against zero off the register that names it' do
      expect(branch_constraint('beqz a3,', 0x2000, 0x2000)).to eq ['a3 == 0x0'] # taken
      @processor = described_class.new
      expect(branch_constraint('bnez a3,', 0x2000, 0x2000)).to eq ['a3 != 0x0'] # taken
    end

    it 'states a reversed spelling as the relation it reads' do
      expect(branch_constraint('bgt a0,a1,', 0x2000, 0x2000)).to eq ['(s64)a0 > a1'] # taken
      @processor = described_class.new
      expect(branch_constraint('bleu a0,a1,', 0x2000, 0x1004)).to eq ['(u64)a0 > a1'] # not taken
      @processor = described_class.new
      expect(branch_constraint('blez a0,', 0x2000, 0x2000)).to eq ['(s64)a0 <= 0x0'] # taken
    end

    it 'takes an unconditional jump without constraining anything' do
      expect(@processor.process('1000: j 2000 <x>')).to be true
      expect(@processor.constraints).to eq []
    end
  end

  it 'folds the bitwise operations and the shifts' do
    @processor.process('1000: li a5,0x30')
    @processor.process('1004: andi a4,a5,-16')
    expect(@processor.registers['a4']).to be 0x30
    @processor.process('1008: slli a4,a4,0x3')
    expect(@processor.registers['a4']).to be 0x180
    @processor.process('100c: xor a3,a2,a2') # how every arch spells "zero this"
    expect(@processor.registers['a3']).to be 0
    @processor.process('1010: ori a2,a1,7')
    expect(@processor.registers['a2'].to_s).to eq '(a1 | 0x7)'
  end

  it 'complements only a value it can name' do
    @processor.process('1000: lui a6,0x80000')
    @processor.process('1004: not a6,a6')
    expect(@processor.registers['a6']).to eq 0xffffffff7fffffff
    expect(@processor.process('1008: not a5,a4')).to be false # a4 is whatever the caller left
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
