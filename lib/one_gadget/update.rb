# frozen_string_literal: true

require 'fileutils'

require 'one_gadget/helper'
require 'one_gadget/logger'
require 'one_gadget/version'

module OneGadget
  # For automatically check update.
  module Update
    # At least 30 days between check for new version.
    FREQUENCY = 30 * 24 * 60 * 60
    # Path to cache file.
    CACHE_FILE = File.join(ENV['HOME'], '.cache', 'one_gadget', 'update').freeze

    class << self
      # Check if new releases have been drafted.
      #
      # @return [void]
      def check!
        return unless need_check?

        FileUtils.touch(cache_file)
        OneGadget::Logger.info("Checking for new versions of OneGadget\n" \
                               "To disable this functionality, do\n$ echo never > #{CACHE_FILE}\n\n")
        latest = Helper.latest_tag[1..-1] # remove 'v'
        if Gem::Version.new(latest) <= Gem::Version.new(OneGadget::VERSION)
          return OneGadget::Logger.info("You have the latest version of OneGadget (#{latest})!\n\n")
        end

        # show update message
        msg = format('A newer version of OneGadget is available (%s --> %s).', OneGadget::VERSION, latest)
        OneGadget::Logger.ask_update(msg: msg)
      end

      private

      # check ~/.cache/one_gadget/update
      def need_check?
        cache = cache_file
        # don't check if not CLI
        return false unless $stdout.tty?
        return false if cache.nil? # cache file fails, no update check.
        return false if IO.binread(cache).strip == 'never'

        Time.now >= last_check + FREQUENCY
      end

      def last_check
        cache = cache_file
        return Time.now if cache.nil?

        File.open(cache, &:mtime)
      end

      def cache_file
        dir = File.dirname(CACHE_FILE)
        FileUtils.mkdir_p(dir) unless File.directory?(dir)
        IO.binwrite(CACHE_FILE, '') unless File.exist?(CACHE_FILE)
        CACHE_FILE
      rescue Errno::EACCES # prevent dir is not writable
        nil
      end
    end
  end
end
