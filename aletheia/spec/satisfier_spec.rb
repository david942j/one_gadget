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

  it 'defaults to benign fill, and to poison fill in strict mode' do
    expect(satisfier.satisfy(gadget(['x1 == NULL'])).benign_default).to be(true)
    strict = described_class.new(Aletheia::Arch::AArch64, strict: true)
    plan = strict.satisfy(gadget(['x1 == NULL']))
    expect(plan.poison_default).to be(true)
    expect(plan.benign_default).to be(false)
  end
end
