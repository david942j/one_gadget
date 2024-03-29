# frozen_string_literal: true

desc 'To auto generate README.md from README.tpl'
task :readme do
  next if ENV['CI']

  @tpl = File.binread('README.tpl.md')

  def replace(prefix)
    @tpl.gsub!(/#{prefix}\(.*\)/) do |s|
      yield(s[(prefix.size + 1)...-1])
    end
  end

  replace('SHELL_OUTPUT_OF') do |cmd|
    out = "$ #{cmd}\n"
    out + `#{cmd}`.lines.map do |c|
      next "#\n" if c.strip.empty?

      "# #{c}"
    end.join
  end

  require 'one_gadget'
  replace('RUBY_OUTPUT_OF') do |cmd|
    res = instance_eval(cmd)
    "#{cmd}\n#=> #{res.inspect}\n"
  end

  File.binwrite('README.md', @tpl)
end
