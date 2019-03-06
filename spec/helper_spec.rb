require 'one_gadget/helper'

describe OneGadget::Helper do
  before(:all) do
    @libcpath = data_path('libc-2.23-60131540dadc6796cab33388349e6e4e68692053.so')
  end

  it 'abspath' do
    expect(described_class.abspath('./spec/data/libc-2.23-60131540dadc6796cab33388349e6e4e68692053.so'))
      .to eq @libcpath
  end

  it 'valid_elf_file?' do
    expect(described_class.valid_elf_file?(__FILE__)).to be false
    expect(described_class.valid_elf_file?(@libcpath)).to be true
  end

  it 'build_id_of' do
    expect(described_class.build_id_of(@libcpath)).to eq '60131540dadc6796cab33388349e6e4e68692053'
  end

  it 'colorize' do
    allow(described_class).to receive(:color_enabled?).and_return(true)
    expect(described_class.colorize('123', sev: :integer)).to eq "\e[38;5;189m123\e[0m"
  end

  it 'url_request' do
    val = :val
    expect { hook_logger { val = described_class.url_request('oao') } }.to output(<<-EOS.strip).to_stdout
[OneGadget] undefined method `request_uri' for #<URI::Generic oao>
    EOS
    expect(val).to be_nil
  end

  it 'architecture' do
    expect(described_class.architecture(@libcpath)).to be :amd64
    expect(described_class.architecture(__FILE__)).to be :invalid
    expect(described_class.architecture(data_path('aarch64-libc-2.24.so'))).to be :aarch64
    # for testing 'unknown'
    Tempfile.create(['tmp', '.elf']) do |f|
      f.write("\x7fELF\x02\x01\x01" + "\x00" * 9 + "\x01" * 48)
      f.close
      expect(described_class.architecture(f.path)).to be :unknown
    end
  end
end
