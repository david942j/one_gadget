# frozen_string_literal: true

require 'one_gadget/one_gadget'

describe 'one_gadget_riscv64' do
  describe 'from file' do
    before(:each) do
      skip_unless_objdump
    end

    it 'libc-2.39' do
      path = data_path('riscv64-libc-2.39.so')
      expect(OneGadget.gadgets(file: path, force_file: true)).to eq [0x9f738, 0x9f73a, 0x9f73c]
      expect(OneGadget.gadgets(file: path, force_file: true, level: 2))
        .to eq [0x9f738, 0x9f73a, 0x9f73c, 0xb5762, 0xb5764, 0xb5766]
    end

    it 'resolves the auipc/addi pair that names "/bin/sh"' do
      path = data_path('riscv64-libc-2.39.so')
      gadget = OneGadget.gadgets(file: path, force_file: true, details: true)
                        .find { |g| g.offset == 0x9f73c }
      # 9f73c: auipc a0,0x86   -> $base+0x12573c
      # 9f740: addi  a0,a0,556 -> $base+0x125968, where "/bin/sh" lives in this build
      expect(gadget.effect).to eq 'execve("/bin/sh", a1, a2)'
      expect(gadget.constraints).to include('[a1] == NULL || a1 == NULL || a1 is a valid argv')
    end
  end
end
