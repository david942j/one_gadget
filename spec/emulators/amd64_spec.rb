# frozen_string_literal: true

require 'one_gadget/emulators/amd64'

describe OneGadget::Emulators::Amd64 do
  before(:each) do
    @processor = described_class.new
  end

  describe 'process' do
    it 'libc-2.24 gadget' do
      gadget = <<-EOS
 d67e5:       48 8b 05 b4 16 2c 00    mov    rax,QWORD PTR [rip+0x2c16b4]        # 397ea0 <_DYNAMIC+0x340>
 d67ec:       48 8d 74 24 70          lea    rsi,[rsp+0x70]
 d67f1:       48 8d 3d 61 ab 08 00    lea    rdi,[rip+0x8ab61]        # 161359 <_nl_POSIX_name+0x154>
 d67f8:       48 8b 10                mov    rdx,QWORD PTR [rax]
 d67fb:       e8 70 1c fe ff          call   b8470 <execve>
      EOS
      gadget.each_line { |s| @processor.process(s) }
      expect(@processor.registers['rsi'].to_s).to eq 'rsp+0x70'
      expect(@processor.registers['rdx'].to_s).to eq '[[rip+0x2c16b4]]'
    end

    it 'mov' do
      gadget = <<-EOS
        mov rax, rdx
        mov rdx, [rax+0x10]
        mov rdi, [rdx]
        mov rdx, rax-0x30
      EOS
      gadget.each_line { |s| @processor.process(s) }
      expect(@processor.registers['rdi'].to_s).to eq '[[rdx+0x10]]'
      expect(@processor.registers['rdx'].to_s).to eq 'rdx-0x30'
      expect(@processor.registers['rax'].to_s).to eq 'rdx'
    end

    context 'xmm instruction' do
      it 'movq/movhps/movaps' do
        gadget = <<-EOS
        movq xmm0, [rsp+0x8]
        mov [rsp+0x8], rax
        movhps xmm0, [rsp+0x8]
        movaps [rsp+0x40], xmm0
        EOS
        gadget.each_line { |s| @processor.process(s) }
        expect(@processor.stack[0x40].to_s).to eq '[rsp+0x8]'
        expect(@processor.stack[0x48].to_s).to eq 'rax'
      end

      it 'unsupported form' do
        expect { @processor.process!('movaps xmm0, [rsp+0x40]') }
          .to raise_error(OneGadget::Error::UnsupportedInstructionArgumentError)
      end
    end

    it 'invalid instruction' do
      expect(@processor.process('oao')).to be false
      expect { @processor.process!('oao') }.to raise_error OneGadget::Error::UnsupportedInstructionError
    end
  end
end
