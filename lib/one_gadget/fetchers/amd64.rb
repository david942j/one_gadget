# frozen_string_literal: true

require 'one_gadget/emulators/amd64'
require 'one_gadget/fetchers/x86'

module OneGadget
  module Fetchers
    # Fetcher for amd64.
    class Amd64 < OneGadget::Fetchers::X86
      private

      def emulator
        OneGadget::Emulators::Amd64.new
      end
    end
  end
end
