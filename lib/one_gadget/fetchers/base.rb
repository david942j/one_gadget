# frozen_string_literal: true

require 'elftools'

require 'one_gadget/emulators/processor'
require 'one_gadget/error'
require 'one_gadget/fetchers/argument_resolution'
require 'one_gadget/fetchers/candidate_walk'
require 'one_gadget/fetchers/disassembly'
require 'one_gadget/fetchers/dynamic_symbols'
require 'one_gadget/fetchers/objdump'

module OneGadget
  module Fetchers
    # Base of the per-architecture gadget fetchers. It discovers candidate
    # instruction sequences - a backward control-flow walk from each
    # +exec+/+posix_spawn+ call - and turns a solved candidate into a
    # {OneGadget::Gadget::Gadget}. A subclass supplies only the arch-specific
    # pieces (call mnemonic, string/global recognition, branch classification),
    # every one of which is declared here whatever module implements the engine
    # that calls it: {CandidateWalk} for the control-flow walk, {Disassembly} for
    # reading the file, and {ArgumentResolution} for describing a reached call.
    #
    # To add an architecture, see +docs/adding-an-architecture.md+; +AArch64+ is
    # the simplest example.
    class Base
      include ArgumentResolution
      include CandidateWalk
      include Disassembly
      include DynamicSymbols

      # The absolute path to glibc.
      # @return [String] The filename.
      attr_reader :file

      # Cache values that are a deterministic function of an objdump command
      # (its output and everything derived from it), so re-analysing the same
      # file - common in the specs, harmless for the CLI which reads a file once -
      # doesn't redo the disassembly or the whole-binary scans.
      # @param [Symbol] kind What is being cached, so two kinds may share a command.
      # @param [String] command The objdump command the value is a function of.
      # @yieldreturn [Object] The value, computed only on a miss.
      # @return [Object] The cached value.
      def self.cached(kind, command)
        @cached ||= Hash.new { |h, k| h[k] = {} }
        @cached[kind][command] ||= yield
      end

      # Instantiate a fetcher object.
      # @param [String] file Absolute path to the target libc.
      def initialize(file)
        @file = file
        arch = self.class.name.split('::').last.downcase.to_sym
        @objdump = Objdump.new(file, arch)
        @objdump.extra_options = objdump_options
      end

      # Do find gadgets in glibc.
      # @return [Array<OneGadget::Gadget::Gadget>] Gadgets found.
      def find
        str_offset('/bin/sh') # ensure it's glibc-like; raises "not glibc?" if not found
        # Reading the disassembly first settles the command the answer is a
        # function of: how a file with no section headers is read is decided
        # there. Each gadget is handed out as a copy, since a caller may write to
        # one (see {OneGadget::Gadget::Gadget#base}).
        disassembly
        Base.cached(:gadgets, @objdump.command) { search }.map(&:dup)
      end

      # Every suffix of +lines+ -- a start line and everything after it, longest
      # last -- cut down to the part that runs: emulation ends at the terminal
      # call, so anything past one never executes. A suffix reaches beyond a
      # terminal call when the function holds several and the candidate was walked
      # back from a later one. Bounding each window here lets everything
      # downstream -- {#emulate} and its overrides, the dedup key in {#find} --
      # read a window as executed code.
      #
      # Each line is classified once per candidate rather than once per suffix
      # containing it: walking the start backwards, the first terminal call at or
      # after it only moves when the start is itself one.
      # @param [Array<String>] lines One candidate, as a line list.
      # @yieldparam [Array<String>] window
      # @return [void]
      def executed_windows(lines)
        stop = lines.size - 1 if terminal_call_line?(lines.last)
        (lines.size - 2).downto(0) do |i|
          stop = i if terminal_call_line?(lines[i])
          yield(stop ? lines[i..stop] : lines[i..])
        end
      end

      # Whether +line+ is the call that ends a gadget, by the same rule the emulator
      # stops on ({OneGadget::Emulators::Processor#terminal_call?}). Not
      # {#terminal_call_regexp}, which is looser so it can locate call sites: it
      # also matches the +posix_spawn+ setup helpers, which emulation runs through.
      # @param [String] line One disassembled line.
      # @return [Boolean]
      def terminal_call_line?(line)
        return false unless call_line?(line)

        name = line[/<([^@>]+)/, 1]
        !name.nil? && OneGadget::Emulators::Processor::TERMINAL_CALL_RE.match?(name)
      end

      # Whether emulating +window+ can only stop short of its terminal call: it
      # runs a line the emulator has already refused (see
      # {OneGadget::Emulators::Processor#refused_line}), and a window that never
      # reaches the call is not a gadget. Refusal belongs to the line, so one
      # learnt anywhere settles every window carrying it -- and overlapping
      # candidates carry the same lines over and over.
      # @param [Array<String>] window
      # @return [Boolean]
      def refused_before_call?(window)
        return false if @refused.nil?

        (window.size - 1).times.any? { |i| @refused.key?(window[i]) }
      end

      # Emulate a candidate suffix and turn it into a gadget, or +nil+ if it isn't one.
      # @param [Array<String>] lines The suffix, ending at the terminal call.
      # @return [OneGadget::Gadget::Gadget, nil]
      def resolve_suffix(lines)
        processor = emulate(lines)
        (@refused ||= {})[processor.refused_line] = true if processor.refused_line
        # resolve reads argument registers, which may not be evaluable on an
        # exotic path; such a candidate simply isn't a gadget.
        options = begin
          resolve(processor)
        rescue OneGadget::Error::Error
          nil
        end
        return if options.nil?
        # A branch that compares a value with itself yields a trivial condition:
        # drop the gadget if it's unsatisfiable, else strip the always-true one.
        return if options[:constraints].any? { |c| contradiction?(c) }

        options[:constraints] = options[:constraints].reject { |c| tautology?(c) }
        options[:closed_fds] = processor.closed_fds
        OneGadget::Gadget::Gadget.new(offset_of(lines.first), **options)
      end

      private

      # Every gadget in the disassembly: each candidate walked back from a
      # terminal call, cut into the windows that reach it, emulated one apiece.
      # @return [Array<OneGadget::Gadget::Gadget>]
      def search
        gadgets = []
        # Overlapping candidate paths share tails, so the same suffix (a start line
        # and everything after it) recurs across candidates; emulate each once.
        seen = {}
        candidates.each do |cand|
          executed_windows(cand.lines) do |suffix|
            next if seen.key?(key = suffix.join)

            seen[key] = true
            next if refused_before_call?(suffix)

            gadget = resolve_suffix(suffix)
            gadgets << gadget unless gadget.nil?
          end
        end
        gadgets
      end

      # Whether +line+ is a call, whatever it calls. The mnemonic must be the call
      # itself, so a branch to a symbol whose name merely looks like one is not
      # counted.
      # @param [String] line One disassembled line.
      # @return [Boolean]
      # @example A call, and a branch into the middle of the same function.
      #   call_line?('e6570: call   94180 <execve>')          #=> true
      #   call_line?('a34d0: b      a3210 <execlp+0x1a8>')    #=> false
      def call_line?(line)
        line[/\A\s*[0-9a-f]+:\s*(\S+)/, 1]&.match?(call_mnemonic) || false
      end

      # The mnemonics {#call_str} names, as the whole of one. Built once: it comes
      # out of a constant, and a search asks it of every line of a libc.
      # @return [Regexp]
      def call_mnemonic
        @call_mnemonic ||= /\A#{call_str}x?(?:\.[wn])?\z/
      end

      # Whether +line+ transfers control, so the address it names is a place in
      # the file rather than a value it works with.
      # @param [String] line One disassembled line.
      # @return [Boolean]
      def control_transfer?(line)
        !branch_kind(line).nil? || call_line?(line)
      end

      # What a libc calls the variable holding the environment a process started
      # with, allowing for the aliases exported beside it (+_environ+, +__environ+).
      ENVIRON = /\A_*environ\z/
      private_constant :ENVIRON

      # Whether +str+ names the address of that variable. An architecture that can
      # say which symbol an address belongs to answers this; the rest cannot, and
      # recognise the environment by the shape of the pointer instead (see
      # {ArgumentResolution#check_envp}).
      # @param [String] _str A rendered value.
      # @return [Boolean]
      def environ?(_str) = false

      # Whether +str+ references a libc global, i.e. an address the caller does not
      # choose. The default reads the +$base+-relative form an arch produces once it
      # concretizes a pc-relative operand; one that reaches its globals through a
      # register (i386's GOT) overrides this against that register instead.
      # @param [String] str A rendered value.
      # @return [Boolean]
      def global_var?(str)
        base_relative?(str, '$base')
      end

      # Whether +str+ names a value at a fixed offset from +base+, i.e. an address
      # whose content can be read out of the file. An operation applied to such an
      # address (see {OneGadget::Emulators::Lambda.operation}) is that address plus
      # whatever the caller supplies, so it names no particular byte and must not be
      # resolved as though it did.
      # @param [String] str A rendered value.
      # @param [String] base The token a libc-relative address renders against.
      # @return [Boolean]
      # @example A fixed global, and the same global offset by a register.
      #   base_relative?('$base+0x10', '$base')        #=> true
      #   base_relative?('(r3 + $base+0x10)', '$base') #=> false
      def base_relative?(str, base)
        str.match?(/\A\[*#{Regexp.escape(base)}(?:[+-]0x[0-9a-f]+)?\]*\z/)
      end

      # The requirement that a value be libc's GOT base, when a register holds it.
      # That is a precondition a caller can arrange and a reader can check: set
      # the register before jumping. A candidate whose window loads the base out
      # of memory instead names a location nobody sets up -- there is no register
      # to point anywhere -- so it is refused rather than stated as a constraint
      # nothing can meet.
      # @param [OneGadget::Emulators::Processor] processor
      # @param [String] holder Where the candidate found the GOT base.
      # @return [String?] The constraint, or +nil+ if the candidate must be refused.
      # @example
      #   got_base_constraint(processor, 'ecx')        #=> "ecx is the GOT address of libc"
      #   got_base_constraint(processor, '[ebp-0x2c]') #=> nil
      def got_base_constraint(processor, holder)
        return nil unless processor.registers.key?(holder)

        "#{holder} is the GOT address of libc"
      end

      # Whether +str+ references the +"/bin/sh"+ string. The default recognises the
      # +$base+-relative form (see {#global_var?}); an arch that renders the address
      # differently overrides it.
      # @param [String] str A rendered value.
      # @return [Boolean]
      def str_bin_sh?(str)
        str.include?('$base') && str.include?(bin_sh_offset.to_s(16))
      end

      # Whether +str+ references the standalone +"sh"+ string glibc passes as
      # argv[0] in +execl("/bin/sh", "sh", ...)+. False for a libc that has none.
      # @param [String] str A rendered value.
      # @return [Boolean]
      def str_sh?(str)
        !sh_offset.nil? && str.include?('$base') && str.include?(sh_offset.to_s(16))
      end

      # File offset of the +"/bin/sh"+ string.
      # @return [Integer]
      def bin_sh_offset
        @bin_sh_offset ||= str_offset('/bin/sh')
      end

      # File offset of the standalone +"sh"+ string (\0-preceded and
      # \0-terminated). Its distance from +"/bin/sh"+ is build-specific, so locate
      # it directly instead of guessing.
      # @return [Integer?] +nil+ when the libc has no such string.
      def sh_offset
        return @sh_offset if defined?(@sh_offset)

        idx = file_bytes.index("\x00sh\x00")
        @sh_offset = idx && idx + 1
      end

      def call_str; raise NotImplementedError
      end

      # Run a window through a fresh emulator, stopping at the first line it can't
      # process (an unsupported instruction, or the terminal call that ends the
      # gadget). +cmds+ is an executed window (see {#executed_windows}): every line
      # in it runs, so an override may read it as evidence of what the path does.
      # @param [Array<String>] cmds
      # @return [OneGadget::Emulators::Processor]
      def emulate(cmds)
        cmds.each_with_object(emulator) { |cmd, obj| break obj unless obj.process(cmd) }
      end

      def emulator; raise NotImplementedError
      end

      def objdump_options
        []
      end

      def str_offset(str)
        file_bytes.index("#{str}\x00") ||
          raise(Error::ArgumentError, "File #{file.inspect} doesn't contain string #{str.inspect}, not glibc?")
      end

      # The target's bytes, read once: a gadget names fixed strings by file offset,
      # and every argv entry of every candidate asks for them again.
      # @return [String]
      def file_bytes
        @file_bytes ||= File.binread(file)
      end

      # The NUL-terminated printable string a resolved-offset global (+$base+<off>+)
      # points to, or +nil+ when +element+ isn't such a global or the bytes aren't a
      # short printable string. Architectures whose globals aren't yet
      # file-offset-relative simply fall through.
      # @param [String] element
      # @return [String, nil]
      def global_str_content(element)
        off = string_file_offset(element) or return nil

        bytes = file_bytes
        return nil unless off.between?(0, bytes.size - 1)

        stop = bytes.index("\x00", off) or return nil
        str = bytes[off...stop]
        str if str.length.between?(1, 16) && str.each_byte.all? { |c| c.between?(0x20, 0x7e) }
      end

      # The file offset a fixed address names, or +nil+ when +element+ isn't one.
      # Here that is the resolved-offset form an arch produces once it concretizes
      # a pc-relative operand; an arch that reaches its globals through a register
      # instead overrides this (see +I386#string_file_offset+).
      # @param [String] element
      # @return [Integer, nil]
      def string_file_offset(element)
        m = /\A\$base\+(0x[0-9a-f]+)\z/.match(element) or return nil

        m[1].to_i(16)
      end

      def offset_of(assembly)
        assembly[/\A([\da-f]+):/, 1].to_i(16)
      end

      # Whether a single (non-disjunctive) branch condition already settles itself,
      # asking nothing of the caller: +X == X+ is always true, +X != X+ never is,
      # and so on for any two sides {#comparable_values} can put a number to.
      # @param [String] con One constraint.
      # @return [Boolean, nil] Whether the relation holds, or nil when it depends
      #   on something the caller arranges -- i.e. it is a real constraint.
      def trivial_relation(con)
        return nil if con.include?(' || ')

        m = con.match(/\A(?:\([su]\d+\))?(.+?) (==|!=|<=|>=|<|>) (.+)\z/)
        return nil unless m

        lhs, rhs = comparable_values(m[1], m[3])
        return nil if lhs.nil?

        lhs.public_send(m[2] == '!=' ? :!= : m[2].to_sym, rhs)
      end

      # The two sides of a relation as plain numbers, when they can be compared
      # without the caller arranging anything: the same expression twice, two
      # concrete values, or two offsets from one base (+r1+ against +r1+0x4+ can
      # never be equal). +nil+ leaves the relation a real constraint.
      #
      # Offsets are only comparable undereferenced. +[r1]+ and +[r1+0x4]+ address
      # different slots, but the values in them are unrelated -- nothing says they
      # differ.
      # @param [String] lhs The relation's left side, cast already stripped.
      # @param [String] rhs The relation's right side.
      # @return [(Numeric, Numeric), nil] Both sides as numbers, or nil when they
      #   cannot be compared without knowing what the caller supplies.
      def comparable_values(lhs, rhs)
        return [0, 0] if lhs == rhs

        left = OneGadget::Emulators::Lambda.parse(lhs)
        right = OneGadget::Emulators::Lambda.parse(rhs)
        return [left, right] if left.is_a?(Integer) && right.is_a?(Integer)
        return nil unless [left, right].all? do |l|
          l.is_a?(OneGadget::Emulators::Lambda) && l.deref_count.zero? && !l.operation?
        end
        return nil unless left.obj.to_s == right.obj.to_s

        [left.immi, right.immi]
      rescue OneGadget::Error::Error
        nil
      end

      def tautology?(con)
        trivial_relation(con) == true
      end

      def contradiction?(con)
        trivial_relation(con) == false
      end

      # Classify a disassembly +line+ for the control-flow walk (arch-specific):
      #   :conditional   - may or may not be taken; the walk explores both edges
      #                    and turns the decision into a gadget constraint
      #   :unconditional - always taken, to a determined (direct) target
      #   :terminator    - ends the path with no determined successor (a return or
      #                    an indirect/computed jump)
      #   nil            - not a branch; execution falls through to the next line
      def branch_kind(_line); raise NotImplementedError
      end

      # The leading character(s) of this arch's branch mnemonics, used to build
      # {#branch_lead_regex}. Must be plain regex-safe literals: they are spliced
      # into a character class, so no +]+, +\+, +-+ or +^+.
      # @example
      #   'bct'  # aarch64/arm: b, cbz/cbnz, tbz/tbnz
      #   'j'    # x86: jmp, jcc
      def branch_lead_chars; raise NotImplementedError
      end

      # The addresses in +data+ (loaded at +base+) of calls into +targets+.
      # Over-approximating is fine -- a false positive only adds a window nothing
      # is found in -- while a missed call costs every gadget around it.
      #
      # How an instruction is spelled in those bytes is the architecture's to say,
      # not the file's: an ELF states the byte order of its *data*, and an
      # architecture may encode instructions in the other one -- ARM and AArch64
      # keep theirs little-endian in a big-endian file, so both read words
      # little-endian whatever the file says.
      # @param [Integer] _base
      # @param [String] _data
      # @param [Hash{Integer => true}] _targets
      # @return [Array<Integer>, nil] +nil+ from an arch with no cheap call finder,
      #   which disassembles everything instead.
      def scan_calls(_base, _data, _targets) = nil

      # The address a symbol's value names. Overridden where the value carries
      # something besides the address (ARM keeps the Thumb bit in it).
      # @param [Integer] value
      # @return [Integer]
      def symbol_address(value)
        value
      end
    end
  end
end
