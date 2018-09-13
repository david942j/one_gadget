require 'one_gadget/error'
require 'one_gadget/helper'

module OneGadget
  module Emulators
    # A {Lambda} object can be:
    # 1. +String+ (variable name)
    # 2. +Numeric+
    # 3. {Lambda} + +Numeric+
    # 4. dereferenced {Lambda}
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
        raise Error::ArgumentError, 'Expect other to be Numeric.' unless other.is_a?(Numeric)

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
      # @raise [Error::ArgumentError] When this object cannot be referenced anymore.
      def ref!
        raise Error::ArgumentError, 'Cannot reference anymore!' if @deref_count <= 0

        @deref_count -= 1
      end

      # A new {Lambda} object with dereference count increase 1.
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

      # Eval the value of lambda.
      # Only support those like +rsp+0x30+.
      # @param [Hash{String => Integer}] context
      #   The context.
      # @return [Integer] Result of evaluation.
      def evaluate(context)
        raise Error::ArgumentError, "Can't eval #{self}" if deref_count > 0
        raise Error::ArgumentError, "Can't eval #{self}" if obj && !context.key?(obj)

        context[obj] + immi
      end

      class << self
        # Target: parse things like <tt>[rsp+0x50]</tt> into a {Lambda} object.
        # @param [String] arg
        # @param [Hash{String => Lambda}] predefined
        #   Predfined values.
        # @return [OneGadget::Emulators::Lambda, Integer]
        #   If +arg+ contains number only, return it.
        #   Otherwise, return a {Lambda} object.
        # @example
        #   obj = Lambda.parse('[rsp+0x50]')
        #   #=> #<Lambda @obj='rsp', @immi=80, @deref_count=1>
        #   Lambda.parse('obj+0x30', predefined: { 'obj' => obj }).to_s
        #   #=> '[rsp+0x50]+0x30'
        def parse(arg, predefined: {})
          deref_count = 0
          if arg[0] == '[' # a little hack because there should nerver something like +[[rsp+1]+2]+ to parse.
            arg = arg[1..-2]
            deref_count = 1
          end
          return Integer(arg) if OneGadget::Helper.integer?(arg)

          sign = arg =~ /[+-]/
          val = 0
          if sign
            raise Error::ArgumentError, "Not support #{arg}" unless OneGadget::Helper.integer?(arg[sign..-1])

            val = Integer(arg.slice!(sign..-1))
          end
          obj = predefined[arg] || Lambda.new(arg)
          obj += val unless val.zero?
          deref_count.zero? ? obj : obj.deref
        end
      end
    end
  end
end
