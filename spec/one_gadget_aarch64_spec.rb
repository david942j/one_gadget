# frozen_string_literal: true

require 'one_gadget/one_gadget'

describe 'one_gadget_aarch64' do
  describe 'from file' do
    before(:each) do
      skip_unless_objdump
    end

    it 'libc-2.23' do
      path = data_path('aarch64-libc-2.23.so')
      expect(OneGadget.gadgets(file: path, force_file: true, level: 1))
        .to eq [0x3d6c4, 0x3d6cc, 0x3d6d0, 0x3d6d4, 0x3d6dc, 0x3d718, 0x60c1c, 0x60c20]
    end

    it 'libc-2.24' do
      path = data_path('aarch64-libc-2.24.so')
      expect(OneGadget.gadgets(file: path, force_file: true)).to eq [0x3c92c, 0x3c934, 0x3c970]
    end

    it 'libc-2.27' do
      path = data_path('aarch64-libc-2.27.so')
      expect(OneGadget.gadgets(file: path,
                               force_file: true)).to eq [0x3f160, 0x3f168, 0x3f16c,
                                                         0x3f184, 0x3f1a8, 0x63e90]
    end

    # glibc 2.43 no longer exposes a straight-line execve("/bin/sh") gadget; the
    # only one-gadgets come from do_system's posix_spawn call.
    it 'libc-2.43' do
      path = data_path('aarch64-libc-2.43.so')
      expect(OneGadget.gadgets(file: path, force_file: true))
        .to eq [0x4bc00, 0x4bc04, 0x4bc08, 0x4bc0c, 0x4bc10, 0x4bc14, 0x4bc18, 0x4bc1c]
    end

    it 'resolves posix_spawn (do_system) gadgets' do
      path = data_path('aarch64-libc-2.43.so')
      gadgets = OneGadget.gadgets(file: path, force_file: true, details: true)
      expect(gadgets.map(&:effect).uniq)
        .to eq ['posix_spawn(sp+0xc, "/bin/sh", 0, sp+0x218, sp+0x50, environ)']
    end
  end

  it 'objdump not installed' do
    allow(OneGadget::Helper).to receive(:objdump_arch).and_return(nil)
    path = data_path('aarch64-libc-2.27.so')
    expect { hook_logger { OneGadget.gadgets(file: path, force_file: true) } }.to output(<<-EOS).to_stdout
[OneGadget] UnsupportedArchitectureError: Objdump that supports architecture "aarch64" is not found!
            Please install the package 'binutils-multiarch' and try one_gadget again!

            For Ubuntu users:
              $ [sudo] apt install binutils-multiarch
    EOS
  end
end
