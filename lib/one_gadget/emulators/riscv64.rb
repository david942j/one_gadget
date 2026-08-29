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

        mnem = mnemonic(cmd)
        return handle_branch(mnem, cmd) != :fail if branch_mnem?(mnem)

        inst, args = parse(cmd)
        __send__(inst.handler, *args) != :fail
      end

      # A conditional branch of this arch compares its operands itself -- there is
      # no flag register and no compare instruction -- so each mnemonic names the
      # relation the operands must stand in for the branch to be taken. The
      # assembler's spellings against zero (+beqz+, +blez+, ...) name one register
      # and the reversed ones (+bgt+, +ble+, ...) read a relation the other way
      # round; each is listed as the relation it states, so a constraint reads as
      # the comparison was written.
      COND = {
        'beq' => :eq, 'bne' => :ne,
        'blt' => :slt, 'bge' => :sge, 'bltu' => :ult, 'bgeu' => :uge,
        'bgt' => :sgt, 'ble' => :sle, 'bgtu' => :ugt, 'bleu' => :ule,
        'beqz' => :eq, 'bnez' => :ne,
        'bltz' => :slt, 'bgez' => :sge, 'blez' => :sle, 'bgtz' => :sgt
      }.freeze

      # The loads, mapped to how many bytes each reads.
      LOADS = { 'ld' => 8, 'lw' => 4, 'lwu' => 4, 'lh' => 2, 'lhu' => 2, 'lb' => 1, 'lbu' => 1 }.freeze
      private_constant :LOADS

      # The stores, mapped to how many bytes each writes.
      STORES = { 'sd' => 8, 'sw' => 4, 'sh' => 2, 'sb' => 1 }.freeze
      private_constant :STORES

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
        ] + (LOADS.keys + STORES.keys).map { |mnem| Instruction.new(mnem, 2) }
      end

      # Return the argument value of calling a function.
      # @param [Integer] idx The 0-based index of the argument.
      # @return [Lambda, Integer] The value held in register +a<idx>+, used for the +idx+-th argument.
      def argument(idx)
        registers["a#{idx}"]
      end

      private

      def branch_mnem?(mnem)
        mnem == 'j' || COND.key?(mnem)
      end

      # Operands of +cmd+ (mnemonic dropped), each stripped of a trailing +<symbol>+.
      def operands(cmd)
        cmd.sub(/\A[0-9a-f]+:\s*\S+\s*/, '').split(',').map { |o| o.strip.sub(/\s*<.*>\z/, '') }
      end

      # Record the comparison and decide the branch together, since one
      # instruction is both (see {COND}). The zero spellings leave their second
      # operand out; +zero+ names it, and reads as the +0x0+ it holds.
      def handle_branch(mnem, cmd)
        return true if mnem == 'j' # unconditional: control handled by the stitched path

        ops = operands(cmd)
        lhs, rhs = mnem.end_with?('z') ? [ops[0], 'zero'] : ops[0..1]
        record_compare(:sub, operand_str(lhs), operand_str(rhs))
        branch_on_compare(COND[mnem], ops.last.to_i(16))
      end

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

      # Each load and store handled the one way, since within a family they differ
      # only in the width they touch (see {#load_value} and {#store_value}).
      LOADS.each do |mnem, size|
        define_method(Instruction.handler_name(mnem)) { |dst, mem| load_value(dst, mem, size) }
      end
      STORES.each do |mnem, size|
        define_method(Instruction.handler_name(mnem)) { |src, mem| store_value(src, mem, size) }
      end

      # A load. The address is read like any other, so what the caller has to
      # arrange about it is recorded the same way. A load narrower than a register
      # only takes part of the word this emulator tracks, which is not a value it
      # can name, so the register then holds what a call would have left: a path
      # that goes on to depend on it is abandoned rather than described wrongly.
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
      # than a register leaves the rest of the slot holding whatever was there, so
      # what the slot then holds is named as unknown rather than as the value
      # stored -- the requirement that it be writable is what the candidate really
      # establishes, and that is kept.
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
      # decimal, as objdump prints every operand but an upper immediate.
      # @param [String] mem The operand, as written.
      # @return [String]
      # @example
      #   mem_operand('-1230(a5)') #=> '[a5-1230]'
      #   mem_operand('0(s1)')     #=> '[s1+0]'
      def mem_operand(mem)
        m = mem.match(/\A(-?\d+)\((\w+)\)\z/)
        raise_unsupported('memory operand', mem) if m.nil?

        "[#{m[2]}#{format('%+d', Integer(m[1]))}]"
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
