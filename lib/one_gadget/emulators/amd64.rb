# frozen_string_literal: true

require 'one_gadget/abi'
require 'one_gadget/emulators/x86'

module OneGadget
  module Emulators
    # Emulator of amd64 instruction set.
    class Amd64 < X86
      class << self
        # Bits.
        def bits
          64
        end
      end

      # Instantiate an {Amd64} object.
      def initialize
        super(OneGadget::ABI.amd64, 'rsp', 'rbp', 'rip')
      end

      # Return the argument value of calling a function.
      # @param [Integer] idx The 0-based index of the argument.
      # @return [Lambda, Integer] The value held in the register used for the +idx+-th argument.
      def argument(idx)
        case idx
        when 0 then registers['rdi']
        when 1 then registers['rsi']
        when 2 then registers['rdx']
        when 3 then registers['rcx']
        when 4 then registers['r8']
        when 5 then registers['r9']
        end
      end

      private

      # Resolve a rip-relative operand to +$base+<file offset>+ (base-relative like
      # arm's +adrp+, not instruction-relative +rip+disp+), taking the offset from
      # objdump's resolution comment and dropping it. Applies to compares too -- a
      # +cmp [rip+x], imm+ branch condition wants the concretized global, not a raw
      # +rip+ (and the trailing comment stripped). Only an actual branch is left
      # untouched: the branch-aware search steers it and its target isn't a data
      # operand.
      # @example
      #   concretize_rip('d67f1: lea rdi,[rip+0x8ab61]  # 161359 <sym>')
      #   #=> 'd67f1: lea rdi,[$base+0x161359]'
      #   concretize_rip('e6731: cmp [rip+0x2dd750],0x0  # 3c3e88 <sym>')
      #   #=> 'e6731: cmp [$base+0x3c3e88],0x0'
      def concretize_rip(cmd)
        resolved = cmd[/#\s*([0-9a-f]+)/, 1]
        return cmd unless resolved && cmd.include?('rip')
        return cmd if branch_mnem?(mnemonic(cmd))

        cmd.sub(/(\[?)rip[+-]0x[0-9a-f]+(\]?)/) { "#{Regexp.last_match(1)}$base+0x#{resolved}#{Regexp.last_match(2)}" }
           .sub(/\s*#.*/, '') # to end-of-line, not \z: the objdump line may end in "\n"
      end

      # Build a lambda for a concretized +$base+<off>+ operand (optionally
      # bracketed); anything else falls back to {Processor#arg_to_lambda}.
      # @example
      #   arg_to_lambda('$base+0x161359').to_s    #=> '$base+0x161359'
      #   arg_to_lambda('[$base+0x1ebeb0]').to_s  #=> '[$base+0x1ebeb0]'
      #   arg_to_lambda('rdi')                    # not a $base operand -> super
      def arg_to_lambda(arg)
        m = arg.match(/\A(\[*)\$base\+0x([0-9a-f]+)(\]*)\z/)
        return super unless m

        lmda = libc_base + m[2].to_i(16)
        m[1].size.times { lmda = lmda.deref }
        lmda
      end

      # Recognise the concretized libc-global marker as a global variable.
      # @example
      #   global_var?('$base+0x100')  #=> true
      #   global_var?('rax')          #=> false
      def global_var?(obj)
        super || obj.to_s.include?(libc_base.obj)
      end
    end
  end
end
