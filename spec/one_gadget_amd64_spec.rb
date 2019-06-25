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
        .to eq [0x46428, 0x4647c, 0xc1ba3, 0xc1bf2, 0xe4968, 0xe5765, 0xe5771, 0xe66bd]
    end

    it 'libc-2.24' do
      path = data_path('libc-2.24-8cba3297f538691eb1875be62986993c004f3f4d.so')
      expect(OneGadget.gadgets(file: path, force_file: true)).to eq [0x3f356, 0x3f3aa, 0xd67e5]
      expect(one_gadget(path)).to eq OneGadget.gadgets(file: path)
    end

    it 'libc-2.26' do
      path = data_path('libc-2.26-ddcc13122ddbfe5e5ef77d4ebe66d124ae5762c2.so')
      expect(OneGadget.gadgets(file: path, force_file: true)).to eq [0x47c46, 0x47c9a, 0xfccde, 0xfdb8e]
      expect(one_gadget(path)).to eq OneGadget.gadgets(file: path)
    end

    it 'libc-2.27' do
      path = data_path('libc-2.27-b417c0ba7cc5cf06d1d1bed6652cedb9253c60d0.so')
      expect(OneGadget.gadgets(file: path, force_file: true)).to eq [0x4f2c5, 0x4f322, 0x10a38c]
      expect(one_gadget(path)).to eq OneGadget.gadgets(file: path)
    end

    it 'not ELF' do
      expect { hook_logger { OneGadget.gadgets(file: __FILE__) } }.to output(<<-EOS).to_stdout
[OneGadget] ArgumentError: Not an ELF file, expected glibc as input
      EOS
    end

    it 'not glibc' do
      expect { hook_logger { OneGadget.gadgets(file: '/bin/ls') } }.to output(<<-EOS).to_stdout
[OneGadget] ArgumentError: File "/bin/ls" doesn't contain string "/bin/sh", not glibc?
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
