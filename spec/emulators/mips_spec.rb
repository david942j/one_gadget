# frozen_string_literal: true

require 'one_gadget/emulators/mips'
require 'one_gadget/error'

describe OneGadget::Emulators::Mips do
  before(:each) do
    @processor = described_class.new
  end

  it 'reads a literal, a move and the arithmetic' do
    @processor.process('4b3d8: li s1,0')
    expect(@processor.registers['s1']).to be 0
    @processor.process('4b3dc: move a2,a1')
    expect(@processor.registers['a2'].to_s).to eq 'a1'
    @processor.process('4b3e0: addiu a3,a2,8') # immediates are decimal here
    expect(@processor.registers['a3'].to_s).to eq 'a1+0x8'
    @processor.process('4b3e4: subu a3,a3,s1')
    expect(@processor.registers['a3'].to_s).to eq 'a1+0x8'
    @processor.process('4b3e8: addu a0,a3,a3')
    expect(@processor.registers['a0'].to_s).to eq '(a1+0x8 + a1+0x8)'
  end

  it 'loads an upper immediate into the upper half of the register' do
    @processor.process('4b400: lui v0,0x8000')
    expect(@processor.registers['v0']).to be 0x80000000
    # every bit above the register width is dropped rather than carried
    @processor.process('4b404: lui v0,0xfffff')
    expect(@processor.registers['v0']).to be 0xfffff0000 & 0xffffffff
  end

  it 'folds the bitwise operations and the shifts' do
    @processor.process('4b408: li t0,0x30')
    @processor.process('4b40c: andi t1,t0,-16')
    expect(@processor.registers['t1']).to be 0x30
    @processor.process('4b410: sll t1,t1,0x3')
    expect(@processor.registers['t1']).to be 0x180
    @processor.process('4b414: xor t2,t3,t3') # how every arch spells "zero this"
    expect(@processor.registers['t2']).to be 0
    @processor.process('4b418: ori t4,a1,7')
    expect(@processor.registers['t4'].to_s).to eq '(a1 | 0x7)'
  end

  describe 'memory' do
    it 'reads back through the slot it wrote' do
      @processor.process('4b420: addiu s1,sp,16')
      @processor.process('4b424: sw s1,32(sp)')
      @processor.process('4b428: lw a0,32(sp)')
      expect(@processor.registers['a0'].to_s).to eq 'sp+0x10'
    end

    it 'names a load through a register the caller supplies' do
      @processor.process('4b42c: lw a1,4(s6)')
      expect(@processor.registers['a1'].to_s).to eq '[s6+0x4]'
    end

    it 'refuses to name what a narrower access leaves behind' do
      @processor.process('4b430: lbu a2,0(s6)')
      # only part of the tracked word was read, so the register does not hold it
      expect(@processor.registers['a2'].to_s).not_to eq '[s6+0x0]'
      # and nothing can be said about what it does hold
      expect(@processor.process('4b434: beqz a2,4b440 <x>')).to be false
    end

    it 'requires a store through a caller-supplied pointer to be writable' do
      @processor.process('4b438: sw a1,8(s6)')
      expect(@processor.constraints).to eq ['writable: s6+0x8']
    end

    it 'aborts on an addressing form it does not model' do
      expect { @processor.send(:mem_operand, 'a1(a2)') }
        .to raise_error(OneGadget::Error::UnsupportedInstructionArgumentError)
    end
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
      expect(branch_constraint('bne a2,a0,', 0x2000, 0x1004)).to eq ['a2 == a0'] # not taken
      @processor = described_class.new
      expect(branch_constraint('beq a2,a0,', 0x2000, 0x2000)).to eq ['a2 == a0'] # taken
    end

    it 'reads a comparison against zero off the register that names it' do
      expect(branch_constraint('beqz a3,', 0x2000, 0x2000)).to eq ['a3 == 0x0'] # taken
      @processor = described_class.new
      expect(branch_constraint('bnez a3,', 0x2000, 0x2000)).to eq ['a3 != 0x0'] # taken
      @processor = described_class.new
      expect(branch_constraint('blez a3,', 0x2000, 0x2000)).to eq ['(s32)a3 <= 0x0'] # taken
    end

    it 'takes an unconditional branch without constraining anything' do
      expect(@processor.process('1000: b 2000 <x>')).to be true
      expect(@processor.constraints).to eq []
    end
  end

  describe 'calls' do
    # This arch reaches libc through a register, so the fetcher writes the name
    # beside the call; these are the lines the emulator is handed.
    it 'ends the path at a terminal call, however it is spelled' do
      expect(@processor.process('4b470: jalr t9 <posix_spawn>')).to be false
      expect(@processor.registers['pc'].to_s).to eq 't9 <posix_spawn>'
    end

    it 'takes a direct call the same way' do
      expect(@processor.process('d88ec: bal d87ec <execve@@GLIBC_2.0>')).to be false
      expect(@processor.registers['pc'].to_s).to eq 'd87ec <execve@@GLIBC_2.0>'
    end

    it 'walks through a call it knows is safe' do
      @processor.process('4b3e4: move a0,s1')
      expect(@processor.process('4b3e0: jalr t9 <posix_spawnattr_init>')).to be true
      expect(@processor.constraints).to eq ['writable: s1']
    end

    it 'abandons a call it cannot name' do
      expect(@processor.process('20590: jalr t9')).to be false
    end
  end

  it 'holds zero in the hardwired register' do
    expect(@processor.registers['zero']).to be 0
  end

  it 'aborts on an instruction it does not model' do
    expect(@processor.process('4b3c0: sltu v0,zero,v0')).to be false
    expect(@processor.refused_line).to eq '4b3c0: sltu v0,zero,v0'
  end

  describe 'arguments' do
    it 'takes a0-a3 as the first four' do
      @processor.process('4b440: li a2,7')
      expect(@processor.argument(2)).to be 7
      expect(@processor.argument(0).to_s).to eq 'a0'
    end

    # o32 reserves a stack slot for every argument, including the four it also
    # states in registers, so the fifth argument's slot is the fifth one along.
    it 'reads the rest out of the slots reserved for them' do
      @processor.process('4b444: addiu s1,sp,64')
      @processor.process('4b448: sw s1,16(sp)')
      expect(@processor.argument(4).to_s).to eq 'sp+0x40'
    end
  end
end
