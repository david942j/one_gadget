desc 'To auto generate the builds_list file'
task :gen_builds_list do
  rd = File.join(__dir__, '..')
  f = open(File.join(rd, 'builds_list'), 'w')
  Dir.glob(File.join(rd, 'lib', 'one_gadget', 'builds', '*.rb')).sort.each do |file|
    f.puts File.basename(file, '.rb')
  end
  f.close
end
