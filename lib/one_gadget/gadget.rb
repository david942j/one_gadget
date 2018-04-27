require 'one_gadget/abi'

module OneGadget
  # Module for define gadgets.
  module Gadget
    # Information of a gadget.
    class Gadget
      # @return [Integer] The gadget's address offset.
      attr_accessor :offset
      # @return [Array<String>] The constraints need for this gadget.
      attr_accessor :constraints
      # @return [String] The final result of this gadget.
      attr_accessor :effect

      # Initialize method of {Gadget} instance.
      # @param [Integer] offset The relative address offset of this gadget.
      # @option options [Array<String>] :constraints
      #   The constraints need for this gadget. Defaults to +[]+.
      # @example
      #   OneGadget::Gadget::Gadget.new(0x12345, constraints: ['rax == 0'])
      def initialize(offset, **options)
        @offset = offset
        @constraints = options[:constraints] || []
        @effect = options[:effect]
      end

      # Show gadget in a pretty way.
      def inspect
        str = OneGadget::Helper.hex(offset)
        str += effect ? "\t#{effect}\n" : "\n"
        unless constraints.empty?
          str += "#{OneGadget::Helper.colorize('constraints')}:\n  "
          str += constraints.join("\n  ")
        end
        str.gsub!(/0x[\da-f]+/) { |s| OneGadget::Helper.colorize(s, sev: :integer) }
        OneGadget::ABI.all.each { |reg| str.gsub!(reg, OneGadget::Helper.colorize(reg, sev: :reg)) }
        str + "\n"
      end
    end

    # Define class methods here.
    module ClassMethods
      # Path to the pre-build files.
      BUILDS_PATH = File.join(__dir__, 'builds').freeze
      # Cache.
      BUILDS = Hash.new { |h, k| h[k] = [] }
      # Get gadgets from pre-defined corpus.
      # @param [String] build_id Desired build id.
      # @param [Boolean] remote
      #   When local not found, try search in latest version?
      # @return [Array<Gadget::Gadget>?] Gadgets.
      def builds(build_id, remote: true)
        require_all if BUILDS.empty?
        return BUILDS[build_id] if BUILDS.key?(build_id)
        return build_not_found unless remote
        # fetch remote builds
        table = OneGadget::Helper.remote_builds.find { |c| c.include?(build_id) }
        return build_not_found if table.nil? # remote doesn't have this one either.
        # builds found in remote! Ask update gem and download remote gadgets.
        OneGadget::Helper.ask_update(msg: 'The desired one-gadget can be found in lastest version!')
        tmp_file = OneGadget::Helper.download_build(table)
        require tmp_file.path
        tmp_file.unlink
        BUILDS[build_id]
      end

      # Returns the comments in builds/libc-*-<build_id>*.rb
      # @param [String] build_id
      #   Supports give only few starting bytes, but a warning will be shown
      #   if multiple BulidIDs are matched.
      # @return [String?]
      #   Lines of comments.
      # @example
      #   puts OneGadget::Gadget.builds_info('3bbdc')
      #   # https://gitlab.com/libcdb/libcdb/blob/master/libc/libc6-amd64-2.19-18+deb8u4/lib64/libc-2.19.so
      #   #
      #   # Advanced Micro Devices X86-64
      #   # ...
      def builds_info(build_id)
        raise ArgumentError, "Invalid BuildID #{build_id.inspect}" if build_id =~ /[^0-9a-f]/
        files = Dir.glob(File.join(BUILDS_PATH, "*-#{build_id}*.rb")).sort
        return OneGadget::Logger.not_found(build_id) && nil if files.empty?
        if files.size > 1
          OneGadget::Logger.warn("Multiple BuildIDs match /^#{build_id}/\n")
          show = files.map do |f|
            File.basename(f, '.rb').reverse.split('-', 2).join(' ').reverse
          end
          OneGadget::Logger.warn("Candidates are:\n#{show * "\n"}\n")
          return nil
        end
        OneGadget::Helper.comments_of_file(files.first)
      end

      # Add a gadget, for scripts in builds/ to use.
      # @param [String] build_id The target's build id.
      # @param [Integer] offset The relative address offset of this gadget.
      # @param [Hash] options See {Gadget::Gadget#initialize} for more information.
      # @return [void]
      def add(build_id, offset, **options)
        BUILDS[build_id] << OneGadget::Gadget::Gadget.new(offset, **options)
      end

      private

      def require_all
        Dir.glob(File.join(BUILDS_PATH, '**', '*.rb')).each do |dic|
          require dic
        end
      end

      def build_not_found
        nil
      end
    end
    extend ClassMethods
  end
end
