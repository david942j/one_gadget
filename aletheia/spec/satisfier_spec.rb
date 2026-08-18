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

  it 'ends the array after argv[0], the shape a shell can be driven from' do
    # Giving x3 a string too would make the shell read it as a script name and
    # exit; {<str>, NULL} leaves it reading stdin. Verified against a real
    # /bin/sh -- see the shape table on #apply_argv_list.
    plan = satisfier.satisfy(gadget(['{x4, x3, x23, NULL} is a valid argv']))
    expect(plan.regs['x4']).to eq('scratch_off' => Aletheia::Satisfier::STRING_POOL)
    expect(plan.regs['x3']).to eq(0)
    expect(plan.regs).not_to have_key('x23')
  end

  it 'gives the command slot of a "-c" array the command, not a terminator' do
    plan = satisfier.satisfy(gadget(['{"sh", "-c", x23, NULL} is a valid argv']))
    expect(plan.regs['x23']).to eq('scratch_off' => Aletheia::Satisfier::COMMAND_POOL)
  end

  it 'terminates after a fixed argv[0] the gadget supplies' do
    plan = satisfier.satisfy(gadget(['{"/bin/sh", x0, NULL} is a valid argv']))
    expect(plan.regs['x0']).to eq(0)
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

  describe 'masks one_gadget could not fold' do
    it 'gives a register a value whose masked bits meet the target' do
      plan = satisfier.satisfy(gadget(['(x1 & 0xf000) == 0x2000']))
      expect(plan.status).to eq('ok')
      expect(plan.regs['x1']).to eq(0x2000)
    end

    it 'refuses a target the mask can never produce' do
      # 0x1 lies outside the mask, so no value of x1 makes the masked read 0x1.
      plan = satisfier.satisfy(gadget(['(x1 & 0xf000) == 0x1']))
      expect(plan.status).to eq('skip')
    end

    it 'flips the masked bits for an inequality' do
      plan = satisfier.satisfy(gadget(['(x2 & 0x10) != 0x0']))
      expect(plan.status).to eq('ok')
      expect(plan.regs['x2']).to eq(0x10)
    end

    it 'writes the value where the mask reads through a pointer' do
      plan = satisfier.satisfy(gadget(['([sp+0x40] & 0x10) != 0x0']))
      expect(plan.status).to eq('ok')
      expect(plan.mem[Aletheia::Satisfier::SP_OFFSET + 0x40]).to eq(0x10)
    end

    it 'points a register rounded down for alignment at a scratch slot' do
      # the gadget writes through (x3 & ~0xf); a scratch slot is 16-aligned, so
      # the rounding leaves it untouched and the slot is the address written.
      plan = satisfier.satisfy(gadget(['writable: (x3 & 0xfffffffffffffff0)']))
      expect(plan.status).to eq('ok')
      expect(plan.regs['x3']['scratch_off'] % 0x10).to eq(0)
    end

    it 'reads a 32-bit alignment mask as an alignment, not a field' do
      # i386 renders the same rounding as 0xfffffff0; complementing that over 64
      # bits would make it look like a field selector and skip the gadget.
      plan = satisfier.satisfy(gadget(['writable: (x3 & 0xfffffff0)']))
      expect(plan.status).to eq('ok')
      expect(plan.regs['x3']['scratch_off'] % 0x10).to eq(0)
    end

    it 'reads a rounded pointer inside a larger expression as that pointer' do
      # the whole disjunction is about the address x3 rounds to, so every mention
      # of it resolves to x3 -- and the scratch it is pointed at is zeroed, which
      # already satisfies the cheapest branch.
      plan = satisfier.satisfy(gadget(['writable: (x3 & 0xfffffffffffffff0)',
                                       '[(x3 & 0xfffffffffffffff0)] == NULL || ' \
                                       '(x3 & 0xfffffffffffffff0) is a valid argv']))
      expect(plan.status).to eq('ok')
      expect(plan.regs['x3']).to be_a(Hash)
    end

    it 'refuses an alignment coarser than a scratch slot guarantees' do
      # page alignment: WRITABLE_STRIDE is 0x800, so slots are not all 0x1000-aligned.
      plan = satisfier.satisfy(gadget(['writable: (x3 & 0xfffffffffffff000)']))
      expect(plan.status).to eq('skip')
    end
  end

  it 'lets a register another constraint pins to NULL terminate the argv' do
    # x3 is __sigaction's oldact -- it has to be NULL, and NULL is exactly what
    # ends an argv, so the array is `sh -c <x6>` rather than unsatisfiable.
    plan = satisfier.satisfy(gadget(['x3 == NULL', '{"sh", "-c", x6, x3, NULL} is a valid argv']))
    expect(plan.status).to eq('ok')
    expect(plan.regs['x3']).to eq(0)
    expect(plan.regs['x6']).to eq('scratch_off' => Aletheia::Satisfier::COMMAND_POOL)
  end

  it 'builds no element past the argv terminator' do
    plan = satisfier.satisfy(gadget(['{"sh", "-c", x6, NULL, x21} is a valid argv']))
    expect(plan.status).to eq('ok')
    expect(plan.regs['x6']).to eq('scratch_off' => Aletheia::Satisfier::COMMAND_POOL)
    expect(plan.regs).not_to have_key('x21')
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
    # Deeper than the one modelled level of nesting (see Operand#inner_imm).
    plan = satisfier.satisfy(gadget(['(s32)[[[sp+0x30]+0x4]+0x8] <= 0']))
    expect(plan.status).to eq('skip')
  end

  it 'points a pointer read from memory at scratch, for a field read off it' do
    plan = satisfier.satisfy(gadget(['(s32)[[sp+0x30]+0x4] <= 0']))
    expect(plan.status).to eq('ok')
    # [sp+0x30] holds a scratch pointer, so the field at +0x4 reads the zero fill.
    expect(plan.mem[Aletheia::Satisfier::SP_OFFSET + 0x30]).to have_key('scratch_off')
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

    # A branch condition on a libc global, e.g. libc-2.19 0xe654d's
    # `(s64)[$base+0x3c3e88] <= 0`: the driver writes 0 to base+off rather than the
    # satisfier pinning a register (a $base address isn't settable).
    it 'zeroes a libc global for "(s64)[$base+off] <= 0"' do
      plan = satisfier.satisfy(gadget(['(s64)[$base+0x3c3e88] <= 0x0']))
      expect(plan.status).to eq('ok')
      expect(plan.base_mem[0x3c3e88]).to eq(0)
      expect(plan.regs).to be_empty # $base is not pinned as a register
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

  # arm-2.27's 0x2d358 window runs `add r1, pc` and then stores through the sum,
  # so one_gadget names the store target `(r1 + $base+0x2d364)`: a fixed libc
  # address whose landing place only r1 decides. There is no pointer to hand out
  # -- r1 has to carry the literal that puts the sum in libc's own spare
  # writable data.
  context 'a store through a register added to a fixed libc address' do
    require 'aletheia/arch/arm'
    subject(:satisfier) { described_class.new(Aletheia::Arch::Arm, spare_writable: spare) }

    let(:spare) { 0xf7590...0xf8000 }

    def gadget(constraints, offset: 0x2d358, effect: 'execve("/bin/sh", sp+0x20, environ)')
      OpenStruct.new(offset: offset, effect: effect, constraints: constraints)
    end

    it 'pins the register so the sum lands in the spare writable data' do
      plan = satisfier.satisfy(gadget(['writable: (r1 + $base+0x2d364)']))
      expect(plan.status).to eq('ok')
      expect(spare).to cover(plan.regs['r1'] + 0x2d364)
    end

    # The register carries the whole displacement, so a trailing one only shifts
    # where inside its area the sum lands -- it stays in the spare region.
    it 'folds a trailing displacement into the literal' do
      plan = satisfier.satisfy(gadget(['writable: (r1 + $base+0x2d364)+0x8']))
      expect(spare).to cover(plan.regs['r1'] + 0x2d364 + 0x8)
    end

    it 'gives distinct areas to two such stores' do
      plan = satisfier.satisfy(gadget(['writable: (r1 + $base+0x100)', 'writable: (r2 + $base+0x200)']))
      expect(plan.status).to eq('ok')
      expect(plan.regs['r1'] + 0x100).not_to eq(plan.regs['r2'] + 0x200)
    end

    # Once the register is pinned the sum is a fixed libc address, so a read
    # through it is an ordinary libc-global read -- and lands on the zero fill.
    it 'reads zero through a dereference of the sum' do
      plan = satisfier.satisfy(gadget(['[(r1 + $base+0x50558)+0x8] == 0x0', 'writable: (r1 + $base+0x50558)']))
      expect(plan.status).to eq('ok')
      slot = plan.regs['r1'] + 0x50558
      expect(spare).to cover(slot)
      expect(plan.base_mem[slot + 0x8]).to eq(0) # written where the read lands
    end

    # A chained read needs a real pointer at the first level, which the driver
    # writes into the libc global the sum resolved to.
    it 'stages a pointer in libc for a chained dereference of the sum' do
      plan = satisfier.satisfy(gadget(['[[(r2 + $base+0x50492)+0xc]+0xa4] == 0x0',
                                       'r6 == [[(r2 + $base+0x50492)+0xc]+0x38]',
                                       'readable: (r2 + $base+0x50492)+0xc']))
      expect(plan.status).to eq('ok')
      slot = plan.regs['r2'] + 0x50492 + 0xc
      expect(plan.base_mem[slot]).to have_key('scratch_off')
      expect(plan.regs['r6']).to eq(0)
    end

    # Pinning a register a rejected branch asked for would hand a poisoned
    # register a valid value, so an address-shaped sum inside a disjunction is
    # refused rather than steered (see Satisfier#steer_base_sums).
    it 'refuses to steer a sum that only one branch of a disjunction needs' do
      plan = satisfier.satisfy(gadget(['r4 == NULL || writable: (r1 + $base+0x100)']))
      expect(plan.status).to eq('skip')
    end

    it 'SKIPs when the libc has no spare writable room to steer the store into' do
      plan = described_class.new(Aletheia::Arch::Arm).satisfy(gadget(['writable: (r1 + $base+0x2d364)']))
      expect(plan.status).to eq('skip')
    end

    it 'SKIPs when the register is not one the plan can set' do
      plan = satisfier.satisfy(gadget(['writable: (lr + $base+0x2c5ee)']))
      expect(plan.status).to eq('skip')
    end

    # Every other constraint form keeps refusing the shape rather than planning
    # it as if the fixed address weren't there (see Satisfier#safe_parse).
    it 'SKIPs a NULL requirement on such a sum' do
      plan = satisfier.satisfy(gadget(['(r2 + $base+0x47a68) == NULL']))
      expect(plan.status).to eq('skip')
    end

    # The same steering serves an argv element: the sum lands on the zero fill,
    # which reads as the valid empty string argv[0] only has to be. arm-2.27's
    # 0x2d35e shape, where the gadget supplies the "-c" and the command follows.
    it 'places an argv[0] built the same way, and still seeds the command' do
      plan = satisfier.satisfy(gadget(['{(ip + $base+0x2d36a), "-c", fp, r3, ...} is a valid argv']))
      expect(plan.status).to eq('ok')
      expect(spare).to cover(plan.regs['r12'] + 0x2d36a)
      expect(plan.regs['fp']).to eq('scratch_off' => Aletheia::Satisfier::COMMAND_POOL)
    end

    # A terminator has to be NULL, which asks the register to cancel the libc
    # address out -- no literal does that, and planning around it would leave the
    # element holding whatever the driver filled its register with.
    it 'refuses such an element where the array has to end' do
      plan = satisfier.satisfy(gadget(['{(ip + $base+0x100), (r7 + $base+0x200), fp, r3, ...} is a valid argv']))
      expect(plan.status).to eq('skip')
    end

    it 'refuses such an element on a register the plan cannot set' do
      plan = satisfier.satisfy(gadget(['{(lr + $base+0x2c5fe), "-c", r6, r3, ...} is a valid argv']))
      expect(plan.status).to eq('skip')
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
