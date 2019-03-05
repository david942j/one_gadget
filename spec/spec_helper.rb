require 'one_gadget/helper'
require 'simplecov'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
  [SimpleCov::Formatter::HTMLFormatter]
)
SimpleCov.start do
  add_filter '/spec/'
end

module Helpers
  def hook_logger(&_block)
    require 'one_gadget/logger'

    # no method 'reopen' before ruby 2.3
    org_logger = OneGadget::Logger.instance_variable_get(:@logger)
    new_logger = ::Logger.new($stdout)
    new_logger.formatter = org_logger.formatter
    OneGadget::Logger.instance_variable_set(:@logger, new_logger)
    ret = yield
    OneGadget::Logger.instance_variable_set(:@logger, org_logger)
    ret
  end
end

RSpec.configure do |config|
  config.before(:suite) { OneGadget::Helper.color_off! }
  config.include Helpers
end
