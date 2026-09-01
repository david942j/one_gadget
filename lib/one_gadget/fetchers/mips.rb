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
    # * a branch or call has a *delay slot*: the instruction after it runs before
    #   it takes effect. {OneGadget::Emulators::Mips#process!} holds the transfer
    #   back so both run in that order, which leaves the disassembly in the order
    #   objdump wrote it and every address meaning what it says. Two seams follow
    #   from it, and they are the only ones: the instruction after a call belongs
    #   to the window that ends at the call ({#emulate}), and the edge into a
    #   branch's target leaves from the delay slot rather than the branch
    #   ({#branch_pred_map}).
    class Mips < Base
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
      # call named.
      def objdump_lines(start: nil, stop: nil, extra: [])
        name_got_calls(super)
      end

      # A window ends at the call that ends the gadget, but that call's delay slot
      # runs before control leaves -- it is where an argument is often set -- so it
      # is part of what the window executes.
      # @param [Array<String>] cmds
      # @return [OneGadget::Emulators::Processor]
      def emulate(cmds)
        super(terminal_call_line?(cmds.last) ? cmds + delay_slot_after(cmds.last) : cmds)
      end

      # The instruction a transfer delays behind, as a one-element list, or none
      # when the disassembly does not carry it (it starts another window).
      # @param [String] line
      # @return [Array<String>]
      def delay_slot_after(line)
        index = disasm_index[offset_of(line)]
        return [] if index.nil? || window_starts.key?(index + 1)

        [disasm_lines[index + 1]].compact
      end

      # A branch takes effect only after its delay slot, so the last instruction to
      # run before control reaches the target is the one *after* the branch. Say
      # the edge leaves from there, and a path through it reads in the order it
      # executes without anything having to be reordered. The memo is the one the
      # base class fills: +super+ sets it to the undelayed map, and this replaces
      # it with the delayed one.
      # @return [Hash{Integer => Array<Integer>}]
      def branch_pred_map
        @branch_pred_map ||= delayed_edges(super)
      end

      # Move each edge on by one instruction, dropping any whose delay slot the
      # disassembly does not carry because another window starts there.
      # @param [Hash{Integer => Array<Integer>}] map
      # @return [Hash{Integer => Array<Integer>}]
      def delayed_edges(map)
        map.to_h { |target, indexes| [target, indexes.filter_map { |i| i + 1 unless window_starts.key?(i + 1) }] }
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
          elsif line.match?(INDIRECT_CALL)
            name = loaded && got_symbol(loaded)
            loaded = nil
            next name ? "#{line} <#{name}>" : line
          elsif line.match?(TARGET_WRITE)
            # the call no longer goes where that offset said
            loaded = nil
          end
          line
        end
      end

      # Loading the call target out of the GOT, which is +gp+-relative.
      GOT_LOAD = /:\s*lw\s+t9,(-?\d+)\(gp\)/
      private_constant :GOT_LOAD

      # The call through it. o32 requires the callee's address in +t9+ -- that is
      # how the callee computes its own +gp+ -- so a call always reads that
      # register, optionally naming the one the return address goes to.
      INDIRECT_CALL = /:\s*jalr\s+(?:\w+,)?t9\s*\z/
      private_constant :INDIRECT_CALL

      # Anything else that writes the call register. Only the load that last wrote
      # +t9+ says where the call goes: most calls reach it another way (out of a
      # struct, or from a register), and carrying a GOT offset over one of those
      # would name the call after a function it never reaches. A store reads the
      # register rather than writing it.
      TARGET_WRITE = /:\s*(?!s[whb]\b)\S+\s+t9,/
      private_constant :TARGET_WRITE

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
        segment = elf.segments_by_type(:load).find { |seg| seg.vma_in?(address) } or return nil

        names = {}
        dynamic.symbols.each do |symbol|
          value = symbol.header.st_value.to_i
          names[value] = symbol.name unless value.zero? || symbol.name.empty?
        end
        { local:, gotsym:, symbols: dynamic.symbols, names:, big: elf.endian == :big,
          offset: segment.vma_to_offset(address) }
      end
    end
  end
end
