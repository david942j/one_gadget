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

      # Enough bytes of a name to tell: a symbol table's string table is read as
      # one blob, so a name is a slice of it.
      TERMINAL_PREFIX_BYTES = 12
      private_constant :TERMINAL_PREFIX_BYTES

      # How much to disassemble around each terminal call when an architecture can
      # locate the calls cheaply (see {#terminal_call_sites} / {#windowed_disasm}).
      #
      # The walk runs backwards from the call, but what it reaches does not: a
      # branch predecessor can sit *after* the call, so the window has to hold the
      # loop or later block that jumps back into the region.
      #
      # Both directions were measured by windowing every architecture against its
      # own full disassembly across the spec corpus. Gadgets start being lost below
      # 0x400 either way, and a window too small to hold a predecessor invents them
      # as well: the line before the first of a window is the last of another, and
      # nothing about it follows. These leave 16x that, and still disassemble about
      # a fifth of a libc -- terminal calls cluster into a handful of merged
      # windows, so a wider one costs little.
      #
      # A gadget whose code and branch-predecessors exceed the window is missed,
      # which is why windowing is opt-in per arch (fast disassembly arches keep the
      # full, exhaustive scan) and falls back to full disassembly if the call scan
      # comes up empty.
      WINDOW_BACK = 0x4000

      # As far past the call, for a predecessor that branches back into the region.
      WINDOW_FWD = 0x4000

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
        prepare_raw_disassembly if sectionless?
        @disassembly ||= Base.cached(:disasm, @objdump.command) do
          sites = terminal_call_sites
          sites.nil? || sites.empty? ? full_disasm : windowed_disasm(sites)
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
        # One objdump per window, all at once: they are separate processes that
        # wait on each other for nothing, and a libc comes to a handful of windows.
        disassembled = merge_ranges(windows)
                       .map { |lo, hi| Thread.new { objdump_lines(start: lo, stop: hi) } }
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

        @sectionless = File.open(file) { |fd| ELFTools::ELFFile.new(fd).sections.empty? }
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
          @objdump.read_raw(machine: OneGadget::Helper.objdump_arch(OneGadget::Helper.architecture(file)),
                            endian: elf.endian,
                            vma: seg.header.p_vaddr.to_i - seg.header.p_offset.to_i)
        end
      end

      def objdump_lines(start: nil, stop: nil)
        # One pass, one string per line: a whole libc is hundreds of thousands of
        # them, and only the instructions are wanted.
        symbols = @raw_symbols
        `#{@objdump.command(start:, stop:)}`.each_line.filter_map do |line|
          line = line.strip
          next unless DISASSEMBLED.match?(line)

          symbols ? symbolize(line, symbols) : line
        end
      end

      # Addresses of the calls reaching a terminal function, found without
      # disassembling anything: the +exec*+/+posix_spawn*+ symbols are read out of
      # the ELF and +.text+ is scanned for direct calls into them (see
      # {#scan_calls}). +nil+ when the file cannot be read that way, so the caller
      # disassembles everything instead.
      # @return [Array<Integer>, nil]
      def terminal_call_sites
        File.open(file) do |fd|
          elf = ELFTools::ELFFile.new(fd)
          return nil unless elf.endian == :little

          targets = terminal_symbol_addresses(elf)
          return [] if targets.empty?

          base, data = executable_bytes(elf)
          return nil if data.nil?

          scan_calls(base, data, targets)
        end
      rescue ELFTools::ELFError
        nil # not something we can scan; disassemble everything
      end

      # The bytes a call scan runs over, and where they are loaded. Normally that is
      # +.text+; a file whose section headers are gone has the executable segment
      # instead, which holds the same code and a little else besides.
      # @param [ELFTools::ELFFile] elf
      # @return [(Integer, String), nil] +nil+ when neither can be found.
      def executable_bytes(elf)
        text = elf.section_by_name('.text')
        return [text.header.sh_addr.to_i, text.data] if text

        seg = executable_segment(elf)
        seg && [seg.header.p_vaddr.to_i, seg.data]
      end

      # The loadable segment holding the code (+PT_LOAD+, executable).
      # @param [ELFTools::ELFFile] elf
      # @return [ELFTools::Segments::Segment, nil]
      def executable_segment(elf)
        elf.segments.find do |seg|
          seg.header.p_type == ELFTools::Constants::PT::PT_LOAD && seg.header.p_flags.to_i.anybits?(1)
        end
      end

      # Where the +exec*+/+posix_spawn*+ symbols live, keyed for lookup. Read
      # straight out of the tables rather than built into an object per symbol: a
      # libc has thousands, and only two fields of each are wanted.
      # @param [ELFTools::ELFFile] elf
      # @return [Hash{Integer => true}]
      def terminal_symbol_addresses(elf)
        return sectionless_terminal_addresses(elf) if elf.sections.empty?

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
      # value being the pair from the third.
      # @param [ELFTools::ELFFile] elf
      # @param [ELFTools::Sections::Section] section
      # @yieldparam [Integer] name_offset
      # @yieldparam [Integer] value
      # @return [void]
      def each_symbol(elf, section)
        wide = elf.elf_class == 64
        section.data.unpack('V*').each_slice(wide ? 6 : 4) do |words|
          value = wide ? words[2] && words[3] && (words[2] | (words[3] << 32)) : words[1]
          next if value.nil? || value.zero?

          yield(words[0], value)
        end
      end

      # Map from an instruction's address to its index in {#disasm_lines}, so a
      # given address can be located in the disassembly in O(1).
      def disasm_index
        @disasm_index ||= disasm_lines.each_with_index.to_h { |line, i| [line[/\A([0-9a-f]+):/, 1].to_i(16), i] }
      end
    end
  end
end
