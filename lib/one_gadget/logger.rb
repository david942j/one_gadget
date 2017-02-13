require 'logger'
require 'one_gadget/helper'

module OneGadget
  # A logger for internal usage.
  module Logger
    @logger = ::Logger.new(STDOUT)
    @logger.formatter = proc do |_severity, _datetime, _progname, msg|
      prep = ' ' * 12
      message = msg.lines.map.with_index do |str, i|
        next str if i.zero?
        prep + str
      end
      "[#{OneGadget::Helper.colorize('OneGadget', sev: :reg)}] #{message.join}"
    end

    def self.info(msg)
      @logger.info(msg)
    end
  end
end
