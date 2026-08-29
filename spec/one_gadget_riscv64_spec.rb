# frozen_string_literal: true

require 'one_gadget/one_gadget'

describe 'one_gadget_riscv64' do
  describe 'from file' do
    before(:each) do
      skip_unless_objdump
    end

    it 'libc-2.39' do
      path = data_path('riscv64-libc-2.39.so')
      expect(OneGadget.gadgets(file: path, force_file: true)).to eq [0x9f73a, 0x9f73c, 0x9f778, 0xb5adc]
      expect(OneGadget.gadgets(file: path, force_file: true, level: 1))
        .to eq [0x46df2, 0x46e12, 0x46e20, 0x46e24, 0x46e26, 0x46e2a, 0x46e2e, 0x46e30, 0x46e32,
                0x46e3c, 0x625dc, 0x625e8, 0x625ec, 0x625ee, 0x625f2, 0x625f6, 0x625fa, 0x625fe,
                0x6260a, 0x9f6d6, 0x9f6ec, 0x9f6f2, 0x9f6f8, 0x9f6fa, 0x9f720, 0x9f726, 0x9f72a,
                0x9f73a, 0x9f73c, 0x9f778, 0x9f78c, 0x9f790, 0x9f794, 0x9f798, 0x9f79c, 0xb5762,
                0xb5764, 0xb5adc]
    end

    it 'stages an argv on the stack and requires it writable' do
      path = data_path('riscv64-libc-2.39.so')
      gadget = OneGadget.gadgets(file: path, force_file: true, details: true, level: 1)
                        .find { |g| g.offset == 0x625e8 }
      # posix_spawn's file_actions/attr are staged through s0 and s1, neither of
      # which is invariantly writable the way sp is, so both stay preconditions.
      expect(gadget.constraints).to include('writable: s0-0xf0')
      expect(gadget.constraints).to include('s1+0xe0 == NULL || writable: s1+0xe0')
    end

    it 'states the branch a gadget is only reached through' do
      path = data_path('riscv64-libc-2.39.so')
      gadget = OneGadget.gadgets(file: path, force_file: true, details: true, level: 1)
                        .find { |g| g.offset == 0x9f720 }
      # execl's loop reaches this window only when the argument count it compares
      # against holds, and a2 is what the caller has to arrange for that.
      expect(gadget.constraints).to include('a2 == 0x1')
      expect(gadget.effect).to eq 'execve("/bin/sh", sp, s2)'
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
