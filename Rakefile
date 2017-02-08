require 'rspec/core/rake_task'
require 'rubocop/rake_task'

task default: %i(rubocop spec)

RuboCop::RakeTask.new(:rubocop) do |task|
  task.patterns = ['lib/**/*.rb', 'test/**/*.rb']
  task.formatters = ['files']
end

RSpec::Core::RakeTask.new(:spec) do |task|
  task.pattern = './spec/**/*_spec.rb'
  task.rspec_opts = ['--color', '--require spec_helper', '--order rand']
end

task default: [:spec]
