# frozen_string_literal: true

require 'elftools'

require 'one_gadget/emulators/arm'
require 'one_gadget/fetchers/base'

module OneGadget
  module Fetchers
    # Fetcher for 32-bit ARM (A32 / Thumb-2).
    class Arm < Base
      # Condition codes as branch suffixes (+bne+, +bcs+, ...).
      CONDS = %w[eq ne cs hs cc lo mi pl vs vc hi ls ge lt gt le].freeze

      private

      # Locate the `bl` sites that call a terminal function *without* disassembling
      # the whole libc - a full objdump of a Thumb-2 arm libc is ~4x slower than
      # amd64/aarch64 (~1.1s vs ~0.3s), and only ~0.35% of it is ever needed.
      #
      # We take the exec*/posix_spawn* addresses from the symbol table and scan
      # +.text+ for A32/Thumb `BL` instructions branching to them. This is exact
      # for the direct `bl <exec*>` calls the search cares about (validated to
      # match the objdump-grep sites on the arm-libc-2.23/2.27/2.39 fixtures);
      # any false positive merely adds a harmless empty window, and if the scan
      # finds nothing we fall back to a full disassembly.
      def terminal_call_sites
        File.open(file) do |f|
          elf = ELFTools::ELFFile.new(f)
          targets = terminal_symbol_addresses(elf)
          return [] if targets.empty?

          text = elf.section_by_name('.text')
          return nil if text.nil?

          scan_bl(text.header.sh_addr.to_i, text.data, targets)
        end
      rescue ELFTools::ELFError
        nil # not something we can scan; disassemble everything
      end

      # Addresses (Thumb bit cleared) of exported/defined exec*/posix_spawn* funcs.
      def terminal_symbol_addresses(elf)
        addrs = {}
        %w[.dynsym .symtab].each do |name|
          sec = elf.section_by_name(name)
          next if sec.nil?

          sec.each_symbols do |sym|
            value = sym.header.st_value.to_i
            addrs[value & ~1] = true if value.nonzero? && sym.name =~ /\A(exec|posix_spawn)/
          end
        end
        addrs
      end

      # Scan +data+ (loaded at +base+) for A32/Thumb BL branches into +targets+.
      # Over-approximates (a stray word may decode to a BL into a target); that is
      # harmless - it just adds an empty window - as long as no real BL is missed.
      def scan_bl(base, data, targets)
        halves = data.unpack('v*') # 16-bit little-endian halfwords
        sites = halves.each_index.filter_map do |i|
          addr = base + i * 2
          addr if call_targets_at(halves, i, addr).any? { |t| targets.key?(t) }
        end
        sites.uniq
      end

      # Masked target(s) of any A32/Thumb BL that could begin at halfword +i+.
      def call_targets_at(halves, i, addr)
        targets = []
        targets << (thumb_bl_target(addr, halves[i], halves[i + 1]) & ~1) if thumb_bl?(halves, i)
        targets << a32_bl_target(addr, halves[i] | (halves[i + 1] << 16)) if i.even? && halves[i + 1]
        targets.compact
      end

      def thumb_bl?(halves, i)
        halves[i].between?(0xf000, 0xf7ff) && halves[i + 1]&.allbits?(0xd000)
      end

      def thumb_bl_target(addr, high, low)
        s = (high >> 10) & 1
        i1 = (~(((low >> 13) & 1) ^ s)) & 1
        i2 = (~(((low >> 11) & 1) ^ s)) & 1
        imm = (s << 24) | (i1 << 23) | (i2 << 22) | ((high & 0x3ff) << 12) | ((low & 0x7ff) << 1)
        imm -= (1 << 25) if s == 1
        (addr + 4 + imm) & 0xffffffff
      end

      def a32_bl_target(addr, word)
        return nil unless ((word >> 24) & 0x0f) == 0x0b # cond|101|1 => BL

        imm = (word & 0xffffff) << 2
        imm -= (1 << 26) if imm.anybits?(1 << 25)
        (addr + 8 + imm) & 0xffffffff
      end

      def emulator
        OneGadget::Emulators::Arm.new(file)
      end

      # In ARM PIC, +environ+ is reached through the GOT base register (e.g. +r8+),
      # which glibc loads in the function prologue -- outside the candidate window.
      # Before emulating a candidate, detect that register and replay its
      # +ldr rX, [pc]; add rX, pc+ setup so it resolves to +$base + got+.
      def emulate(cmds)
        emu = emulator
        @got_base_regs = seed_got_registers(emu, cmds)
        cmds.each_with_object(emu) { |cmd, obj| break obj unless obj.process(cmd) }
      end

      # A GOT base register seeded from the prologue is a runtime precondition,
      # independent of what its load is *for*: the +[rB, rX]+ dereference itself
      # faults on a wrong base, whether the value it fetches is +environ+ or
      # something unrelated to the effect entirely (e.g. a stack-protector guard
      # read). Surface it as a constraint (mirroring i386's +<reg> is the GOT
      # address of libc+) whenever the candidate actually walked past such a
      # dereference. Seeding only ever primes registers set up *before* the
      # window, so a gadget that establishes the base itself carries no such
      # constraint.
      def resolve(processor)
        res = super
        return res if res.nil? || @got_base_regs.empty?

        @got_base_regs.each do |reg|
          res[:constraints].unshift("#{reg} is the GOT address of libc")
          res[:constraints].delete_if { |c| c.start_with?("writable: #{reg}") }
        end
        res
      end

      # Collect the registers used as a base in a register-offset load (+[rB, rX]+);
      # in glibc's PIC these +rB+ are the GOT base holding +$base + got+.
      # @example
      #   got_base_registers(['88ab2: ldr r2, [r1, r2]'])
      #   #=> ['r1']
      def got_base_registers(cmds)
        cmds.flat_map { |c| c.scan(/\[(r\d+|sl|fp|ip|lr),\s*(?:r\d+|sl|fp|ip|lr)\]/) }
            .flatten.uniq
      end

      # Prime +emu+ with every GOT base register the candidate relies on, by
      # replaying the +ldr rX, [pc]; add rX, pc+ pair (found via {#got_setup_lines})
      # that established it earlier in the function, so +[rX, ...]+ loads inside the
      # candidate resolve against +$base+.
      # @return [Array<String>] the registers actually seeded (their setup was
      #   found before the window), i.e. the GOT-base runtime preconditions.
      def seed_got_registers(emu, cmds)
        start = cmds.first[/\A\s*([0-9a-f]+):/, 1]&.to_i(16)
        return [] if start.nil?

        got_base_registers(cmds).select do |reg|
          lines = got_setup_lines(reg, start) or next false

          lines.each { |line| emu.process(line) }
          true
        end
      end

      # Locate the +ldr reg, [pc, ...]; add reg, pc+ pair that establishes +reg+
      # before address +before+. Returns the two objdump lines, or +nil+.
      def got_setup_lines(reg, before)
        pos = disasm_index[before]
        return if pos.nil?

        add_re = /:\s*add(?:\.w)?\s+#{reg}, pc$/
        add_at = pos.downto([0, pos - 400].max).find { |i| disasm_lines[i].match?(add_re) }
        return if add_at.nil?

        ldr_re = /:\s*ldr(?:\.w)?\s+#{reg}, \[pc[,\]]/
        ldr_at = add_at.downto([0, add_at - 4].max).find { |i| disasm_lines[i].match?(ldr_re) }
        return if ldr_at.nil?

        [disasm_lines[ldr_at], disasm_lines[add_at]]
      end

      def branch_lead_chars
        'bct'
      end

      # +b+ is unconditional; +bne+/+beq+/... and Thumb +cbz+/+cbnz+ are
      # conditional (+bl+/+blx+ are calls, not branches). +bx+/table branches and
      # returns via +pop {..,pc}+ / +ldm .. {..,pc}+ / +mov pc,..+ / +ldr pc,..+
      # terminate the path.
      def branch_kind(line)
        m = branch_mnemonic(line)
        return :conditional if conditional_mnemonic?(m)
        return :unconditional if m == 'b'
        return :terminator if m.start_with?('bx') || %w[tbb tbh].include?(m)
        return :terminator if %w[pop ldm ldmia ldmfd ldmdb].include?(m) && line.match?(/\bpc\b/)

        :terminator if line.match?(/:\s*(mov|ldr)(\.[wn])?\s+pc\b/)
      end

      def conditional_mnemonic?(mnem)
        return true if %w[cbz cbnz].include?(mnem)

        !mnem.start_with?('bl') && mnem.start_with?('b') && CONDS.include?(mnem[1..])
      end

      def branch_mnemonic(line)
        mnemonic(line).sub(/\.[wn]\z/, '')
      end

      def call_str
        'bl'
      end

      def bin_sh_offset
        @bin_sh_offset ||= str_offset('/bin/sh')
      end

      def str_bin_sh?(str)
        str.include?('$base') && str.include?(bin_sh_offset.to_s(16))
      end

      # Offset of the standalone "sh" string (\0-preceded and \0-terminated) that
      # glibc passes as argv[0] in execl("/bin/sh", "sh", ...). Its distance from
      # "/bin/sh" is build-specific, so locate it directly instead of guessing.
      # +nil+ when the libc has no such string.
      def sh_offset
        return @sh_offset if defined?(@sh_offset)

        idx = File.binread(file).index("\x00sh\x00")
        @sh_offset = idx && idx + 1
      end

      def str_sh?(str)
        !sh_offset.nil? && str.include?('$base') && str.include?(sh_offset.to_s(16))
      end

      def global_var?(str)
        str.include?('$base')
      end
    end
  end
end
