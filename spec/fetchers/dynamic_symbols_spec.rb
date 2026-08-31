# frozen_string_literal: true

require 'elftools'

require 'one_gadget/fetchers/aarch64'
require 'one_gadget/fetchers/amd64'

describe OneGadget::Fetchers::DynamicSymbols do
  let(:path) { data_path('libc-2.31-9fdb74e7b217d06c93172a8243f8547f947ee6d1.so') }
  let(:fetcher) { OneGadget::Fetchers::Amd64.new(path) }

  def with_elf
    File.open(path) { |fd| yield ELFTools::ELFFile.new(fd) }
  end

  describe '#dynamic_symbols' do
    it 'names the functions at the addresses the tags record' do
      with_elf do |elf|
        symbols = fetcher.send(:dynamic_symbols, elf)
        execve = elf.section_by_name('.dynsym').symbol_by_name('execve')
        expect(symbols[execve.header.st_value.to_i]).to eq 'execve'
        expect(symbols.values).to include('posix_spawn')
      end
    end

    # glibc gives one address both +sigaction+ and +__sigaction+, and only the
    # second is a name anything downstream acts on.
    it 'keeps the name the engine reads when an address carries several' do
      versioned = data_path('aarch64-libc-2.27.so')
      File.open(versioned) do |fd|
        elf = ELFTools::ELFFile.new(fd)
        addr = elf.section_by_name('.dynsym').symbol_by_name('sigaction').header.st_value.to_i
        expect(OneGadget::Fetchers::AArch64.new(versioned).send(:dynamic_symbols, elf)[addr])
          .to eq '__sigaction'
      end
    end

    it 'is empty for a file the loader is told nothing about' do
      elf = instance_double(ELFTools::ELFFile, dynamic: nil)
      expect(fetcher.send(:dynamic_symbols, elf)).to be_empty
    end
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
