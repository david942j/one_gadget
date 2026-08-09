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
      # test eax,eax sets ZF = (eax == 0); je taken means eax == 0.
      expect(branch_constraint('test eax,eax', 'je', 0x2000, 0x2000)).to eq ['eax == 0x0']
      @processor = described_class.new
      expect(branch_constraint(nil, 'jrcxz', 0x2000, 0x1008)).to eq ['rcx != 0x0'] # not taken
    end

    it 'aborts a magnitude branch after test' do
      @processor.process('1000: test eax,eax')
      expect(@processor.process('1004: jg 2000 <x>')).to be false
    end

    it 'concretizes a rip-relative compare operand and drops the objdump comment' do
      # cmp [rip+x],0 ; jle taken -> (s64)[$base+<file off>] <= 0, the offset taken
      # from objdump's resolution comment (which must not leak into the constraint).
      cons = branch_constraint('cmp DWORD PTR [rip+0x2dd750],0x0        # 3c3e88 <sym>',
                               'jle', 0x2000, 0x2000)
      expect(cons).to eq ['(s64)[$base+0x3c3e88] <= 0x0']
    end
  end

  describe 'implied constraints' do
    # posix_spawnattr_setsigmask copies *rsi unconditionally, so its pointer must
    # be readable ("readable: r12"); the following test/jne (taken) also yields
    # "r12 != 0x0", which the readable constraint makes redundant.
    it 'drops "reg != 0" a readable-pointer constraint already implies' do
      @processor.process('1000: mov rsi,r12')
      @processor.process('1004: call 10d0b0 <posix_spawnattr_setsigmask@@GLIBC_2.2.5>')
      @processor.process('1009: test r12,r12')
      @processor.process('100b: jne 2000 <x>')
      @processor.process('2000: nop') # branch taken -> r12 != 0
      cons = @processor.constraints
      expect(cons).to include('readable: r12')
      expect(cons).not_to include('r12 != 0x0')
    end

    # __sigaction writes the old action through oldact (arg 2) unless it is NULL,
    # so the gadget is usable exactly when the caller can make that argument NULL.
    it 'asks for NULL where the caller can supply it, and refuses where nobody can' do
      @processor.process('1000: mov rdx,r12')
      expect(@processor.process('1004: call 3f110 <__sigaction@@GLIBC_2.2.5>')).to be true
      expect(@processor.constraints).to include('r12 == NULL')

      # a libc global and a stack slot both name memory that exists when the
      # gadget runs, so neither can be the NULL the callee has to be given.
      ['lea rdx,[rip+0x2dd750]        # 3c3e88 <sym>', 'lea rdx,[rsp+0x10]'].each do |setup|
        other = described_class.new
        other.process("1000: #{setup}")
        expect(other.process('1004: call 3f110 <__sigaction@@GLIBC_2.2.5>')).to be false
      end
    end

    # A branch that already tested the pointer for zero asks for the same zero the
    # NULL requirement does, so the pair collapses to the one that says what for.
    it 'states once a zero that both a branch and a NULL requirement ask for' do
      @processor.process('1000: test rdx,rdx')
      @processor.process('1004: je 2000 <x>')
      @processor.process('2000: nop') # taken -> rdx == 0
      @processor.process('2004: call 3f110 <__sigaction@@GLIBC_2.2.5>')
      cons = @processor.constraints
      expect(cons).to include('rdx == NULL')
      expect(cons).not_to include('rdx == 0x0')
    end

    # The stack is always writable, so a pure stack-pointer store needs no
    # "writable" constraint; a store through any other register still does.
    it 'omits "writable" for a stack-pointer store but keeps it otherwise' do
      @processor.process('1000: mov QWORD PTR [rsp+0x30],rax')
      @processor.process('1004: mov QWORD PTR [rbx+0x8],rax')
      cons = @processor.constraints
      expect(cons).not_to include('writable: rsp+0x30')
      expect(cons).to include('writable: rbx+0x8')
    end
  end

  describe 'and' do
    it 'names a mask it cannot fold, and folds one it can' do
      @processor.process('1000: and rax,0xf')
      expect(@processor.registers['rax'].to_s).to eq '(rax & 0xf)'

      other = described_class.new
      other.process('1000: mov eax,0x30')
      other.process('1004: and eax,0xf')
      expect(other.registers['eax']).to eq 0
    end

    it 'sets the flags a following branch reads, as well as writing the register' do
      @processor.process('1000: and rax,0xf')
      @processor.process('1004: jne 2000 <x>')
      @processor.process('2000: nop') # taken
      expect(@processor.constraints).to eq ['(rax & 0xf) != 0x0']
    end
  end

  describe 'descriptors a gadget closes' do
    it 'records where a closed descriptor is read from' do
      @processor.process('1000: mov edi,DWORD PTR [rsp+0x44]')
      @processor.process('1004: call ebe00 <__close@@GLIBC_2.2.5>')
      expect(@processor.closed_fds).to eq ['[rsp+0x44]']
    end

    it 'says nothing about a descriptor fixed in the code' do
      # nobody can change it, and no path reaching a terminal call closes one.
      @processor.process('1000: mov edi,0x2')
      @processor.process('1004: call ebe00 <__close@@GLIBC_2.2.5>')
      expect(@processor.closed_fds).to be_empty
    end
  end

  describe 'reading back a slot the gadget wrote' do
    it 'yields what was stored there, not the value the slot held on entry' do
      @processor.process('1000: mov QWORD PTR [rsp+0x8],rdx')
      @processor.process('1004: mov rax,QWORD PTR [rsp+0x8]')
      expect(@processor.registers['rax'].to_s).to eq 'rdx'

      # through a plain register too, not just the stack pointer
      @processor.process('1008: mov QWORD PTR [rbx+0x8],rsi')
      @processor.process('100c: mov rcx,QWORD PTR [rbx+0x8]')
      expect(@processor.registers['rcx'].to_s).to eq 'rsi'
    end

    it 'still reads a slot the gadget never wrote as a dereference' do
      @processor.process('1000: mov rax,QWORD PTR [rsp+0x8]')
      expect(@processor.registers['rax'].to_s).to eq '[rsp+0x8]'
      # a neighbouring slot is not the one that was written
      @processor.process('1004: mov QWORD PTR [rsp+0x10],rdx')
      @processor.process('1008: mov rcx,QWORD PTR [rsp+0x18]')
      expect(@processor.registers['rcx'].to_s).to eq '[rsp+0x18]'
    end
  end

  describe 'sub-register views' do
    it 'lets a 32-bit write through to the register it names part of' do
      @processor.process('1000: mov edi,0x1')
      # the call's first argument is that 1, not the value rdi was entered with.
      expect(@processor.argument(0)).to eq 1
      @processor.process('1004: mov eax,rsi')
      expect(@processor.registers['rax'].to_s).to eq 'rsi'
    end

    it 'accepts the d-name of an extended register as that register' do
      @processor.process('1000: mov r8d,0x1')
      # the call's fifth argument is that 1 -- an instruction naming r8d used to
      # be rejected outright, and r8d read as a symbol of its own.
      expect(@processor.argument(4)).to eq 1
      @processor.process('1004: lea r13d,[rdx+0x2]')
      expect(@processor.registers['r13'].to_s).to eq 'rdx+0x2'
    end

    it 'sign-extends a 32-bit value into the register movsxd widens it into' do
      @processor.process('1000: lea r13d,[rdx+0x2]')
      @processor.process('1004: movsxd r13,r13d')
      # nothing names half of a symbolic value, so it widens whole.
      expect(@processor.registers['r13'].to_s).to eq 'rdx+0x2'

      other = described_class.new
      other.process('1000: mov eax,0xffffffff')
      other.process('1004: movsxd rax,eax')
      expect(other.registers['rax']).to eq(-1)
      # a destination that isn't a register is a store this doesn't model.
      expect(other.process('1008: movsxd QWORD PTR [rsp],eax')).to be false
    end

    it 'names the low half of an untouched register by its own name' do
      # rax is untouched, so its low half is still what "eax" names -- a narrower
      # requirement than one naming the whole register.
      expect(@processor.registers['eax'].to_s).to eq 'eax'
      expect(@processor.registers['eax']).to be_equal(@processor.registers['eax'])
      @processor.process('1000: mov rax,0x1')
      # once the full register holds something, no expression names half of it.
      expect(@processor.registers['eax']).to eq 1
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
      # rip-relative operands are concretized to $base+<file offset> (from objdump's
      # resolution comment), so a libc global carries the $base marker.
      expect(@processor.registers['rdi'].to_s).to eq '$base+0x161359'
      expect(@processor.registers['rdx'].to_s).to eq '[[$base+0x397ea0]]'
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
