require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'yard'

import 'tasks/builds/generate.rake'
import 'tasks/builds/list.rake'
import 'tasks/readme.rake'

task default: %i(readme rubocop spec builds:list)

RuboCop::RakeTask.new(:rubocop) do |task|
  task.patterns = ['lib/**/*.rb', 'spec/**/*.rb', 'bin/*', 'tasks/**/*.rake']
  task.options += ['--force-exclusion', 'lib/one_gadget/builds/*.rb']
end

RSpec::Core::RakeTask.new(:spec) do |task|
  task.pattern = './spec/**/*_spec.rb'
  task.rspec_opts = ['--color', '--require spec_helper', '--order rand', '--warning']
end

YARD::Rake::YardocTask.new(:doc) do |t|
  t.files = Dir['lib/**/*.rb'] - Dir['lib/one_gadget/builds/*.rb']
  t.stats_options = ['--list-undoc']
end
