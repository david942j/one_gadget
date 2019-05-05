# frozen_string_literal: true

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
      msg = +"[#{OneGadget::Helper.colorize('OneGadget', sev: color)}] #{message.join}"
      msg << "\n" unless msg.end_with?("\n")
      msg
    end

    module_function

    # Show warning message of no such build id in database.
    # @param [String] build_id
    #   Build ID.
    def not_found(build_id)
      warn("Cannot find BuildID [#{build_id}]\n")
      []
    end

    # Show the message of ask user to update gem.
    # @return [void]
    def ask_update(msg: '')
      name = 'one_gadget'
      cmd = OneGadget::Helper.colorize("gem update #{name} && gem cleanup #{name}")
      OneGadget::Logger.info(msg + "\n" + "Update with: $ #{cmd}" + "\n")
    end

    %i[info warn error].each do |sym|
      define_method(sym) do |msg|
        @logger.__send__(sym, msg)
      end
    end
  end
end
