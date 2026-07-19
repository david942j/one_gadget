# frozen_string_literal: true

require 'one_gadget/emulators/arm'
require 'one_gadget/error'

describe OneGadget::Emulators::Arm do
  before(:each) do
    @processor = described_class.new
  end

  describe 'process' do
    it 'libc-2.23 gadget (Thumb PIC /bin/sh idiom)' do
      # ldr rX, [pc, #imm] loads a literal-pool word; add rX, pc turns it into a
      # $base-relative address. The literal words are read from the real libc.
      processor = described_class.new(data_path('arm-libc-2.23.so'))
      gadget = <<-EOS
        2c5ec:	ldr.w	lr, [pc, #180]	@ 2c6a4 <x>
        2c626:	ldr	r2, [pc, #128]	@ (2c6a8 <x>)
        2c628:	mov	r1, r4
        2c62a:	ldr	r0, [pc, #128]	@ (2c6ac <x>)
        2c630:	add	r0, pc
        2c636:	ldr	r2, [r3, #0]
        2c638:	bl	70160 <execve@@GLIBC_2.4>
      EOS
      gadget.each_line { |s| processor.process(s) }
      expect(processor.registers['r0'].to_s).to eq '$base+0xca57c'
      expect(processor.registers['r1'].to_s).to eq 'r4'
      expect(processor.registers['pc'].to_s).to eq '70160 <execve@@GLIBC_2.4>'
    end

    it 'detects Thumb vs A32 from stride/suffix for the pc bias' do
      # A32: no Thumb evidence, pc reads as instruction + 8.
      @processor.process('1000: mov r0, #0')
      @processor.process('1004: add r0, pc')
      expect(@processor.registers['r0'].to_s).to eq '$base+0x100c'

      # Thumb: a 2-byte stride proves Thumb, pc reads as instruction + 4.
      thumb = described_class.new
      thumb.process('2000: movs r0, #0')
      thumb.process('2002: add r0, pc')
      expect(thumb.registers['r0'].to_s).to eq '$base+0x2006'
    end

    it 'mov' do
      @processor.process('0: mov r1, r4')
      expect(@processor.registers['r1'].to_s).to eq 'r4'
      # immediates are kept as integers (rendered in decimal).
      @processor.process('4: mov.w r2, #0x10')
      expect(@processor.registers['r2']).to eq 16
    end

    it 'add / sub' do
      @processor.process('0: add r4, sp, #36')
      expect(@processor.registers['r4'].to_s).to eq 'sp+0x24'
      @processor.process('4: sub.w r4, r4, #4')
      expect(@processor.registers['r4'].to_s).to eq 'sp+0x20'
      # 2-operand form: sub sp, #16 == sub sp, sp, #16
      @processor.process('8: sub sp, #16')
      expect(@processor.registers['sp'].to_s).to eq 'sp-0x10'
    end

    it 'ldr (reg offset, pre-index, post-index)' do
      @processor.process('0: ldr r0, [r1, #8]!')
      expect(@processor.registers['r0'].to_s).to eq '[r1+0x8]'
      expect(@processor.registers['r1'].to_s).to eq 'r1+0x8'

      @processor.process('4: ldr r2, [r3], #8')
      expect(@processor.registers['r2'].to_s).to eq '[r3]'
      expect(@processor.registers['r3'].to_s).to eq 'r3+0x8'

      # register offset is resolved when it currently holds an integer.
      @processor.process('8: mov r5, #0xd8')
      @processor.process('c: ldr.w r6, [r7, r5]')
      expect(@processor.registers['r6'].to_s).to eq '[r7+0xd8]'
    end

    it 'str (stack, writable, $base is skipped)' do
      @processor.process('0: mov r1, sp')
      @processor.process('4: str r0, [r1], #-8')
      expect(@processor.registers['r1'].to_s).to eq 'sp-0x8'
      expect(@processor.sp_based_stack[0].to_s).to eq 'r0'

      @processor.process('8: str r2, [sp, #0x100]!')
      expect(@processor.sp_based_stack[0x100].to_s).to eq 'r2'
      expect(@processor.registers['sp'].to_s).to eq 'sp+0x100'

      @processor.process('c: str r3, [r4]')
      expect(@processor.constraints).to eq ['writable: r4']

      # A store through a $base-relative pointer adds no writable constraint.
      clean = described_class.new
      clean.process('1000: mov r0, #0')
      clean.process('1004: add r0, pc')
      clean.process('1008: str r1, [r0]')
      expect(clean.constraints).to eq []
    end

    it 'push / pop' do
      @processor.process('0: push {r4, r5, lr}')
      expect(@processor.registers['sp'].to_s).to eq 'sp-0xc'
      # lowest-numbered register lands at the (decremented) sp.
      expect(@processor.sp_based_stack[-12].to_s).to eq 'r4'
      expect(@processor.sp_based_stack[-8].to_s).to eq 'r5'

      @processor.process('4: pop {r4, r5, pc}')
      expect(@processor.registers['r4'].to_s).to eq 'r4'
      expect(@processor.registers['sp'].to_s).to eq 'sp'
    end

    it 'bl / blx to terminal and pass-through calls' do
      expect(@processor.process('0: bl 70160 <execl@@GLIBC_2.4>')).to be true
      expect(@processor.registers['pc'].to_s).to include 'execl'

      other = described_class.new
      expect(other.process('0: blx 88990 <execve@@GLIBC_2.4>')).to be true
      expect(other.registers['pc'].to_s).to include 'execve'

      # sigprocmask is always safe; __sigaction needs arg2 (r2) == 0.
      expect(@processor.process('4: bl 24778 <sigprocmask@@GLIBC_2.4>')).to be true
      @processor.process('8: mov r2, #0')
      expect(@processor.process('c: bl 24754 <__sigaction@@GLIBC_2.4>')).to be true
      @processor.process('10: mov r2, r0')
      expect(@processor.process('14: bl 24754 <__sigaction@@GLIBC_2.4>')).to be false
      # an unhandled call aborts the candidate.
      expect(@processor.process('18: bl 12345 <free@@GLIBC_2.4>')).to be false
    end

    it 'flag-only instructions have no effect' do
      expect(@processor.process('0: cmp r0, r1')).to be true
      expect(@processor.process('4: cmn.w r0, #4096')).to be true
      expect(@processor.process('8: tst r0, r1')).to be true
      expect(@processor.process('c: svc 0')).to be true
      expect(@processor.registers['r0'].to_s).to eq 'r0'
    end
  end

  describe 'error handling' do
    it 'rejects an unsupported instruction' do
      expect(@processor.process('0: mul r0, r1, r2')).to be false
    end

    it 'rejects writing to an invalid register' do
      expect(@processor.process('0: mov r99, r0')).to be false
    end

    it 'rejects a non-integer index' do
      expect(@processor.process('0: ldr r0, [r1], r2')).to be false
      expect(@processor.process('4: sub r0, r1, r2')).to be false
    end

    it 'rejects a PC-relative load without file data' do
      # no @data (file-less) => cannot read the literal pool.
      expect(@processor.process('2c62a: ldr r0, [pc, #128]')).to be false
    end

    it 'tolerates a line without an address' do
      expect(@processor.process('mov r0, r1')).to be true
    end
  end

  describe 'helpers' do
    it 'argument maps to r0-r3' do
      @processor.process('0: mov r2, #0x30')
      expect(@processor.argument(2)).to eq 0x30
    end

    it 'get_corresponding_stack' do
      expect(@processor.get_corresponding_stack('sp+0x10')).to be(@processor.sp_based_stack)
      expect(@processor.get_corresponding_stack('r4')).to be_nil
    end

    it 'is 32-bit' do
      expect(described_class.bits).to be 32
    end
  end
end
