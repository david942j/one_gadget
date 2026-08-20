# frozen_string_literal: true

require 'one_gadget/one_gadget'

describe 'one_gadget_arm' do
  describe 'from file' do
    before(:each) do
      skip_unless_objdump
    end

    it 'libc-2.23' do
      path = data_path('arm-libc-2.23.so')
      expect(OneGadget.gadgets(file: path, force_file: true)).to eq [0x2c5f4, 0x2c626, 0x84dc4]
    end

    it 'libc-2.27' do
      path = data_path('arm-libc-2.27.so')
      expect(OneGadget.gadgets(file: path, force_file: true)).to eq [0x2d39c, 0x73f7a, 0x73f96]
    end

    it 'libc-2.39' do
      path = data_path('arm-libc-2.39.so')
      expect(OneGadget.gadgets(file: path, force_file: true)).to eq [0x38f6c, 0x88a48, 0x9ef1a]
    end

    it 'libc-2.43' do
      path = data_path('libc-2.43-8c7af7f227b3871d6afba752cbb617f317023de5.so')
      expect(OneGadget.gadgets(file: path, force_file: true, level: 1))
        .to eq [0x3afdc, 0x3afde, 0x3affc, 0x3b000, 0x3b002, 0x3b004, 0x543d2, 0x543d4, 0x543d8, 0x8d94a,
                0xa42c8, 0xa4334, 0xa4338]
      expect(OneGadget.gadgets(file: path, force_file: true)).to eq [0x3b004, 0x8d94a, 0xa4338]
    end

    it 'constrains the GOT base register on arm-libc-2.43 environ gadgets' do
      path = data_path('libc-2.43-8c7af7f227b3871d6afba752cbb617f317023de5.so')
      # Level 2 keeps every gadget, so this stays about the constraint rather than
      # about which sibling currently out-ranks which.
      by_offset = OneGadget.gadgets(file: path, force_file: true, details: true, level: 2)
                           .to_h { |g| [g.offset, g] }
      # Two environ gadgets whose GOT base lives in different registers.
      expect(by_offset[0x3afdc].constraints).to include('r6 is the GOT address of libc')
      expect(by_offset[0x543d2].constraints).to include('r7 is the GOT address of libc')
    end

    it 'resolves a gadget guarded by a conditional branch' do
      path = data_path('arm-libc-2.27.so')
      gadget = OneGadget.gadgets(file: path, force_file: true, level: 1, details: true)
                        .find { |g| g.offset == 0x73f2c }
      expect(gadget.effect).to eq 'execve("/bin/sh", sp-0x10, r2)'
      expect(gadget.constraints).to include('[r1] == 0x0')
    end

    it 'constrains a GOT base register even when its load is for something other than environ' do
      path = data_path('arm-libc-2.27.so')
      gadget = OneGadget.gadgets(file: path, force_file: true, level: 1, details: true)
                        .find { |g| g.offset == 0x73f2c }
      # 0x73f2c reads a libc global (the stack-protector guard) via r3 as the GOT
      # base, not environ -- the constraint must still surface: a wrong r3 faults
      # on that load regardless of what it was for.
      expect(gadget.constraints).to include('r3 is the GOT address of libc')
    end

    # 0x73f2a's window OPENS with the `add r3, pc` that builds that base, so
    # replaying the prologue setup would apply it twice: r3 would end up holding
    # the GOT plus another whole load base, while the constraint went on naming
    # the register's entry value. Nothing is seeded, and the load states what it
    # actually needs. The offset also pins the pc bias -- Thumb reads pc as the
    # instruction address + 4, and 0x73f2a + 4 is 0x73f2e.
    it 'does not claim the GOT base for a window that establishes it itself' do
      path = data_path('arm-libc-2.27.so')
      gadget = OneGadget.gadgets(file: path, force_file: true, level: 1, details: true)
                        .find { |g| g.offset == 0x73f2a }
      expect(gadget.constraints).not_to include('r3 is the GOT address of libc')
      expect(gadget.constraints).to include('readable: [(r3 + $base+0x73f2e)+0x148]')
    end

    it 'resolves environ through the GOT base register and constrains it' do
      path = data_path('arm-libc-2.23.so')
      gadgets = OneGadget.gadgets(file: path, force_file: true, details: true)
      gadget = gadgets.find { |g| g.effect == 'execve("/bin/sh", r4, environ)' }
      expect(gadget).not_to be_nil
      # Reaching environ needs the GOT base in a register (loaded in the prologue,
      # outside the window); it must be pinned, like i386's GOT-base constraint.
      expect(gadget.constraints).to include('r8 is the GOT address of libc')
    end

    it 'resolves argv through a register written via str, not just sp/bp' do
      path = data_path('arm-libc-2.27.so')
      # Level 2 keeps every gadget, so this stays about the constraint rather than
      # about which sibling currently out-ranks which.
      gadgets = OneGadget.gadgets(file: path, force_file: true, level: 2, details: true)
      # 0x73f96 builds argv on the stack via `str reg, [r7, #imm]`; the array's
      # first element (r7's own target) must be tracked so r0 -- an untracked
      # entry the code writes into the array too -- surfaces as a real
      # precondition, not an opaque "r7 is a valid argv".
      gadget = gadgets.find { |g| g.offset == 0x73f96 }
      expect(gadget.constraints).to include('r0 == NULL || {"/bin/sh", r0, NULL} is a valid argv')
    end

    it 'finds posix_spawn (do_system) gadgets with stack-passed argv/envp' do
      path = data_path('arm-libc-2.39.so')
      gadgets = OneGadget.gadgets(file: path, force_file: true, details: true)
      effects = gadgets.map(&:effect)
      expect(effects).to include('posix_spawn(r0, "/bin/sh", r2, r8, [sp], r3)')
      expect(effects).to include('posix_spawn([sp+0x34], "/bin/sh", [sp+0x2c], 0, [sp+0x3c], r3)')
    end
  end

  it 'objdump not installed' do
    allow(OneGadget::Helper).to receive(:objdump_arch).and_return(nil)
    path = data_path('arm-libc-2.27.so')
    expect { hook_logger { OneGadget.gadgets(file: path, force_file: true) } }.to output(<<-EOS).to_stdout
[OneGadget] UnsupportedArchitectureError: Objdump that supports architecture "arm" is not found!
            Please install the package 'binutils-multiarch' and try one_gadget again!

            For Ubuntu users:
              $ [sudo] apt install binutils-multiarch
    EOS
  end
end
