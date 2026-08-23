# frozen_string_literal: true

require 'one_gadget'
require 'one_gadget/error'

describe 'one_gadget_amd64' do
  describe 'from file' do
    before(:each) do
      skip_unless_objdump
    end

    it 'libc-2.19' do
      path = data_path('libc-2.19-cf699a15caae64f50311fc4655b86dc39a479789.so')
      expect(OneGadget.gadgets(file: path, force_file: true, level: 1))
        .to eq [0x46421, 0x46428, 0x4647c,
                0xc18c8, 0xc18cd, 0xc18d1, 0xc18d8, 0xc1b3d, 0xc1ba3, 0xc1bf2, 0xc1ca7,
                0xe4968, 0xe5765,
                0xe6527, 0xe652e, 0xe6532, 0xe653e, 0xe6543, 0xe654a,
                0xe654d, 0xe6552, 0xe6557, 0xe669e, 0xe66bd, 0xe66c9]
    end

    # 0xc1ca7 builds argv in place at rax (mov [rsi],rax with rsi==rax), so rax
    # must be writable; that makes the separate `rax != 0x0` branch redundant.
    it 'libc-2.19 requires the in-place argv buffer (rax) be writable' do
      path = data_path('libc-2.19-cf699a15caae64f50311fc4655b86dc39a479789.so')
      gadget = OneGadget.gadgets(file: path, force_file: true, level: 1, details: true)
                        .find { |g| g.offset == 0xc1ca7 }
      expect(gadget.constraints).to include('writable: rax')
      expect(gadget.constraints).not_to include('rax != 0x0')
    end

    # 0xc18c8's argv pointer renders as "(rsp+0xf & 0xfffffffffffffff0)". While the
    # fetcher round-tripped that pointer through its own rendering, reading it back
    # raised -- three tokens where a base+offset has two -- and the candidate was
    # discarded as "not a gadget". Passing the value instead of its text keeps it.
    it 'keeps a gadget whose argv pointer renders as an operation' do
      path = data_path('libc-2.19-cf699a15caae64f50311fc4655b86dc39a479789.so')
      gadget = OneGadget.gadgets(file: path, force_file: true, level: 1, details: true)
                        .find { |g| g.offset == 0xc18c8 }
      expect(gadget.constraints).to include('writable: (rsp+0xf & 0xfffffffffffffff0)')
    end

    # Both of these build argv in place through a pointer no register names --
    # 0xc18cd rounds one down (`and rsi, ~0xf`), 0xc1b3d loads one from the frame
    # -- and then write [ptr] = "sh", [ptr+8] = r15. Tracking those writes is what
    # replaces the opaque "[ptr] == NULL" disjunct, which the gadget's own store
    # to argv[0] can never leave true, with the r15 requirement that really is
    # the caller's to meet.
    it 'names the argv a gadget builds through a pointer no register names' do
      path = data_path('libc-2.19-cf699a15caae64f50311fc4655b86dc39a479789.so')
      by_offset = OneGadget.gadgets(file: path, force_file: true, level: 1, details: true)
                           .to_h { |g| [g.offset, g] }
      expect(by_offset[0xc18cd].constraints).to include(
        'r15 == NULL || {"sh", r15, [(rsi & 0xfffffffffffffff0)+0x10], ' \
        '[(rsi & 0xfffffffffffffff0)+0x18], ...} is a valid argv'
      )
      expect(by_offset[0xc1b3d].constraints).to include(
        'r15 == NULL || {"sh", r15, [[rbp-0x48]+0x10], [[rbp-0x48]+0x18], ...} is a valid argv'
      )
    end

    # Regression: a candidate that ran past its terminal execve into the stack-guard
    # epilogue used to yield spurious gadgets whose fs:/[rax-8] constraints crashed
    # score computation at the default level. Halting at the terminal call drops them.
    it 'libc-2.23 (level 0 does not crash on stale-state gadgets)' do
      path = data_path('libc-2.23-60131540dadc6796cab33388349e6e4e68692053.so')
      expect(OneGadget.gadgets(file: path, force_file: true)).to eq [0x4526a, 0xef6c4, 0xf0567]
    end

    it 'libc-2.24' do
      path = data_path('libc-2.24-8cba3297f538691eb1875be62986993c004f3f4d.so')
      expect(OneGadget.gadgets(file: path, force_file: true)).to eq [0x3f356, 0x3f3aa, 0xb8a6c, 0xd67e5]
      expect(one_gadget(path)).to eq OneGadget.gadgets(file: path)
    end

    it 'libc-2.26' do
      path = data_path('libc-2.26-ddcc13122ddbfe5e5ef77d4ebe66d124ae5762c2.so')
      expect(OneGadget.gadgets(file: path, force_file: true)).to eq [0x47c9a, 0xfccde, 0xfdb8e]
      expect(one_gadget(path)).to eq OneGadget.gadgets(file: path)
    end

    it 'libc-2.27' do
      path = data_path('libc-2.27-b417c0ba7cc5cf06d1d1bed6652cedb9253c60d0.so')
      expect(OneGadget.gadgets(file: path, force_file: true))
        .to eq [0x4f322, 0xe56d8, 0xe5863, 0x10a38c]
      expect(one_gadget(path)).to eq OneGadget.gadgets(file: path)
    end

    it 'libc-2.31' do
      path = data_path('libc-2.31-9fdb74e7b217d06c93172a8243f8547f947ee6d1.so')
      expect(OneGadget.gadgets(file: path, force_file: true,
                               level: 1)).to eq [0x51df8, 0x51e2b, 0x51e32, 0x51e39, 0x51e40, 0x51e45, 0x51e55, 0x51e5a,
                                                 0x84165, 0x8416c, 0x84173, 0x84176, 0x8417b, 0x84180, 0x8418c,
                                                 0x84192, 0x84199, 0x841a0, 0xe3b31, 0xe3b34, 0xe3c20, 0xe3d26,
                                                 0xe3d88, 0xe3d90, 0xe3d92, 0xe3d99, 0xe3da0, 0xe3dd7, 0xe3de1,
                                                 0x1075e7, 0x1075f1, 0x107cea]
      expect(OneGadget.gadgets(file: path)).to eq [0xe3b2e, 0xe3b31, 0xe3b34]
    end

    # rip-relative libc globals are concretized to $base+<off>, so the do_system
    # "-c" separator resolves to its string content (like aarch64/arm).
    it 'libc-2.31 resolves the do_system "-c" argv operand' do
      path = data_path('libc-2.31-9fdb74e7b217d06c93172a8243f8547f947ee6d1.so')
      gadget = OneGadget.gadgets(file: path, force_file: true, level: 1, details: true)
                        .find { |g| g.offset == 0x51df8 }
      expect(gadget.constraints).to include('{"sh", "-c", rbx, NULL} is a valid argv')
    end

    # 0x51df8 enters before the posix_spawnattr_setsigmask/setsigdefault calls,
    # which copy *from* their second argument unconditionally, so r12/r13 must be
    # readable pointers (poisoning them faults the parent before execve).
    it 'libc-2.31 requires the setsigmask/setsigdefault pointers be readable' do
      path = data_path('libc-2.31-9fdb74e7b217d06c93172a8243f8547f947ee6d1.so')
      gadget = OneGadget.gadgets(file: path, force_file: true, level: 1, details: true)
                        .find { |g| g.offset == 0x51df8 }
      expect(gadget.constraints).to include('readable: r12', 'readable: r13')
    end

    it 'libc-2.43' do
      path = data_path('libc-2.43-90ebd03ae9d9f42b23b4eb82fdf70352cf744198.so')
      expect(OneGadget.gadgets(file: path, force_file: true,
                               level: 1)).to eq [0x5c20e, 0x5c213, 0x5c227, 0xf8640, 0xf87a3, 0x11d6c5, 0x11d7aa,
                                                 0x11d7b2, 0x11d7b7, 0x11d7bf, 0x11d7c9]
      expect(OneGadget.gadgets(file: path)).to eq [0xf87a3, 0x11d6c5, 0x11d7aa, 0x11d7b2, 0x11d7b7]
    end

    # Level 2 keeps every distinct gadget, restoring ones level 1 trims as
    # duplicate or harder-to-reach, while still omitting ones dropped as invalid.
    it 'libc-2.19 level 2 restores trimmed gadgets but not invalid ones' do
      path = data_path('libc-2.19-cf699a15caae64f50311fc4655b86dc39a479789.so')
      l1 = OneGadget.gadgets(file: path, force_file: true, level: 1)
      l2 = OneGadget.gadgets(file: path, force_file: true, level: 2)
      expect(l2.size).to be > l1.size
      expect(l1).not_to include(0x461fb) # dominated by 0x46421 -> trimmed at level 1
      expect(l2).to include(0x461fb)     # ... but kept at level 2
      expect(l2).not_to include(0xe6670) # a "-nc" noexec argv: invalid, never emitted
    end

    # One entry point can be reached under several branch-dependent constraint
    # sets; level 2 keeps each in detail but lists the offset once.
    it 'libc-2.31 level 2 dedupes offsets yet keeps per-branch variants in detail' do
      path = data_path('libc-2.31-9fdb74e7b217d06c93172a8243f8547f947ee6d1.so')
      offsets = OneGadget.gadgets(file: path, force_file: true, level: 2)
      details = OneGadget.gadgets(file: path, force_file: true, level: 2, details: true)
      expect(offsets).to eq(offsets.uniq)
      expect(details.size).to be > offsets.size
    end

    it 'not ELF' do
      expect { hook_logger { OneGadget.gadgets(file: __FILE__) } }.to output(<<-EOS).to_stdout
