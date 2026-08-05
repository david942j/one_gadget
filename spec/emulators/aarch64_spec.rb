# frozen_string_literal: true

require 'one_gadget/emulators/aarch64'
require 'one_gadget/error'

describe OneGadget::Emulators::AArch64 do
  before(:each) do
    @processor = described_class.new
  end

  describe 'conditional branches' do
    # Emit the branch decision by feeding cmp, the branch, then a follow-up line
    # whose address decides taken (== target) vs not-taken (!= target).
    def branch_constraint(compare, branch, target, follow_addr)
      @processor.process("1000: #{compare}") if compare
      @processor.process("1004: #{branch} #{format('%x', target)} <x>")
      @processor.process("#{format('%x', follow_addr)}: nop")
      @processor.constraints
    end

    it 'renders cmp + b.ne / b.eq' do
      expect(branch_constraint('cmp x2, #1', 'b.ne', 0x2000, 0x1008)).to eq ['x2 == 0x1'] # not taken
      @processor = described_class.new
      expect(branch_constraint('cmp x2, #1', 'b.ne', 0x2000, 0x2000)).to eq ['x2 != 0x1'] # taken
      @processor = described_class.new
      expect(branch_constraint('cmp x0, x1', 'b.eq', 0x2000, 0x2000)).to eq ['x0 == x1'] # taken
    end

    it 'falls back for an unparseable compare operand' do
      expect(@processor.send(:operand_str, 'somelabel')).to eq 'somelabel'
    end

    it 'renders signed and unsigned comparisons' do
      expect(branch_constraint('cmp x0, #0x400', 'b.cs', 0x2000, 0x2000)).to eq ['(u64)x0 >= 0x400'] # taken
      @processor = described_class.new
      expect(branch_constraint('cmp x0, #0x400', 'b.lt', 0x2000, 0x1008)).to eq ['(s64)x0 >= 0x400'] # not taken
    end

    it 'rejects a path whose branches cannot all hold' do
      # Two branches on one compare, taken then not taken: the same test cannot
      # give both answers, so the path can never execute.
      expect(branch_constraint('cmp x2, #1', 'b.ne', 0x2000, 0x2000)).to eq ['x2 != 0x1']
      @processor.process('2000: b.ne 3000 <x>')
      expect(@processor.process('2004: nop')).to be false
    end

    it 'renders cmn as a bound, folding a shifted immediate' do
      # glibc's "the syscall didn't return -errno" check. An unsigned condition
      # after cmn reads the carry, so it bounds x0 rather than forcing x0+0x1000
      # to be zero -- x0 == 0 satisfies it. Same form amd64 emits for this check.
      expect(branch_constraint('cmn x0, #0x1, lsl #12', 'b.hi', 0x2000, 0x1008))
        .to eq ['(u64)x0 <= 0xfffffffffffff000'] # not taken
      @processor = described_class.new
      expect(branch_constraint('cmn x0, #0x1, lsl #12', 'b.hi', 0x2000, 0x2000))
        .to eq ['(u64)x0 > 0xfffffffffffff000'] # taken
      # An equality condition does read the sum, so it keeps the additive form.
      @processor = described_class.new
      expect(branch_constraint('cmn x0, #0x1', 'b.eq', 0x2000, 0x2000)).to eq ['(x0 + 0x1) == 0x0']
    end

    it 'aborts on a compare modifier it cannot model' do
      # Silently dropping the modifier would understate the constraint.
      expect(@processor.process('1000: cmn x0, x1, lsl x2')).to be false
    end

    it 'renders cbz / cbnz' do
      expect(branch_constraint(nil, 'cbz x0,', 0x2000, 0x1008)).to eq ['x0 != 0x0'] # not taken
      @processor = described_class.new
      expect(branch_constraint(nil, 'cbnz x1,', 0x2000, 0x2000)).to eq ['x1 != 0x0'] # taken
    end

    it 'renders tbz / tbnz bit tests' do
      expect(branch_constraint(nil, 'tbz w3, #4,', 0x2000, 0x2000)).to eq ['(w3 & 0x10) == 0x0'] # taken
      @processor = described_class.new
      expect(branch_constraint(nil, 'tbnz w3, #0,', 0x2000, 0x1008)).to eq ['(w3 & 0x1) == 0x0'] # not taken
    end

    it 'aborts a cmp-based branch with no preceding compare' do
      expect(@processor.process('1004: b.ne 2000 <x>')).to be false
    end

    it 'uses eq/ne but rejects magnitude conditions after tst' do
      # tst x0,x0 sets ZF = (x0 == 0); b.eq taken means x0 == 0.
      expect(branch_constraint('tst x0, x0', 'b.eq', 0x2000, 0x2000)).to eq ['x0 == 0x0'] # taken
      # tst with distinct operands is a real bitmask test.
      @processor = described_class.new
      expect(branch_constraint('tst x0, x1', 'b.ne', 0x2000, 0x2000)).to eq ['(x0 & x1) != 0x0'] # taken
      @processor = described_class.new
      expect(@processor.process('1000: tst x0, x0')).to be true
      expect(@processor.process('1004: b.lt 2000 <x>')).to be false # magnitude after tst: unsound
    end
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

    it 'constrains posix_spawn setup-call pointers (source readable, attr writable)' do
      # setsigmask copies *arg1 into the attr: arg1 (x1) readable, attr (x0) written.
      @processor.process('0: mov x1, x22')
      @processor.process('4: bl e16e0 <posix_spawnattr_setsigmask@@GLIBC_2.17>')
      expect(@processor.constraints).to include('readable: x22', 'writable: x0')

      # a pure sp-relative attr is writable for free, so it needs no constraint.
      other = described_class.new
      other.process('0: add x0, sp, #0x218')
      other.process('4: bl e1560 <posix_spawnattr_init@@GLIBC_2.17>')
      expect(other.constraints).not_to include(a_string_matching(/writable: sp/))
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
      expect(@processor.sp_based_stack[16].to_s).to eq 'x2'
      expect(@processor.sp_based_stack[24].to_s).to eq 'x3'

      # equivalent to 'push x1; push x0'
      @processor.process('stp x0, x1, [sp, #-16]!')
      expect(@processor.registers['sp'].to_s).to eq 'sp-0x10'
      expect(@processor.sp_based_stack[-8].to_s).to eq 'x1'
      expect(@processor.sp_based_stack[-16].to_s).to eq 'x0'
    end

    it 'str' do
      # post-index mode
      @processor.process('mov x1, sp')
      @processor.process('str x0, [x1], #-8')
      expect(@processor.registers['sp'].to_s).to eq 'sp'
      expect(@processor.registers['x1'].to_s).to eq 'sp-0x8'
      expect(@processor.sp_based_stack[0].to_s).to eq 'x0'

      @processor.process('str xzr, [sp, #200]')
      expect(@processor.sp_based_stack[200]).to be_zero

      @processor.process('str x2, [sp, #0x100]!')
      expect(@processor.sp_based_stack[0x100].to_s).to eq 'x2'
      expect(@processor.registers['sp'].to_s).to eq 'sp+0x100'

      @processor.process('str x3, [x4]')
      expect(@processor.constraints).to eq ['writable: x4']
    end
  end
end
