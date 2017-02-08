module OneGadget
  # Module for define gadgets.
  module Gadget
    # Information of a gadget.
    class Gadget
      attr_accessor :offset
      attr_accessor :constraints
      def constraints=(value)
        raise ArgumentError, value unless value.is_a?(Array)
        @constraints = value
      end

      def inspect
        str = format("offset: 0x%x\n", offset)
        unless constraints.nil?
          str += "constraints:\n  "
          str += constraints.join("\n  ")
        end
        str + "\n"
      end

      # Only check if +offset+ being set now.
      def self_check!
        raise ArgumentError, format('invalid offset: %p', offset) unless offset.is_a?(Integer) && offset >= 0
      end
    end

    # Define class methods here.
    module ClassMethods
      BUILDS_PATH = File.join(File.dirname(__FILE__), 'builds').freeze
      CACHE = Hash.new { |h, k| h[k] = [] }
      def builds(build_id)
        return CACHE[build_id] if CACHE.key?(build_id)
        return [] unless File.exist?(File.join(BUILDS_PATH, build_id + '.rb'))
        require File.join(BUILDS_PATH, build_id + '.rb')
        CACHE[build_id]
      end

      def define(build_id)
        g = OneGadget::Gadget::Gadget.new
        yield(g)
        g.self_check!
        CACHE[build_id] << g
      end
    end
    extend ClassMethods
  end
end
