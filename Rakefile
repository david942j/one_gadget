# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'yard'

import 'tasks/aletheia.rake'
import 'tasks/builds/generate.rake'
import 'tasks/builds/list.rake'
import 'tasks/builds/refresh.rake'
import 'tasks/readme.rake'

task default: %i[readme rubocop spec builds:list]

RuboCop::RakeTask.new(:rubocop) do |task|
  task.patterns = ['lib/**/*.rb', 'spec/**/*.rb', 'bin/*', 'tasks/**/*.rake', 'aletheia/**/*.rb', 'aletheia/bin/*']
  task.options += ['--force-exclusion', 'lib/one_gadget/builds/*.rb']
end

RSpec::Core::RakeTask.new(:spec) do |task|
  # The harness's own unit specs run with the suite; +.rspec+ says the same for a
  # bare +rspec+, which this task does not read.
  task.pattern = '{spec,aletheia/spec}/**/*_spec.rb'
end

YARD::Rake::YardocTask.new(:doc) do |t|
  t.files = Dir['lib/**/*.rb'] - Dir['lib/one_gadget/builds/*.rb']
  t.stats_options = ['--list-undoc']
end
