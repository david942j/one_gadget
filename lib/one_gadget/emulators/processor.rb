require 'one_gadget/emulators/instruction'

module OneGadget
  # Instruction emulator to solve the constraint of gadgets.
  module Emulators
    # Base class of a processor.
    class Processor
      attr_reader :registers
      attr_accessor :stack
      def initialize(registers)
        @registers = registers.map { |reg| [reg, OneGadget::Emulators::Lambda.new(reg)] }.to_h
        @stack = []
      end

      def parse(cmd)
        inst = instructions.find { |i| i.match?(cmd) }
        raise ArgumentError, "Not implemented instruction in #{cmd}" if inst.nil?
        [inst, inst.fetch_args(cmd)]
      end

      def process(_cmd); raise NotImplementedError
      end

      def instructions; raise NotImplementedError
      end
    end
  end
end
