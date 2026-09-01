# frozen_string_literal: true

require 'one_gadget/fetchers/mips'

describe OneGadget::Fetchers::Mips do
  # OpenWrt's musl for ath79: big-endian, and shipped with no section headers, so
  # it is also the shape a real router's libc arrives in.
  let(:fetcher) { described_class.new(data_path('mips-musl-1.2.4.so')) }

  def swap(lines) = fetcher.send(:swap_delay_slots, lines)

  describe 'delay slots' do
    # The instruction after a branch runs before the branch takes effect, so
    # stating it first is stating the order things happen in.
    it 'states the slot before the branch it belongs to' do
      expect(swap(['4b3c8: beq a0,v1,4b3d8 <x>', '4b3cc: sw v0,236(sp)', '4b3d0: ori v0,v0,0x4']))
        .to eq ['4b3cc: sw v0,236(sp)', '4b3c8: beq a0,v1,4b3d8 <x>', '4b3d0: ori v0,v0,0x4']
    end

    it 'does the same for a call, which is where an argument often sits' do
      expect(swap(['4b3e0: jalr t9 <posix_spawn>', '4b3e4: move a0,s1']))
        .to eq ['4b3e4: move a0,s1', '4b3e0: jalr t9 <posix_spawn>']
    end

    it 'leaves a run of ordinary instructions alone' do
      lines = ['4b3d8: addiu s1,sp,508', '4b3dc: lw t9,-31652(gp)']
      expect(swap(lines)).to eq lines
    end

    # A branch's own delay slot is never itself a branch, so a swapped pair is
    # complete and the next pair starts after it.
    it 'takes each pair once' do
      expect(swap(['1000: b 2000 <x>', '1004: nop', '1008: b 3000 <x>', '100c: nop']))
        .to eq ['1004: nop', '1000: b 2000 <x>', '100c: nop', '1008: b 3000 <x>']
    end

    it 'refuses to start a candidate at one' do
      lines = swap(['1000: b 2000 <x>', '1004: nop', '1008: move a0,s1', '100c: nop'])
      starts = [].tap { |acc| fetcher.executed_windows(lines) { |w| acc << w.first } }
      # 0x1004 is the delay slot: entering there would fall past the branch, not
      # through it, so it is not an entry this listing describes
      expect(starts.map { |l| l[/\A[0-9a-f]+/] }).to eq %w[1008 1000]
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
      # the instruction before a named call is its delay slot, which really runs first
      call = lines.index { |line| fetcher.terminal_call_line?(line) }
      expect(fetcher.send(:offset_of, lines[call - 1])).to be > fetcher.send(:offset_of, lines[call])
      expect(fetcher.send(:candidates)).not_to be_empty
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
