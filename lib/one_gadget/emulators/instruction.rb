require 'one_gadget/error'

module OneGadget
  module Emulators
    # Define instruction name and it's argument count.
    class Instruction
      attr_reader :inst # @return [String]  The instruction name.
      attr_reader :argc # @return [Integer] Count of arguments.
      # Instantiate a {Instruction} object.
      # @param [String] inst The instruction name.
      # @param [Integer] argc
      #   Count of arguments.
      #   Negative integer for doesn't care the number of arguments.
      def initialize(inst, argc)
        @inst = inst
        @argc = argc
      end

      # Extract arguments from command.
      # @param [String] cmd
      # @return [Array<String>] Arguments.
      def fetch_args(cmd)
        idx = cmd.index(inst)
        cmd = cmd[0...cmd.rindex('#')] if cmd.rindex('#')
        args = cmd[idx + inst.size..-1].split(',')
        if argc >= 0 && args.size != argc
          raise Error::ArgumentError, "Incorrect argument number in #{cmd}, expect: #{argc}"
        end
        args.map do |arg|
          arg.gsub(/XMMWORD|QWORD|DWORD|WORD|BYTE|PTR/, '').strip
        end
      end

      # If the command contains this instruction.
      # @param [String] cmd
      # @return [Boolean]
      def match?(cmd)
        cmd.include?(inst + ' ')
      end
    end
  end
end
