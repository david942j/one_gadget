lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'date'

require 'one_gadget/version'

Gem::Specification.new do |s|
  s.name          = 'one_gadget'
  s.version       = ::OneGadget::VERSION
  s.date          = Date.today.to_s
  s.summary       = 'one_gadget'
  s.description   = <<-EOS
  When playing ctf pwn challenges we usually needs the one-gadget of execve('/bin/sh', NULL, NULL).

  This gem provides such gadget finder, no need to use IDA-pro every time like a fool :p.

  Typing `one_gadget /path/to/libc` in terminal and having fun!
  EOS
  s.license       = 'MIT'
  s.authors       = ['david942j']
  s.email         = ['david942j@gmail.com']
  s.files         = Dir['lib/**/*.rb'] + Dir['bin/*'] + %w(README.md)
  s.homepage      = 'https://github.com/david942j/one_gadget'
  s.executables   = ['one_gadget']

  s.required_ruby_version = '>= 2.1.0'

  s.add_runtime_dependency 'elftools', '~> 1.0'

  s.add_development_dependency 'rake', '~> 12.0'
  s.add_development_dependency 'rspec', '~> 3.5'
  s.add_development_dependency 'rubocop', '~> 0.49'
  s.add_development_dependency 'simplecov', '~> 0.16.1'
  s.add_development_dependency 'yard', '~> 0.9'
end