[OneGadget] ArgumentError: Not an ELF file, expected glibc as input
      EOS
    end

    it 'not glibc' do
      realpath = data_path('not_libc.elf')
      expect { hook_logger { OneGadget.gadgets(file: realpath) } }.to output(<<-EOS).to_stdout
[OneGadget] ArgumentError: File "#{realpath}" doesn't contain string "/bin/sh", not glibc?
      EOS
    end
  end

  describe 'from build id' do
    before(:all) do
      @build_id = '60131540dadc6796cab33388349e6e4e68692053'
    end

    it 'normal' do
      # only check not empty because the gadgets might add frequently.
      expect(OneGadget.gadgets(build_id: @build_id)).not_to be_empty
    end

    it 'alias' do
      expect(one_gadget(@build_id)).to eq OneGadget.gadgets(build_id: @build_id)
    end

    it 'invalid' do
      expect { hook_logger { OneGadget.gadgets(build_id: '^_^') } }.to output(<<-EOS).to_stdout
[OneGadget] ArgumentError: invalid BuildID format: "^_^"
      EOS
    end

    it 'fetch from remote' do
      entry = OneGadget::Gadget::ClassMethods::BUILDS.delete(@build_id)
      # silence the logger
      allow(OneGadget::Logger).to receive(:ask_update)
      expect(OneGadget.gadgets(build_id: @build_id)).not_to be_empty
      OneGadget::Gadget::ClassMethods::BUILDS[@build_id] = entry unless entry.nil?
    end

    it 'not found' do
      expect { hook_logger { OneGadget.gadgets(build_id: @build_id.reverse) } }.to output(<<-EOS).to_stdout
[OneGadget] Cannot find BuildID [35029686e4e6e94388333bac6976cdad04513106]
      EOS
      expect(OneGadget::Gadget.builds(@build_id.reverse)).to be_nil
    end
  end
end
