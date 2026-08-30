# frozen_string_literal: true

require 'tmpdir'

require 'elftools'

require 'one_gadget/one_gadget'

describe OneGadget::Fetchers::DynamicSymbols do
  # An embedded libc commonly ships with its section headers removed -- OpenWrt
  # does it to musl to save flash. Nothing is missing from such a file, but the
  # usual route to its code and symbols is, so the same libc is stripped here and
  # required to report the same gadgets.
  def without_sections(path, target)
    File.open(path) do |fd|
      elf = ELFTools::ELFFile.new(fd)
      elf.header.e_shoff = 0
      elf.header.e_shnum = 0
      elf.header.e_shstrndx = 0
      elf.save(target)
    end
  end

  it 'reports what the same libc reports with its sections intact' do
    skip_unless_objdump
    path = data_path('libc-2.31-9fdb74e7b217d06c93172a8243f8547f947ee6d1.so')
    Dir.mktmpdir do |dir|
      stripped = File.join(dir, 'stripped.so')
      without_sections(path, stripped)
      # the state the file is in: objdump disassembles sections, and there are none
      expect(`objdump -d #{stripped}`).not_to include('call')
      (0..2).each do |level|
        expect(OneGadget.gadgets(file: stripped, force_file: true, level:))
          .to eq OneGadget.gadgets(file: path, force_file: true, level:)
      end
    end
  end
end
