# frozen_string_literal: true

require 'one_gadget/abi'
require 'one_gadget/emulators/instruction'
require 'one_gadget/emulators/processor'

module OneGadget
  module Emulators
    # Emulator of RISC-V (RV64).
    class Riscv64 < Processor
      # Instantiate a {Riscv64} object.
      def initialize
        super(OneGadget::ABI.riscv64, 'sp')
        @registers['zero'] = 0 # hardwired
        @pc = 'pc'
        setup_frame_pointer('s0') # track argv/data staged off the frame pointer
      end

      # @see OneGadget::Emulators::X86#process!
      def process!(cmd)
        resolve_pending_branch(cmd)
        @cur_addr = cmd[/\A\s*([0-9a-f]+):/, 1]&.to_i(16)

        inst, args = parse(cmd)
        __send__(inst.handler, *args) != :fail
      end

      # Supported instruction set. Anything not listed aborts the candidate.
      # @return [Array<Instruction>] The supported instructions.
      def instructions
        [
          Instruction.new('add', 3),
          Instruction.new('addi', 3),
          Instruction.new('auipc', 2),
          Instruction.new('jal', 1..2),
          Instruction.new('li', 2),
          Instruction.new('lui', 2),
          Instruction.new('mv', 2),
          Instruction.new('nop', 0),
          Instruction.new('sub', 3)
        ]
      end

      # Return the argument value of calling a function.
      # @param [Integer] idx The 0-based index of the argument.
      # @return [Lambda, Integer] The value held in register +a<idx>+, used for the +idx+-th argument.
      def argument(idx)
        registers["a#{idx}"]
      end

      private

      # A direct call: record the terminal +exec*+ target, accept a known-safe
      # syscall wrapper, or +:fail+ to abort the candidate. The two-operand form
      # names the register the return address is written to, which is +ra+ for a
      # call and is not modelled either way.
      def inst_jal(*args)
        addr = args.last
        return reach_terminal_call(addr) if terminal_call?(addr)

        dispatch_safe_call(addr)
      end

      # +auipc dst, imm+ is how this arch names an address relative to the
      # instruction itself: the immediate objdump prints is the upper 20 bits, so
      # the value is +pc + (imm << 12)+. The +addi+/load that follows applies the
      # low half, which is what makes the pair resolve to the +$base+<off>+ form
      # the rest of the engine reads as a libc global.
      # @example the pair objdump resolves to 171fc0 in its own comment
      #   9f48e: auipc a5,0xd3     # a5 = $base+0x17248e
      #   9f492: ld    a5,-1230(a5) # a5 = [$base+0x171fc0]
      def inst_auipc(dst, imm)
        check_register!(dst)

        registers[dst] = pc_value + (imm.to_i(16) << 12)
      end

      # +lui dst, imm+ loads the same upper 20 bits, but as a plain value rather
      # than an address, so nothing about the instruction's own location enters it.
      def inst_lui(dst, imm)
        check_register!(dst)

        registers[dst] = (imm.to_i(16) << 12) & width_mask
      end

      # +li+ is the assembler's spelling of loading a constant, whatever the
      # instructions it expands to.
      def inst_li(dst, imm)
        check_register!(dst)

        registers[dst] = Integer(imm)
      end

      # This arch spells no modifier on an operand and has no 2-operand shorthand,
      # so the arithmetic is the plain three-operand form; +addi+ differs from
      # +add+ only in that its right operand is written as a literal.
      def inst_add(dst, src, op2) = arith(:+, dst, src, op2)
      alias inst_addi inst_add

      # +sub dst, src, op2+. See {#inst_add}.
      def inst_sub(dst, src, op2) = arith(:-, dst, src, op2)

      def inst_mv(dst, src)
        check_register!(dst)

        registers[dst] = arg_to_lambda(src)
      end

      # The value +pc+ holds while the instruction at {@cur_addr} runs: this arch
      # reads its own address, with no pipeline bias to add.
      def pc_value
        libc_base + @cur_addr
      end

      class << self
        # RV64 is 64-bit.
        def bits
          64
        end
      end
    end
  end
end
