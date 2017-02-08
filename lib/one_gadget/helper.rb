require 'pathname'

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
        cmd = 'readelf -n ' + Shellwords.escape(path)
        bid = `#{cmd}`.scan(/Build ID: (#{BUILD_ID_FORMAT})$/).first
        return nil if bid.nil?
        bid.first
      end

      def color_off!
        @disable_color = true
      end

      def color_on!
        @disable_color = false
      end

      # Color codes for pretty print
      COLOR_CODE = {
        esc_m: "\e[0m",
        normal_s: "\e[38;5;1m", # red
        integer: "\e[38;5;12m", # light blue
        fatal: "\e[38;5;197m", # dark red
        reg: "\e[38;5;120m", # light green
        sym: "\e[38;5;229m", # pry like
      }.freeze

      # Wrapper color codes for for pretty inspect.
      # @param [String] str Contents to colorize.
      # @option [Symbol] sev Specific which kind of color want to use, valid symbols are defined in +COLOR_CODE+.
      # @return [String] Wrapper with color codes.
      def colorize(str, sev: :normal_s)
        return str if @disable_color
        cc = COLOR_CODE
        color = cc.key?(sev) ? cc[sev] : ''
        "#{color}#{str.sub(cc[:esc_m], color)}#{cc[:esc_m]}"
      end
    end
    extend ClassMethods
  end
end
