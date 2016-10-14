require 'netuitive/netuitive_rails_logger'

class ConfigManager
  class << self
    attr_reader :capture_errors

    attr_reader :ignored_errors

    attr_reader :queue_time_divisor

    attr_reader :sidekiq_enabled

    attr_reader :data

    def property(name, var, default = nil)
      prop = ENV[var]
      prop = data[name] if prop.nil? || (prop == '')
      return prop unless prop.nil? || (prop == '')
      default
    end

    def boolean_property(name, var)
      prop = ENV[var].nil? ? nil : ENV[var].dup
      if prop.nil? || (prop == '')
        prop = data[name]
      else
        prop.strip!
        prop = prop.casecmp('true').zero?
      end
      prop
    end

    def float_property(name, var)
      prop = ENV[var].nil? ? nil : ENV[var]
      if prop.nil? || (prop == '')
        data[name].to_f
      else
        prop.to_f
      end
    end

    def string_list_property(name, var)
      list = []
      prop = ENV[var].nil? ? nil : ENV[var].dup
      if prop.nil? || (prop == '')
        list = data[name] if !data[name].nil? && data[name].is_a?(Array)
      else
        list = prop.split(',')
      end
      list.each(&:strip!) unless list.empty?
      list
    end

    def load_config
      gem_root = File.expand_path('../../..', __FILE__)
      @data = YAML.load_file "#{gem_root}/config/agent.yml"
    end

    def read_config
      debug_level_string = property('debugLevel', 'NETUITIVE_RAILS_DEBUG_LEVEL')
      NetuitiveLogger.log.level = if debug_level_string == 'error'
                                    Logger::ERROR
                                  elsif debug_level_string == 'info'
                                    Logger::INFO
                                  elsif debug_level_string == 'debug'
                                    Logger::DEBUG
                                  else
                                    Logger::ERROR
                                  end

      @capture_errors = boolean_property('sendErrorEvents', 'NETUITIVE_RAILS_SEND_ERROR_EVENTS')
      @queue_time_divisor = float_property('queueTimeUnits', 'NETUITIVE_RAILS_QUEUE_TIME_UNITS')
      @ignored_errors = string_list_property('ignoredErrors', 'NETUITIVE_RAILS_IGNORED_ERRORS')
      @sidekiq_enabled = boolean_property('sidekiqEnabled', 'NETUITIVE_RAILS_SIDEKIQ_ENABLED')

      NetuitiveLogger.log.debug "read config file. Results:
        debugLevel: #{debug_level_string},
        capture_errors: #{capture_errors},
        ignored_errors: #{ignored_errors},
        queue_time_divisor: #{queue_time_divisor},
        sidekiq_enabled: #{sidekiq_enabled}"
    end
  end
end
