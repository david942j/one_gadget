# frozen_string_literal: true

require 'one_gadget/emulators/lambda'

module OneGadget
  module Emulators
    # The memory a candidate reads and writes. Every store is filed under the base
    # its address is an offset from -- the stack pointer, the frame pointer, or any
    # register holding a pointer the caller supplies -- so a later load of the same
    # slot reads back what this candidate put there, and a load of an untouched one
    # is answered as what the caller left. Mixed into {Processor}.
    module TrackedMemory
      # @return [Hash{Integer => OneGadget::Emulators::Lambda}] Memory written through +sp+.
      def sp_based_stack = get_corresponding_stack(sp)

      # @return [Hash{Integer => Lambda}, nil] Memory written through {#bp}, or nil when the arch has none.
      def bp_based_stack = bp && get_corresponding_stack(bp)

      # Enable frame-pointer stack tracking with +bp+ as the frame register, so a
      # gadget staging data at +[bp+imm]+ (e.g. an argv array off the frame
      # pointer) is recovered instead of collapsing to a bare +writable:+. A nil
      # +bp+ leaves the arch +sp+-only. Call from the arch initializer after +super+.
      # @return [void]
      def setup_frame_pointer(bp)
        @bp = bp
      end

      # Where +address+ lands in the memory this emulator tracks: the stack it
      # falls in and its offset within it. A load or store passes the address it
      # dereferences, i.e. its operand with that dereference peeled off.
      # @param [Lambda, String] address An address.
      # @return [(Hash{Integer => Lambda}?, Integer)] The stack, +nil+ if none
      #   tracks this address, and the offset to index it at.
      # @example an offset from a register
      #   resolve_address(Lambda.parse('rsp+0x10')) #=> [sp_based_stack, 0x10]
      # @example an offset from a pointer no register names
      #   resolve_address(Lambda.parse('[rbp-0x48]+0x8')) #=> [the "[rbp-0x48]" stack, 0x8]
      def resolve_address(address)
        base, offset = address_base(address)
        [get_corresponding_stack(base), offset]
      end

      # The memory +base+ addresses: what this candidate has written through it,
      # keyed by offset. Every base gets one -- the stack pointer, the frame
      # pointer, any other register, and a value no register names at all (a
      # pointer the candidate derived and then built an array through).
      #
      # Keyed by how the base renders, which is what makes one store enough: a
      # register that gets reassigned addresses somewhere else and renders
      # differently, so it lands on a different key without any invalidation to
      # arrange. Only a store overwriting what the base itself reads from would
      # break that, which a candidate short enough to be a gadget doesn't do.
      # @example a register
      #   get_corresponding_stack('x21')
      # @example a pointer rounded down before use
      #   get_corresponding_stack(Lambda.parse('(rsi & 0xfffffffffffffff0)'))
      # @param [String, Lambda] base A base, as {#resolve_address} yields it --
      #   not an offset expression, whose offset belongs in the key it indexes.
      # @return [Hash{Integer => Lambda}, nil] nil when +base+ names nothing this
      #   emulator tracks memory for.
      def get_corresponding_stack(base)
        return nil unless base.is_a?(OneGadget::Emulators::Lambda) || registers.key?(base.to_s)

        tracked_memory[base.to_s]
      end

      # The values this candidate wrote through an address built from +text+, which
      # the array reported at +text+ therefore holds -- wherever in it they landed.
      # A reader told about that array has to be told about these too, or it is
      # described as though the gadget had not written to it.
      # @param [String] text How the address is named.
      # @return [Array<String>] Each value written, rendered, without duplicates.
      # @example (riscv64) a store of +s8+ through +((a5 << 0x3) + [sp+0xd0])+
      #   writes_through('[sp+0xd0]') #=> ['s8']
      def writes_through(text)
        return [] if text.empty?

        derived_writes.filter_map do |base, values|
          next unless operands_of(base).any? { |operand| operand.to_s == text }

          # A literal is not the caller's to arrange -- it is already what it is,
          # and the NULL such a loop writes to terminate the array is one.
          values.grep_v(Integer).map(&:to_s)
        end.flatten.uniq
      end

      private

      # Every base this candidate has written through, each mapped to the memory
      # it addresses. See {#get_corresponding_stack}, which is how it is reached.
      # @return [Hash{String => Hash{Integer => Lambda}}]
      def tracked_memory
        @tracked_memory ||= Hash.new { |memory, base| memory[base] = tracked_stack(base) }
      end

      # Split +address+ into the base it is offset from and that offset, in the
      # forms {#get_corresponding_stack} and a tracked stack expect.
      # @param [Lambda, String] address See {#resolve_address}.
      # @return [(String, Lambda), Integer]
      def address_base(address)
        return [address, 0] unless address.is_a?(OneGadget::Emulators::Lambda)
        # Still a dereference deep, so the whole thing names one value rather than
        # an offset from anything: its own immediate is part of that name.
        return [address, 0] if address.deref_count.positive?
        # An operation's +obj+ is only the value it operates on, which addresses
        # somewhere else entirely -- a candidate building an array through
        # +(rsi & ~0xf)+ is not writing through +rsi+.
        return [address.dup.tap { |base| base.immi = 0 }, address.immi] if address.operation?

        [address.obj, address.immi]
      end

      # An always-on tracked stack keyed by offset: a Hash that lazily materialises
      # +[reg+off]+ as a one-deref {Lambda}. Used for the +sp+- and {#bp}-based stacks.
      def tracked_stack(reg)
        Hash.new do |h, k|
          h[k] = OneGadget::Emulators::Lambda.new(reg).tap do |lmda|
            lmda.immi = k
            lmda.deref!
          end
        end
      end

      # The value an instruction reads through +val+: what this candidate put at
      # that address, when it is one the candidate has written, and the
      # dereference itself otherwise (recording the read, see {#note_read}).
      #
      # A slot the gadget fills in reads back as what was put there, so a
      # constraint on it names the value the caller has to arrange rather than
      # whatever the slot held on entry -- which the gadget has already replaced.
      # @param [Object] val The operand's value, as produced by {#arg_to_lambda}.
      # @return [Object]
      # @example (arm) +str r3, [sp, #4]+ then +ldr r0, [sp, #4]+ reads back r3
      def read_value(val)
        stored = stored_value(val)
        return stored unless stored.nil?

        note_read(val)
        val
      end

      # What this candidate stored at the address +val+ dereferences, or +nil+ if
      # it stored nothing there. Only a single dereference of an address this
      # emulator tracks names a slot it can answer for (see {#resolve_address}).
      # @param [Object] val
      # @return [Object, nil]
      def stored_value(val)
        return nil unless val.is_a?(OneGadget::Emulators::Lambda) && val.deref_count.positive?

        stack, offset = resolve_address(val.dup.ref!)
        stack&.key?(offset) ? stack[offset] : nil
      end

      # The innermost base name of a (possibly nested or dereferenced) address
      # lambda, following +obj+ through any nested lambdas.
      # @param [OneGadget::Emulators::Lambda] lmda
      # @return [String, nil] The root base name, or +nil+ for an absolute address.
      # @example
      #   root_base(arg_to_lambda('[[$base+0x10]+0x8]')) #=> '$base'
      #   root_base(arg_to_lambda('x19+0xed8'))          #=> 'x19'
      def root_base(lmda)
        obj = lmda.obj
        obj = obj.obj while obj.is_a?(OneGadget::Emulators::Lambda)
        obj
      end

      # Stores whose address is an operation rather than a base and a displacement
      # -- a scaled index added to a pointer, say. Such a write lands somewhere in
      # whatever that pointer addresses, at an offset only a value the caller
      # supplies decides, so it is tracked under a base of its own that nothing
      # reads back (see {#writes_through}).
      # @return [Array<(Lambda, Array)>] Each address operation, and what went there.
      def derived_writes
        @derived_writes ||= []
      end

      # The values an operation is built from, flattened out of its tree, so an
      # operand is recognised as itself rather than as text inside a rendering
      # (where +x3+ would be found in +x30+).
      # @param [Lambda, Object] lmda An address, or one part of one.
      # @return [Array] Its leaf operands, or +lmda+ itself when it is not an operation.
      def operands_of(lmda)
        return [lmda] unless lmda.is_a?(OneGadget::Emulators::Lambda) && lmda.operation?

        operands_of(lmda.obj) + operands_of(lmda.rhs)
      end

      # Track a store: write +values+ (one per word from +dst_l+) into the stack
      # {#resolve_address} resolves +dst_l+ to, and require +dst_l+
      # writable -- unless it is a pure +sp+ store. +sp+ is invariantly the
      # writable stack; the frame pointer only conventionally is, so a store
      # through it stays a real precondition (like amd64's +writable: rbp+imm+).
      # @param [OneGadget::Emulators::Lambda] dst_l The destination, zero-deref.
      # @param [Array<OneGadget::Emulators::Lambda, Integer>] values One per word.
      # @return [void]
      def track_write(dst_l, *values)
        stack, offset = resolve_address(dst_l)
        base, = address_base(dst_l)
        derived_writes << [base, values] if base.is_a?(OneGadget::Emulators::Lambda) && base.operation?
        values.each_with_index { |v, i| stack[offset + size_t * i] = v } if stack
        add_writable(dst_l) unless stack.equal?(sp_based_stack)
      end

      # Resolve +sp+- and (when tracked) {#bp}-relative operands to their offset.
      def eval_dict
        bp ? { sp => 0, bp => 0 } : { sp => 0 }
      end
    end
  end
end
