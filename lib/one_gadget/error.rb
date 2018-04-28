module OneGadget
  module Error
    class Error < StandardError
    end

    class UnsupportedInstructionArguments < Error
    end
  end
end
