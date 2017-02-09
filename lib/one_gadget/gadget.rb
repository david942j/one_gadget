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

      # Initialize method of {Gadget} instance.
      # @param [Integer] offset The relative address offset of this gadget.
      # @option options [Array<String>] :constraints
      #   The constraints need for this gadget. Defaults to +[]+.
      # @example
      #   OneGadget::Gadget::Gadget.new(0x12345, constraints: ['rax == 0'])
      def initialize(offset, **options)
        @offset = offset
        @constraints = options[:constraints] || []
      end

      # Show gadget in a pretty way.
      def inspect
        str = format("#{OneGadget::Helper.colorize('offset', sev: :sym)}: 0x%x\n", offset)
        unless constraints.nil?
          str += "#{OneGadget::Helper.colorize('constraints')}:\n  "
          str += constraints.join("\n  ")
        end
        str.gsub!(/0x[\da-f]+/) { |s| OneGadget::Helper.colorize(s, sev: :integer) }
        OneGadget::ABI.registers.each { |reg| str.gsub!(reg, OneGadget::Helper.colorize(reg, sev: :reg)) }
        str + "\n"
      end
    end

    # Define class methods here.
    module ClassMethods
      BUILDS_PATH = File.join(File.dirname(__FILE__), 'builds').freeze
      BUILDS = Hash.new { |h, k| h[k] = [] }
      # Get gadgets from pre-defined corpus.
      # @param [String] build_id Desired build id.
      # @return [Array<Gadget::Gadget>] Gadgets.
      def builds(build_id)
        require_all if BUILDS.empty?
        return BUILDS[build_id] if BUILDS.key?(build_id)
        # TODO: fetch remote builds information.
        []
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
    end
    extend ClassMethods
  end
end
