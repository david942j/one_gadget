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

      # An ARM function's symbol value carries the Thumb bit; the address is what
      # is left of it.
      def symbol_address(value)
        value & ~1
      end

      # A32 and Thumb both spell a direct call +BL+, in different encodings, and a
      # Thumb one is not word-aligned, so every halfword has to be considered.
      def scan_calls(base, data, targets)
        halves = data.unpack('v*') # 16-bit little-endian halfwords
        sites = []
        halves.each_with_index do |high, i|
          low = halves[i + 1] or next

          # Decoding a target is the expensive half, and a whole .text is hundreds
          # of thousands of halfwords: ask what the encoding could be first.
          addr = base + i * 2
          if thumb_bl?(high, low) && targets.key?(thumb_bl_target(addr, high, low) & ~1)
            sites << addr
            next
          end
          next unless i.even? && a32_bl?(low)

          sites << addr if targets.key?(a32_bl_target(addr, high | (low << 16)))
        end
        sites.uniq
      end

      def thumb_bl?(high, low)
        high.between?(0xf000, 0xf7ff) && low.allbits?(0xd000)
      end

      # The +cond|101|1+ of an A32 BL, read off the word's top byte -- which is the
      # top byte of its second halfword.
      def a32_bl?(low)
        ((low >> 8) & 0x0f) == 0x0b
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
        emu.note_instruction_set(cmds)
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

        gots = @got_base_regs.to_h { |reg| [reg, got_base_constraint(processor, reg)] }
        return nil unless gots.values.all?

        gots.each do |reg, got|
          res[:constraints].unshift(got)
          res[:constraints].delete_if { |c| c.start_with?("writable: #{reg}") }
        end
        res
      end

      # A general-purpose register, by number or by the role name objdump prints.
      REG = /r\d+|sl|fp|ip|lr/
      private_constant :REG

      # A register-offset load, +[rB, rX]+.
      REG_OFFSET_LOAD = /\[(#{REG}),\s*(?:#{REG})\]/
      private_constant :REG_OFFSET_LOAD

      # Collect the registers used as a base in a register-offset load (+[rB, rX]+);
      # in glibc's PIC these +rB+ are the GOT base holding +$base + got+.
      # @example
      #   got_base_registers(['88ab2: ldr r2, [r1, r2]'])
      #   #=> ['r1']
      def got_base_registers(cmds)
        cmds.flat_map { |c| c.scan(REG_OFFSET_LOAD) }
            .flatten.uniq
      end

      # The patterns naming one register: what uses it as a load base, and the
      # +ldr+/+add+ pair that establishes it. Built once per register -- they are
      # asked of every line of every window a candidate yields.
      # @param [String] reg
      # @return [Hash{Symbol => Regexp}]
      def reg_patterns(reg)
        (@reg_patterns ||= {})[reg] ||= {
          use: /\[#{reg},\s*(?:#{REG})\]/,
          add: /:\s*add(?:\.w)?\s+#{reg}, pc$/,
          ldr: /:\s*ldr(?:\.w)?\s+#{reg}, \[pc[,\]]/
        }
      end

      # Whether the candidate builds +reg+'s base itself, before the +[reg, rX]+
      # that relies on it. Replaying a prologue setup for such a register would
      # apply it twice -- once as the seed, once by emulating the window that
      # contains it -- leaving a value no caller can supply, described by a
      # constraint naming the register's *entry* value.
      # @example arm-2.27's +0x73f2a+, whose first instruction is +add r3, pc+
      def window_establishes?(reg, cmds)
        pattern = reg_patterns(reg)
        use = cmds.index { |c| c.match?(pattern[:use]) } or return false

        cmds[0...use].any? { |c| c.match?(pattern[:add]) }
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
          next false if window_establishes?(reg, cmds)

          lines = got_setup_lines(reg, start) or next false

          lines.each { |line| emu.process(line) }
          true
        end
      end

      # Locate the +ldr reg, [pc, ...]; add reg, pc+ pair that establishes +reg+
      # before address +before+. Returns the two objdump lines, or +nil+.
      def got_setup_lines(reg, before)
        (@got_setup ||= {})[[reg, before]] ||= find_got_setup_lines(reg, before)
      end

      # {#got_setup_lines} without the memo: overlapping candidates ask the same
      # register at the same address again and again, and the answer only depends
      # on the disassembly.
      def find_got_setup_lines(reg, before)
        pos = disasm_index[before]
        return if pos.nil?

        lines = disasm_lines
        pattern = reg_patterns(reg)
        add_at = pos.downto([0, pos - 400].max).find { |i| lines[i].match?(pattern[:add]) }
        return if add_at.nil?

        ldr_at = add_at.downto([0, add_at - 4].max).find { |i| lines[i].match?(pattern[:ldr]) }
        return if ldr_at.nil?

        [lines[ldr_at], lines[add_at]]
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
    end
  end
end
