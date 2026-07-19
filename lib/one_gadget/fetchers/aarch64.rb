# frozen_string_literal: true

require 'one_gadget/emulators/aarch64'
require 'one_gadget/fetchers/base'

module OneGadget
  module Fetcher
    # Define common methods for gadget fetchers.
    class AArch64 < Base
      private

      def emulator
        OneGadget::Emulators::AArch64.new
      end

      # If str contains a branch instruction.
      def branch?(str)
        %w[b b.hi b.gt b.eq b.le b.ls b.lt b.ne b.cs].any? { |f| str.include?(" #{f} ") }
      end

      def call_str
        'bl'
      end

      def bin_sh_offset
        @bin_sh_offset ||= str_offset('/bin/sh')
      end

      def str_bin_sh?(str)
        str.include?('$base') && str.include?(bin_sh_offset.to_s(16))
      end

      # Offset of the standalone "sh" string (\0-preceded and \0-terminated) that
      # glibc passes as argv[0] in execl("/bin/sh", "sh", ...). Its distance from
      # "/bin/sh" is build-specific, so locate it directly instead of guessing.
      # +nil+ when the libc has no such string.
      def sh_offset
        return @sh_offset if defined?(@sh_offset)

        idx = File.binread(file).index("\x00sh\x00")
        @sh_offset = idx && idx + 1
      end

      def str_sh?(str)
        !sh_offset.nil? && str.include?('$base') && str.include?(sh_offset.to_s(16))
      end

      def global_var?(str)
        str.include?('$base')
      end
    end
  end
end
