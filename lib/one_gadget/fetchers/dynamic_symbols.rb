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
      # This is where a file that has been stripped of its sections still records
      # them, and the tags reach as many as anything in the file refers to.
      # @param [ELFTools::ELFFile] elf
      # @return [Hash{Integer => String}]
      def dynamic_symbols(elf)
        @dynamic_symbols ||= (elf.dynamic&.symbols || []).each_with_object({}) do |symbol, symbols|
          value = symbol.header.st_value.to_i
          symbols[value] = symbol.name unless value.zero? || symbol.name.to_s.empty?
        end
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
