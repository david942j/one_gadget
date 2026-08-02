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

  it 'restores and retries when the cheapest branch genuinely conflicts' do
    # writable: x0 pins x0 to a (nonzero) scratch address; "x0 == NULL" would need
    # x0 = 0 -- a conflict -- so the satisfier restores and takes "x0 is a valid argv".
    plan = satisfier.satisfy(gadget(['writable: x0', 'x0 == NULL || x0 is a valid argv']))
    expect(plan.status).to eq('ok')
    expect(plan.branches['c1']).to eq('x0 is a valid argv')
  end

  it 'lets a writable slot also satisfy a "[reg] == NULL" on that same slot' do
    # writable: x0 points x0 at zeroed scratch, so the deref [x0] already reads
    # NULL -- the cheapest argv branch holds without re-assigning (and conflicting on) x0.
    plan = satisfier.satisfy(gadget(['writable: x0', '[x0] == NULL || x0 == NULL || x0 is a valid argv']))
    expect(plan.status).to eq('ok')
    expect(plan.branches['c1']).to eq('[x0] == NULL')
    expect(plan.regs['x0']).to be_a(Hash) # still the single writable scratch pointer
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

    it 'points a register at zeroed scratch for a dereferenced "[reg] == 0"' do
      plan = satisfier.satisfy(gadget(['[rbx] == 0']))
      expect(plan.status).to eq('ok')
      expect(plan.regs['rbx']).to eq('scratch_off' => Aletheia::Satisfier::STRING_POOL)
    end

    # "readable: reg" (a libc call dereferences reg, e.g. libc-2.31 0x51df8's
    # posix_spawnattr_setsigmask/setsigdefault reading r12/r13): point the register
    # at readable scratch, like the bare-pointer argv/envp form.
    it 'points a register at readable scratch for "readable: reg"' do
      plan = satisfier.satisfy(gadget(['readable: r12']))
      expect(plan.status).to eq('ok')
      expect(plan.regs['r12']).to eq('scratch_off' => Aletheia::Satisfier::STRING_POOL)
    end

    # A "writable: reg" and a "reg != 0" on the SAME register must not conflict
    # (libc-2.19 0xc1ca7 builds argv in place at rax and also branches on rax != 0):
    # the writable pins rax to a scratch pointer, which -- applied first -- already
    # satisfies the != 0. Applying the relation first would pin rax to a bare 1 and
    # leave the writable unsatisfiable.
    it 'satisfies "writable: reg" and "reg != 0" together by pinning the pointer' do
      plan = satisfier.satisfy(gadget(['rax != 0x0', 'writable: rax+0x8']))
      expect(plan.status).to eq('ok')
      expect(plan.regs['rax']).to be_a(Hash) # a scratch pointer, not the literal 1
    end

    # libc-2.23's 0xcc610 reads a mode flag off the stack (`mov esi,[rbp-0x50]`,
    # never overwritten within the window) that a later branch requires to be
    # exactly 1 -- unlike a zero target, there's no pre-zeroed region to point
    # at, so this needs rbp pinned to a *fresh* scratch slot (rbp is otherwise
    # unconstrained by this gadget) with the literal actually written there.
    it 'pins an unconstrained register and writes a nonzero literal for "[reg+imm] == <imm>"' do
      plan = satisfier.satisfy(gadget(['[rbp-0x50] == 0x1']))
      expect(plan.status).to eq('ok')
      rbp_off = plan.regs['rbp']['scratch_off']
      expect(plan.mem[rbp_off - 0x50]).to eq(1)
    end

    # A "writable: [base]+imm" compound base (base is dereferenced, not a bare
    # register -- a store through a pointer read off the stack, e.g. libc-2.27's
    # 0xe5887) can't be resolved until `base`'s own argv/envp constraint has run,
    # and that constraint must not pick base == NULL: with base == NULL,
    # "[base]+imm" is a fixed low address (a real unmapped-page write), not
    # merely untracked. The deferred pass (order_compound_writable_last) plus the
    # NULL-branch block (@null_unsafe_bases) together force "[rbp-0x78] is a
    # valid argv" instead of the cheaper "[rbp-0x78] == NULL".
    it 'defers a compound "writable: [base]+imm" until base resolves to a real pointer' do
      plan = satisfier.satisfy(gadget([
                                        'writable: [rbp-0x78]+0x10',
                                        'writable: rbp-0x80',
                                        '[[rbp-0x78]] == NULL || [rbp-0x78] == NULL || [rbp-0x78] is a valid argv',
                                        '[[rbp-0x70]] == NULL || [rbp-0x70] == NULL || [rbp-0x70] is a valid envp'
                                      ], effect: 'execve("/bin/sh", [rbp-0x78], [rbp-0x70])'))
      expect(plan.status).to eq('ok')
      expect(plan.branches.values).to include('[rbp-0x78] is a valid argv')
      expect(plan.branches.values).not_to include('[rbp-0x78] == NULL')

      rbp_off = plan.regs['rbp']['scratch_off']
      expect(plan.mem[rbp_off - 0x78]).to eq('scratch_off' => Aletheia::Satisfier::STRING_POOL)
    end
  end

  context 'i386 backend' do
    require 'aletheia/arch/i386'
    subject(:satisfier) { described_class.new(Aletheia::Arch::I386, got_offset: 0x1d5000) }

    def gadget(constraints, offset: 0x1000, effect: 'execve("/bin/sh", esp+0x34, environ)')
      OpenStruct.new(offset: offset, effect: effect, constraints: constraints)
    end

    it 'sets the base register to the libc GOT (base + PLTGOT offset)' do
      plan = satisfier.satisfy(gadget(['esi is the GOT address of libc']))
      expect(plan.status).to eq('ok')
      expect(plan.regs['esi']).to eq('base_off' => 0x1d5000)
    end

    it 'SKIPs the GOT constraint when the PLTGOT offset is unknown' do
      plan = described_class.new(Aletheia::Arch::I386).satisfy(gadget(['esi is the GOT address of libc']))
      expect(plan.status).to eq('skip')
    end
  end
end
