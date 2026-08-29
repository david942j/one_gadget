# frozen_string_literal: true

require 'one_gadget/error'

module OneGadget
  module Emulators
    # Define instruction name and it's argument count.
    class Instruction
      attr_reader :inst # @return [String]  The instruction name.
      attr_reader :argc # @return [Range] Count of arguments.

      # Instantiate a {Instruction} object.
      # @param [String] inst The instruction name.
      # @param [Range, Integer] argc
      #   Count of arguments.
      #   Negative integer for doesn't care the number of arguments.
      def initialize(inst, argc)
        @inst = inst
        @argc = case argc
                when -1 then 0..Float::INFINITY
                when Range then argc
                when Integer then argc..argc
                end
      end

      # Extract arguments from command.
      # @param [String] cmd One line of objdump output containing this instruction.
      # @return [Array<String>] The instruction's operands, with size hints and comments stripped.
      # @raise [OneGadget::Error::InstructionArgumentError]
      #   Raised when the number of operands does not match {#argc}.
      def fetch_args(cmd)
        idx = cmd.index(inst)
        cmd = cmd[0...cmd.rindex('//')] if cmd.rindex('//')
        cmd = cmd[0...cmd.rindex('#')] if cmd.rindex('#')
        args = parse_args(cmd[idx + inst.size..])
        unless argc.include?(args.size)
          raise OneGadget::Error::InstructionArgumentError, "Incorrect argument number in #{cmd}, expect: #{argc}"
        end

        args.map do |arg|
          arg.gsub(/XMMWORD|QWORD|DWORD|WORD|BYTE|PTR/, '').strip
        end
      end

      # If the command contains this instruction.
      # @param [String] cmd One line of objdump output.
      # @return [Boolean] +true+ if +cmd+ contains this instruction's mnemonic.
      def match?(cmd)
        cmd.match?(/#{Regexp.escape(inst)}\s/)
      end

      class << self
        # The emulator method that runs +mnemonic+. A mnemonic is not always a
        # method name -- one can carry a suffix spelled with a dot -- so the dots
        # become underscores. Named here, rather than at each dispatch, so an
        # emulator defining a family of handlers at once agrees with the dispatcher
        # about what to call them.
        # @param [String] mnemonic
        # @return [Symbol]
        # @example
        #   Instruction.handler_name('mov')     #=> :inst_mov
        #   Instruction.handler_name('sext.w')  #=> :inst_sext_w
        def handler_name(mnemonic) = :"inst_#{mnemonic.tr('.', '_')}"
      end

      # The emulator method that runs this instruction.
      # @return [Symbol]
      # @see .handler_name
      def handler
        @handler ||= self.class.handler_name(inst)
      end

      private

      def parse_args(str)
        args = []
        cur = +''
        bkt_cnt = 0
        str.each_char do |c|
          if c == ',' && bkt_cnt.zero?
            args << cur
            cur = +''
            next
          end

          cur << c
          case c
          when '[' then bkt_cnt += 1
          when ']' then bkt_cnt -= 1
          end
        end
        args << cur unless cur.empty?
        args
      end
    end
  end
end
