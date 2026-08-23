# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))

require 'fileutils'
require 'tmpdir'

require 'aletheia/arch/aarch64'
require 'aletheia/transport'

# A libc has to be matched to the sysroot that can run it, and the only thing
# that says which release it is, is the libc.
RSpec.describe Aletheia::Transport::Base do
  let(:fixture) { File.expand_path('../spec/data/aarch64-libc-2.27.so', File.dirname(__dir__)) }

  def transport(target)
    described_class.new(Aletheia::Arch::AArch64, target)
  end

  it 'reads the glibc release out of the libc' do
    expect(transport(fixture).send(:libc_version, fixture)).to eq '2.27'
  end

  # Distributions ship the file as plain libc.so.6, which names no version at
  # all; reading the name instead would leave the release unknown and the libc
  # running against whatever sysroot happened to be the default.
  it 'reads it the same however the file is named' do
    Dir.mktmpdir do |dir|
      plain = File.join(dir, 'libc.so.6')
      FileUtils.cp(fixture, plain)
      expect(transport(plain).send(:libc_version, plain)).to eq '2.27'
    end
  end
end
