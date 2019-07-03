# frozen_string_literal: true

require 'net/http'
require 'openssl'
require 'pathname'
require 'tempfile'

require 'elftools'

require 'one_gadget/error'

module OneGadget
  # Define some helpful methods here.
  module Helper
    # Format of build-id, 40 hex numbers.
    BUILD_ID_FORMAT = /[0-9a-f]{40}/.freeze

    module_function

    # Checks if +build_id+ is a valid SHA1 hex format.
    # @param [String] build_id
    #   BuildID.
    # @raise [Error::ArgumentError]
    #   Raises error if invalid.
    # @return [void]
    def verify_build_id!(build_id)
      return if build_id =~ /\A#{OneGadget::Helper::BUILD_ID_FORMAT}\Z/

      raise OneGadget::Error::ArgumentError, format('invalid BuildID format: %p', build_id)
    end

    # Fetch lines start with '#'.
    # @param [String] file
    #   Filename.
    # @return [Array<String>]
    #   Lines of comments.
    def comments_of_file(file)
      File.readlines(file).map { |s| s[2..-1].rstrip if s.start_with?('# ') }.compact
    end

    # Get absolute path from relative path. Support symlink.
    # @param [String] path Relative path.
    # @return [String] Absolute path, with symlink resolved.
    # @example
    #   Helper.abspath('/lib/x86_64-linux-gnu/libc.so.6')
    #   #=> '/lib/x86_64-linux-gnu/libc-2.23.so'
    def abspath(path)
      Pathname.new(File.expand_path(path)).realpath.to_s
    end

    # Checks if the file of given path is a valid ELF file.
    #
    # @param [String] path Path to target file.
    # @return [Boolean] If the file is an ELF or not.
    # @example
    #   Helper.valid_elf_file?('/etc/passwd')
    #   #=> false
    #   Helper.valid_elf_file?('/lib64/ld-linux-x86-64.so.2')
    #   #=> true
    def valid_elf_file?(path)
      # A light-weight way to check if is a valid ELF file
      # Checks at least one phdr should present.
      File.open(path) { |f| ELFTools::ELFFile.new(f).each_segments.first }
      true
    rescue ELFTools::ELFError
      false
    end

    # Checks if the file of given path is a valid ELF file.
    #
    # An error message will be shown if given path is not a valid ELF.
    #
    # @param [String] path Path to target file.
    # @return [void]
    # @raise [Error::ArgumentError] Raise exception if not a valid ELF.
    def verify_elf_file!(path)
      return if valid_elf_file?(path)

      raise Error::ArgumentError, 'Not an ELF file, expected glibc as input'
    end

    # Get the Build ID of target ELF.
    # @param [String] path Absolute file path.
    # @return [String] Target build id.
    # @example
    #   Helper.build_id_of('/lib/x86_64-linux-gnu/libc-2.23.so')
    #   #=> '60131540dadc6796cab33388349e6e4e68692053'
    def build_id_of(path)
      File.open(path) { |f| ELFTools::ELFFile.new(f).build_id }
    end

    # Disable colorize.
    # @return [void]
    def color_off!
      @disable_color = true
    end

    # Is colorize output enabled?
    # @return [Boolean]
    #   True or false.
    def color_enabled?
      # if not set, use tty to check
      return $stdout.tty? unless instance_variable_defined?(:@disable_color)

      !@disable_color
    end

    # Color codes for pretty print
    COLOR_CODE = {
      esc_m: "\e[0m",
      normal_s: "\e[38;5;203m", # red
      integer: "\e[38;5;189m", # light purple
      reg: "\e[38;5;82m", # light green
      warn: "\e[38;5;230m", # light yellow
      error: "\e[38;5;196m" # heavy red
    }.freeze

    # Wrap string with color codes for pretty inspect.
    # @param [String] str Contents to colorize.
    # @param [Symbol] sev Specify which kind of color to use, valid symbols are defined in {.COLOR_CODE}.
    # @return [String] String wrapped with color codes.
    def colorize(str, sev: :normal_s)
      return str unless color_enabled?

      cc = COLOR_CODE
      color = cc.key?(sev) ? cc[sev] : ''
      "#{color}#{str.sub(cc[:esc_m], color)}#{cc[:esc_m]}"
    end

    # Returns the hexified and colorized integer.
    # @param [Integer] val
    # @return [String]
    def colored_hex(val)
      colorize(hex(val), sev: :integer)
    end

    # Fetch the latest release version's tag name.
    # @return [String] The tag name, in form +vX.X.X+.
    def latest_tag
      releases_url = 'https://github.com/david942j/one_gadget/releases/latest'
      @latest_tag ||= url_request(releases_url).split('/').last
    end

    # Get the url which can fetch +filename+ from remote repo.
    # @param [String] filename
    # @return [String] The url.
    def url_of_file(filename)
      raw_file_url = 'https://raw.githubusercontent.com/david942j/one_gadget/@tag/@file'
      raw_file_url.sub('@tag', latest_tag).sub('@file', filename)
    end

    # Download the latest version of +file+ in +lib/one_gadget/builds/+ from remote repo.
    #
    # @param [String] file The filename desired.
    # @return [Tempfile] The temp file be created.
    def download_build(file)
      temp = Tempfile.new(['gadgets', file + '.rb'])
      temp.write(url_request(url_of_file(File.join('lib', 'one_gadget', 'builds', file + '.rb'))))
      temp.tap(&:close)
    end

    # Get the latest builds list from repo.
    # @return [Array<String>] List of build ids.
    def remote_builds
      @remote_builds ||= url_request(url_of_file('builds_list')).lines.map(&:strip)
    end

    # Get request.
    # @param [String] url The url.
    # @return [String]
    #   The request response body.
    #   If the response is +302 Found+, returns the location in header.
    def url_request(url)
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = ::OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(uri.request_uri)

      response = http.request(request)
      raise ArgumentError, "Fail to get response of #{url}" unless %w[200 302].include?(response.code)

      response.code == '302' ? response['location'] : response.body
    rescue NoMethodError, SocketError, ArgumentError => e
      OneGadget::Logger.error(e.message)
      nil
    end

    # Fetch the ELF architecture of +file+.
    # @param [String] file The target ELF filename.
    # @return [Symbol]
    #   Currently supports amd64, i386, arm, aarch64, and mips.
    # @example
    #   Helper.architecture('/bin/cat')
    #   #=> :amd64
    def architecture(file)
      return :invalid unless File.exist?(file)

      f = File.open(file)
      str = ELFTools::ELFFile.new(f).machine
      {
        'Advanced Micro Devices X86-64' => :amd64,
        'Intel 80386' => :i386,
        'ARM' => :arm,
        'AArch64' => :aarch64,
        'MIPS R3000' => :mips
      }[str] || :unknown
    rescue ELFTools::ELFError # not a valid ELF
      :invalid
    ensure
      f&.close
    end

    # Present number in hex format.
    # @param [Integer] val
    #   The number.
    # @param [Boolean] psign
    #   If needs to show the plus sign when +val >= 0+.
    # @return [String]
    #   String in hex format.
    # @example
    #   Helper.hex(32) #=> '0x20'
    #   Helper.hex(32, psign: true) #=> '+0x20'
    #   Helper.hex(-40) #=> '-0x28'
    #   Helper.hex(0) #=> '0x0'
    #   Helper.hex(0, psign: true) #=> '+0x0'
    def hex(val, psign: false)
      return format("#{psign ? '+' : ''}0x%x", val) if val >= 0

      format('-0x%x', -val)
    end

    # Checks if a string can be converted into an integer.
    # @param [String] str
    #   String to be checked.
    # @return [Boolean]
    #   If +str+ can be converted into an integer.
    # @example
    #   Helper.integer? '1234'
    #   #=> true
    #   Helper.integer? '0x1234'
    #   #=> true
    #   Helper.integer? '0xheapoverflow'
    #   #=> false
    def integer?(str)
      true if Integer(str)
    rescue ArgumentError, TypeError
      false
    end

    # Cross-platform way of finding an executable in +$PATH+.
    #
    # @param [String] cmd
    # @return [String?]
    # @example
    #   Helper.which('ruby')
    #   #=> "/usr/bin/ruby"
    def which(cmd)
      exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
      ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
        exts.each do |ext|
          exe = File.join(path, "#{cmd}#{ext}")
          return exe if File.executable?(exe) && !File.directory?(exe)
        end
      end
      nil
    end

    # Find objdump that supports architecture +arch+.
    # @param [String] arch
    # @return [String?]
    # @example
    #   Helper.find_objdump(:amd64)
    #   #=> '/usr/bin/objdump'
    #   Helper.find_objdump(:aarch64)
    #   #=> '/usr/bin/aarch64-linux-gnu-objdump'
    def find_objdump(arch)
      [
        which('objdump'),
        which(arch_specific_objdump(arch))
      ].find { |bin| objdump_arch_supported?(bin, arch) }
    end

    # Checks if the given objdump supports certain architecture.
    # @param [String] bin
    # @param [Symbol] arch
    # @return [Boolean]
    # @example
    #   Helper.objdump_arch_supported?('/usr/bin/objdump', :i386)
    #   #=> true
    def objdump_arch_supported?(bin, arch)
      return false if bin.nil?

      arch = objdump_arch(arch)
      `#{::Shellwords.join([bin, '--help'])}`.lines.any? { |c| c.split.include?(arch) }
    end

    # Converts to the architecture name shown in objdump's +--help+ command.
    # @param [Symbol] arch
    # @return [String]
    # @example
    #   Helper.objdump_arch(:i386)
    #   #=> 'i386'
    #   Helper.objdump_arch(:amd64)
    #   #=> 'i386:x86-64'
    def objdump_arch(arch)
      case arch
      when :amd64 then 'i386:x86-64'
      else arch.to_s
      end
    end

    # Returns the binary name of objdump.
    # @param [Symbol] arch
    # @return [String]
    def arch_specific_objdump(arch)
      {
        aarch64: 'aarch64-linux-gnu-objdump',
        amd64: 'x86_64-linux-gnu-objdump',
        i386: 'i686-linux-gnu-objdump'
      }[arch]
    end

    # Returns the names of functions from the file's global offset table.
    # @param [String] file
    # @return [Array<String>]
    def got_functions(file)
      arch = architecture(file)
      objdump_bin = find_objdump(arch)
      `#{::Shellwords.join([objdump_bin, '-T', file])} | grep -iPo 'GLIBC_.+?\\s+\\K.*'`.split
    end

    # Returns a dictionary that maps functions to their offsets.
    # @param [String] file
    # @param [Array<String>] functions
    # @return [Hash{String => Integer}]
    def function_offsets(file, functions)
      arch = architecture(file)
      objdump_bin = find_objdump(arch)
      objdump_cmd = ::Shellwords.join([objdump_bin, '-T', file])
      functions.map! { |f| '\\b' + f + '\\b' }
      ret = {}
      `#{objdump_cmd} | grep -iP '(#{functions.join('|')})'`.lines.map(&:chomp).each do |line|
        tokens = line.split
        ret[tokens.last] = tokens.first.to_i(16)
      end
      ret
    end
  end
end
