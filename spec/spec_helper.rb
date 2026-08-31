# frozen_string_literal: true

require 'simplecov'
require 'simplecov_json_formatter'
require 'tmpdir'

require 'elftools'

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
require 'one_gadget'
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

  # An embedded libc commonly ships with its section headers removed -- OpenWrt
  # does it to musl to save flash. Nothing is missing from such a file, but the
  # usual route to its code and symbols is, so +file+ must still report what it
  # reports intact. Compared at level 100 only: nothing is trimmed above
  # {OneGadget::Fetchers::RAW_LEVEL}, and every lower level is a function of that
  # set, so matching there matches at every level.
  # @param [String] file A fixture name, as {#data_path} takes it.
  # @return [void]
  def expect_same_gadgets_when_stripped(file)
    path = data_path(file)
    Dir.mktmpdir do |dir|
      stripped = File.join(dir, 'stripped.so')
      File.open(path) do |fd|
        elf = ELFTools::ELFFile.new(fd)
        elf.header.e_shoff = 0
        elf.header.e_shnum = 0
        elf.header.e_shstrndx = 0
        elf.save(stripped)
      end
      # the state the file is in: objdump disassembles sections, and there are none
      expect(`objdump -d #{stripped}`).not_to match(/^\s*[0-9a-f]+:/)
      expect(OneGadget.gadgets(file: stripped, force_file: true, level: 100))
        .to eq OneGadget.gadgets(file: path, force_file: true, level: 100)
    end
  end
end

RSpec.configure do |config|
  config.before(:suite) { OneGadget::Helper.color_off! }
  config.include Helper
end
