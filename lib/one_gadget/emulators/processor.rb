require 'one_gadget/emulators/lambda'

module OneGadget
  # Instruction emulator to solve the constraint of gadgets.
  module Emulators
    # Base class of a processor.
    class Processor
      attr_reader :registers # @return [Hash{String => OneGadget::Emulators::Lambda}] The current registers' state.
      # Instantiate a {Processor} object.
      # @param [Array<String>] registers Registers that supported in the architecture.
      def initialize(registers)
        @registers = registers.map { |reg| [reg, OneGadget::Emulators::Lambda.new(reg)] }.to_h
      end

      # Parse one command into instruction and arguments.
      # @param [String] cmd One line of result of objdump.
      # @return [Array(Instruction, Array<String>)]
      #   The parsing result.
      def parse(cmd)
        inst = instructions.find { |i| i.match?(cmd) }
        raise ArgumentError, "Not implemented instruction in #{cmd}" if inst.nil?
        [inst, inst.fetch_args(cmd)]
      end

      # Method need to be implemented in inheritors.
      # @return [void]
      def process(_cmd); raise NotImplementedError
      end

      # Method need to be implemented in inheritors.
      # @return [Array<Instruction>] The support instructions.
      def instructions; raise NotImplementedError
      end
    end
  end
end
