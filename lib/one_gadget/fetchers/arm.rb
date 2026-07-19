# frozen_string_literal: true

require 'one_gadget/emulators/arm'
require 'one_gadget/fetchers/base'

module OneGadget
  module Fetcher
    # Fetcher for 32-bit ARM (A32 / Thumb-2).
    class Arm < Base
      private

      def emulator
        OneGadget::Emulators::Arm.new(file)
      end

      # In ARM PIC, +environ+ is reached through the GOT base register (e.g. +r8+),
      # which glibc loads in the function prologue -- outside the candidate window.
      # Before emulating a candidate, detect that register and replay its
      # +ldr rX, [pc]; add rX, pc+ setup so it resolves to +$base + got+.
      def emulate(cmds)
        emu = emulator
        seed_got_registers(emu, cmds)
        cmds.each_with_object(emu) { |cmd, obj| break obj unless obj.process(cmd) }
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
      def seed_got_registers(emu, cmds)
        start = cmds.first[/\A\s*([0-9a-f]+):/, 1]&.to_i(16)
        return if start.nil?

        got_base_registers(cmds).each do |reg|
          got_setup_lines(reg, start)&.each { |line| emu.process(line) }
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

      # The target's full objdump disassembly as stripped +"ADDR: insn"+ lines,
      # cached for the lifetime of the fetcher.
      def disasm_lines
        @disasm_lines ||= `#{@objdump.command}`.lines.map(&:strip).grep(/\A[0-9a-f]+:/)
      end

      # Map from an instruction's address to its index in {#disasm_lines}, so a
      # given address can be located in the disassembly in O(1).
      def disasm_index
        @disasm_index ||= disasm_lines.each_with_index.to_h { |line, i| [line[/\A([0-9a-f]+):/, 1].to_i(16), i] }
      end

      # If str contains a branch instruction. +bl+/+blx+ are calls, not branches.
      def branch?(str)
        mnem = (str[/\A\s*[0-9a-f]+:\s*(\S+)/, 1] || str.split.first || '').sub(/\.(w|n)\z/, '')
        return false if mnem.start_with?('bl')

        mnem.match?(/\A(b|bx|cbn?z|tbb|tbh|
                       b(eq|ne|cs|hs|cc|lo|mi|pl|vs|vc|hi|ls|ge|lt|gt|le)|
                       bx(eq|ne|cs|hs|cc|lo|mi|pl|vs|vc|hi|ls|ge|lt|gt|le))\z/x)
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
