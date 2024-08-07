# frozen_string_literal: true

TEMPLATE = <<-EOS
require 'one_gadget/gadget'
INFO
build_id = File.basename(__FILE__, '.rb').split('-').last
GADGETS
EOS

GADGET_TEMPLATE = <<-EOS
OneGadget::Gadget.add(build_id, OFFSET,
                      constraints: CONSTRAINTS,
                      effect: EFFECT)
EOS

namespace :builds do
  desc 'Generates lib/builds/*.rb from libc files'
  # bundle exec rake "builds:generate[../libcdb/libc/**/*]"
  # bundle exec rake "builds:generate[../libcdb/libc/**/*, overwrite]"
  task :generate, :pattern, :mode do |_t, args|
    require 'elftools'
    require 'one_gadget'
    entries = Dir.glob(args.pattern).select { |f| File.file?(f) && !File.symlink?(f) }
    overwrite = args.mode == 'overwrite'
    total = entries.size
    if total > 1
      print "Process #{total} files? (Y/n) "
      s = $stdin.gets
      next if s.upcase[0] == 'N'
    end
    path = File.join(__dir__, '..', '..', 'lib', 'one_gadget', 'builds')
    @skipped = 0
    @failed = 0
    entries.sort.each_with_index do |libc_file, i|
      print "[#{i + 1}/#{total}] Processing #{libc_file} .. "
      info = libc_info(libc_file)
      next failed('parse info fail') if info.nil? # error when fetching info
      next failed('build id not found') if info[:build_id].nil? # no .note.gnu.build.id section

      version = info[:info].scan(/version ([\d.]+\d)/).flatten.first
      next skipped('version too old') if Gem::Version.new(version) < Gem::Version.new('2.19')

      filename = File.join(path, "libc-#{version}-#{info[:build_id]}.rb")
      next skipped('file exists') if !overwrite && File.file?(filename)

      gadgets = OneGadget.gadgets(file: libc_file, force_file: true, details: true, level: 100)
      next failed('no gadgets found') if gadgets.empty?

      content = template(info, gadgets)
      File.write(filename, content)
      puts 'done'
    end
    puts "Total #{total} files, \e[32m#{total - @skipped - @failed}\e[0m succeeded, " \
         "\e[33m#{@skipped}\e[0m skipped, and \e[31m#{@failed}\e[0m failed."
  end

  def template(info, gadgets)
    info_str = info[:info].lines.map { |c| "# #{c}" }.join
    gadgets_str = gadgets.map do |gadget|
      %i[offset constraints effect].reduce(GADGET_TEMPLATE) do |str, attr|
        str.sub(attr.to_s.upcase, gadget.__send__(attr).inspect)
      end
    end.join
    TEMPLATE.sub('INFO', info_str).sub('GADGETS', gadgets_str)
  end

  def libc_info(filename)
    file = File.open(filename)
    libc = ELFTools::ELFFile.new(file)
    build_id = libc.build_id
    arch = libc.machine
    return nil unless ['Advanced Micro Devices X86-64', 'Intel 80386', 'AArch64'].include?(arch)
    # let's skip amd64 with 32bit, i.e. x32
    return nil if arch.start_with?('Advanced') && libc.elf_class == 32

    str = file.read
    st = str.index('GNU C Library')
    return nil if st.nil?

    len = str[st..].index("\x00")
    return nil if len.nil?

    fname = filename.sub('../libcdb', 'https://gitlab.com/david942j/libcdb/blob/master')
    {
      build_id:,
      info: "#{fname}\n\n#{arch}\n\n#{str[st, len]}"
    }
  rescue ELFTools::ELFError, EOFError # corrupted elf file
    nil
  ensure
    file.close
  end

  def failed(msg)
    puts "fail: #{msg}"
    @failed += 1
  end

  def skipped(msg)
    puts "skip: #{msg}"
    @skipped += 1
  end
end
