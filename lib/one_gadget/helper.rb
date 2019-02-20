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
    # Define class methods here.
    module ClassMethods
      # Verify if `build_id` is a valid SHA1 hex format.
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
      #   abspath('/lib/x86_64-linux-gnu/libc.so.6')
      #   #=> '/lib/x86_64-linux-gnu/libc-2.23.so'
      def abspath(path)
        Pathname.new(File.expand_path(path)).realpath.to_s
      end

      # Checks if the file of given path is a valid ELF file.
      #
      # @param [String] path Path to target file.
      # @return [Boolean] If the file is an ELF or not.
      # @example
      #   valid_elf_file?('/etc/passwd')
      #   => false
      #   valid_elf_file?('/lib64/ld-linux-x86-64.so.2')
      #   => true
      def valid_elf_file?(path)
        # A light-weight way to check if is a valid ELF file
        # Checks at least one phdr should present.
        File.open(path) { |f| ELFTools::ELFFile.new(f).each_segments.first }
        true
      rescue ELFTools::ELFError
        false
      end

      # Checks if the file of given path is a valid ELF file
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
      #   build_id_of('/lib/x86_64-linux-gnu/libc-2.23.so')
      #   #=> '60131540dadc6796cab33388349e6e4e68692053'
      def build_id_of(path)
        File.open(path) { |f| ELFTools::ELFFile.new(f).build_id }
      end

      # Disable colorize.
      # @return [void]
      def color_off!
        @disable_color = true
      end

      # Enable colorize.
      # @return [void]
      def color_on!
        @disable_color = false
      end

      # Is colorify output enabled?
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

      # Fetch the latest release version's tag name.
      # @return [String] The tag name, in form +vx.x.x+.
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
        url_request(url_of_file(File.join('lib', 'one_gadget', 'builds', file + '.rb')))
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
      #   If the response is '302 Found', return the location in header.
      def url_request(url)
        uri = URI.parse(url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = ::OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Get.new(uri.request_uri)

        response = http.request(request)
        raise ArgumentError, "Fail to get response of #{url}" unless %w(200 302).include?(response.code)

        response.code == '302' ? response['location'] : response.body
      rescue NoMethodError, SocketError, ArgumentError => e
        p e
        nil
      end

      # Fetch the file archiecture of +file+.
      # @param [String] file The target ELF filename.
      # @return [Symbol]
      #   Only supports architecture amd64 and i386 now.
      def architecture(file)
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
        f.close
      end

      # Present number in hex format.
      # @param [Integer] val The number.
      # @param [Boolean] psign Need to show plus sign when +val >= 0+.
      # @return [String] string in hex format.
      # @example
      #   hex(32) #=> 0x20
      #   hex(32, psign: true) #=> +0x20
      #   hex(-40) #=> -0x28
      #   hex(0) #=> 0x0
      #   hex(0, psign: true) #=> +0x0
      def hex(val, psign: false)
        return format("#{psign ? '+' : ''}0x%x", val) if val >= 0

        format('-0x%x', -val)
      end

      # For checking a string is actually an integer.
      # @param [String] str String to be checked.
      # @return [Boolean] If +str+ can be converted into integer.
      # @example
      #   Helper.integer? '1234'
      #   # => true
      #   Helper.integer? '0x1234'
      #   # => true
      #   Helper.integer? '0xheapoverflow'
      #   # => false
      def integer?(str)
        true if Integer(str)
      rescue ArgumentError, TypeError
        false
      end
    end
    extend ClassMethods
  end
end
