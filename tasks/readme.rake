desc 'To auto generate the builds_list file'
task :readme do
  next if ENV['CI']
  @tpl = IO.binread('README.tpl')

  def replace(prefix)
    @tpl.gsub!(/#{prefix}\(.*\)/) do |s|
      yield(s[(prefix.size + 1)...-1])
    end
  end

  replace('SHELL_OUTPUT_OF') do |cmd|
    '$ ' + cmd + "\n" + `#{cmd}`.lines.map do |c|
      next "#\n" if c.strip.empty?
      '# ' + c
    end.join
  end

  require 'one_gadget'
  replace('RUBY_OUTPUT_OF') do |cmd|
    res = instance_eval(cmd)
    cmd + "\n" + '#=> ' + res.inspect + "\n"
  end

  IO.binwrite('README.md', @tpl)
end
