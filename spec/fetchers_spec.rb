# frozen_string_literal: true

require 'one_gadget/fetchers'
require 'one_gadget/gadget'

describe OneGadget::Fetchers do
  def gadget(offset, constraints)
    OneGadget::Gadget::Gadget.new(offset, constraints: constraints, effect: 'execve("/bin/sh", 0, 0)')
  end

  describe '.supported_architecture?' do
    it 'answers for what a fetcher exists for' do
      # the build database generator asks this rather than keeping a list of its
      # own, which is how riscv64 was left out of it
      expect(described_class.supported_architecture?(:riscv64)).to be true
      expect(described_class.supported_architecture?(:amd64)).to be true
      expect(described_class.supported_architecture?(:ppc64)).to be false
    end
  end

  describe '.trim_gadgets' do
    # Gadgets asking for the very same constraints are interchangeable, so the
    # last one represents them all -- and it has to be the same one however the
    # emulator happened to run into them.
    it 'picks the same representative whatever order the gadgets arrive in' do
      dup = [gadget(0x2000, ['rax == NULL']), gadget(0x1000, ['rax == NULL'])]
      picked = [dup, dup.reverse].map { |gs| described_class.send(:trim_gadgets, gs).map(&:offset) }
      expect(picked).to eq [[0x2000], [0x2000]]
    end

    it 'drops a gadget whose constraints an easier one already meets' do
      gadgets = [gadget(0x2000, ['rax == NULL', 'writable: rsp']), gadget(0x1000, ['rax == NULL'])]
      expect(described_class.send(:trim_gadgets, gadgets).map(&:offset)).to eq [0x1000]
    end
  end

  describe '.from_build_id' do
    let(:build_id) { '60131540dadc6796cab33388349e6e4e68692053' }

    # A build-id lookup answers with the same set the very same libc would give
    # as a file: the level says what to show, not where the answer came from.
    it 'narrows the stored gadgets to the requested level' do
      trimmed = described_class.from_build_id(build_id, remote: false, level: 1)
      raw = described_class.from_build_id(build_id, remote: false, level: OneGadget::Fetchers::RAW_LEVEL)
      expect(raw.size).to be >= trimmed.size
      expect(trimmed).to eq described_class.send(:trim_gadgets, raw)
    end

    it 'returns nil for an unknown build id' do
      expect(described_class.from_build_id('0' * 40, remote: false)).to be_nil
    end
  end
end
