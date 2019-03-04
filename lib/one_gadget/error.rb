module OneGadget
  # OneGadget errors.
  module Error
    # Generic error class.
    class Error < StandardError
    end

    # Unsupported instruction.
    class UnsupportedInstructionError < Error
    end

    # Raises when arguments form of an instrution is invalid.
    class InstructionArgumentError < Error
    end

    # Raises when form of arguments is valid but not supported.
    class UnsupportedInstructionArgumentError < Error
    end

    # Unsupported architecture.
    class UnsupportedArchitectureError < Error
    end

    # Argument error of ruby methods.
    class ArgumentError < Error
    end
  end
end
