# frozen_string_literal: true

require 'one_gadget/emulators/amd64'

describe OneGadget::Emulators::Amd64 do
  before(:each) do
    @processor = described_class.new
  end

  describe 'conditional branches' do
    def branch_constraint(compare, branch, target, follow_addr)
      @processor.process("1000: #{compare}") if compare
      @processor.process("1004: #{branch} #{format('%x', target)} <x>")
      @processor.process("#{format('%x', follow_addr)}: nop")
      @processor.constraints
    end

    it 'renders cmp + jcc (Intel mnemonics)' do
      expect(branch_constraint('cmp rax,0x1', 'jne', 0x2000, 0x1008)).to eq ['rax == 0x1'] # not taken
      @processor = described_class.new
      expect(branch_constraint('cmp rax,0x400', 'jb', 0x2000, 0x2000)).to eq ['(u64)rax < 0x400'] # taken
      @processor = described_class.new
      expect(branch_constraint('cmp rsi,rdi', 'jg', 0x2000, 0x2000)).to eq ['(s64)rsi > rdi'] # taken
    end

    it 'renders test (zero flag only) and jrcxz' do
      # a tautology is only dropped later, in the fetcher
      expect(branch_constraint('test eax,eax', 'je', 0x2000, 0x2000)).to eq ['eax == eax']
      @processor = described_class.new
      expect(branch_constraint(nil, 'jrcxz', 0x2000, 0x1008)).to eq ['rcx != 0'] # not taken
    end

    it 'aborts a magnitude branch after test' do
      @processor.process('1000: test eax,eax')
      expect(@processor.process('1004: jg 2000 <x>')).to be false
    end
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
        expect(@processor.sp_based_stack[0x40].to_s).to eq '[rsp+0x8]'
        expect(@processor.sp_based_stack[0x48].to_s).to eq 'rax'
      end

      it 'punpcklqdq' do
        gadget = <<-EOS
        movq   xmm1,rax
        movq   xmm0,rcx
        punpcklqdq xmm0,xmm1
        movaps XMMWORD PTR [rsp+0x50],xmm0
        EOS
        gadget.each_line { |s| @processor.process(s) }
        expect(@processor.sp_based_stack[0x50].to_s).to eq 'rcx'
        expect(@processor.sp_based_stack[0x58].to_s).to eq 'rax'
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
