require 'logger'
module NetuitiveRailsAgent
  class CheaterLogger
    attr_accessor :level
    def debug(message)
    end

    def error(message)
    end

    def info(message)
    end
  end

  class NetuitiveLogger
    class << self
      attr_accessor :log
      def setup
        file = NetuitiveRailsAgent::ConfigManager.property('logLocation', 'NETUITIVE_RAILS_LOG_LOCATION', "#{File.expand_path('../../..', __FILE__)}/log/netuitive.log")
        age = NetuitiveRailsAgent::ConfigManager.property('logAge', 'NETUITIVE_RAILS_LOG_AGE', 'daily')
        age = begin
                Integer(age)
              rescue
                'daily'
              end
        size = NetuitiveRailsAgent::ConfigManager.property('logSize', 'NETUITIVE_RAILS_LOG_SIZE', '1000000')
        NetuitiveRailsAgent::NetuitiveLogger.log = Logger.new(file, age, size.to_i)
      rescue => e
        puts 'netuitive unable to open log file'
        puts e.message
        NetuitiveRailsAgent::NetuitiveLogger.log = NetuitiveRailsAgent::CheaterLogger.new
      end
    end
  end
end
