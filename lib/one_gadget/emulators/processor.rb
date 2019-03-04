require 'one_gadget/emulators/lambda'
require 'one_gadget/error'

module OneGadget
  # Instruction emulator to solve the constraint of gadgets.
  module Emulators
    # Base class of a processor.
    class Processor
      attr_reader :registers # @return [Hash{String => OneGadget::Emulators::Lambda}] The current registers' state.
      attr_reader :stack # @return [Hash{Integer => OneGadget::Emulators::Lambda}] The content on stack.
      attr_reader :sp # @return [String] Stack pointer.

      # Instantiate a {Processor} object.
      # @param [Array<String>] registers
      #   Registers that supported in the architecture.
      # @param [String] sp
      #   The stack register.
      def initialize(registers, sp)
        @registers = registers.map { |reg| [reg, to_lambda(reg)] }.to_h
        @sp = sp
        @stack = Hash.new do |h, k|
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
        # rescue OneGadget::Error::UnsupportedInstructionError # for debugging
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

      private

      def register?(reg)
        registers.include?(reg)
      end

      def to_lambda(reg)
        OneGadget::Emulators::Lambda.new(reg)
      end

      def raise_unsupported(inst, *args)
        raise OneGadget::Error::UnsupportedInstructionArgumentError, "#{inst} #{args.join(', ')}"
      end
    end
  end
end
