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
      # Everything this arch reaches -- its calls and its globals alike -- goes
      # through the GOT base in +gp+, which is a precondition the caller arranges
      # by setting that register. Say so, and drop the read/write requirements
      # rooted there: the GOT is a fixed, mapped libc address, so reaching through
      # it asks nothing further of the caller (as i386 does for its own GOT
      # register).
      # @param [OneGadget::Emulators::Processor] processor
      # @return [Hash, nil]
      def resolve(processor)
        res = super
        return if res.nil?

        got = got_base_constraint(processor, GOT_BASE) or return nil

        res[:constraints].unshift(*got_preconditions(processor, got))
        res[:constraints].reject! { |con| con.match?(/\A(?:writable|readable): \[*#{GOT_BASE}\b/) }
        res
      end

      # This arch reads a global through the GOT and resolves the slot to the
      # address it holds, so what reaches a call is one dereference of the variable
      # rather than two of the slot naming it. Which variable that is comes from
      # the symbols already read for the table.
      # @param [String] str A rendered value.
      # @return [Boolean]
      def environ?(str)
        got = mips_got or return false
        offset = string_file_offset(str.delete('[]')) or return false

        ENVIRON.match?(got[:names][offset].to_s)
      end

      # What the caller must arrange for this window to reach the GOT. Normally
      # just the register itself -- but o32 has the *caller* restore it after
      # every call, because the callee establishes its own, so a window that runs
      # past a call reads the table through whatever it restored from. Every call
      # it makes after that point was named on the assumption that this is the
      # GOT, so say so rather than leaving it unsaid.
      # @param [OneGadget::Emulators::Processor] processor
      # @param [String] got The constraint naming the register itself.
      # @return [Array<String>]
      # @example a window that restores gp from its frame
      #   got_preconditions(processor, 'gp is the GOT address of libc')
      #   #=> ['gp is the GOT address of libc', '[sp+0x18] is the GOT address of libc']
      def got_preconditions(processor, got)
        held = processor.registers[GOT_BASE].to_s
        return [got] if held == GOT_BASE

        [got, "#{held} is the GOT address of libc"]
      end

      # A candidate may begin at a delay slot -- entering there runs it and falls
      # past the transfer it belongs to -- but it may not then *follow* that
      # transfer, which never executed. Such a window shows it by its second line
      # not being the next instruction along; entering one instruction earlier, at
      # the transfer itself, is the separate and valid window that does follow it.
      # @param [Array<String>] lines One candidate, as a line list.
      # @yieldparam [Array<String>] window
      # @return [void]
      def executed_windows(lines)
        super do |window|
          yield(window) unless follows_a_transfer_it_skipped?(window) || enters_at_an_unset_call?(window)
        end
      end

      private

      # This arch spells every instruction in one word.
      INSTRUCTION_SIZE = 4
      private_constant :INSTRUCTION_SIZE

      # Whether the window opens on a call through a register it never set, so that
      # where it goes is whatever the caller happened to leave there. Refusing
      # costs nothing: the window one instruction earlier loads it itself.
      # @param [Array<String>] window
      # @return [Boolean]
      # @example The load that names the call is behind the window's first line.
      #   enters_at_an_unset_call?(['4b3e0: jalr t9 <posix_spawnattr_init>']) #=> true
      #   enters_at_an_unset_call?(['4b3dc: lw t9,-31652(gp)', '4b3e0: jalr t9']) #=> false
      def enters_at_an_unset_call?(window)
        mnemonic(window.first) == 'jalr'
      end

      # @param [Array<String>] window
      # @return [Boolean] Whether it starts at a delay slot and then takes the
      #   branch that delay slot belongs to.
      def follows_a_transfer_it_skipped?(window)
        return false if window.size < 2

        offset_of(window[1]) != offset_of(window.first) + INSTRUCTION_SIZE
      end

      # The register o32 states the GOT base in.
      GOT_BASE = 'gp'
      private_constant :GOT_BASE

      # Every instruction is one word here and word-aligned, so the whole scan is
      # a masked compare per word. A call spells its destination two ways: a
      # direct one carries it, and the indirect one PIC code reaches everything
      # through names the GOT slot it is taken from.
      def scan_calls(base, data, targets)
        got = mips_got or return nil

        sites = []
        data.unpack(got[:big] ? 'N*' : 'V*').each_with_index do |word, i|
          address = base + (i * INSTRUCTION_SIZE)
          destination = call_destination(word, address)
          sites << address if destination && targets.key?(destination)
        end
        sites
      end

      # Where a call at +address+ goes.
      # @param [Integer] word The instruction word.
      # @param [Integer] address
      # @return [Integer, nil] +nil+ when the word is not a call, or is one whose
      #   destination these bytes alone do not say.
      # @example
      #   # lw t9,-32744(gp), whose GOT slot holds _setjmp
      #   call_destination(0x8f998018, 0x4b3dc) #=> 0x39190
      #   # bal 4b3f0
      #   call_destination(0x04110004, 0x4b3dc) #=> 0x4b3f0
      def call_destination(word, address)
        following = address + INSTRUCTION_SIZE
        case word & OPCODE_AND_TARGET_REGISTERS
        when GOT_CALL_LOAD then got_address(immediate(word))
        when BAL then following + (immediate(word) * INSTRUCTION_SIZE)
        else ((following & JAL_REGION) | ((word & JAL_TARGET) << 2) if (word >> 26) == JAL_OPCODE)
        end
      end

      # The high half of a word, which is opcode plus whichever registers an
      # instruction of that opcode names there.
      OPCODE_AND_TARGET_REGISTERS = 0xffff0000
      private_constant :OPCODE_AND_TARGET_REGISTERS

      # +lw t9,<imm>(gp)+ -- the load of a call's destination out of the GOT.
      GOT_CALL_LOAD = 0x8f990000
      private_constant :GOT_CALL_LOAD

      # +bal <imm>+, the pc-relative direct call, spelled +bgezal zero,<imm>+.
      BAL = 0x04110000
      private_constant :BAL

      # +jal <target>+, the direct call that states an absolute address, which it
      # can only do within the 256MB region it is itself in.
      JAL_OPCODE = 3
      JAL_TARGET = 0x03ffffff
      JAL_REGION = 0xf0000000
      private_constant :JAL_OPCODE, :JAL_TARGET, :JAL_REGION

      # The signed offset an instruction states in its low half.
      # @param [Integer] word The instruction word.
      # @return [Integer]
      def immediate(word)
        half = word & 0xffff
        half >= 0x8000 ? half - 0x10000 : half
      end

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
        state_got_values(name_got_calls(super))
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
      #   name_got_calls(['4b3dc: lw t9,-31652(gp)', '4b3e0: jalr t9'])
      #   #=> ['4b3dc: lw t9,-31652(gp)', '4b3e0: jalr t9 <posix_spawnattr_init>']
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

      # A libc global is reached through the GOT as well: the slot holds the
      # address, and an +addiu+ applies the offset within it. What the slot holds
      # is in the file, so state it beside the load -- which is what lets the
      # value read as +$base+<off>+, the form every other architecture produces
      # for a global.
      # @param [Array<String>] lines
      # @return [Array<String>]
      # @example
      #   state_got_values(['77b44: lw a0,-32496(gp)'])
      #   #=> ['77b44: lw a0,-32496(gp)  # b0000']
      def state_got_values(lines)
        lines.map do |line|
          m = line.match(GOT_GLOBAL_LOAD) or next line

          address = got_address(m[1].to_i)
          address.nil? || address.zero? ? line : "#{line}  # #{format('%x', address)}"
        end
      end

      # Loading anything but the call target out of the GOT.
      GOT_GLOBAL_LOAD = /:\s*lw\s+(?!t9,)\w+,(-?\d+)\(gp\)/
      private_constant :GOT_GLOBAL_LOAD

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

      # What a +gp+-relative GOT slot holds, as +[address, name]+, or +nil+ for one
      # this cannot read. This arch states its GOT in the dynamic segment, so the
      # answer is there even for a file with no sections at all. An entry below
      # +DT_MIPS_LOCAL_GOTNO+ holds the address outright; the rest correspond one
      # for one with the dynamic symbols.
      # @param [Integer] gp_offset The offset as the instruction writes it.
      # @return [(Integer, String), nil]
      def got_entry(gp_offset)
        got = mips_got or return nil

        index = (GP_BIAS + gp_offset) / 4
        if index < got[:local]
          address = local_got_entry(got, index)
          return address && [address, got[:names][address]]
        end
        got[:symbols][got[:gotsym] + index - got[:local]]
      end

      # @param [Integer] gp_offset
      # @return [String, nil] The symbol the slot names.
      def got_symbol(gp_offset) = got_entry(gp_offset)&.last

      # @param [Integer] gp_offset
      # @return [Integer, nil] The address the slot holds.
      def got_address(gp_offset) = got_entry(gp_offset)&.first

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

        # Read out of the symbols now, rather than holding them: they are lazy, and
        # the file they would read from is closed as soon as this returns.
        symbols = dynamic.symbols.map { |symbol| [symbol.header.st_value.to_i, symbol.name] }
        names = symbols.to_h { |value, name| [value, name] }
                       .reject { |value, name| value.zero? || name.empty? }
        { local:, gotsym:, symbols:, names:, big: elf.endian == :big,
          offset: segment.vma_to_offset(address) }
      end
    end
  end
end
