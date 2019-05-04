# frozen_string_literal: true

require 'logger'
require 'tmpdir'

require 'one_gadget/update'
require 'one_gadget/version'

describe OneGadget::Update do
  before(:all) do
    @tmpdir = File.join(Dir.tmpdir, 'one_gadget')
    FileUtils.mkdir_p(@tmpdir)
    # prevent failing on CI
    @hook_cache_file = lambda do |&block|
      Dir::Tmpname.create('update', @tmpdir) do |tmp|
        stub_const('OneGadget::Update::CACHE_FILE', tmp)
        block.call(tmp)
      end
    end
  end

  after(:all) do
    FileUtils.rm_r(@tmpdir)
  end

  it 'cache_file' do
    skip 'Windows so hard' unless RUBY_PLATFORM =~ /linux/
    @hook_cache_file.call do |path|
      expect(described_class.__send__(:cache_file)).to eq path
      File.chmod(0o000, File.dirname(path))
      expect(described_class.__send__(:cache_file)).to be nil
      File.chmod(0o700, File.dirname(path))
    end
  end

  it 'need_check?' do
    @hook_cache_file.call do |path|
      expect(described_class.__send__(:need_check?)).to be false
      now = Time.now
      allow(Time).to receive(:now).and_return(now + 30 * 24 * 3600)
      allow($stdout).to receive(:tty?).and_return(true)
      expect(described_class.__send__(:need_check?)).to be true
      IO.binwrite(path, 'never')
      expect(described_class.__send__(:need_check?)).to be false
    end
  end

  it 'check!' do
    @hook_cache_file.call do |path|
      allow(described_class).to receive(:need_check?).and_return(true)
      expect { hook_logger { described_class.check! } }.to output(include(<<-EOS.strip)).to_stdout
[OneGadget] Checking for new versions of OneGadget
            To disable this functionality, do
            $ echo never > #{path}

[OneGadget] You have the latest version of OneGadget
      EOS
      stub_const('OneGadget::VERSION', '0.0.0')
      expect { hook_logger { described_class.check! } }.to output(include(<<-EOS.strip)).to_stdout
$ gem update one_gadget && gem cleanup one_gadget
      EOS
    end
  end
end
