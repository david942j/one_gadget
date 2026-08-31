# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

import 'tasks/aletheia.rake'
import 'tasks/builds/audit.rake'
import 'tasks/builds/check.rake'
import 'tasks/builds/generate.rake'
import 'tasks/builds/list.rake'
import 'tasks/builds/refresh.rake'
import 'tasks/doc.rake'
import 'tasks/readme.rake'

task default: %i[readme rubocop doc doc:orphans doc:untagged spec builds:list builds:audit builds:check]

RuboCop::RakeTask.new(:rubocop) do |task|
  task.patterns = ['lib/**/*.rb', 'spec/**/*.rb', 'bin/*', 'tasks/**/*.rake', 'aletheia/**/*.rb', 'aletheia/bin/*']
  task.options += ['--force-exclusion', 'lib/one_gadget/builds/*.rb']
end

RSpec::Core::RakeTask.new(:spec) do |task|
  # The harness's own unit specs run with the suite; +.rspec+ says the same for a
  # bare +rspec+, which this task does not read.
  task.pattern = '{spec,aletheia/spec}/**/*_spec.rb'
end
