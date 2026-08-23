# frozen_string_literal: true

require 'json'

require 'one_gadget/abi'
require 'one_gadget/emulators/lambda'
require 'one_gadget/error'

module OneGadget
  # Module for define gadgets.
  module Gadget
    # Information of a gadget.
    class Gadget
      # @return [Integer] Base address of libc. Default: 0.
      attr_accessor :base
      # @return [Integer] The gadget's address offset.
      attr_reader :offset
      # @return [Array<String>] The constraints need for this gadget.
      attr_reader :constraints
      # @return [String] The final result of this gadget.
      attr_reader :effect
      # @return [Array<String>] Where each descriptor this gadget closes before the
      #   exec is read from, in the order it closes them (see {#caveats}).
      attr_reader :closed_fds

      # Initialize method of {Gadget} instance.
      # @param [Integer] offset The relative address offset of this gadget.
      # @option options [Array<String>] :constraints
      #   The constraints need for this gadget. Defaults to +[]+.
      # @example
      #   OneGadget::Gadget::Gadget.new(0x12345, constraints: ['rax == 0'])
      def initialize(offset, **options)
        @base = 0
        @offset = offset
        @constraints = prune_settled(options[:constraints] || [])
        @effect = options[:effect] || ''
        @closed_fds = options[:closed_fds] || []
      end

      # What the gadget costs the caller beyond its constraints: a descriptor it
      # closes on the way to the exec. Each line names the close itself, so it
      # reads as the code does and can be matched exactly, and says what the value
      # must avoid for the spawned shell to keep its I/O.
      # @return [Array<String>]
      # @example
      #   ['close([rsp+0x44]): prevent it from being 0 (stdin) or 1 (stdout) ...']
      def caveats
        closed_fds.map do |fd|
          "close(#{fd}): prevent it from being 0 (stdin) or 1 (stdout) to sound " \
            'an interactive shell.'
        end
      end

      # Returns a human-readable, colorized representation of this gadget,
      # showing its address followed by the effect and constraints.
      # @return [String] The multi-line pretty-printed gadget.
      def inspect
        str = "#{OneGadget::Helper.hex(value)} #{effect}\n"
        unless constraints.empty?
          str += "#{OneGadget::Helper.colorize('constraints')}:\n  "
          str += merge_constraints.join("\n  ")
        end
        unless caveats.empty?
          str += "\n" unless constraints.empty?
          str += "#{OneGadget::Helper.colorize('caveats')}:\n  "
          str += caveats.join("\n  ")
        end
        str.gsub!(/0x[\da-f]+/) { |s| OneGadget::Helper.colorize(s, sev: :integer) }
        OneGadget::ABI.all.each do |reg|
          str.gsub!(/([^\w])(#{reg})([^\w])/, "\\1#{OneGadget::Helper.colorize('\2', sev: :reg)}\\3")
        end
        "#{str}\n"
      end

      # Converts this gadget into a plain hash, suitable for serialization.
      # @return [Hash{Symbol => Integer, String, Array<String>, Array<Integer>}]
      #   A hash with keys +:value+ (the absolute address), +:effect+ (the
      #   resulting function call), +:constraints+ (the required constraints) and,
      #   when the gadget closes a descriptor, +:closed_fds+ with the {#caveats}
      #   they carry.
      def to_obj
        obj = { value:, effect:, constraints: }
        return obj if caveats.empty?

        obj.merge(closed_fds:, caveats:)
      end

      # Serializes this gadget into a JSON string.
      # @return [String] The gadget in JSON format. See {#to_obj} for the keys.
      def to_json(*)
        to_obj.to_json
      end

      # @return [Integer]
      #   Returns +base+ plus +offset+.
      def value
        base + offset
      end

      # @return [Float]
      #   The success probability of the constraints.
      def score
        @score ||= constraints.reduce(1.0) { |s, c| s * calculate_score(c) }
      end

      # Whether +other+ asks for everything this gadget asks for, so listing this
      # one beside it tells the reader nothing new. Each constraint here has to be
      # met by +other+'s list: named there, or -- for one that offers several
      # options -- an option of it required there outright.
      # @param [Gadget] other
      # @return [Boolean]
      # @example An option required outright meets the constraint offering it.
      #   met_by?(other) # where this asks "r8 == NULL || (u16)[r8] == 0x0"
      #                  # and +other+ asks "(u16)[r8] == 0x0"
      def met_by?(other)
        constraints.all? do |con|
          other.constraints.include?(con) ||
            con.split(DISJUNCTION).any? { |option| other.constraints.include?(option) }
        end
      end

      # Every architecture's register names, for {#base_register} to recognise one
      # by. Keyed for lookup: it is asked once per token of every constraint scored.
      REGISTER_NAMES = OneGadget::ABI.all.to_h { |reg| [reg, true] }.freeze
      private_constant :REGISTER_NAMES

      # What separates the options of a constraint that can be met in more than
      # one way.
      DISJUNCTION = ' || '
      private_constant :DISJUNCTION

      # How far from an address a dereference can sit and still say the address
      # is not NULL: within the smallest page, which a NULL base cannot reach out
      # of.
      PAGE_SIZE = 0x1000
      private_constant :PAGE_SIZE

      private

      # Drops what the rest of the list already settles, so a gadget asks for each
      # thing once and never offers an option it rules out itself.
      #
      # Most of it follows from one reading: a constraint that accesses an address
      # says that address is mapped memory (see {#mapped?}), which in turn says it
      # is readable and not NULL. So:
      # * A +readable:+ on an address a dereference already reaches repeats it.
      # * A +== NULL+ option for a mapped address can never be taken.
      # * A +!= NULL+ requirement on one is already met.
      # The last rule reads a value rather than an address: one the list pins to a
      # literal answers every other comparison against it, so a bound that literal
      # already satisfies asks for nothing.
      #
      # Each needs the constraint doing the settling to hold outright: one inside a
      # +||+ is an option among several and settles nothing. They run until the
      # list stops changing, because dropping an option can leave a constraint
      # holding outright and settle the next thing.
      # @param [Array<String>] cons
      # @return [Array<String>]
      # @example An option the same list rules out.
      #   prune_settled(['writable: r8', 'r8 == NULL || (u16)[r8] == 0x0'])
      #   #=> ['writable: r8', '(u16)[r8] == 0x0']
      # @example A readability the dereference beside it already states.
      #   prune_settled(['readable: x1', '[x1] == 0x0']) #=> ['[x1] == 0x0']
      # @example A non-NULL the dereference beside it already states.
      #   prune_settled(['[$base+0x10] != 0x0', '[[$base+0x10]+0xa4] == 0x0'])
      #   #=> ['[[$base+0x10]+0xa4] == 0x0']
      # @example A bound the pinned value already satisfies.
      #   prune_settled(['r0 == NULL', '(u32)r0 <= 0xfffff000']) #=> ['r0 == NULL']
      def prune_settled(cons)
        loop do
          settled = drop_stated_readable(
            drop_settled_comparison(drop_settled_non_null(drop_ruled_out_null(cons)))
          )
          return cons if settled == cons

          cons = settled
        end
      end

      # The constraints that hold outright, as opposed to naming several options.
      # @param [Array<String>] cons
      # @return [Array<String>]
      def unconditional(cons)
        cons.reject { |c| c.include?(DISJUNCTION) }
      end

      # Whether the list requires +identity+ to be mapped memory: a constraint
      # holding outright either names it as one, or accesses it -- at the address
      # itself, or near enough that a NULL one could not be what is accessed.
      # @param [Array<String>] cons
      # @param [String] identity
      # @return [Boolean]
      def mapped?(cons, identity)
        deref = "[#{identity}]"
        near = /\[#{Regexp.escape(identity)}([+-]0x[0-9a-f]+)\]/
        unconditional(cons).any? do |con|
          con == "readable: #{identity}" || con == "writable: #{identity}" || con.include?(deref) ||
            (off = con[near, 1]) && off.to_i(16).abs < PAGE_SIZE
        end
      end

      # Drops every option that asks an address the list requires to be mapped
      # memory to be NULL. A constraint whose every option goes is left alone: it
      # says the gadget is impossible, which is not this pass's call to make.
      # @param [Array<String>] cons
      # @return [Array<String>]
      def drop_ruled_out_null(cons)
        cons.map do |con|
          options = con.split(DISJUNCTION)
          next con if options.size == 1

          kept = options.reject do |opt|
            identity = opt[/\A(.+) == NULL\z/, 1]
            !identity.nil? && mapped?(cons, identity)
          end
          kept.empty? ? con : kept.join(DISJUNCTION)
        end
      end

      # Drops every requirement that an address the list requires to be mapped
      # memory be non-NULL, which mapped memory never is.
      # @param [Array<String>] cons
      # @return [Array<String>]
      def drop_settled_non_null(cons)
        cons.reject do |con|
          identity = con[/\A(.+) != (?:NULL|0x0)\z/, 1]
          !identity.nil? && !identity.match?(/\A\([su]\d+\)/) && mapped?(cons, identity)
        end
      end

      # A comparison against a literal: the cast that says how much of the value is
      # compared and whether those bits read as signed, what is compared, and what
      # it is compared with.
      # @example +(u32)r0 <= 0xfffff000+, +[rbp-0x50] == 0x1+, +x2 == NULL+
      COMPARISON = /\A(?:\(([su])(\d+)\))?(.+?) (==|!=|<=|>=|<|>) (NULL|-?(?:0x[0-9a-f]+|\d+))\z/
      private_constant :COMPARISON

      # Drops every comparison a value pinned elsewhere in the list already
      # answers. Only an uncast equality pins a whole value -- +(u16)X == 0x0+
      # leaves the rest of it unsaid -- and a comparison the pinned value does not
      # satisfy is left alone: it says the gadget is impossible, which is not this
      # pass's call to make.
      # @param [Array<String>] cons
      # @return [Array<String>]
      def drop_settled_comparison(cons)
        pinned = pinned_values(unconditional(cons))
        return cons if pinned.empty?

        cons.reject do |con|
          parts = COMPARISON.match(con)
          next false if parts.nil? || (parts[1].nil? && parts[4] == '==')

          value = pinned[parts[3]]
          !value.nil? && comparison_holds?(value, parts)
        end
      end

      # What the list pins outright, by what is pinned.
      # @param [Array<String>] held
      # @return [Hash{String => Integer}]
      def pinned_values(held)
        held.each_with_object({}) do |con, pinned|
          parts = COMPARISON.match(con)
          next unless parts && parts[1].nil? && parts[4] == '=='

          pinned[parts[3]] = literal_value(parts[5])
        end
      end

      # Whether a comparison already holds for a value pinned to +value+.
      # @param [Integer] value
      # @param [MatchData] parts A {COMPARISON} match.
      # @return [Boolean]
      def comparison_holds?(value, parts)
        value = as_cast(value, parts[1], parts[2]) if parts[1]
        value.public_send(parts[4], literal_value(parts[5]))
      end

      # +value+ as a cast reads it: the low +bits+ of it, negative when those bits
      # are read as signed and the top one is set.
      def as_cast(value, sign, bits)
        bits = Integer(bits)
        low = value & ((1 << bits) - 1)
        sign == 's' && low >= (1 << (bits - 1)) ? low - (1 << bits) : low
      end

      # @param [String] literal +NULL+ or a number, as a constraint writes it.
      # @return [Integer]
      def literal_value(literal)
        literal == 'NULL' ? 0 : Integer(literal)
      end

      # Drops every +readable:+ whose address another constraint dereferences
      # outright, which asks for that readability already. Unlike {#mapped?} this
      # takes only the address itself: a dereference nearby says the page it lands
      # on is mapped, not the one +identity+ sits on.
      # @param [Array<String>] cons
      # @return [Array<String>]
      def drop_stated_readable(cons)
        cons.reject do |con|
          identity = con[/\Areadable: (.+)\z/, 1]
          next false if identity.nil?

          unconditional(cons).any? { |other| other.include?("[#{identity}]") }
        end
      end

      # REG: OneGadget::ABI.all
      # IMM: [+-]0x[\da-f]+
      # BITS: 8, 16, 32, 64
      # CAST: (<s|u><BITS>)
      # Identity: <REG><IMM>?
      # Identity: [<Identity>]
      # Expr: <REG> is the GOT address of libc
      # Expr: writable: <Identity>
      # Expr: readable: <Identity>
      # Expr: <CAST>?<Identity> == NULL
      # Expr: <REG> & 0xf == <IMM>
      # Expr: (s32)[<Identity>] <= 0
      # Expr: .+ is a valid argv
      # Expr: .+ is a valid envp
      # Expr: <Expr> || <Expr>
      def calculate_score(expr)
        return expr.split(' || ').map(&method(:calculate_score)).max if expr.include?(' || ')
        return 0.95 if stack_alignment?(expr)
        # A requirement on some of a value's bits leaves every other bit free, so
        # it is a branch relation whatever its right side reads -- including zero.
        return calculate_relation_score(expr) if MASKED_COMPARISON.match?(expr)

        case expr
        when /GOT address/ then 0.9
        when /^writable/ then calculate_writable_score(expr.sub('writable: ', ''))
        # However a "must be zero" is spelled -- NULL where the value is a pointer,
        # 0x0 where it is not, with or without a size cast, and <= for a signed
        # field -- it asks for the same thing, and asking for zero is easier than a
        # relation that names some other value.
        when / == NULL$/, / == 0x0$/, / <= 0x0$/
          calculate_null_score(expr.sub(/ (?:==|<=) (?:NULL|0x0)\z/, ''))
        # A register that just has to be a readable pointer -- a "readable: <reg>"
        # (a dereferenced call arg) or a valid argv/envp element -- is easy.
        when /^readable/, / is a valid (argv|envp)$/ then 0.2
        when / (==|!=|<=|>=|<|>) / then calculate_relation_score(expr) # a branch condition
        end
      end

      # A requirement on some of a value's bits: +(eax & 0xf000) == 0x2000+, or the
      # unparenthesised +rsp & 0xf == 0x0+ an alignment renders as. A mask *inside*
      # what is compared (+[(rsi & 0xf0)] == NULL+) is not one of these: there the
      # whole value still has to be zero.
      MASKED_COMPARISON = /\A(?:\(.+ & .+\)|[\w$]+ & \S+) (?:==|!=|<=|>=|<|>) /
      private_constant :MASKED_COMPARISON

      # Whether +expr+ is the alignment an aligned store imposes (see
      # {OneGadget::Emulators::X86#inst_movaps}): the stack pointer's low bits
      # must hold a fixed value, which is free -- the caller picks where the
      # stack sits. Matched exactly, so a masked value the caller has to arrange
      # stays the branch relation it is.
      # @example matches +rsp & 0xf == 0x0+; not +(eax & 0xf000) == 0x2000+
      def stack_alignment?(expr)
        reg = expr[/\A(\S+) & 0xf == 0x[0-9a-f]+\z/, 1]
        !reg.nil? && OneGadget::ABI.stack_register?(reg)
      end

      # Score a branch-derived relational constraint such as +x2 == 0x1+ or
      # +(u64)x0 >= 0x400+: an equality on one specific value is harder than an
      # inequality/range, and a dereferenced left-hand side is harder still.
      def calculate_relation_score(expr)
        op = expr[/ (==|!=|<=|>=|<|>) /, 1]
        lhs = expr.split(/ #{Regexp.escape(op)} /, 2).first.sub(/\A\([su]\d+\)/, '')
        base = op == '==' ? 0.4 : 0.6
        base * 0.9**deref_depth(lhs)
      end

      # How many dereferences +identity+ is behind, read off the rendering that
      # produced it -- a lambda emits one +[+ per dereference.
      # @example deref_depth('[[ebp+0x10]]') #=> 2
      def deref_depth(identity)
        identity[/\A\[*/].size
      end

      # The register +identity+ is derived from: the first one it names, since a
      # rendering puts its base ahead of whatever is applied to it. +nil+ when it
      # names none, e.g. a libc-relative +$base+0x10+.
      # @example base_register('[(rsi & 0xfffffffffffffff0)+0x10]') #=> 'rsi'
      def base_register(identity)
        identity.scan(/\w+/).find { |token| REGISTER_NAMES.key?(token) }
      end

      # Whether +identity+ is a register itself rather than a value derived from
      # one. Asked of an undereferenced identity, where being the register is
      # what makes a requirement on it cheap to meet.
      # @example bare_register?('rax') #=> true
      # @example bare_register?('rax+0x10'), bare_register?('(rax & 0xf0)') #=> false
      def bare_register?(identity)
        identity == base_register(identity)
      end

      def calculate_writable_score(identity)
        return 0.81 unless deref_depth(identity).zero?

        OneGadget::ABI.stack_register?(base_register(identity)) ? 0.95 : 0.81
      end

      def calculate_null_score(identity)
        identity = identity.sub(/\A\([su]\d+\)/, '') # remove <CAST>
        depth = deref_depth(identity)
        # rax == 0 is easy; rax + 0x10 == 0 is damn hard.
        return bare_register?(identity) ? 0.9 : 0.1 if depth.zero?

        # [sp+xx] == NULL is easy.
        base = OneGadget::ABI.stack_register?(base_register(identity)) ? 0 : 1
        0.9**(depth + base)
      end

      def merge_constraints
        key = 'writable: '
        w_cons, normal = constraints.partition { |c| c.start_with?(key) }
        return normal if w_cons.empty?

        w_cons.map! { |c| c[key.size..] }
        ["address#{'es' if w_cons.size > 1} #{w_cons.join(', ')} #{w_cons.size > 1 ? 'are' : 'is'} writable"] +
          normal
      end
    end

    # Define class methods here.
    module ClassMethods
      # Path to the pre-build files.
      BUILDS_PATH = File.join(__dir__, 'builds').freeze
      # Record.
      BUILDS = Hash.new { |h, k| h[k] = [] }
      # Get gadgets from pre-defined corpus.
      # @param [String] build_id Desired build id.
      # @param [Boolean] remote
      #   When local not found, try search in latest version?
      # @return [Array<Gadget::Gadget>?] Gadgets.
      def builds(build_id, remote: true)
        ret = find_build(build_id)
        return ret unless ret.nil?
        return build_not_found unless remote

        # fetch remote builds
        table = OneGadget::Helper.remote_builds.find { |c| c.include?(build_id) }
        return build_not_found if table.nil? # remote doesn't have this one either.

        # builds found in remote! Ask update gem and download remote gadgets.
        OneGadget::Logger.ask_update(msg: 'The desired one-gadget can be found in lastest version!')
        tmp_file = OneGadget::Helper.download_build(table)
        require tmp_file.path
        tmp_file.unlink
        BUILDS[build_id]
      end

      # Returns the comments in builds/libc-*-<build_id>*.rb
      # @param [String] build_id
      #   Supports give only few starting bytes, but a warning will be shown
      #   if multiple BulidIDs are matched.
      # @return [String?]
      #   Lines of comments.
      # @example
      #   puts OneGadget::Gadget.builds_info('3bbdc')
      #   # https://gitlab.com/libcdb/libcdb/blob/master/libc/libc6-amd64-2.19-18+deb8u4/lib64/libc-2.19.so
      #   #
      #   # Advanced Micro Devices X86-64
      #   # ...
      def builds_info(build_id)
        raise Error::ArgumentError, "Invalid BuildID #{build_id.inspect}" if build_id =~ /[^0-9a-f]/

        files = Dir.glob(File.join(BUILDS_PATH, "*-#{build_id}*.rb"))
        return OneGadget::Logger.not_found(build_id) && nil if files.empty?

        if files.size > 1
          OneGadget::Logger.warn("Multiple BuildIDs match /^#{build_id}/\n")
          show = files.map do |f|
            File.basename(f, '.rb').reverse.split('-', 2).join(' ').reverse
          end
          OneGadget::Logger.warn("Candidates are:\n#{show * "\n"}\n")
          return nil
        end
        OneGadget::Helper.comments_of_file(files.first)
      end

      # Add a gadget, for scripts in builds/ to use.
      #
      # Keyword arguments are forwarded to {Gadget#initialize}.
      # @param [String] build_id The target's build id.
      # @param [Integer] offset The relative address offset of this gadget.
      # @return [void]
      def add(build_id, offset, **)
        BUILDS[build_id] << OneGadget::Gadget::Gadget.new(offset, **)
      end

      private

      def find_build(id)
        return BUILDS[id] if BUILDS.key?(id)

        Dir.glob(File.join(BUILDS_PATH, "*-#{id}.rb")).each do |dic|
          require dic
        end
        BUILDS[id] if BUILDS.key?(id)
      end

      def build_not_found
        nil
      end
    end
    extend ClassMethods
  end
end
