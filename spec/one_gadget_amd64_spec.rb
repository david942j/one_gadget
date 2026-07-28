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
        .to eq [0x461fb, 0x46421, 0x46428, 0x4647c, 0xc1ba3, 0xc1bf2, 0xc1ca7, 0xe4968, 0xe5765, 0xe5771,
                0xe654d, 0xe6552, 0xe6557, 0xe6670, 0xe6677, 0xe6685, 0xe668a, 0xe668f, 0xe6697, 0xe669e, 0xe66bd]
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
      expect(OneGadget.gadgets(file: path, force_file: true)).to eq [0x3f3aa, 0xb8a38, 0xd67e5]
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
        .to eq [0x4f322, 0xe569f, 0xe5858, 0xe585f, 0xe5863, 0x10a38c]
      expect(one_gadget(path)).to eq OneGadget.gadgets(file: path)
    end

    it 'libc-2.31' do
      path = data_path('libc-2.31-9fdb74e7b217d06c93172a8243f8547f947ee6d1.so')
      expect(OneGadget.gadgets(file: path, force_file: true,
                               level: 1)).to eq [0x51df8, 0x51e2b, 0x51e32, 0x51e39, 0x51e40, 0x51e45, 0x51e55, 0x51e5a,
                                                 0x51e5d, 0x51e62, 0x84165, 0x8416c, 0x84173, 0x84176, 0x8417b, 0x84180,
                                                 0x8418c, 0x84192, 0x84199, 0x841a0, 0xe3b2e, 0xe3b31, 0xe3b34, 0xe3d23,
                                                 0xe3d26, 0xe3d88, 0xe3d92, 0xe3d99, 0xe3da0, 0xe3dd7, 0xe3de1, 0xe3de5,
                                                 0xe3ded, 0x1075e7, 0x1075f1, 0x107cea]
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

    it 'libc-2.43' do
      path = data_path('libc-2.43-94d508beb08edbbbafc159774d75250bb285cb44.so')
      expect(OneGadget.gadgets(file: path, force_file: true,
                               level: 1)).to eq [0x547fe, 0x54803, 0x8233c, 0x82343, 0x82348, 0x8234f, 0x82356, 0x82369,
                                                 0x8236d, 0x82372, 0x82384, 0xe1067, 0xe106b, 0xe106f, 0xfe6e9, 0xfe7ca,
                                                 0xfe7d2, 0xfe7d7, 0xfe7df, 0xfe7e6]
      expect(OneGadget.gadgets(file: path)).to eq [0xe1067, 0xe106b, 0xe106f]
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
