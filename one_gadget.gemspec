lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'one_gadget/version'
require 'date'

Gem::Specification.new do |s|
  s.name          = 'one_gadget'
  s.version       = ::OneGadget::VERSION
  s.date          = Date.today.to_s
  s.summary       = 'one_gadget'
  s.description   = <<-EOS
  When playing ctf pwn challenges we usually needs the one-gadget of execve('/bin/sh', NULL, NULL).
  This gem provides such gadget finder, no need to use IDA-pro every time like a fool.
  Also provides the command-line tool `one_gadget` for easy usage.
  EOS
  s.license       = 'MIT'
  s.authors       = ['david942j']
  s.email         = ['david942j@gmail.com']
  s.files         = Dir['lib/**/*.rb'] + Dir['bin/*'] + %w(README.md)
  s.test_files    = Dir['spec/**/*']
  s.homepage      = 'https://github.com/david942j/one_gadget'
  s.executables   = ['one_gadget']

  s.required_ruby_version = '>= 2.1.0'

  s.add_development_dependency 'rspec', '~> 3.5'
  s.add_development_dependency 'rubocop', '~> 0.46'
  s.add_development_dependency 'rake', '~> 12.0'
  s.add_development_dependency 'simplecov', '~> 0.13.0'
  s.add_development_dependency 'codeclimate-test-reporter', '~> 0.6'
end
