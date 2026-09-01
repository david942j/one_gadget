# frozen_string_literal: true

require 'elftools'

require 'one_gadget/fetchers/amd64'

describe OneGadget::Fetchers::Disassembly do
  let(:fetcher) { OneGadget::Fetchers::Amd64.new(data_path('libc-2.31-9fdb74e7b217d06c93172a8243f8547f947ee6d1.so')) }

  # A symbol table is the file's own data, so it is written in whichever byte
  # order the file states -- and a big-endian one states a 64-bit value most
  # significant word first. Both spellings have to read back the same.
  describe '#each_symbol' do
    let(:name_offset) { 0x1234 }
    let(:value) { 0x1122334455667788 }

    def entry64(pack_word, pack_half, pack_quad)
      [name_offset].pack(pack_word) + [2].pack('C') + [0].pack('C') + [1].pack(pack_half) +
        [value].pack(pack_quad) + [0x40].pack(pack_quad)
    end

    def entry32(pack_word, pack_half)
      [name_offset].pack(pack_word) + [value & 0xffffffff].pack(pack_word) +
        [0x40].pack(pack_word) + [2].pack('C') + [0].pack('C') + [1].pack(pack_half)
    end

    def read(elf_class, endian, data)
      elf = instance_double(ELFTools::ELFFile, elf_class:, endian:)
      section = instance_double(ELFTools::Sections::Section, data:)
      [].tap { |acc| fetcher.send(:each_symbol, elf, section) { |off, val| acc << [off, val] } }
    end

    it 'reads a 64-bit table the same in either byte order' do
      little = read(64, :little, entry64('V', 'v', 'Q<'))
      big = read(64, :big, entry64('N', 'n', 'Q>'))
      expect(little).to eq [[name_offset, value]]
      expect(big).to eq little
    end

    it 'reads a 32-bit table the same in either byte order' do
      little = read(32, :little, entry32('V', 'v'))
      big = read(32, :big, entry32('N', 'n'))
      expect(little).to eq [[name_offset, value & 0xffffffff]]
      expect(big).to eq little
    end

    it 'passes over an entry naming nothing, and a truncated one' do
      empty = [0].pack('V') * 6
      expect(read(64, :little, empty + [1].pack('V') * 3)).to be_empty
    end
  end
end
