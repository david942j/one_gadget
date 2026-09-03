# frozen_string_literal: true

require 'one_gadget/fetchers/mips'

describe OneGadget::Fetchers::Mips do
  # OpenWrt's musl for ath79: big-endian, and shipped with no section headers, so
  # it is also the shape a real router's libc arrives in.
  let(:fetcher) { described_class.new(data_path('mips-musl-1.2.4.so')) }

  # A branch or call takes effect one instruction late, so both addresses of the
  # pair are real entry points and they run different things: entering at the
  # transfer runs it and its delay slot, entering at the delay slot runs that and
  # falls straight past the transfer.
  describe 'delay slots' do
    let(:pair) { ['1000: b 2000 <x>', '1004: move a0,s1', '1008: lw a1,4(s6)', '100c: nop'] }

    def run_from(window)
      emulator = OneGadget::Emulators::Mips.new
      window.each { |line| break unless emulator.process(line) }
      emulator.argument(0).to_s
    end

    it 'offers every address of the pair as an entry' do
      starts = [].tap { |acc| fetcher.executed_windows(pair) { |w| acc << w.first[/\A\w+/] } }
      expect(starts).to eq %w[1008 1004 1000]
    end

    it 'runs the delay slot when entered at the transfer' do
      window = [].tap { |acc| fetcher.executed_windows(pair) { |w| acc << w } }.find { |w| w.first.start_with?('1000') }
      expect(run_from(window)).to eq 's1'
    end

    # A branch's edge into its target leaves from the delay slot, that being the
    # last instruction to run before control transfers -- right for a path
    # arriving *through* the branch, wrong for one starting at the slot, which
    # never executed it.
    it 'refuses to start at a delay slot and then take its branch' do
      # the walk stitches the target on after the delay slot, so a candidate
      # reads: branch, its delay slot, then where the branch goes
      lines = ['1000: b 1030 <x>', '1004: move a0,s1', '1030: lw a1,4(s6)', '1034: nop']
      starts = [].tap { |acc| fetcher.executed_windows(lines) { |w| acc << w.first[/\A\w+/] } }
      # entering at 1004 runs the move and falls to 1008; it never reaches 1030,
      # so that window is not offered. Entering at 1000 is the one that does.
      expect(starts).to eq %w[1030 1000]
    end

    it 'runs the delay slot alone when entered at it, without the branch' do
      window = [].tap { |acc| fetcher.executed_windows(pair) { |w| acc << w } }.find { |w| w.first.start_with?('1004') }
      expect(window.map { |l| l[/\A\w+/] }).to eq %w[1004 1008 100c] # the branch is behind us
      expect(run_from(window)).to eq 's1'
    end
  end

  describe 'naming a call' do
    before(:each) { allow(fetcher).to receive(:got_symbol).with(-31_652).and_return('posix_spawnattr_init') }

    it 'writes the callee beside the jump that reaches it' do
      expect(fetcher.send(:name_got_calls, ['4b3dc: lw t9,-31652(gp)', '4b3e0: jalr t9']))
        .to eq ['4b3dc: lw t9,-31652(gp)', '4b3e0: jalr t9 <posix_spawnattr_init>']
    end

    it 'leaves a call it cannot name as it found it' do
      allow(fetcher).to receive(:got_symbol).with(-30_000).and_return(nil)
      expect(fetcher.send(:name_got_calls, ['20: lw t9,-30000(gp)', '24: jalr t9']))
        .to eq ['20: lw t9,-30000(gp)', '24: jalr t9']
    end

    it 'leaves a call whose target was never loaded from the GOT' do
      expect(fetcher.send(:name_got_calls, ['24: jalr t9'])).to eq ['24: jalr t9']
    end

    # Most calls reach their target another way; carrying the offset over one of
    # those would name the call after a function it never reaches.
    it 'forgets the offset once something else writes the call register' do
      lines = ['4b3dc: lw t9,-31652(gp)', '4b3e0: lw t9,8(s0)', '4b3e4: jalr t9']
      expect(fetcher.send(:name_got_calls, lines)).to eq lines
    end

    it 'reads the register the call really uses, not the one it returns to' do
      expect(fetcher.send(:name_got_calls, ['4b3dc: lw t9,-31652(gp)', '4b3e0: jalr ra,t9']))
        .to eq ['4b3dc: lw t9,-31652(gp)', '4b3e0: jalr ra,t9 <posix_spawnattr_init>']
    end

    it 'keeps the offset across a store, which reads the register' do
      lines = ['4b3dc: lw t9,-31652(gp)', '4b3e0: sw t9,16(sp)', '4b3e4: jalr t9']
      expect(fetcher.send(:name_got_calls, lines).last).to eq '4b3e4: jalr t9 <posix_spawnattr_init>'
    end
  end

  # This arch states its GOT in the dynamic segment, so the table is readable even
  # though this file has no sections at all. gp addresses it from 0x7ff0 in, so an
  # entry's offset is its index counted back from there.
  describe 'reading the GOT' do
    def offset_of_entry(index) = (index * 4) - 0x7ff0

    it 'reads an entry that names a symbol out of the dynamic symbols' do
      expect(fetcher.send(:got_symbol, offset_of_entry(896))).to eq 'free'
    end

    it 'reads an entry that holds the address itself' do
      # a local entry states the address in the file's own byte order, which for
      # this one is big-endian
      expect(fetcher.send(:got_symbol, offset_of_entry(501))).to eq 'execl'
    end

    it 'names nothing for a file that states no GOT' do
      allow(fetcher).to receive(:mips_got).and_return(nil)
      expect(fetcher.send(:got_symbol, -0x7ff0)).to be_nil
    end
  end

  # Everything above, over a real libc: the calls named, the delay slots moved,
  # and terminal calls where the engine can see them.
  describe 'reading the libc' do
    it 'hands the engine a disassembly it can walk' do
      lines = fetcher.send(:disasm_lines)
      named = lines.grep(/jalr\s+t9\s+</)
      expect(named.size).to be > 1000
      expect(lines.count { |line| fetcher.terminal_call_line?(line) }).to be > 0
      expect(fetcher.send(:candidates)).not_to be_empty
    end

    # The window ends at the call, but the call's delay slot runs before control
    # leaves -- so it is emulated too, which is often where an argument is set.
    it 'runs the delay slot of the call a window ends at' do
      call = fetcher.send(:disasm_lines).find { |line| fetcher.terminal_call_line?(line) }
      expect(fetcher.send(:delay_slot_after, call).size).to be 1
      # the call still lands, because the instruction it delays behind came with
      # the window -- without that it would be held back and never applied
      expect(fetcher.send(:emulate, [call]).registers['pc'].to_s).to eq call[/[0-9a-f]+ <.*>/]
    end

    it 'emulates with this arch' do
      expect(fetcher.send(:emulator)).to be_a OneGadget::Emulators::Mips
    end
  end

  describe '#branch_kind' do
    it 'classifies what the walk needs to know' do
      expect(fetcher.send(:branch_kind, '1000: beqz a0,2000 <x>')).to be :conditional
      expect(fetcher.send(:branch_kind, '1000: b 2000 <x>')).to be :unconditional
      expect(fetcher.send(:branch_kind, '1000: jr ra')).to be :terminator
      expect(fetcher.send(:branch_kind, '1000: move a0,s1')).to be_nil
      # a call is not a branch: the walk stitches the window it targets
      expect(fetcher.send(:branch_kind, '1000: jalr t9 <execve>')).to be_nil
    end
  end
end
