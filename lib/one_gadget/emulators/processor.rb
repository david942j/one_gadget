# frozen_string_literal: true

require 'one_gadget/emulators/lambda'
require 'one_gadget/error'

module OneGadget
  # Instruction emulator to solve the constraint of gadgets.
  module Emulators
    # Base class of a processor.
    class Processor
      attr_reader :registers # @return [Hash{String => OneGadget::Emulators::Lambda}] The current registers' state.
      attr_reader :sp_based_stack # @return [Hash{Integer => OneGadget::Emulators::Lambda}] Stack content based on sp.
      attr_reader :sp # @return [String] Stack pointer.
      attr_reader :pc # @return [String] Program counter.

      # Instantiate a {Processor} object.
      # @param [Array<String>] registers
      #   Registers that supported in the architecture.
      # @param [String] sp
      #   The stack register.
      def initialize(registers, sp)
        @registers = registers.to_h { |reg| [reg, to_lambda(reg)] }
        @sp = sp
        @constraints = []
        @sp_based_stack = Hash.new do |h, k|
          h[k] = OneGadget::Emulators::Lambda.new(sp).tap do |lmda|
            lmda.immi = k
            lmda.deref!
          end
        end
      end

      # Parse one command into instruction and arguments.
      # @param [String] cmd One line of result of objdump.
      # @return [(Instruction, Array<String>)]
      #   The parsing result.
      def parse(cmd)
        inst = instructions.find { |i| i.match?(cmd) }
        raise Error::UnsupportedInstructionError, "Not implemented instruction in #{cmd}" if inst.nil?

        [inst, inst.fetch_args(cmd)]
      end

      # Process one command, without raising any exceptions.
      # @param [String] cmd
      #   See {#process!} for more information.
      # @return [Boolean]
      def process(cmd)
        process!(cmd)
      # rescue OneGadget::Error::UnsupportedError => e; p e # for debugging
      rescue OneGadget::Error::Error
        false
      end

      # Method need to be implemented in inheritors.
      #
      # Process one command.
      # Will raise exceptions when encounter unhandled instruction.
      # @param [String] _cmd
      #   One line from result of objdump.
      # @return [Boolean]
      #   If successfully processed.
      def process!(_cmd); raise NotImplementedError
      end

      # Method need to be implemented in inheritors.
      # @return [Array<Instruction>] The support instructions.
      def instructions; raise NotImplementedError
      end

      # To be inherited.
      #
      # @param [Integer] _idx
      #   The idx-th argument.
      #
      # @return [Lambda, Integer]
      #   Return value can be a {Lambda} or an +Integer+.
      def argument(_idx); raise NotImplementedError
      end

      # @return [Array<String>]
      #   Extra constraints found during execution.
      def constraints
        return [] if @constraints.empty?

        # we have these types:
        # * :writable
        # * :raw
        cons = @constraints.uniq do |type, obj|
          next obj unless type == :writable

          obj.deref_count.zero? ? obj.obj.to_s : obj.to_s
        end
        cons.map { |type, obj| type == :writable ? "writable: #{obj}" : obj }.sort
      end

      # Method need to be implemented in inheritors.
      #
      # @param [String | Lambda] obj
      #  A lambda object or its string.
      # @return [Hash{Integer => Lambda}, nil]
      #  The corresponding stack that +obj+ used,
      #  or nil if +obj+ doesn't use the stack.
      def get_corresponding_stack(obj); raise NotImplementedError
      end

      private

      def check_register!(reg)
        raise Error::InstructionArgumentError, "#{reg.inspect} is not a valid register" unless register?(reg)
      end

      def check_argument(idx, expect)
        case expect
        when :global_var? then global_var?(argument(idx))
        when :zero? then argument(idx).is_a?(Integer) && argument(idx).zero?
        end
      end

      def register?(reg)
        registers.include?(reg)
      end

      def to_lambda(reg)
        OneGadget::Emulators::Lambda.new(reg)
      end

      # Fetch the corresponding lambda value of instruction arguments from the current register sets.
      #
      # @param [String] arg The instruction argument passed to inst_* functions.
      # @return [Lambda]
      def arg_to_lambda(arg)
        OneGadget::Emulators::Lambda.parse(arg, predefined: registers)
      end

      def raise_unsupported(inst, *args)
        raise OneGadget::Error::UnsupportedInstructionArgumentError, "#{inst} #{args.join(', ')}"
      end

      def eval_dict
        { sp => 0 }
      end

      def size_t
        self.class.bits / 8
      end

      def global_var?(obj)
        obj.to_s.include?(pc)
      end

      class << self
        # 32 or 64.
        # @return [Integer] 32 or 64.
        def bits; raise NotImplementedError
        end
      end
    end
  end
end
