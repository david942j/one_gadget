module OneGadget
  # OneGadget errors.
  module Error
    # Generic error class.
    class Error < StandardError
    end

    # Unsupported arguments of intructions.
    class UnsupportedInstructionArgumentsError < Error
    end

    # Unsupported architecture.
    class UnsupportedArchitectureError < Error
    end

    # Argument error of ruby methods.
    class ArgumentError < Error
    end
  end
end
