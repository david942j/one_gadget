# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))

require 'ostruct'
require 'aletheia/arch/aarch64'
require 'aletheia/satisfier'

# gdb-free unit tests for the constraint satisfier: they assert the plan it emits
# (register/memory assignments and chosen disjunction branch) for representative
# constraints of each category.
RSpec.describe Aletheia::Satisfier do
  subject(:satisfier) { described_class.new(Aletheia::Arch::AArch64) }

  def gadget(constraints, offset: 0x1000, effect: 'execve("/bin/sh", x0, environ)')
    OpenStruct.new(offset: offset, effect: effect, constraints: constraints)
  end

  it 'sets a bare register to zero for "reg == NULL"' do
    plan = satisfier.satisfy(gadget(['x1 == NULL']))
    expect(plan.status).to eq('ok')
    expect(plan.regs['x1']).to eq(0)
    expect(plan.branches['c0']).to eq('x1 == NULL')
  end

  it 'satisfies a stack-relative dereference-NULL for free (no register set)' do
    plan = satisfier.satisfy(gadget(['[sp+0x50] == NULL']))
    expect(plan.status).to eq('ok')
    expect(plan.regs).to be_empty
  end

  it 'rejects the unsatisfiable "sp+imm == NULL" branch and takes the deref branch' do
    plan = satisfier.satisfy(gadget(['sp+0x218 == NULL || (u16)[sp+0x218] == NULL']))
    expect(plan.status).to eq('ok')
    expect(plan.branches['c0']).to eq('(u16)[sp+0x218] == NULL')
  end

  it 'points a register into scratch to satisfy "writable: reg+imm"' do
    plan = satisfier.satisfy(gadget(['writable: x19+0x258']))
    expect(plan.status).to eq('ok')
    off = plan.regs['x19']['scratch_off']
    expect(off + 0x258).to eq(Aletheia::Satisfier::WRITABLE_BASE)
  end

  it 'gives distinct scratch write-areas to multiple writable constraints' do
    plan = satisfier.satisfy(gadget(['writable: x19+0x258', 'writable: x20+0x4']))
    a = plan.regs['x19']['scratch_off'] + 0x258
    b = plan.regs['x20']['scratch_off'] + 0x4
    expect(a).not_to eq(b)
  end

  it 'prefers the cheap NULL branch over building a valid argv' do
    plan = satisfier.satisfy(gadget(['x4 == NULL || {x4, x3, x23, NULL} is a valid argv']))
    expect(plan.regs['x4']).to eq(0)
    expect(plan.branches['c0']).to eq('x4 == NULL')
  end

  it 'sets a register to the immediate for a "reg == imm" branch condition' do
    plan = satisfier.satisfy(gadget(['x2 == 0x1']))
    expect(plan.status).to eq('ok')
    expect(plan.regs['x2']).to eq(1)
  end

  it 'normalises a 32-bit view (w21) to its 64-bit register' do
    plan = satisfier.satisfy(gadget(['w21 == 0x1']))
    expect(plan.regs['x21']).to eq(1)
  end

  it 'treats a scratch pointer as already satisfying "!= 0"' do
    plan = satisfier.satisfy(gadget(['writable: x0', 'x0 != 0']))
    expect(plan.status).to eq('ok')
    expect(plan.regs['x0']).to be_a(Hash) # points into scratch, hence nonzero
  end

  it 'builds a valid argv by pointing register elements at scratch, -c at the command pool' do
    plan = satisfier.satisfy(gadget(['{"sh", "-c", x23, NULL} is a valid argv']))
    expect(plan.status).to eq('ok')
    expect(plan.regs['x23']).to eq('scratch_off' => Aletheia::Satisfier::COMMAND_POOL)
  end

  it 'points the first register operand after -c at the command pool, past a "--" separator' do
    # `$base+0x100` here stands in for the libc "--" constant; the real command is
    # the next operand register (x21), which `sh -c -- <x21>` runs.
    plan = satisfier.satisfy(gadget(['{"sh", "-c", $base+0x100, x21, NULL} is a valid argv']))
    expect(plan.status).to eq('ok')
    expect(plan.regs['x21']).to eq('scratch_off' => Aletheia::Satisfier::COMMAND_POOL)
  end

  it 'zeroes memory for a single-deref "[reg] == NULL" by pointing the register at scratch' do
    plan = satisfier.satisfy(gadget(['[x0] == NULL']))
    expect(plan.status).to eq('ok')
    expect(plan.regs['x0']).to eq('scratch_off' => Aletheia::Satisfier::STRING_POOL)
  end

  it 'retries to a consistent branch when the cheapest one conflicts' do
    # writable: x0 pins x0 to scratch; the argv disjunction must then avoid the
    # x0 == NULL branch and accept "x0 is a valid argv" instead.
    plan = satisfier.satisfy(gadget(['writable: x0', '[x0] == NULL || x0 == NULL || x0 is a valid argv']))
    expect(plan.status).to eq('ok')
    expect(plan.branches['c1']).to eq('x0 is a valid argv')
  end

  it 'SKIPs (does not crash) on an unparseable operand' do
    plan = satisfier.satisfy(gadget(['(s32)[[sp+0x30]+0x4] <= 0']))
    expect(plan.status).to eq('skip')
  end

  it 'defaults to benign fill, and to poison fill in strict mode' do
    expect(satisfier.satisfy(gadget(['x1 == NULL'])).benign_default).to be(true)
    strict = described_class.new(Aletheia::Arch::AArch64, strict: true)
    plan = strict.satisfy(gadget(['x1 == NULL']))
    expect(plan.poison_default).to be(true)
    expect(plan.benign_default).to be(false)
  end

  context 'amd64 backend' do
    require 'aletheia/arch/amd64'
    subject(:satisfier) { described_class.new(Aletheia::Arch::Amd64) }

    def gadget(constraints, offset: 0x1000, effect: 'execve("/bin/sh", rsi, environ)')
      OpenStruct.new(offset: offset, effect: effect, constraints: constraints)
    end

    it 'satisfies a bare stack-alignment "rsp & 0xf == 0" by construction (no register set)' do
      plan = satisfier.satisfy(gadget(['rsp & 0xf == 0']))
      expect(plan.status).to eq('ok')
      expect(plan.regs).to be_empty
      expect(plan.branches['c0']).to eq('rsp & 0xf == 0')
    end

    it 'aligns a GPR by pointing it at an aligned scratch slot for "reg & 0xf == 0"' do
      plan = satisfier.satisfy(gadget(['rbx & 0xf == 0']))
      expect(plan.status).to eq('ok')
      expect(plan.regs['rbx']).to eq('scratch_off' => Aletheia::Satisfier::STRING_POOL)
    end

    it 'normalises a 32-bit view (eax) to its 64-bit register (rax)' do
      plan = satisfier.satisfy(gadget(['eax == 0']))
      expect(plan.regs['rax']).to eq(0)
    end
  end
end
