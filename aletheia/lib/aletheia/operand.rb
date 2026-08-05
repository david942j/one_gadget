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
  Operand = Struct.new(:reg, :imm, :deref, :cast_bits, :inner_imm) do
    # @return [Boolean] a bare register with no displacement and no dereference.
    def bare_reg?
      !reg.nil? && imm.zero? && deref.zero?
    end

    # @return [Boolean] a plain integer literal (no register, no dereference).
    def literal?
      reg.nil? && deref.zero?
    end
  end

  module Operand_
    module_function

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
      return Operand.new(nil, 0, deref, cast, 0) if s == 'NULL'
      return Operand.new(nil, Integer(s), deref, cast, 0) if s.match?(/\A-?(0x[0-9a-fA-F]+|\d+)\z/)

      # A displacement off a dereferenced value, e.g. `[$base+0x1c2438]+0xe8`
      # (what remains of `[[$base+0x1c2438]+0xe8]` once the outer brackets are
      # stripped). One such level is modelled; anything deeper is not needed.
      if (m = s.match(/\A(\[.+\])\s*([+-]\s*(?:0x[0-9a-fA-F]+|\d+))?\z/))
        inner = parse(m[1])
        raise ArgumentError, "unparseable operand: #{str.inspect}" unless inner.deref == 1 && inner.inner_imm.zero?

        return Operand.new(inner.reg, inner.imm, deref + inner.deref, cast,
                           m[2] ? Integer(m[2].gsub(/\s+/, '')) : 0)
      end

      m = s.match(/\A(\$?[a-zA-Z_][a-zA-Z0-9_]*)\s*([+-]\s*(?:0x[0-9a-fA-F]+|\d+))?\z/)
      raise ArgumentError, "unparseable operand: #{str.inspect}" unless m

      imm = m[2] ? Integer(m[2].gsub(/\s+/, '')) : 0
      Operand.new(m[1], imm, deref, cast, 0)
    end
  end
end
