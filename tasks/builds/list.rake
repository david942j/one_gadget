# frozen_string_literal: true

namespace :builds do
  desc 'To auto generate the builds_list file'
  task :list do
    rd = File.join(__dir__, '..', '..')
    f = File.open(File.join(rd, 'builds_list'), 'w')
    Dir.glob(File.join(rd, 'lib', 'one_gadget', 'builds', '*.rb')).sort.each do |file|
      f.puts File.basename(file, '.rb')
    end
    f.close
  end
end
