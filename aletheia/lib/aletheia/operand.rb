# frozen_string_literal: true

module Aletheia
  # An independent parser for the operand expressions that appear inside
  # one_gadget constraint strings, e.g. +x0+, +sp+0x218+, +[sp+0x50]+,
  # +(u16)[sp+0x218]+, +x20+0x338+, +$base+0x16b250+, +environ+, +NULL+.
  #
  # Deliberately written from scratch rather than reusing the emulator's own
  # +Lambda.parse+: the tool under verification must not supply the semantics
  # used to check it. This keeps a bug in one_gadget's parser from silently
  # propagating into the verifier. (A cross-check against +Lambda.parse+ is
  # cheap and can be layered on top when desired.)
  # +inner_imm+ is the displacement applied *between* two dereferences, as in
  # +[[$base+0x1c2438]+0xe8]+ (follow a pointer, then read a field off it): the
  # address is +[reg+imm] + inner_imm+. It is 0 for every single-level operand,
  # where +imm+ alone describes the displacement.
  # +base_imm+ is a fixed libc address added to the register, as in
  # +(r1 + $base+0x2d364)+: the value is +reg + $base+base_imm + imm+. It is 0
  # for every operand that names no such address.
  Operand = Struct.new(:reg, :imm, :deref, :cast_bits, :inner_imm, :base_imm) do
    # @return [Boolean] a bare register with no displacement and no dereference.
    def bare_reg?
      !reg.nil? && imm.zero? && deref.zero?
    end

    # @return [Boolean] a plain integer literal (no register, no dereference).
    def literal?
      reg.nil? && deref.zero?
    end
  end

  # Reads one of those expressions into an {Operand}. Kept apart from the struct
  # so the value and the syntax that produces it stay separable.
  module OperandParser
    module_function

    NUM = /0x[0-9a-fA-F]+|\d+/
    # A register added to a fixed libc address, optionally displaced further.
    # @example +(r1 + $base+0x2d364)+, +(r2 + $base+0x5048c)+0x8+
    BASE_SUM = /\A\(([a-zA-Z_]\w*) \+ \$base\s*([+-]\s*#{NUM})\)\s*([+-]\s*#{NUM})?\z/

    # @param [String] str
    # @return [Aletheia::Operand]
    def parse(str)
      s = str.strip
      cast = nil
      if (m = s.match(/\A\(([su])(\d+)\)/))
        cast = m[2].to_i
        s = s[m[0].length..].strip
      end
      deref = 0
      while s.start_with?('[') && s.end_with?(']')
        deref += 1
        s = s[1..-2].strip
      end
      # Matched before the grouping parentheses are stripped: for a base sum they
      # are what delimits it from a trailing displacement.
      if (m = s.match(BASE_SUM))
        return Operand.new(m[1], displacement(m[3]), deref, cast, 0, displacement(m[2]))
      end

      # A parenthesised sum, e.g. the `(x0 + 0x1)` of `(u64)(x0 + 0x1) <= 0x0`:
      # the parentheses only group, they don't dereference.
      s = s[1..-2].strip while s.start_with?('(') && s.end_with?(')')
      return Operand.new(nil, 0, deref, cast, 0, 0) if s == 'NULL'
      return Operand.new(nil, Integer(s), deref, cast, 0, 0) if s.match?(/\A-?(?:#{NUM})\z/)

      # A displacement off a dereferenced value, e.g. `[$base+0x1c2438]+0xe8`
      # (what remains of `[[$base+0x1c2438]+0xe8]` once the outer brackets are
      # stripped). One such level is modelled; anything deeper is not needed.
      if (m = s.match(/\A(\[.+\])\s*([+-]\s*(?:#{NUM}))?\z/))
        inner = parse(m[1])
        raise ArgumentError, "unparseable operand: #{str.inspect}" unless inner.deref == 1 && inner.inner_imm.zero?

        return Operand.new(inner.reg, inner.imm, deref + inner.deref, cast, displacement(m[2]), inner.base_imm)
      end

      m = s.match(/\A(\$?[a-zA-Z_][a-zA-Z0-9_]*)\s*([+-]\s*(?:#{NUM}))?\z/)
      raise ArgumentError, "unparseable operand: #{str.inspect}" unless m

      Operand.new(m[1], displacement(m[2]), deref, cast, 0, 0)
    end

    # The integer a matched displacement denotes, 0 when the operand carries none.
    # @param [String, nil] text
    # @return [Integer]
    def displacement(text)
      text ? Integer(text.gsub(/\s+/, '')) : 0
    end
  end
end
