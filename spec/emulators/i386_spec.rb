# frozen_string_literal: true

require 'one_gadget/emulators/i386'

describe OneGadget::Emulators::I386 do
  before(:each) do
    @processor = described_class.new
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
      gadget.each_line { |s| @processor.process(s) }
      expect(@processor.registers['esp'].to_s).to eq 'esp'
      expect(@processor.stack[0].to_s).to eq 'esi-0x55f61'
      expect(@processor.stack[4].to_s).to eq 'esp+0x34'
      expect(@processor.stack[8].to_s).to eq '[[esi-0xb8]]'
      # The default value of stack is a lambda
      expect(@processor.stack[3].to_s).to eq '[esp+0x3]'
    end

    it 'libc-2.23-execl' do
      gadget = <<-EOS
   5ef3e:       50                      push   eax
   5ef3f:       8d 86 a4 a0 fa ff       lea    eax,[esi-0x55f5c]
   5ef45:       50                      push   eax
   5ef46:       8d 86 9f a0 fa ff       lea    eax,[esi-0x55f61]
   5ef4c:       50                      push   eax
   5ef4d:       e8 be 07 05 00          call   af710 <execl@@GLIBC_2.0>
      EOS
      gadget.each_line { |s| @processor.process(s) }
      expect(@processor.registers['esp'].to_s).to eq 'esp-0xc'
      expect(@processor.stack[-0xc].to_s).to eq 'esi-0x55f61'
      expect(@processor.stack[-0x8].to_s).to eq 'esi-0x55f5c'
      expect(@processor.stack[-0x4].to_s).to eq 'eax'
    end

    it 'add sub push' do
      @processor.process('push 1')
      expect(@processor.registers['esp'].to_s).to eq 'esp-0x4'
      @processor.process('push 2')
      expect(@processor.registers['esp'].to_s).to eq 'esp-0x8'
      @processor.process('sub esp, 0x30')
      expect(@processor.registers['esp'].to_s).to eq 'esp-0x38'
      @processor.process('push 1337')
      expect(@processor.registers['esp'].to_s).to eq 'esp-0x3c'
      @processor.process('add esp, 0x3c')
      expect(@processor.registers['esp'].to_s).to eq 'esp'
      expect(@processor.stack[-0x3c].to_s).to eq '1337'
      expect(@processor.stack[-0x4].to_s).to eq '1'
    end

    it 'libc-2.19' do
      gadget = <<-'EOS'
  64c60: mov DWORD PTR [esp+0x8],eax
  64c64: lea eax,[ebx-0x4956f]
  64c6a: mov DWORD PTR [esp+0x4],eax
  64c6e: lea eax,[ebx-0x49574]
  64c74: mov DWORD PTR [esp],eax
  64c77: call b5170 <execl@@GLIBC_2.0>
      EOS
      gadget.each_line { |s| @processor.process(s) }
      expect(@processor.registers['esp'].to_s).to eq 'esp'
      expect(@processor.stack[0].to_s).to eq 'ebx-0x49574'
      expect(@processor.stack[4].to_s).to eq 'ebx-0x4956f'
      expect(@processor.stack[8].to_s).to eq 'eax'
    end
  end
end
