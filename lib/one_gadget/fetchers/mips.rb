# frozen_string_literal: true

require 'elftools'

require 'one_gadget/emulators/mips'
require 'one_gadget/fetchers/base'

module OneGadget
  module Fetchers
    # Fetcher for MIPS (32-bit, o32).
    #
    # Two things about this architecture are unlike every other one supported, and
    # both are answered here so that nothing about them reaches the engine:
    #
    # * a call states no target -- it goes through a register loaded from the GOT,
    #   so the callee's name has to be resolved and written where every other arch
    #   has one already ({#name_got_calls});
    # * a branch has a *delay slot*: the instruction after it runs before it takes
    #   effect. Stating the pair in that order ({#swap_delay_slots}) is what the
    #   engine already understands, so no delay-slot concept is needed anywhere
    #   else.
    class Mips < Base
      # A candidate may not begin at a delay slot. Jumping to one runs it and then
      # falls past the branch it belongs to, which is not the path stated here --
      # the branch is listed after it, and would be taken. Reporting such an entry
      # would be reporting a gadget that does not exist.
      # @param [Array<String>] lines One candidate, as a line list.
      # @yieldparam [Array<String>] window
      # @return [void]
      def executed_windows(lines)
        super { |window| yield(window) unless delay_slot?(window.first) }
      end

      private

      # A call, however it is spelled: through a register (which is how PIC code
      # reaches everything) or directly.
      def call_str = '(?:jalr|jal|bal)'

      def branch_lead_chars = 'bj'

      # +b+ is the unconditional branch, the compare-and-branch family is
      # conditional, and +jr+ (which is how a return is written) ends the path.
      # Calls are not branches: the walk stitches the window they target.
      def branch_kind(line)
        mnem = mnemonic(line)
        return :conditional if OneGadget::Emulators::Mips::COND.key?(mnem)
        return :unconditional if mnem == 'b'

        :terminator if %w[jr j].include?(mnem)
      end

      def emulator = OneGadget::Emulators::Mips.new

      # Rewrite the disassembly into what the engine reads everywhere else: every
      # call named, and every instruction in the order it runs.
      def objdump_lines(start: nil, stop: nil, extra: [])
        swap_delay_slots(name_got_calls(super))
      end

      # The call this arch actually uses names no target: the callee is loaded out
      # of the GOT into +t9+ and jumped to. Resolve the slot and write the name
      # beside the call, which is where the engine reads one.
      # @param [Array<String>] lines
      # @return [Array<String>]
      # @example
      #   'lw t9,-31652(gp)' then 'jalr t9' #=> 'jalr t9 <posix_spawnattr_init>'
      def name_got_calls(lines)
        loaded = nil
        lines.map do |line|
          if (m = line.match(GOT_LOAD))
            loaded = m[1].to_i
            line
          elsif line.match?(INDIRECT_CALL) && loaded
            name = got_symbol(loaded)
            loaded = nil
            name ? "#{line} <#{name}>" : line
          else
            line
          end
        end
      end

      # Loading the call target out of the GOT, which is +gp+-relative.
      GOT_LOAD = /:\s*lw\s+t9,(-?\d+)\(gp\)/
      private_constant :GOT_LOAD

      # The call through it, which objdump writes with nothing after the register.
      INDIRECT_CALL = /:\s*jalr\s+t9\s*\z/
      private_constant :INDIRECT_CALL

      # State each branch and its delay slot in the order they execute. The slot
      # runs first -- that is what a delay slot is -- so listing it first leaves a
      # line list the engine can read as ordinary straight-line code.
      # @param [Array<String>] lines
      # @return [Array<String>]
      def swap_delay_slots(lines)
        lines = lines.dup
        index = 0
        while index < lines.size - 1
          unless delayed?(lines[index])
            index += 1
            next
          end

          delay_slots[offset_of(lines[index + 1])] = true
          lines[index], lines[index + 1] = lines[index + 1], lines[index]
          index += 2
        end
        lines
      end

      # Every mnemonic that carries a delay slot: this arch delays each of its
      # branches, jumps and calls alike.
      def delayed?(line)
        mnem = mnemonic(line)
        OneGadget::Emulators::Mips::COND.key?(mnem) || DELAYED_JUMPS.include?(mnem)
      end

      # The unconditional transfers, which are delayed as the conditional ones are.
      DELAYED_JUMPS = %w[b j jr jal jalr bal].freeze
      private_constant :DELAYED_JUMPS

      # Which addresses hold a delay slot, remembered as they are found so
      # {#executed_windows} can refuse to start there.
      # @return [Hash{Integer => true}]
      def delay_slots
        @delay_slots ||= {}
      end

      # @param [String] line
      # @return [Boolean] Whether +line+ is the delay slot of the branch after it.
      def delay_slot?(line)
        delay_slots.key?(offset_of(line))
      end

      # The symbol a +gp+-relative GOT slot names, or +nil+ for one that names
      # nothing this can read. This arch states its GOT in the dynamic segment, so
      # the answer is there even for a file with no sections at all.
      # @param [Integer] gp_offset The offset as the instruction writes it.
      # @return [String, nil]
      def got_symbol(gp_offset)
        got = mips_got or return nil

        index = (GP_BIAS + gp_offset) / 4
        return got[:names][local_got_entry(got, index)] if index < got[:local]

        got[:symbols][got[:gotsym] + index - got[:local]]&.name
      end

      # +gp+ points this far into the GOT, so that one signed 16-bit offset reaches
      # the most of it. Every +gp+-relative offset is read against it.
      GP_BIAS = 0x7ff0
      private_constant :GP_BIAS

      # What a local GOT entry holds: the address itself, written in the file.
      # @param [Hash] got
      # @param [Integer] index
      # @return [Integer, nil]
      def local_got_entry(got, index)
        file_bytes[got[:offset] + (index * 4), 4]&.unpack1(got[:big] ? 'N' : 'V')
      end

      # Where this file's GOT is and how to read it. The entries below
      # +DT_MIPS_LOCAL_GOTNO+ hold an address outright; the rest correspond one for
      # one with the dynamic symbols, starting at +DT_MIPS_GOTSYM+.
      # @return [Hash, nil] +nil+ when the file states no GOT.
      def mips_got
        return @mips_got if defined?(@mips_got)

        @mips_got = File.open(file) { |fd| read_mips_got(ELFTools::ELFFile.new(fd)) }
      end

      # @param [ELFTools::ELFFile] elf
      # @return [Hash, nil]
      def read_mips_got(elf)
        dynamic = elf.segment_by_type(:dynamic) or return nil
        address = dynamic.tag_by_type(:pltgot)&.value or return nil
        local = dynamic.tag_by_type(:mips_local_gotno)&.value or return nil
        gotsym = dynamic.tag_by_type(:mips_gotsym)&.value or return nil
        segment = elf.segments_by_type(:load).find { |seg| holds?(seg, address) } or return nil

        names = {}
        dynamic.symbols.each do |symbol|
          value = symbol.header.st_value.to_i
          names[value] = symbol.name unless value.zero? || symbol.name.to_s.empty?
        end
        { local:, gotsym:, symbols: dynamic.symbols, names:, big: elf.endian == :big,
          offset: address - segment.header.p_vaddr.to_i + segment.header.p_offset.to_i }
      end

      # @param [ELFTools::Segments::Segment] segment
      # @param [Integer] address
      # @return [Boolean] Whether +segment+ carries the bytes at +address+.
      def holds?(segment, address)
        base = segment.header.p_vaddr.to_i
        address >= base && address < base + segment.header.p_filesz.to_i
      end
    end
  end
end
