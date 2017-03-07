require 'pathname'
require 'shellwords'
require 'net/http'
require 'openssl'
require 'tempfile'
require 'one_gadget/logger'

module OneGadget
  # Define some helpful methods here.
  module Helper
    BUILD_ID_FORMAT = /[0-9a-f]{40}/
    # Define class methods here.
    module ClassMethods
      # Get absolute path from relative path. Support symlink.
      # @param [String] path Relative path.
      # @return [String] Absolute path, with symlink resolved.
      # @example
      #   abspath('/lib/x86_64-linux-gnu/libc.so.6')
      #   #=> '/lib/x86_64-linux-gnu/libc-2.23.so'
      def abspath(path)
        Pathname.new(File.expand_path(path)).realpath.to_s
      end

      # Get the Build ID of target ELF.
      # @param [String] path Absolute file path.
      # @return [String] Target build id.
      # @example
      #   build_id_of('/lib/x86_64-linux-gnu/libc-2.23.so')
      #   #=> '60131540dadc6796cab33388349e6e4e68692053'
      def build_id_of(path)
        cmd = 'readelf -n ' + ::Shellwords.escape(path)
        bid = `#{cmd}`.scan(/Build ID: (#{BUILD_ID_FORMAT})$/).first
        return nil if bid.nil?
        bid.first
      end

      # Disable colorize
      def color_off!
        @disable_color = true
      end

      # Enable colorize
      def color_on!
        @disable_color = false
      end

      # Color codes for pretty print
      COLOR_CODE = {
        esc_m: "\e[0m",
        normal_s: "\e[31m", # red
        integer: "\e[1m\e[34m", # light blue
        reg: "\e[32m", # light green
        sym: "\e[33m", # pry like
      }.freeze

      # Wrapper color codes for pretty inspect.
      # @param [String] str Contents to colorize.
      # @option [Symbol] sev Specific which kind of color want to use, valid symbols are defined in +COLOR_CODE+.
      # @return [String] Wrapper with color codes.
      def colorize(str, sev: :normal_s)
        return str if @disable_color
        cc = COLOR_CODE
        color = cc.key?(sev) ? cc[sev] : ''
        "#{color}#{str.sub(cc[:esc_m], color)}#{cc[:esc_m]}"
      end

      # Fetch the latest release version's tag name.
      # @return [String] The tag name, in form +vx.x.x+.
      def latest_tag
        releases_url = 'https://github.com/david942j/one_gadget/releases'
        @latest_tag ||= 'v' + url_request(releases_url).scan(%r{/tree/v([\d.]+)"}).map do |tag|
          Gem::Version.new(tag.first)
        end.max.to_s
      end

      # Get the url which can fetch +filename+ from remote repo.
      # @param [String] filename
      # @return [String] The url.
      def url_of_file(filename)
        raw_file_url = 'https://raw.githubusercontent.com/david942j/one_gadget/@tag/@file'
        raw_file_url.gsub('@tag', latest_tag).gsub('@file', filename)
      end

      # Download the latest version of +file+ in +lib/one_gadget/builds/+ from remote repo.
      #
      # @param [String] file The filename desired.
      # @return [Tempfile] The temp file be created.
      def download_build(file)
        temp = Tempfile.new(['gadgets', file + '.rb'])
        url_request(url_of_file(File.join('lib', 'one_gadget', 'builds', file + '.rb')))
        temp.write url_request(url_of_file(File.join('lib', 'one_gadget', 'builds', file + '.rb')))
        temp.close
        temp
      end

      # Get the latest builds list from repo.
      # @return [Array<String>] List of build ids.
      def remote_builds
        @remote_builds ||= url_request(url_of_file('builds_list')).lines.map(&:strip)
      end

      # Get request.
      # @param [String] url The url.
      # @return [String] The request response body.
      def url_request(url)
        uri = URI.parse(url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = ::OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Get.new(uri.request_uri)

        response = http.request(request)
        raise ArgumentError, "Fail to get response of #{url}" unless response.code == '200'
        response.body
      rescue NoMethodError, SocketError, ArgumentError => e
        p e
        nil
      end

      # Show the message of ask user to update gem.
      # @return [void]
      def ask_update(msg: '')
        name = 'one_gadget'
        cmd = colorize("gem update #{name}")
        OneGadget::Logger.info(msg + "\n" + "Update with: $ #{cmd}" + "\n")
      end

      # Fetch the file archiecture of +file+.
      # @param [String] The target ELF filename.
      # @return [String]
      #   Only supports :amd64, :i386 now.
      def architecture(file)
        str = `readelf -h #{::Shellwords.escape(file)}`
        return :amd64 if str.include?('X86-64')
        return :i386 if str.include?('Intel 80386')
        :unknown
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
