require 'logger'

class CheaterLogger
  attr_accessor :level
  def debug(message)
  end

  def error(message)
  end

  def info(message)
  end
end

class RailsNetuitiveLogger
  class << self
    attr_accessor :log
    def setup
      file = RailsConfigManager.property('logLocation', 'NETUITIVE_RAILS_LOG_LOCATION', "#{File.expand_path('../../..', __FILE__)}/log/netuitive.log")
      age = RailsConfigManager.property('logAge', 'NETUITIVE_RAILS_LOG_AGE', 'daily')
      size = RailsConfigManager.property('logSize', 'NETUITIVE_RAILS_LOG_SIZE', nil)
      RailsNetuitiveLogger.log = Logger.new(file, age.to_i, size.to_i)
    rescue => e
      puts 'netuitive unable to open log file'
      puts e.message
      RailsNetuitiveLogger.log = CheaterLogger.new
    end
  end
end
