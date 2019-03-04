require 'one_gadget/emulators/aarch64'

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
  end
end
