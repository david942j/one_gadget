require 'one_gadget/helper'

module OneGadget
  module Emulators
    # A {Lambda} object can be:
    # 1. {String} # variable name
    # 2. {Numeric}
    # 3. {Lambda} + {Numeric}
    # 4. dereference {Lambda}
    class Lambda
      attr_reader :obj # @return [String, Lambda]
      attr_accessor :immi # @return [Integer]
      attr_accessor :deref_count # @return [Integer] The times of dereference.
      def initialize(val)
        @immi = 0
        @obj = val
        @deref_count = 0
      end

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

      def -(other)
        self.+(-other)
      end

      def deref!
        @deref_count += 1
      end

      def deref
        ret = Lambda.new(obj)
        ret.immi = immi
        ret.deref_count = deref_count + 1
        ret
      end

      def to_s
        str = ''
        str += '[' * deref_count
        str += obj.to_s unless obj.nil?
        str += OneGadget::Helper.hex(immi, psign: true) unless immi.zero?
        str += ']' * deref_count
        str
      end
    end
  end
end
