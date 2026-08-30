# frozen_string_literal: true

require 'elftools'

module OneGadget
  module Fetchers
    # Reading a shared object that ships without section headers, as an embedded
    # libc commonly does: OpenWrt strips them from musl to save flash, and a
    # vendor firmware may do the same to glibc.
    #
    # Nothing is actually missing from such a file -- the loader still has to find
    # the symbols, so they are reachable through +PT_DYNAMIC+ -- but the usual
    # route to them is not. objdump disassembles sections and so produces nothing
    # at all, and the engine recognises a terminal call by the symbol objdump
    # prints beside it. Both are answered here: the symbols are read out of the
    # dynamic segment, and the raw disassembly is rewritten to name them, so
    # everything downstream reads what it always reads.
    module DynamicSymbols
      # A branch or call whose target objdump could not name, e.g.
      # +call   0x94180+. Raw disassembly writes every target this way.
      UNNAMED_TARGET = /\A(.*\s)0x([0-9a-f]+)\z/

      private

      # Where the terminal +exec*+/+posix_spawn*+ entry points live, read through
      # the dynamic segment. Keyed for lookup, as {#terminal_symbol_addresses} is.
      # @param [ELFTools::ELFFile] elf
      # @return [Hash{Integer => true}]
      def sectionless_terminal_addresses(elf)
        dynamic_symbols(elf).each_with_object({}) do |(addr, name), addrs|
          addrs[symbol_address(addr)] = true if name.start_with?(*Disassembly::TERMINAL_PREFIXES)
        end
      end

      # Every function the dynamic symbol table names, as +{address => name}+.
      # @param [ELFTools::ELFFile] elf
      # @return [Hash{Integer => String}]
      def dynamic_symbols(elf)
        @dynamic_symbols ||= begin
          dyn = elf.segment_by_type(:dynamic)
          symtab = dynamic_tag(dyn, :symtab)
          strtab = dynamic_tag(dyn, :strtab)
          symtab && strtab ? read_symbols(elf, symtab, strtab, dyn) : {}
        end
      end

      # @return [Hash{Integer => String}]
      def read_symbols(elf, symtab, strtab, dyn)
        wide = elf.elf_class == 64
        entry = dynamic_tag(dyn, :syment) || (wide ? 24 : 16)
        count = symbol_count(elf, dyn, symtab, strtab, entry)
        table = file_bytes.byteslice(file_offset(elf, symtab).to_i, count * entry).to_s
        strings = file_bytes.byteslice(file_offset(elf, strtab).to_i, dynamic_tag(dyn, :strsz).to_i).to_s
        symbols = {}
        each_symbol_entry(table, entry, wide) do |name_offset, value|
          name = strings.byteslice(name_offset..)&.unpack1('Z*')
          symbols[value] = name unless name.nil? || name.empty?
        end
        symbols
      end

      # How many entries the symbol table has. +DT_HASH+ says so directly -- every
      # symbol has to be reachable through it, so its chain is as long as the table
      # -- and where a file carries only the GNU hash, the string table starting
      # right after the symbols says the same thing.
      # @return [Integer]
      def symbol_count(elf, dyn, symtab, strtab, entry)
        hash = dynamic_tag(dyn, :hash)
        # A file carrying only the GNU hash says it another way: the string table
        # starts where the symbols end.
        return (strtab - symtab) / entry if hash.nil?

        file_bytes.byteslice(file_offset(elf, hash).to_i + 4, 4).to_s.unpack1('V').to_i
      end

      # Walk +table+, yielding each entry's name offset and value. The two ELF
      # classes order the fields differently, which is the only thing that differs.
      # @return [void]
      def each_symbol_entry(table, entry, wide)
        (table.bytesize / entry).times do |i|
          words = table.byteslice(i * entry, entry).unpack('V*')
          value = wide ? words[2] | (words[3] << 32) : words[1]
          next if value.nil? || value.zero?

          yield(words[0], value)
        end
      end

      # @param [ELFTools::Segments::DynamicSegment] dyn
      # @param [Symbol] type The tag to read, e.g. +:symtab+.
      # @return [Integer, nil] Its value, or nil when the file carries no such tag.
      def dynamic_tag(dyn, type)
        dyn && dyn.tag_by_type(type)&.value&.to_i
      end

      # Where +vaddr+ lives in the file. With no section headers to say, the
      # loadable segment covering it does.
      # @param [ELFTools::ELFFile] elf
      # @param [Integer] vaddr
      # @return [Integer, nil] nil when no segment covers it.
      def file_offset(elf, vaddr)
        seg = elf.segments_by_type(:load).find do |s|
          base = s.header.p_vaddr.to_i
          vaddr >= base && vaddr < base + s.header.p_filesz.to_i
        end
        seg && vaddr - seg.header.p_vaddr.to_i + seg.header.p_offset.to_i
      end

      # Rewrite a raw-disassembly line into what reading the ELF would have
      # produced: a target objdump wrote as +0x<addr>+ becomes the bare address,
      # named when a symbol is there. The engine recognises a terminal call, and
      # reads a branch target, from exactly that.
      # @param [String] line One disassembled line.
      # @param [Hash{Integer => String}] symbols
      # @return [String]
      # @example
      #   symbolize('e6570: call   0x94180', symbols) #=> 'e6570: call   94180 <execve>'
      def symbolize(line, symbols)
        m = line.match(UNNAMED_TARGET) or return line

        name = symbols[m[2].to_i(16)]
        named = name ? " <#{name}>" : ''
        "#{m[1]}#{m[2]}#{named}"
      end
    end
  end
end
