# frozen_string_literal: true

require 'one_gadget/emulators/safe_calls'
require 'one_gadget/emulators/amd64'
require 'one_gadget/emulators/i386'
require 'one_gadget/emulators/arm'
require 'one_gadget/emulators/aarch64'

describe OneGadget::Emulators::SafeCalls do
  # The bug this guards against: a per-arch copy of the posix_spawn table let x86
  # gain a setsigmask constraint that arm/aarch64 silently lacked. Every arch must
  # carry the shared requirements verbatim, so a fix to one reaches all of them.
  it 'is inherited unchanged by every architecture emulator' do
    common = described_class::COMMON
    [OneGadget::Emulators::Amd64, OneGadget::Emulators::I386,
     OneGadget::Emulators::Arm, OneGadget::Emulators::AArch64].each do |klass|
      common.each do |name, req|
        expect(klass::SAFE_CALLS[name]).to eq(req), "#{klass}::SAFE_CALLS[#{name.inspect}]"
      end
    end
  end

  it 'orders the specific setsigmask/setsigdefault keys before the generic prefix' do
    # dispatch_safe_call matches the first key that is a substring of the symbol,
    # so the specific entries must precede "posix_spawnattr_".
    keys = described_class::COMMON.keys
    expect(keys.index('posix_spawnattr_setsigmask')).to be < keys.index('posix_spawnattr_')
    expect(keys.index('posix_spawnattr_setsigdefault')).to be < keys.index('posix_spawnattr_')
  end
end
