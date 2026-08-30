# frozen_string_literal: true

require 'one_gadget/emulators/lambda'

module OneGadget
  module Emulators
    # The register state of one emulated candidate, keyed so that names sharing
    # storage share a value: what a write through a narrower name leaves behind is
    # what a read of the full register finds, and the other way round.
    #
    # Values are kept under the full register's name, so an operand rendered into a
    # constraint names the storage the caller has to arrange, whichever name the
    # instruction used to reach it.
    # @example (amd64) the first argument, set through its 32-bit name
    #   file['edi'] = 1
    #   file['rdi'] #=> 1
    class RegisterFile < Hash
      # Build the initial state: one entry per distinct storage, holding the value
      # the block returns for its full name.
      # @param [Array<String>] names All the register names the architecture accepts.
      # @param [Hash{String => String}] narrow_views Narrower name => full register.
      # @yieldparam [String] name The full register's name.
      # @return [RegisterFile]
      def self.build(names, narrow_views)
        new(narrow_views).tap do |file|
          names.map { |name| narrow_views.fetch(name, name) }
               .uniq
               .each { |name| file[name] = yield(name) }
        end
      end

      # @param [Hash{String => String}] narrow_views Narrower name => full register.
      def initialize(narrow_views = {})
        super()
        @narrow_views = narrow_views
        @entry_halves = {}
      end

      # @param [String] name Any name the architecture accepts, narrow or full.
      # @return [OneGadget::Emulators::Lambda, Integer] What that name currently reads as.
      def [](name)
        value = super(full(name))
        narrow?(name) ? narrowed(name, value) : value
      end

      # @param [String] name Any name the architecture accepts, narrow or full.
      # @param [OneGadget::Emulators::Lambda, Integer] value
      # @return [void]
      def []=(name, value)
        super(full(name), value)
      end

      # @param [String] name Any name the architecture accepts, narrow or full.
      # @return [Boolean] Whether its storage holds a value.
      def key?(name)
        super(full(name))
      end
      alias has_key? key?
      alias include? key?
      alias member? key?

      private

      # The name +name+'s storage is kept under: itself, unless it is a narrower
      # view of a wider register.
      # @param [String] name
      # @return [String]
      def full(name)
        @narrow_views.fetch(name, name)
      end

      # @param [String] name
      # @return [Boolean] Whether +name+ addresses part of a wider register.
      def narrow?(name)
        @narrow_views.key?(name)
      end

      # The part of +value+ that +name+ addresses. Only one such part can be named
      # exactly: the low half of a register still holding what the gadget was
      # entered with, which is what the narrower name means. Anything else is
      # handed back whole, since no expression names half of it -- an
      # over-approximation, and one that only ever tightens a constraint or drops
      # the path it renders.
      #
      # The name's own lambda is kept rather than rebuilt, so that repeated reads
      # of an untouched register return one object: a register's value is compared
      # by identity to tell a reassignment from the value that was there before
      # (see {Processor#reg_based_stack}).
      # @param [String] name A narrower name (see {#narrow?}).
      # @param [Object] value The value held by the register it names part of.
      # @return [Object]
      def narrowed(name, value)
        return value unless entry_value?(value, full(name))

        @entry_halves[name] ||= Lambda.new(name)
      end

      # Whether +value+ is still the untouched value +reg+ was entered with.
      def entry_value?(value, reg)
        value.is_a?(Lambda) && value.obj == reg && value.deref_count.zero? && value.immi.zero?
      end
    end
  end
end
