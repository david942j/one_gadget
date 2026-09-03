# frozen_string_literal: true

require 'one_gadget/one_gadget'

describe 'one_gadget_mips' do
  describe 'from file' do
    before(:each) do
      skip_unless_objdump
    end

    # OpenWrt's musl, which is what a real router runs. Both byte orders are in
    # wide use on this architecture -- ath79 is big-endian, ramips little -- so
    # both are read here.
    it 'musl 1.2.4, big-endian' do
      path = data_path('mips-musl-1.2.4.so')
      expect(OneGadget.gadgets(file: path, force_file: true)).to eq [0x56fd4, 0x77b44, 0x77b48]
      expect(OneGadget.gadgets(file: path, force_file: true, level: 1)).to eq [0x56fd4, 0x77b44, 0x77b48]
    end

    it 'musl 1.2.4, little-endian' do
      path = data_path('mipsel-musl-1.2.4.so')
      expect(OneGadget.gadgets(file: path, force_file: true)).to eq [0x56f98, 0x77b00, 0x77b04]
      expect(OneGadget.gadgets(file: path, force_file: true, level: 1)).to eq [0x56f98, 0x77b00, 0x77b04]
    end

    it 'libc-2.36' do
      path = data_path('mipsel-libc-2.36.so')
      expect(OneGadget.gadgets(file: path, force_file: true)).to eq [0x4b42c, 0x4b440]
      expect(OneGadget.gadgets(file: path, force_file: true, level: 1))
        .to eq [0x4b3d8, 0x4b424, 0x4b42c, 0x4b440, 0x722d0, 0x722d8, 0x187aa8, 0x187aac]
    end

    # Everything this arch reaches goes through the GOT base register, including
    # the "/bin/sh" it passes: the table holds the address and the instruction
    # after the load applies the offset within it. So the caller has to have set
    # that register, exactly as i386 must set its own.
    it 'requires the GOT base register the whole architecture reads through' do
      gadget = OneGadget.gadgets(file: data_path('mipsel-libc-2.36.so'), force_file: true, details: true, level: 1)
                        .find { |g| g.offset == 0x4b440 }
      expect(gadget.effect).to eq 'posix_spawn(a0, "/bin/sh", a2, a3, v1, environ)'
      expect(gadget.constraints).to include 'gp is the GOT address of libc'
    end

    # Resolving the GOT slot means the environment arrives as one dereference of
    # the variable rather than two of the slot naming it, so it is recognised by
    # which variable it is -- otherwise the gadget would carry a constraint asking
    # the caller to arrange what is already environ.
    it 'names the environment it passes' do
      gadget = OneGadget.gadgets(file: data_path('mips-musl-1.2.4.so'), force_file: true, details: true, level: 1)
                        .find { |g| g.offset == 0x77b44 }
      expect(gadget.effect).to end_with 'environ)'
      expect(gadget.constraints.join).not_to include 'valid envp'
    end

    # o32 has the *caller* restore the GOT base after every call, because the
    # callee establishes its own. A window that runs past a call therefore reads
    # the table through the slot it restored from, and every call it makes after
    # that point was named on the assumption that this is the GOT -- so the slot
    # is stated as a precondition rather than left unsaid. Verified: without it
    # these gadgets segfault at the first load through the restored register.
    it 'states the slot it restores the GOT base from' do
      gadget = OneGadget.gadgets(file: data_path('mipsel-libc-2.36.so'), force_file: true, details: true, level: 1)
                        .find { |g| g.offset == 0x4b3d8 }
      expect(gadget.constraints).to include 'gp is the GOT address of libc'
      expect(gadget.constraints).to include '[sp+0x18] is the GOT address of libc'
    end

    it 'reports the same gadgets for a libc with no section headers' do
      expect_same_gadgets_when_stripped('mipsel-libc-2.36.so')
    end
  end
end
