# frozen_string_literal: true

require 'one_gadget/fetchers/arm'

describe OneGadget::Fetcher::Arm do
  def fetcher(version)
    OneGadget::Fetcher::Arm.new(data_path("arm-libc-#{version}.so"))
  end

  # Terminal-call sites found by disassembling the whole libc and grepping.
  def objdump_sites(fetcher)
    cmd = fetcher.instance_variable_get(:@objdump).command
    lines = `#{cmd}`.lines.grep(/#{fetcher.send(:terminal_call_regexp)}/)
    lines.map { |l| l[/\A\s*([0-9a-f]+):/, 1].to_i(16) }.sort
  end

  describe 'terminal_call_sites (BL byte scan)' do
    # The scan must miss no real bl-to-exec site (a false positive only adds a
    # harmless empty window, so we require superset, not equality). Gadget-level
    # correctness for every arm fixture is covered by one_gadget_arm_spec; here we
    # check the scanner directly on 2.27, whose scan includes one such false
    # positive. (One version keeps this from re-running a full objdump per libc.)
    it 'finds every objdump bl-to-exec site (superset)' do
      skip_unless_objdump
      f = fetcher('2.27')
      sites = f.send(:terminal_call_sites)
      expect(objdump_sites(f) - sites).to be_empty
      expect(sites).not_to be_empty
    end

    it 'falls back to a full disassembly (nil) when the file is not scannable' do
      f = fetcher('2.23')
      allow(f).to receive(:file).and_return(__FILE__) # a Ruby source, not an ELF
      expect(f.send(:terminal_call_sites)).to be_nil
    end
  end
end
