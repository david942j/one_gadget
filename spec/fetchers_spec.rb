# frozen_string_literal: true

require 'one_gadget/fetchers'
require 'one_gadget/gadget'

describe OneGadget::Fetchers do
  def gadget(offset, constraints)
    OneGadget::Gadget::Gadget.new(offset, constraints: constraints, effect: 'execve("/bin/sh", 0, 0)')
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
end
