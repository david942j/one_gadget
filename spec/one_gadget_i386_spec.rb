# frozen_string_literal: true

require 'one_gadget'

describe 'one_gadget_i386' do
  describe 'from file' do
    before(:each) do
      skip_unless_objdump
    end

    it 'libc-2.19' do
      path = data_path('libc-2.19-fd51b20e670e9a9f60dc3b06dc9761fb08c9358b.so')
      expect(OneGadget.gadgets(file: path,
                               force_file: true)).to eq [0x3fd27, 0x64c64, 0x64c6a, 0x64c6e]
    end

    it 'libc-2.23' do
      ans = [0x3ac69, 0x5fbc5, 0x5fbc6]
      path = data_path('libc-2.23-926eb99d49cab2e5622af38ab07395f5b32035e9.so')
      expect(OneGadget.gadgets(file: path, force_file: true)).to eq ans
    end

    it 'libc-2.26' do
      ans = [0x3cc3c, 0x66e7f, 0x66e80, 0x132fbe, 0x132fbf]
      path = data_path('libc-2.26-f65648a832414f2144ce795d75b6045a1ec2e252.so')
      expect(OneGadget.gadgets(file: path, force_file: true)).to eq ans
    end

    it 'libc-2.27' do
      ans = [0x3cbf7, 0x6729f, 0x672a0, 0x13573e, 0x13573f]
      path = data_path('libc-2.27-63b3d43ad45e1b0f601848c65b067f9e9b40528b.so')
      expect(OneGadget.gadgets(file: path, force_file: true)).to eq ans
    end

    it 'libc-2.43' do
      path = data_path('libc-2.43-7a08e84aa7f1e0bd80a7da6227c3a006c3ff327d.so')
      expect(OneGadget.gadgets(file: path, force_file: true, level: 1))
        .to eq [0xed234, 0xed300, 0x18a495, 0x18a496]
      expect(OneGadget.gadgets(file: path)).to eq [0xed300, 0x18a495, 0x18a496]
    end

    # 0xed234's own first instruction (mov [ebp-0x30], ecx) writes ecx into the
    # exact stack slot the envp check later requires to be NULL, so ecx itself is
    # the real precondition -- not the opaque "[[ebp-0x30]] == NULL" form its
    # sibling 0xed300 (whose window starts after that write) still gets.
    it 'resolves envp through a tracked stack slot to the register that fills it' do
      path = data_path('libc-2.43-7a08e84aa7f1e0bd80a7da6227c3a006c3ff327d.so')
      gadgets = OneGadget.gadgets(file: path, force_file: true, details: true, level: 1)
      by_offset = gadgets.to_h { |g| [g.offset, g] }
      expect(by_offset[0xed234].constraints)
        .to include('[ecx] == NULL || ecx == NULL || ecx is a valid envp')
      expect(by_offset[0xed300].constraints)
        .to include('[[ebp-0x30]] == NULL || [ebp-0x30] == NULL || [ebp-0x30] is a valid envp')
    end

    # 0xbda64's argv pointer is a `lea eax, [ebp-0x28]` alias: the array it builds
    # on the stack is {"/bin/sh", eax, NULL}, with eax an untracked incoming
    # register -- so the same resolve_stack_deref used for envp above applies to
    # argv too, surfacing `eax == NULL` instead of the opaque "[ebp-0x2c] is a
    # valid argv" form.
    it 'resolves argv through a lea-computed alias into the stack frame' do
      path = data_path('libc-2.26-f65648a832414f2144ce795d75b6045a1ec2e252.so')
      gadget = OneGadget.gadgets(file: path, force_file: true, details: true, level: 1)
                        .find { |g| g.offset == 0xbda64 }
      expect(gadget.constraints).to include('eax == NULL || {"/bin/sh", eax, NULL} is a valid argv')
    end

    it 'special filename' do
      expect(OneGadget.gadgets(file: data_path('filename$with+special&keys'))).not_to be_empty
    end
  end

  describe 'from build id' do
    before(:all) do
      @build_id = '926eb99d49cab2e5622af38ab07395f5b32035e9'
    end

    it 'normal' do
      # only check not empty because the gadgets might add frequently.
      expect(OneGadget.gadgets(build_id: @build_id)).not_to be_empty
    end
  end
end
