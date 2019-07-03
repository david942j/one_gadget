# frozen_string_literal: true

module OneGadget
  # OneGadget errors.
  module Error
    # Generic error class.
    class Error < StandardError
    end

    # Super class of unsupported errors.
    class UnsupportedError < Error
    end

    # Unsupported instruction.
    class UnsupportedInstructionError < UnsupportedError
    end

    # Raises when arguments form of an instruction is invalid.
    class InstructionArgumentError < Error
    end

    # Raises when form of arguments is valid but not supported.
    class UnsupportedInstructionArgumentError < UnsupportedError
    end

    # Unsupported architecture.
    class UnsupportedArchitectureError < UnsupportedError
    end

    # Argument error of ruby methods.
    class ArgumentError < Error
    end
  end
end
