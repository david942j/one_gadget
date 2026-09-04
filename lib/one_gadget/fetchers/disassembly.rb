# frozen_string_literal: true

require 'elftools'

module OneGadget
  module Fetchers
    # Reading the target file: where its terminal calls are, and the disassembly
    # around them. Disassembling a whole libc is the dominant cost of a search, so
    # an architecture that can find its call sites cheaply gets windows around them
    # instead (see {Base#scan_calls}), and everything derived from one objdump
    # command is cached. Mixed into {Base}.
    module Disassembly
      # What a terminal function's name starts with. Read by {DynamicSymbols} too,
      # which finds the same functions by another route.
      TERMINAL_PREFIXES = %w[exec posix_spawn].freeze

      # A call to +posix_spawn+ itself, not one of the setup helpers that share its
      # prefix. The name ends at the version marker, or at the closing bracket when
      # there is none -- glibc's symbols are versioned, musl's are not, and neither
      # is one recovered from a file with no symbol table (see {DynamicSymbols}).
      TERMINAL_SPAWN = /posix_spawn[@>]/

      # Enough bytes of a name to tell: a symbol table's string table is read as
      # one blob, so a name is a slice of it.
      TERMINAL_PREFIX_BYTES = 12
      private_constant :TERMINAL_PREFIX_BYTES

      # How much to disassemble around each terminal call when an architecture can
      # locate the calls cheaply (see {#terminal_call_sites} / {#windowed_disasm}).
      #
      # Both directions were measured against a full disassembly of every fixture:
      # the least that reports the same gadgets is 0x368 back and 0x350 forward,
      # and one word less than either changes the answer. These leave about four
      # times that. Widening them further is close to free -- terminal calls
      # cluster into a handful of merged windows -- so the margin is cheap and the
      # thing it guards against, a libc whose predecessor sits further out than
      # anything measured, is silent when it happens.
      #
      # Both must stay a multiple of four. A window is asked for by address, and
      # objdump decodes from wherever it is told to start, so an offset landing
      # mid-instruction turns the whole window into rubble rather than shifting it.
      #
      # A window too small to hold a predecessor does not merely lose the gadgets
      # that needed it: the line before the first of a window is the last of
      # another, and nothing about it follows, so shortening one can invent gadgets
      # too. Judge a change to these by set equality against a full disassembly,
      # never by the count alone.
      WINDOW_BACK = 0x1000

      # As far past the call, for a predecessor that branches back into the region.
      WINDOW_FWD = 0x1000

      private

      # Regexp (as a String) matching an objdump line that calls a terminal
      # function (+exec*+ / +posix_spawn*+) we can turn into a gadget.
      def terminal_call_regexp
        "#{call_str}.*<(exec[^+]*|posix_spawn[^+]*)>$"
      end

      # The target's objdump disassembly as stripped +"ADDR: insn"+ lines.
      def disasm_lines
        disassembly[:lines]
      end

      # The disassembly and the shape it was taken in, cached (per objdump command)
      # for the lifetime of the fetcher.
      # @return [Hash{Symbol => Array<String>, Hash}]
      def disassembly
        @disassembly ||= begin
          # Before the command is read: it is what says how to disassemble, and
          # what the cache is keyed on.
          prepare_raw_disassembly if sectionless?
          Base.cached(:disasm, @objdump.command) do
            sites = terminal_call_sites
            sites.nil? || sites.empty? ? full_disasm : windowed_disasm(sites)
          end
        end
      end

      # Disassemble the whole file (the exhaustive default).
      def full_disasm
        { lines: objdump_lines, starts: {} }
      end

      # Disassemble only [call-WINDOW_BACK, call+WINDOW_FWD] around each call site,
      # merging overlaps. Used when {#terminal_call_sites} located the calls without
      # a full disassembly (the win on the slow-to-objdump Thumb-2 arm libcs).
      def windowed_disasm(sites)
        windows = sites.sort.map { |a| [[a - WINDOW_BACK, 0].max, a + WINDOW_FWD] }
        # One objdump per range, all at once: they are separate processes that
        # wait on each other for nothing, and a libc comes to a handful of windows.
        disassembled = merge_ranges(windows)
                       .flat_map { |lo, hi| decode_ranges(lo, hi) }
                       .map { |lo, hi, extra| Thread.new { objdump_lines(start: lo, stop: hi, extra:) } }
                       .map(&:value)
        starts = {}
        lines = disassembled.each_with_object([]) do |window, acc|
          starts[acc.size] = true
          acc.concat(window)
        end
        { lines:, starts: }
      end

      # Merge a list of sorted [lo, hi] ranges, coalescing any that overlap.
      def merge_ranges(ranges)
        ranges.each_with_object([]) do |(lo, hi), merged|
          if merged.last && lo <= merged.last[1]
            merged.last[1] = hi if hi > merged.last[1]
          else
            merged << [lo, hi]
          end
        end
      end

      # An objdump line carries an instruction when it opens with its address.
      DISASSEMBLED = /\A[0-9a-f]+:/
      private_constant :DISASSEMBLED

      # Whether this file ships without section headers, which is what makes the
      # ordinary route to its code and symbols unavailable (see {DynamicSymbols}).
      # @return [Boolean]
      def sectionless?
        return @sectionless unless @sectionless.nil?

        @sectionless = File.open(file) { |fd| ELFTools::ELFFile.new(fd).num_sections.zero? }
      end

      # Point objdump at the bytes rather than the ELF, once, when there is no
      # other way to read the file.
      # @return [void]
      def prepare_raw_disassembly
        File.open(file) do |fd|
          elf = ELFTools::ELFFile.new(fd)
          seg = executable_segment(elf)
          next if seg.nil?

          @raw_symbols = dynamic_symbols(elf)
          record_instruction_sets(elf)
          @objdump.read_raw(machine: OneGadget::Helper.objdump_arch(OneGadget::Helper.architecture(file)),
                            endian: elf.endian,
                            vma: seg.header.p_vaddr.to_i - seg.header.p_offset.to_i)
        end
      end

      # How +lo+ to +hi+ must be disassembled: as one range by default. An
      # architecture that encodes different parts of its code differently splits
      # it where the encoding changes, since objdump reads a whole range one way.
      # @param [Integer] lo
      # @param [Integer] hi
      # @return [Array<(Integer, Integer, Array<String>)>]
      #   Each range, with the objdump options that read it correctly.
      def decode_ranges(lo, hi)
        [[lo, hi, []]]
      end

      # Note how the file says its code is encoded, for {#decode_ranges} to split
      # on. Nothing to note for an architecture with one encoding.
      # @param [ELFTools::ELFFile] elf
      # @return [void]
      def record_instruction_sets(elf); end

      def objdump_lines(start: nil, stop: nil, extra: [])
        # One pass, one string per line: a whole libc is hundreds of thousands of
        # them, and only the instructions are wanted.
        symbols = @raw_symbols
        `#{@objdump.command(start:, stop:, extra:)}`.each_line.filter_map do |line|
          line = line.strip
          next unless DISASSEMBLED.match?(line)

          symbols ? symbolize(line, symbols) : line
        end
      end

      # Addresses of the calls reaching a terminal function, found without
      # disassembling anything: the +exec*+/+posix_spawn*+ symbols are read out of
      # the ELF and the segment holding the code is scanned for direct calls into
      # them (see {#scan_calls}). +nil+ when the file cannot be read that way, so
      # the caller disassembles everything instead.
      # @return [Array<Integer>, nil]
      def terminal_call_sites
        File.open(file) do |fd|
          elf = ELFTools::ELFFile.new(fd)
          targets = terminal_symbol_addresses(elf)
          return [] if targets.empty?

          seg = executable_segment(elf)
          return nil if seg.nil?

          scan_calls(seg.header.p_vaddr.to_i, seg.data, targets)
        end
      rescue ELFTools::ELFError
        nil # not something we can scan; disassemble everything
      end

      # The loadable segment holding the code, which is where a call scan runs and
      # what raw disassembly is taken from. It holds a little besides the code, and
      # is used in place of a section because a stripped file has none.
      # @param [ELFTools::ELFFile] elf
      # @return [ELFTools::Segments::Segment, nil]
      def executable_segment(elf)
        elf.segments_by_type(:load).find(&:executable?)
      end

      # Where the +exec*+/+posix_spawn*+ symbols live, keyed for lookup. Read
      # straight out of the tables rather than built into an object per symbol: a
      # libc has thousands, and only two fields of each are wanted.
      # @param [ELFTools::ELFFile] elf
      # @return [Hash{Integer => true}]
      def terminal_symbol_addresses(elf)
        return sectionless_terminal_addresses(elf) if elf.num_sections.zero?

        addrs = {}
        %w[.dynsym .symtab].each do |name|
          sec = elf.section_by_name(name)
          next if sec.nil?

          strtab = elf.sections[sec.header.sh_link.to_i].data
          each_symbol(elf, sec) do |name_offset, value|
            symbol = strtab.byteslice(name_offset, TERMINAL_PREFIX_BYTES)
            addrs[symbol_address(value)] = true if symbol&.start_with?(*TERMINAL_PREFIXES)
          end
        end
        addrs
      end

      # Each symbol's name offset and value, unpacked from the table's bytes. A
      # 32-bit entry is four words with the value second; a 64-bit one is six, the
      # value being the pair from the third. The table is the file's own data, so
      # it is read in the byte order the file states.
      # @param [ELFTools::ELFFile] elf
      # @param [ELFTools::Sections::Section] section
      # @yieldparam [Integer] name_offset
      # @yieldparam [Integer] value
      # @return [void]
      def each_symbol(elf, section)
        wide = elf.elf_class == 64
        big = elf.endian == :big
        section.data.unpack(big ? 'N*' : 'V*').each_slice(wide ? 6 : 4) do |words|
          value = wide ? wide_value(words, big) : words[1]
          next if value.nil? || value.zero?

          yield(words[0], value)
        end
      end

      # A 64-bit value stated as two words, the more significant of which comes
      # first in a big-endian file.
      # @param [Array<Integer>] words One symbol table entry.
      # @param [Boolean] big
      # @return [Integer, nil] +nil+ for a truncated entry.
      def wide_value(words, big)
        low, high = big ? [words[3], words[2]] : [words[2], words[3]]
        low && high && (low | (high << 32))
      end

      # Map from an instruction's address to its index in {#disasm_lines}, so a
      # given address can be located in the disassembly in O(1).
      def disasm_index
        @disasm_index ||= disasm_lines.each_with_index.to_h { |line, i| [line[/\A([0-9a-f]+):/, 1].to_i(16), i] }
      end
    end
  end
end
