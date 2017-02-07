require 'codeclimate-test-reporter'
require 'simplecov'
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
  [SimpleCov::Formatter::HTMLFormatter, CodeClimate::TestReporter::Formatter]
)
SimpleCov.start do
  add_filter '/spec/'
end
