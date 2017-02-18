require 'one_gadget/emulators/i386'

describe OneGadget::Emulators::I386 do
  before(:each) do
    @processor = OneGadget::Emulators::I386.new
  end

  describe 'process' do
    it 'libc-2.23' do
      gadget = <<-EOS
   3a7f9:       8b 86 48 ff ff ff       mov    eax,DWORD PTR [esi-0xb8]
   3a7ff:       83 c4 0c                add    esp,0xc
   3a802:       c7 86 20 16 00 00 00 00 00 00   mov    DWORD PTR [esi+0x1620],0x0
   3a80c:       c7 86 24 16 00 00 00 00 00 00   mov    DWORD PTR [esi+0x1624],0x0
   3a816:       ff 30                   push   DWORD PTR [eax]
   3a818:       8d 44 24 2c             lea    eax,[esp+0x2c]
   3a81c:       50                      push   eax
   3a81d:       8d 86 9f a0 fa ff       lea    eax,[esi-0x55f61]
   3a823:       50                      push   eax
   3a824:       e8 57 4c 07 00          call   af480 <execve@@GLIBC_2.0>
      EOS
      gadget.lines.each { |s| @processor.process(s) }
      expect(@processor.registers['esp'].to_s).to eq 'esp'
      expect(@processor.stack[0].to_s).to eq 'esi-0x55f61'
      expect(@processor.stack[4].to_s).to eq 'esp+0x34'
      expect(@processor.stack[8].to_s).to eq '[[esi-0xb8]]'
      expect(@processor.stack[3].to_s).to eq '[esp+0x3]'
    end
  end
end
