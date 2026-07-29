# frozen_string_literal: true

require 'one_gadget/one_gadget'

describe 'one_gadget_arm' do
  describe 'from file' do
    before(:each) do
      skip_unless_objdump
    end

    it 'libc-2.23' do
      path = data_path('arm-libc-2.23.so')
      expect(OneGadget.gadgets(file: path, force_file: true)).to eq [0x2c626, 0x84dc4]
    end

    it 'libc-2.27' do
      path = data_path('arm-libc-2.27.so')
      expect(OneGadget.gadgets(file: path, force_file: true)).to eq [0x2d39c, 0x73f7a, 0x73f96]
    end

    it 'libc-2.39' do
      path = data_path('arm-libc-2.39.so')
      expect(OneGadget.gadgets(file: path, force_file: true)).to eq [0x38f6c, 0x88a48, 0x9ef1a, 0x9f2bc]
    end

    it 'resolves a gadget guarded by a conditional branch' do
      path = data_path('arm-libc-2.27.so')
      gadget = OneGadget.gadgets(file: path, force_file: true, level: 1, details: true)
                        .find { |g| g.offset == 0x73f2c }
      expect(gadget.effect).to eq 'execve("/bin/sh", sp-0x10, r2)'
      expect(gadget.constraints).to include('[r1] == 0')
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
