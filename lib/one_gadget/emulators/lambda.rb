require 'one_gadget/helper'

module OneGadget
  module Emulators
    # A {Lambda} object can be:
    # 1. {String} # variable name
    # 2. {Numeric}
    # 3. {Lambda} + {Numeric}
    # 4. dereference {Lambda}
    class Lambda
      attr_accessor :obj # @return [String, Lambda] The object currently related to.
      attr_accessor :immi # @return [Integer] The immidiate value currently added.
      attr_accessor :deref_count # @return [Integer] The times of dereference.
      # Instantiate a {Lambda} object.
      # @param [Lambda, String] obj
      def initialize(obj)
        @immi = 0
        @obj = obj
        @deref_count = 0
      end

      # Implement addition with +Numeric+.
      # @param [Numeric] other Value to add.
      # @return [Lambda] The result.
      def +(other)
        raise ArgumentError, 'Expect other to be Numeric.' unless other.is_a?(Numeric)
        if deref_count > 0
          ret = Lambda.new(self)
        else
          ret = Lambda.new(obj)
          ret.immi = immi
        end
        ret.immi += other
        ret
      end

      # Implement substract with +Numeric+.
      # @param [Numeric] other Value to substract.
      # @return [Lambda] The result.
      def -(other)
        self.+(-other)
      end

      # Increase dreference count with 1.
      # @return [void]
      def deref!
        @deref_count += 1
      end

      # Decrease dreference count with 1.
      # @return [void]
      def ref!
        raise ArgumentError, 'Cannot reference anymore!' if @deref_count <= 0
        @deref_count -= 1
      end

      # A new {Lambda} object with dreference count increase 1.
      # @return [Lambda]
      def deref
        ret = Lambda.new(obj)
        ret.immi = immi
        ret.deref_count = deref_count + 1
        ret
      end

      # Expand the lambda presentation.
      # @return [String] The expand result.
      def to_s
        str = ''
        str += '[' * deref_count
        str += obj.to_s unless obj.nil?
        str += OneGadget::Helper.hex(immi, psign: true) unless immi.zero?
        str += ']' * deref_count
        str
      end

      class << self
        # Target: parse something like +[rsp+0x50]+ into a {Lambda} object.
        # @param [String] arg
        # @param [Hash{String => Lambda}] predefined
        # @return [OneGadget::Emulators::Lambda, Integer]
        #   If +arg+ contains number only, return it.
        #   Otherwise, return a {Lambda} object.
        # @example
        #   parse('[rsp+0x50]') #=> #<Lambda @obj='rsp', @immi=80, @deref_count=1>
        def parse(arg, predefined: {})
          ret = Lambda.new('tmp')
          if arg[0] == '[' # a little hack because there should nerver something like +[[rsp+1]+2]+ to parse.
            arg = arg[1..-2]
            ret.deref_count += 1
          end
          return Integer(arg) if OneGadget::Helper.integer?(arg)
          sign = arg =~ /[+-]/
          raise ArgumentError, "Not support #{arg}" if sign && !OneGadget::Helper.integer?(arg[sign..-1])
          if sign
            ret.immi = Integer(arg[sign..-1])
            arg = arg[0, sign]
          end
          ret.obj = predefined[arg] || arg
          ret
        end
      end
    end
  end
end
