# frozen_string_literal: true

require 'one_gadget/emulators/safe_calls'

describe OneGadget::Emulators::SafeCalls do
  it 'orders the specific setsigmask/setsigdefault keys before the generic prefix' do
    # dispatch_safe_call matches the first key that is a substring of the symbol,
    # so the specific entries must precede "posix_spawnattr_".
    keys = described_class::COMMON.keys
    expect(keys.index('posix_spawnattr_setsigmask')).to be < keys.index('posix_spawnattr_')
    expect(keys.index('posix_spawnattr_setsigdefault')).to be < keys.index('posix_spawnattr_')
  end
end
