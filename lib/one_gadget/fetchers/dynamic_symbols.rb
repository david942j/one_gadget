# frozen_string_literal: true

require 'elftools'

require 'one_gadget/emulators/processor'
require 'one_gadget/emulators/safe_calls'

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
      # Where a line that transfers control says it goes. Raw disassembly writes
      # every destination as +0x<addr>+, and the rest of the line is whatever the
      # architecture puts around it: the destination may be separated by a comma,
      # and followed by the note objdump appends to name the mnemonic's alias.
      # @example
      #   'call   0x94180'
      #   'beqz   a5,0x43060'
      #   'b.ls   0x47dcc  // b.plast'
      CONTROL_TARGET = %r{\A(.*[\s,])0x([0-9a-f]+)(?:\s+//.*)?\z}

      # An address any other line names, which it states last and alone -- so a
      # value the line merely operates on is left as it is written.
      # @example An architecture may resolve a pc-relative operand from this.
      #   'lea    rcx,[rip+0x19dabe]        # 0x1eb960'
      TRAILING_ADDRESS = /\A(.*\s)0x([0-9a-f]+)\z/

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
      #
      # Several symbols may name one address, and only one of them can be
      # written beside it. They all name the same code, so the choice is settled
      # by what a reader of the name can do with it ({#name_rank}).
      # @param [ELFTools::ELFFile] elf
      # @return [Hash{Integer => String}]
      def dynamic_symbols(elf)
        @dynamic_symbols ||= (elf.dynamic&.symbols || []).each_with_object({}) do |symbol, symbols|
          value = symbol.header.st_value.to_i
          name = symbol.name.to_s
          next if value.zero? || name.empty?

          symbols[value] = name if !symbols.key?(value) || name_rank(name) >= name_rank(symbols[value])
        end
      end

      # How much the engine can do with +name+: it recognises a terminal entry
      # point by naming it exactly, a call it can step over by containing one of
      # the catalog's names, and nothing else by name at all. Higher is more.
      # @param [String] name One symbol name.
      # @return [Integer]
      # @example Two names for one address, of which only the second is read.
      #   name_rank('sigaction')   #=> 0
      #   name_rank('__sigaction') #=> 1
      def name_rank(name)
        return 2 if OneGadget::Emulators::Processor::TERMINAL_CALL_RE.match?(name)
        return 1 if OneGadget::Emulators::SafeCalls::COMMON.keys.any? { |known| name.include?(known) }

        0
      end

      # Rewrite a raw-disassembly line into what reading the ELF would have
      # produced: an address objdump wrote as +0x<addr>+ becomes the bare address,
      # named when a symbol is there. The engine recognises a terminal call, reads
      # a branch target, and matches a safe call by name, from exactly that.
      #
      # Where the address sits depends on what the line does, so the two are
      # matched apart ({CONTROL_TARGET} against {TRAILING_ADDRESS}): asking for a
      # destination's shape anywhere else would rewrite an operand that only looks
      # like one.
      # @param [String] line One disassembled line.
      # @param [Hash{Integer => String}] symbols
      # @return [String]
      # @example
      #   symbolize('e6570: call   0x94180', symbols) #=> 'e6570: call   94180 <execve>'
      def symbolize(line, symbols)
        m = line.match(control_transfer?(line) ? CONTROL_TARGET : TRAILING_ADDRESS) or return line

        name = symbols[m[2].to_i(16)]
        named = name ? " <#{name}>" : ''
        "#{m[1]}#{m[2]}#{named}"
      end
    end
  end
end
