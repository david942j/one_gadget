module OneGadget
  module Error
    class Error < StandardError
    end

    class UnsupportedInstructionArgumentsError < Error
    end

    class UnsupportedArchitectureError < Error
    end

    class ArgumentError < Error
    end
  end
end
