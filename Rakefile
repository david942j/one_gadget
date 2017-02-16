require 'rspec/core/rake_task'
require 'rubocop/rake_task'
import 'tasks/gen_builds_list.rake'

task default: %i(rubocop spec gen_builds_list)

RuboCop::RakeTask.new(:rubocop) do |task|
  task.patterns = ['lib/**/*.rb', 'spec/**/*.rb', 'bin/*']
end

RSpec::Core::RakeTask.new(:spec) do |task|
  task.pattern = './spec/**/*_spec.rb'
  task.rspec_opts = ['--color', '--require spec_helper', '--order rand']
end
