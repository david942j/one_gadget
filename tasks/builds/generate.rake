namespace :builds do
  desc 'To auto generate rb files into lib/builds/*.rb'
  task :generate, :pattern do |_t, args|
    require 'elftools'
    require 'one_gadget'
    total = Dir.glob(args.pattern).size
    if total > 1
      print "Process #{total} files? (Y/n) "
      s = STDIN.gets
      next if s.upcase[0] == 'N'
    end
    path = File.join(__dir__, '..', '..', 'lib', 'one_gadget', 'builds')
    @skipped = 0
    @failed = 0
    Dir.glob(args.pattern).sort.each_with_index do |libc_file, i|
      print "[#{i + 1}/#{total}] Processing #{libc_file}.. "
      info = libc_info(libc_file)
      next failed('parse info fail') if info.nil? # error when fetching info
      next failed('build id not found') if info[:build_id].nil? # no .note.gnu.build.id section
      version = info[:info].scan(/version ([\d.]+)/).flatten.first
      next skipped('version too old') if Gem::Version.new(version) < Gem::Version.new('2.19')
      filename = File.join(path, "libc-#{version}-#{info[:build_id]}.rb")
      next skipped('file exists') if File.file?(filename)
      gadgets = OneGadget.gadgets(file: libc_file, force_file: true, details: true)
      next failed('no gadgets found') if gadgets.empty?
      content = template(info, gadgets)
      File.open(filename, 'w') { |f| f.write(content) }
      puts 'done'
    end
    puts "Total #{total} files, skipped #{@skipped} files, failed #{@failed} files"
  end

  TEMPLATE = <<-EOS
require 'one_gadget/gadget'
INFO
build_id = File.basename(__FILE__, '.rb').split('-').last
GADGETS
  EOS
             .freeze
  GADGET_TEMPLATE = <<-EOS
OneGadget::Gadget.add(build_id, OFFSET,
                      constraints: CONSTRAINTS,
                      effect: EFFECT)
  EOS
                    .freeze
  def template(info, gadgets)
    info_str = info[:info].lines.map { |c| '# ' + c }.join
    gadgets_str = gadgets.map do |gadget|
      %i(offset constraints effect).reduce(GADGET_TEMPLATE) do |str, attr|
        str.sub(attr.to_s.upcase, gadget.send(attr).inspect)
      end
    end.join
    TEMPLATE.sub('INFO', info_str).sub('GADGETS', gadgets_str)
  end

  def libc_info(filename)
    file = File.open(filename)
    str = file.read
    libc = ELFTools::ELFFile.new(file)
    build_id = libc.build_id
    arch = libc.machine
    file.close
    st = str.index('GNU C Library')
    return nil if st.nil?
    len = str[st..-1].index("\x00")
    return nil if len.nil?
    {
      build_id: build_id,
      info: arch + "\n\n" + str[st, len]
    }
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
