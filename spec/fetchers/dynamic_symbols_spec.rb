# frozen_string_literal: true

require 'elftools'

require 'one_gadget/fetchers/amd64'

describe OneGadget::Fetchers::DynamicSymbols do
  let(:path) { data_path('libc-2.31-9fdb74e7b217d06c93172a8243f8547f947ee6d1.so') }
  let(:fetcher) { OneGadget::Fetchers::Amd64.new(path) }

  def with_elf
    File.open(path) { |fd| yield ELFTools::ELFFile.new(fd) }
  end

  describe '#sectionless_terminal_addresses' do
    # The dynamic segment is the route left when the section headers are gone, so
    # what it reports has to be what the sections would have.
    it 'finds through the dynamic segment what the symbol table names' do
      with_elf do |elf|
        expect(fetcher.send(:sectionless_terminal_addresses, elf))
          .to eq fetcher.send(:terminal_symbol_addresses, elf)
      end
    end
  end

  describe '#symbol_count' do
    # Every symbol has to be reachable through DT_HASH, so its chain is as long as
    # the table. A file carrying only the GNU hash says it another way, and the two
    # have to agree.
    it 'counts by where the string table starts when there is no DT_HASH' do
      gnu_only = OneGadget::Fetchers::Amd64.new(path)
      allow(gnu_only).to receive(:dynamic_tag).and_wrap_original do |original, dyn, type|
        type == :hash ? nil : original.call(dyn, type)
      end
      with_elf do |elf|
        expect(gnu_only.send(:dynamic_symbols, elf)).to eq fetcher.send(:dynamic_symbols, elf)
      end
    end
  end

  describe '#file_offset' do
    it 'is nil for an address no segment covers' do
      with_elf { |elf| expect(fetcher.send(:file_offset, elf, 0xdeadbeef000)).to be_nil }
    end
  end

  # What keeps the rest of the engine unaware that anything is unusual: it
  # recognises a terminal call, and reads a branch target, from this text.
  describe '#symbolize' do
    it 'names the target a raw disassembly left as a bare address' do
      expect(fetcher.send(:symbolize, 'e6570: call   0x94180', { 0x94180 => 'execve' }))
        .to eq 'e6570: call   94180 <execve>'
    end

    it 'leaves the address unnamed when no symbol is there' do
      expect(fetcher.send(:symbolize, 'e6570: call   0x94180', {})).to eq 'e6570: call   94180'
    end

    it 'leaves a line carrying no target alone' do
      expect(fetcher.send(:symbolize, 'e6570: nop', {})).to eq 'e6570: nop'
    end
  end
end
