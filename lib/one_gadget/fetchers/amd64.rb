require 'one_gadget/emulators/amd64'
require 'one_gadget/fetchers/base'

module OneGadget
  module Fetcher
    # Fetcher for amd64.
    class Amd64 < OneGadget::Fetcher::Base
      # Gadgets for amd64 glibc.
      # @return [Array<OneGadget::Gadget::Gadget>] Gadgets found.
      def find
        candidates.map do |candidate|
          lines = candidate.lines
          # use processor to find which can lead to a valid one-gadget call.
          gadgets = []
          (lines.size - 2).downto(0) do |i|
            processor = emulate(lines[i..-1])
            options = resolve(processor)
            next if options.nil? # impossible be a gadget
            offset = offset_of(lines[i])
            gadgets << OneGadget::Gadget::Gadget.new(offset, options)
          end
          gadgets
        end.flatten
      end

      private

      def emulate(cmds)
        cmds.each_with_object(OneGadget::Emulators::Amd64.new) { |cmd, obj| break obj unless obj.process!(cmd) }
      end

      def candidates
        # one basic block case
        bin_sh_hex = str_offset('/bin/sh').to_s(16)
        cands = super do |candidate|
          next false unless candidate.include?(bin_sh_hex) # works in x86-64
          next false unless candidate.lines.last.include?('execve') # only care execve
          true
        end
        cands + jmp_case_candidates # + sigaction_case_candidates
      end

      # find gadgets in form:
      #   lea rdi, '/bin/sh'
      #   ...
      #   jmp xxx
      # xxx:
      #   ...
      #   call execve
      def jmp_case_candidates
        bin_sh_hex = str_offset('/bin/sh').to_s(16)
        `#{objdump_cmd}|egrep 'rdi.*# #{bin_sh_hex}' -A 3`.split('--').map do |cand|
          cand = cand.lines.map(&:strip).reject(&:empty?)
          jmp_at = cand.index { |c| c.include?('jmp') }
          next nil if jmp_at.nil?
          cand = cand[0..jmp_at]
          jmp_addr = cand.last.scan(/jmp\s+([\da-f]+)\s/)[0][0].to_i(16)
          dump = `#{objdump_cmd(start: jmp_addr, stop: jmp_addr + 100)}|egrep '[0-9a-f]+:'`
          remain = dump.lines.map(&:strip).reject(&:empty?)
          remain = remain[0..remain.index { |r| r.match(/call.*<execve[^+]*>/) }]
          [cand + remain].join("\n")
        end.compact
      end

      def resolve(processor)
        # must end with execve
        return unless processor.registers['rip'].to_s.include?('execve')
        # check rdi should always related to rip
        return unless processor.registers['rdi'].to_s.include?('rip')
        rsi, cons = rsi_cons(processor)
        return if rsi.nil?
        rdx = processor.registers['rdx'].to_s
        env_cons = should_null(rdx, allow_global: true)
        cons << env_cons if env_cons
        { constraints: cons, effect: %(execve("/bin/sh", #{rsi}, #{env_cons ? rdx : 'environ'})) }
      end

      # rsi or [rsi] should be zero
      def rsi_cons(processor)
        rsi = processor.registers['rsi'].to_s
        return [rsi, [should_null(rsi)]] unless rsi.start_with?('rsp')
        # now rsi is in form rsp+<num>, let's see if stack[<num>] is defined.
        num = Integer(rsi[3..-1])
        # stack slot not defined, back to normal case
        return [rsi, [should_null(rsi)]] unless processor.stack.key?(num)
        slot = processor.stack[num].to_s
        return if slot.include?('rip')
        [rsi, ["#{slot} == NULL"]]
      end

      def should_null(str, allow_global: false)
        return nil if allow_global && str.include?('rip')
        ret = "[#{str}] == NULL"
        ret += " || #{str} == NULL" unless str.include?('rsp')
        ret
      end
    end
  end
end
