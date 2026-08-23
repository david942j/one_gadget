# frozen_string_literal: true

require 'simplecov'
require 'simplecov_json_formatter'

SimpleCov.start do
  formatter SimpleCov::Formatter::MultiFormatter.new([
                                                       SimpleCov::Formatter::JSONFormatter,
                                                       SimpleCov::Formatter::HTMLFormatter
                                                     ])
  skip '/spec/'
  # The harness runs under gdb/qemu against real libcs, which CI has none of;
  # its unit specs run here, but its coverage is not what this bar is about.
  skip '/aletheia/'
  skip '/lib/one_gadget/builds/'
  # The suite covers every line, so anything less is a real gap rather than a
  # number to interpret -- and a new line arrives covered or the build says so.
  minimum_coverage line: 100
end

# These requirements must be put after SimpleCov.start,
# otherwise the coverage report will not include them.
require 'one_gadget/helper'
require 'one_gadget/logger'

module Helper
  def hook_logger
    OneGadget::Logger.instance_variable_get(:@logger).reopen($stdout)
    yield
  end

  def skip_on_windows
    skip 'Cannot run on Windows' if /cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM
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
  config.include Helper
end
