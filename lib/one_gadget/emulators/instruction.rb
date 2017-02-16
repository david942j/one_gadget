module OneGadget
  module Emulators
    # Define instruction name and it's argument count.
    class Instruction
      attr_reader :inst # @return [String]
      attr_reader :argc # @return [Integer]
      def initialize(inst, argc)
        @inst = inst
        @argc = argc
      end

      def fetch_args(cmd)
        idx = cmd.index(inst)
        cmd = cmd[0...cmd.rindex('#')] if cmd.rindex('#')
        args = cmd[idx + inst.size..-1].split(',')
        raise ArgumentError, "Incorrect argument number in #{cmd}, expect: #{argc}" if args.size != argc
        args.map do |arg|
          arg.gsub(/QWORD|DWORD|WORD|BYTE|PTR/, '').strip
        end
      end

      def match?(str)
        str.include?(inst)
      end
    end
  end
end
