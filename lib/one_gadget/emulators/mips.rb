# frozen_string_literal: true

require 'one_gadget/abi'
require 'one_gadget/emulators/instruction'
require 'one_gadget/emulators/processor'

module OneGadget
  module Emulators
    # Emulator of MIPS (32-bit, o32).
    class Mips < Processor
      # Instantiate a {Mips} object.
      def initialize
        super(OneGadget::ABI.mips, 'sp')
        @registers['zero'] = 0 # hardwired
        @pc = 'pc'
      end

      # This arch compares and branches in one instruction -- there is no flag
      # register -- so each mnemonic names the relation its operands must stand in
      # for the branch to be taken. The spellings against zero name one operand;
      # +zero+ is the other, and reads as the +0x0+ it holds.
      # @return [Hash{String => Symbol}]
      COND = {
        'beq' => :eq, 'bne' => :ne,
        'beqz' => :eq, 'bnez' => :ne,
        'blez' => :sle, 'bgtz' => :sgt, 'bltz' => :slt, 'bgez' => :sge
      }.freeze

      # The data-processing instructions, mapped to the Ruby operator that folds
      # them. An immediate form differs from its register one only in how the right
      # operand is written, which the operand reader already handles, so both name
      # the same operator. Arithmetic shift right is absent: a value is held masked
      # to its width, where +>>+ is the logical shift.
      DATA_OPS = {
        'and' => :&, 'andi' => :&,
        'or' => :|, 'ori' => :|,
        'xor' => :^, 'xori' => :^,
        'sll' => :<<, 'srl' => :>>
      }.freeze
      private_constant :DATA_OPS

      # The loads, mapped to how many bytes each reads.
      LOADS = { 'lw' => 4, 'lh' => 2, 'lhu' => 2, 'lb' => 1, 'lbu' => 1 }.freeze
      private_constant :LOADS

      # The stores, mapped to how many bytes each writes.
      STORES = { 'sw' => 4, 'sh' => 2, 'sb' => 1 }.freeze
      private_constant :STORES

      # Supported instruction set. Anything not listed aborts the candidate.
      # @return [Array<Instruction>] The supported instructions.
      def instructions
        [
          Instruction.new('addiu', 3),
          Instruction.new('addu', 3),
          Instruction.new('bal', 1),
          Instruction.new('jal', 1),
          Instruction.new('jalr', 1..2),
          Instruction.new('li', 2),
          Instruction.new('lui', 2),
          Instruction.new('move', 2),
          Instruction.new('nop', 0),
          Instruction.new('subu', 3)
        ] + (LOADS.keys + STORES.keys).map { |mnem| Instruction.new(mnem, 2) } +
          DATA_OPS.keys.map { |mnem| Instruction.new(mnem, 3) }
      end

      # The value of a call's +idx+-th argument. o32 states the first four in
      # registers, and reserves a stack slot for every argument including those --
      # so an argument's slot is its index however it is passed, and the ones past
      # the registers are read from there.
      # @param [Integer] idx The 0-based index of the argument.
      # @return [Lambda, Integer]
      def argument(idx)
        return registers["a#{idx}"] if idx < ARG_REGISTERS

        top = registers['sp'].evaluate('sp' => 0)
        sp_based_stack[top + (idx * size_t)]
      end

      # @see OneGadget::Emulators::X86#process!
      # @param [String] cmd One line from result of objdump.
      # @return [Boolean] If successfully processed.
      def process!(cmd)
        resolve_pending_branch(cmd)
        @cur_addr = cmd[/\A\s*([0-9a-f]+):/, 1]&.to_i(16)

        mnem = mnemonic(cmd)
        return handle_branch(mnem, cmd) != :fail if branch_mnem?(mnem)

        inst, args = parse(cmd)
        __send__(inst.handler, *args) != :fail
      end

      # How many arguments this ABI states in registers.
      ARG_REGISTERS = 4
      private_constant :ARG_REGISTERS

      private

      def branch_mnem?(mnem) = mnem == 'b' || COND.key?(mnem)

      # Operands of +cmd+ (mnemonic dropped), each stripped of a trailing +<symbol>+.
      def operands(cmd)
        cmd.sub(/\A[0-9a-f]+:\s*\S+\s*/, '').split(',').map { |o| o.strip.sub(/\s*<.*>\z/, '') }
      end

      # Record the comparison and decide the branch together, since one
      # instruction is both (see {COND}).
      def handle_branch(mnem, cmd)
        return true if mnem == 'b' # unconditional: control handled by the stitched path

        ops = operands(cmd)
        lhs, rhs = mnem.end_with?('z') ? [ops[0], 'zero'] : ops[0..1]
        record_compare(:sub, operand_str(lhs), operand_str(rhs))
        branch_on_compare(COND[mnem], ops.last.to_i(16))
      end

      # A call: record the terminal +exec*+ target, accept a known-safe libc call,
      # or +:fail+ to abort the candidate. This arch reaches most of libc through a
      # register, so the name comes from what the fetcher wrote beside it
      # (+OneGadget::Fetchers::Mips+); a call it could not name is one the emulator
      # cannot reason about either, which {Processor#dispatch_safe_call} refuses.
      # @param [String] addr The call target, as the line names it.
      # @return [nil, :fail]
      def call_target(addr)
        return reach_terminal_call(addr) if terminal_call?(addr)

        dispatch_safe_call(addr)
      end

      # +jalr+ takes the register holding the target, optionally preceded by the
      # register the return address goes to; the target is the last either way.
      def inst_jalr(*args) = call_target(args.last)

      # A direct call, which states its target outright.
      def inst_jal(addr) = call_target(addr)

      # +bal+ is the pc-relative direct call; it names its target as +jal+ does.
      def inst_bal(addr) = call_target(addr)

      def inst_nop = true

      def inst_move(dst, src)
        check_register!(dst)

        registers[dst] = arg_to_lambda(src)
      end

      # +li+ is the assembler's spelling of loading a constant, whatever the
      # instructions it expands to.
      def inst_li(dst, imm)
        check_register!(dst)

        registers[dst] = Integer(imm)
      end

      # +lui dst, imm+ loads the immediate into the upper half of the register.
      def inst_lui(dst, imm)
        check_register!(dst)

        registers[dst] = (imm.to_i(16) << 16) & width_mask
      end

      # +addu dst, src, op2+; +addiu+ differs only in that its right operand is
      # written as a literal. Neither traps on overflow, which is why the compiler
      # uses them for address arithmetic and the trapping forms are not modelled.
      def inst_addu(dst, src, op2) = arith(:+, dst, src, op2)
      alias inst_addiu inst_addu

      # +subu dst, src, op2+. See {#inst_addu}.
      def inst_subu(dst, src, op2) = arith(:-, dst, src, op2)

      # Each data-processing mnemonic handled the one way, since they differ only
      # in the operator applied.
      DATA_OPS.each do |mnem, op|
        define_method(Instruction.handler_name(mnem)) do |dst, src, op2|
          data_op(op, dst, src, op2, name: mnem)
        end
      end

      LOADS.each do |mnem, size|
        define_method(Instruction.handler_name(mnem)) { |dst, mem| load_value(dst, mem, size) }
      end

      STORES.each do |mnem, size|
        define_method(Instruction.handler_name(mnem)) { |src, mem| store_value(src, mem, size) }
      end

      # A load. The address is read like any other, so what the caller has to
      # arrange about it is recorded the same way. A load narrower than a register
      # only takes part of the word this emulator tracks, which is not a value it
      # can name, so the register then holds what a call would have left.
      # @param [String] dst The destination register.
      # @param [String] mem The memory operand, as written.
      # @param [Integer] size How many bytes the load reads.
      # @return [void]
      def load_value(dst, mem, size)
        check_register!(dst)

        value = read_value(arg_to_lambda(mem_operand(mem)))
        registers[dst] = size == size_t ? value : clobbered_value
      end

      # A store, tracked so a later load of the same slot reads it back, and
      # requiring its target writable ({Processor#track_write}). A store narrower
      # than a register leaves the rest of the slot as it was, so what the slot
      # then holds is named as unknown rather than as the value stored.
      # @param [String] src The register holding the value stored.
      # @param [String] mem The memory operand, as written.
      # @param [Integer] size How many bytes the store writes.
      # @return [void]
      def store_value(src, mem, size)
        check_register!(src)

        dst_l = arg_to_lambda(mem_operand(mem)).ref!
        track_write(dst_l, size == size_t ? registers[src] : clobbered_value)
      end

      # This arch writes a memory operand as an offset applied to one register,
      # which the {Lambda} parser reads in its bracketed form. The offset is
      # decimal, as objdump prints it.
      # @param [String] mem The operand, as written.
      # @return [String]
      # @example
      #   mem_operand('-31652(gp)') #=> '[gp-31652]'
      #   mem_operand('4(s6)')      #=> '[s6+4]'
      def mem_operand(mem)
        m = mem.match(/\A(-?\d+)\((\w+)\)\z/)
        raise_unsupported('memory operand', mem) if m.nil?

        "[#{m[2]}#{format('%+d', Integer(m[1]))}]"
      end

      class << self
        # o32 is 32-bit.
        # @return [Integer]
        def bits
          32
        end
      end
    end
  end
end
