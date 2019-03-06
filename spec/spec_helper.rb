require 'simplecov'

require 'one_gadget/helper'
require 'one_gadget/logger'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
  [SimpleCov::Formatter::HTMLFormatter]
)
SimpleCov.start do
  add_filter '/spec/'
end

module Helpers
  def hook_logger
    OneGadget::Logger.instance_variable_get(:@logger).reopen($stdout)
    yield
  end

  def skip_unless_objdump
    skip 'binutils not installed' if OneGadget::Helper.which('objdump').nil?
  end

  def data_path(file)
    File.join(__dir__, 'data', file)
  end
end

RSpec.configure do |config|
  config.before(:suite) { OneGadget::Helper.color_off! }
  config.include Helpers
end
