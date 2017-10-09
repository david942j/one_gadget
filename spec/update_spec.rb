require 'logger'
require 'tempfile'

require 'one_gadget/update'
require 'one_gadget/version'

describe OneGadget::Update do
  before(:all) do
    # precent fail on CI
    @hook_cache_file = lambda do |&block|
      tmp = Tempfile.new('update')
      stub_const('OneGadget::Update::CACHE_FILE', tmp.path)
      block.call(tmp.path)
      tmp.close
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

  it 'cache_file' do
    stub_const('OneGadget::Update::CACHE_FILE', '/bin/pusheeeeeen')
    expect(described_class.send(:cache_file)).to be nil
    @hook_cache_file.call do |path|
      expect(described_class.send(:cache_file)).to eq path
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
      expect { @hook_logger.call { described_class.check! } }.to output(<<-EOS).to_stdout
[OneGadget] Checking for new versions of OneGadget
            To disable this functionality, do
            $ echo never > #{path}

[OneGadget] You have the latest version of OneGadget (#{OneGadget::VERSION})!

      EOS
      stub_const('OneGadget::VERSION', '0.0.0')
      expect { @hook_logger.call { described_class.check! } }.to output(include(<<-EOS)).to_stdout
$ gem update one_gadget
      EOS
    end
    OneGadget::Helper.color_on!
  end
end
