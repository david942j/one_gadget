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
        raise Error::InstructionArgumentError, "Expect other(#{other}) to be numeric." unless other.is_a?(Numeric)

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
      # @return [self]
      # @raise [Error::InstrutionArgumentError] When this object cannot be referenced anymore.
      def ref!
        raise Error::InstructionArgumentError, 'Cannot reference anymore!' if @deref_count <= 0

        @deref_count -= 1
        self
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
        raise Error::InstructionArgumentError, "Can't eval #{self}" if deref_count > 0 || (obj && !context.key?(obj))

        context[obj] + immi
      end

      class << self
        # Target: parse string like <tt>[rsp+0x50]</tt> into a {Lambda} object.
        # @param [String] argument
        # @param [Hash{String => Lambda}] predefined
        #   Predfined values.
        # @return [OneGadget::Emulators::Lambda, Integer]
        #   If +argument+ contains number only, returns the value.
        #   Otherwise, returns a {Lambda} object.
        # @example
        #   obj = Lambda.parse('[rsp+0x50]')
        #   #=> #<Lambda @obj='rsp', @immi=80, @deref_count=1>
        #   Lambda.parse('obj+0x30', predefined: { 'obj' => obj }).to_s
        #   #=> '[rsp+0x50]+0x30'
        # @example
        #   Lambda.parse('[x0, -104]')
        #   #=> #<Lambda @obj='x0', @immi=-104, @deref_count=1>
        def parse(argument, predefined: {})
          deref_count = 0
          arg = argument.dup
          if arg[0] == '[' # a little hack because there should nerver something like +[[rsp+1]+2]+ to parse.
            arg = arg[1...arg.rindex(']')]
            deref_count = 1
          end
          return Integer(arg) if OneGadget::Helper.integer?(arg)

          # We have three forms:
          # 0. [reg]
          # 1. [reg+imm] / [reg-imm]
          # 2. [reg, imm] / [reg, -imm]
          sign = arg =~ /[+-]/
          sign = (arg =~ /,\s/) + 2 if sign.nil? && arg =~ /,\s/
          val = 0
          if sign
            # Form [r1+r2] is not supported
            raise Error::UnsupportedInstructionArgumentError, argument unless OneGadget::Helper.integer?(arg[sign..-1])

            val = Integer(arg.slice!(sign..-1))
          end
          arg.gsub!(/,\s/, '')
          obj = predefined[arg] || Lambda.new(arg)
          obj += val unless val.zero?
          deref_count.zero? ? obj : obj.deref
        end
      end
    end
  end
end
