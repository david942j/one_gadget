require 'rspec/core/rake_task'
require 'rubocop/rake_task'
import 'tasks/builds/list.rake'
import 'tasks/builds/generate.rake'

task default: %i(rubocop spec builds:list)

RuboCop::RakeTask.new(:rubocop) do |task|
end

RSpec::Core::RakeTask.new(:spec) do |task|
  task.pattern = './spec/**/*_spec.rb'
  task.rspec_opts = ['--color', '--require spec_helper', '--order rand']
end
