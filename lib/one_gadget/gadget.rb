# frozen_string_literal: true

require 'one_gadget/abi'
require 'one_gadget/emulators/lambda'
require 'one_gadget/error'

module OneGadget
  # Module for define gadgets.
  module Gadget
    # Information of a gadget.
    class Gadget
      # @return [Integer] Base address of libc. Default: 0.
      attr_accessor :base
      # @return [Integer] The gadget's address offset.
      attr_reader :offset
      # @return [Array<String>] The constraints need for this gadget.
      attr_reader :constraints
      # @return [String] The final result of this gadget.
      attr_reader :effect

      # Initialize method of {Gadget} instance.
      # @param [Integer] offset The relative address offset of this gadget.
      # @option options [Array<String>] :constraints
      #   The constraints need for this gadget. Defaults to +[]+.
      # @example
      #   OneGadget::Gadget::Gadget.new(0x12345, constraints: ['rax == 0'])
      def initialize(offset, **options)
        @base = 0
        @offset = offset
        @constraints = options[:constraints] || []
        @effect = options[:effect]
      end

      # Show gadget in a pretty way.
      def inspect
        str = OneGadget::Helper.hex(value)
        str += effect ? " #{effect}\n" : "\n"
        unless constraints.empty?
          str += "#{OneGadget::Helper.colorize('constraints')}:\n  "
          str += merge_constraints.join("\n  ")
        end
        str.gsub!(/0x[\da-f]+/) { |s| OneGadget::Helper.colorize(s, sev: :integer) }
        OneGadget::ABI.all.each do |reg|
          str.gsub!(/([^\w])(#{reg})([^\w])/, '\1' + OneGadget::Helper.colorize('\2', sev: :reg) + '\3')
        end
        str + "\n"
      end

      # @return [Integer]
      #   Returns +base+ plus +offset+.
      def value
        base + offset
      end

      # @return [Float]
      #   The success probability of the constraints.
      def score
        @score ||= constraints.reduce(1.0) { |s, c| s * calculate_score(c) }
      end

      private

      # REG: OneGadget::ABI.all
      # IMM: [+-]0x[\da-f]+
      # Identity: <REG><IMM>?
      # Identity: [<Identity>]
      # Expr: <REG> is the GOT address of libc
      # Expr: writable: <Identity>
      # Expr: <Identity> == NULL
      # Expr: <REG> & 0xf == <IMM>
      # Expr: <Expr> || <Expr>
      def calculate_score(cons)
        return cons.split(' || ').map(&method(:calculate_score)).max if cons.include?(' || ')

        case cons
        when / & 0xf/ then 0.95
        when /GOT address/ then 0.9
        when /^writable/ then 0.81
        when / == NULL$/ then calculate_null_score(cons)
        end
      end

      def calculate_null_score(cons)
        identity = cons.slice(0...cons.rindex(' == NULL'))
        # Thank God we are already able to parse this
        lmda = OneGadget::Emulators::Lambda.parse(identity)
        # raise Error::ArgumentError, cons unless OneGadget::ABI.all.include?(lmda.obj)
        # rax == 0 is easy; rax + 0x10 == 0 is damn hard.
        return lmda.immi.zero? ? 0.9 : 0.1 if lmda.deref_count.zero?

        # [sp+xx] == NULL is easy.
        base = OneGadget::ABI.stack_register?(lmda.obj) ? 0 : 1
        0.9**(lmda.deref_count + base)
      end

      def merge_constraints
        key = 'writable: '
        w_cons, normal = constraints.partition { |c| c.start_with?(key) }
        return normal if w_cons.empty?

        w_cons.map! { |c| c[key.size..-1] }
        ["address#{w_cons.size > 1 ? 'es' : ''} #{w_cons.join(', ')} #{w_cons.size > 1 ? 'are' : 'is'} writable"] +
          normal
      end
    end

    # Define class methods here.
    module ClassMethods
      # Path to the pre-build files.
      BUILDS_PATH = File.join(__dir__, 'builds').freeze
      # Record.
      BUILDS = Hash.new { |h, k| h[k] = [] }
      # Get gadgets from pre-defined corpus.
      # @param [String] build_id Desired build id.
      # @param [Boolean] remote
      #   When local not found, try search in latest version?
      # @return [Array<Gadget::Gadget>?] Gadgets.
      def builds(build_id, remote: true)
        ret = find_build(build_id)
        return ret unless ret.nil?
        return build_not_found unless remote

        # fetch remote builds
        table = OneGadget::Helper.remote_builds.find { |c| c.include?(build_id) }
        return build_not_found if table.nil? # remote doesn't have this one either.

        # builds found in remote! Ask update gem and download remote gadgets.
        OneGadget::Logger.ask_update(msg: 'The desired one-gadget can be found in lastest version!')
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
        raise Error::ArgumentError, "Invalid BuildID #{build_id.inspect}" if build_id =~ /[^0-9a-f]/

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

      def find_build(id)
        return BUILDS[id] if BUILDS.key?(id)

        Dir.glob(File.join(BUILDS_PATH, "*-#{id}.rb")).each do |dic|
          require dic
        end
        BUILDS[id] if BUILDS.key?(id)
      end

      def build_not_found
        nil
      end
    end
    extend ClassMethods
  end
end
