require 'logger'

require 'one_gadget/update'
require 'one_gadget/version'

describe OneGadget::Update do
  before(:all) do
    # precent fail on CI
    @hook_cache_file = lambda do |&block|
      tmp = Dir::Tmpname.make_tmpname('/tmp/one_gadget/update', nil)
      stub_const('OneGadget::Update::CACHE_FILE', tmp)
      block.call(tmp)
    end

    @hook_logger = lambda do |&block|
      # no method 'reopen' before ruby 2.3
      org_logger = OneGadget::Logger.instance_variable_get(:@logger)
      new_logger = ::Logger.new($stdout)
      new_logger.formatter = org_logger.formatter
      OneGadget::Logger.instance_variable_set(:@logger, new_logger)
      block.call
      OneGadget::Logger.instance_variable_set(:@logger, org_logger)
    end
  end

  after(:all) do
    FileUtils.rm_r('/tmp/one_gadget')
  end

  it 'cache_file' do
    skip 'Windows so hard' unless RUBY_PLATFORM =~ /linux/
    @hook_cache_file.call do |path|
      expect(described_class.send(:cache_file)).to eq path
      File.chmod(0o000, File.dirname(path))
      expect(described_class.send(:cache_file)).to be nil
      File.chmod(0o700, File.dirname(path))
    end
  end

  it 'need_check?' do
    @hook_cache_file.call do |path|
      expect(described_class.send(:need_check?)).to be false
      now = Time.now
      allow(Time).to receive(:now).and_return(now + 7 * 24 * 3600)
      expect(described_class.send(:need_check?)).to be true
      IO.binwrite(path, 'never')
      expect(described_class.send(:need_check?)).to be false
    end
  end

  it 'check!' do
    OneGadget::Helper.color_off!
    @hook_cache_file.call do |path|
      allow(described_class).to receive(:need_check?).and_return(true)
      expect { @hook_logger.call { described_class.check! } }.to output(include(<<-EOS.strip)).to_stdout
[OneGadget] Checking for new versions of OneGadget
            To disable this functionality, do
            $ echo never > #{path}

[OneGadget] You have the latest version of OneGadget
      EOS
      stub_const('OneGadget::VERSION', '0.0.0')
      expect { @hook_logger.call { described_class.check! } }.to output(include(<<-EOS)).to_stdout
$ gem update one_gadget
      EOS
    end
    OneGadget::Helper.color_on!
  end
end
