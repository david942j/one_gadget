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
        cmd = 'file ' + Shellwords.escape(path)
        bid = `#{cmd}`.scan(/BuildID\[sha1\]=(#{BUILD_ID_FORMAT}),/).first
        return nil if bid.nil?
        bid.first
      end

      def color_off!
        @disable_color = true
      end
    end
    extend ClassMethods
  end
end
