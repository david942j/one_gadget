# frozen_string_literal: true

require 'one_gadget/emulators/aarch64'
require 'one_gadget/error'

describe OneGadget::Emulators::AArch64 do
  before(:each) do
    @processor = described_class.new
  end

  describe 'process' do
    it 'libc-2.23 gadget' do
      gadget = <<-EOS
        3d718:  adrp    x2, 140000 <h_errlist@@GLIBC_2.17+0x8b0>
        3d71c:  adrp    x0, 117000 <in6addr_any@@GLIBC_2.17+0x2680>
        3d720:  mov     x1, x22
        3d724:  add     x0, x0, #0x9a0
        3d728:  str     wzr, [x20, #4]
        3d72c:  ldr     x2, [x2, #3728]
        3d730:  ldr     x2, [x2]
        3d734:  bl      9b1b0 <execve@@GLIBC_2.17>
      EOS
      gadget.each_line { |s| @processor.process(s) }
      expect(@processor.registers['x0'].to_s).to eq '$base+0x1179a0'
      expect(@processor.registers['x1'].to_s).to eq 'x22'
      expect(@processor.registers['x2'].to_s).to eq '[[$base+0x140e90]]'
      expect(@processor.registers['pc'].to_s).to eq '9b1b0 <execve@@GLIBC_2.17>'
    end

    it 'ldr' do
      @processor.process('ldr x0, [x1, #8]!')
      expect(@processor.registers['x0'].to_s).to eq '[x1+0x8]'
      expect(@processor.registers['x1'].to_s).to eq 'x1+0x8'

      @processor.process('ldr x2, [x3], #8')
      expect(@processor.registers['x2'].to_s).to eq '[x3]'
      expect(@processor.registers['x3'].to_s).to eq 'x3+0x8'
    end

    it 'stp' do
      @processor.process('stp x2, x3, [sp, #16]')
      expect(@processor.registers['sp'].to_s).to eq 'sp'
      expect(@processor.stack[16].to_s).to eq 'x2'
      expect(@processor.stack[24].to_s).to eq 'x3'

      # equivalent to 'push x1; push x0'
      @processor.process('stp x0, x1, [sp, #-16]!')
      expect(@processor.registers['sp'].to_s).to eq 'sp-0x10'
      expect(@processor.stack[-8].to_s).to eq 'x1'
      expect(@processor.stack[-16].to_s).to eq 'x0'
    end

    it 'str' do
      # post-index mode
      @processor.process('mov x1, sp')
      @processor.process('str x0, [x1], #-8')
      expect(@processor.registers['sp'].to_s).to eq 'sp'
      expect(@processor.registers['x1'].to_s).to eq 'sp-0x8'
      expect(@processor.stack[0].to_s).to eq 'x0'

      @processor.process('str xzr, [sp, #200]')
      expect(@processor.stack[200]).to be_zero

      @processor.process('str x2, [sp, #0x100]!')
      expect(@processor.stack[0x100].to_s).to eq 'x2'
      expect(@processor.registers['sp'].to_s).to eq 'sp+0x100'

      @processor.process('str x3, [x4]')
      expect(@processor.constraints).to eq ['writable: x4']
    end
  end
end
