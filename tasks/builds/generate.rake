namespace :builds do
  desc 'To auto generate rb files into lib/builds/*.rb'
  task :generate, :filename do |_t, args|
    require 'elftools'
    require 'one_gadget'
    libc_file = args.filename
    path = File.join(__dir__, '..', '..', 'lib', 'one_gadget', 'builds')
    info = libc_info(libc_file)
    version = info[:info].scan(/GLIBC ([\d.]+)/).flatten.first
    filename = "libc-#{version}-#{info[:build_id]}.rb"
    File.open(File.join(path, filename), 'w') do |f|
      f.write(template(info, OneGadget.gadgets(file: libc_file, force_file: true, details: true)))
    end
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
    len = str[st..-1].index("\x00")
    {
      build_id: build_id,
      info: arch + "\n\n" + str[st, len]
    }
  end
end
