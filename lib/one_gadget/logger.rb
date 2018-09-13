require 'logger'

require 'one_gadget/helper'

module OneGadget
  # A logger for internal usage.
  module Logger
    @logger = ::Logger.new(STDOUT)
    @logger.formatter = proc do |severity, _datetime, _progname, msg|
      prep = ' ' * 12
      message = msg.lines.map.with_index do |str, i|
        next str if i.zero?

        str.strip.empty? ? str : prep + str
      end
      color = case severity
              when 'WARN' then :warn
              when 'INFO' then :reg
              when 'ERROR' then :error
              end
      "[#{OneGadget::Helper.colorize('OneGadget', sev: color)}] #{message.join}"
    end

    module_function

    # Show warning message of no such build id in database.
    # @param [String] build_id
    #   Build ID.
    def not_found(build_id)
      warn("Cannot find BuildID [#{build_id}]\n")
      []
    end

    %i[info warn error].each do |sym|
      define_method(sym) do |msg|
        @logger.__send__(sym, msg)
      end
    end
  end
end
