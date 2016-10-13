require 'netuitive/netuitive_rails_logger'

class ConfigManager
  class << self
    def setup
      read_config
    end

    attr_reader :capture_errors

    attr_reader :ignored_errors

    attr_reader :queue_time_divisor

    def read_config
      gem_root = File.expand_path('../../..', __FILE__)
      data = YAML.load_file "#{gem_root}/config/agent.yml"
      debug_level_string = ENV['NETUITIVE_RAILS_DEBUG_LEVEL']
      if debug_level_string.nil? || (debug_level_string == '')
        debug_level_string = data['debugLevel']
      end
      NetuitiveLogger.log.level = if debug_level_string == 'error'
                                    Logger::ERROR
                                  elsif debug_level_string == 'info'
                                    Logger::INFO
                                  elsif debug_level_string == 'debug'
                                    Logger::DEBUG
                                  else
                                    Logger::ERROR
                                  end

      exception_string = ENV['NETUITIVE_RAILS_SEND_ERROR_EVENTS'].nil? ? nil : ENV['NETUITIVE_RAILS_SEND_ERROR_EVENTS'].dup
      if exception_string.nil? || (exception_string == '')
        @capture_errors = data['sendErrorEvents']
      else
        exception_string.strip!
        @capture_errors = exception_string.casecmp('true').zero?
      end

      divisor_string = ENV['NETUITIVE_RAILS_QUEUE_TIME_UNITS'].nil? ? nil : ENV['NETUITIVE_RAILS_QUEUE_TIME_UNITS']
      @queue_time_divisor = if divisor_string.nil? || (divisor_string == '')
                              data['queueTimeUnits'].to_f
                            else
                              divisor_string.to_f
                            end

      @ignored_errors = []
      ignored_exception_string = ENV['NETUITIVE_RAILS_IGNORED_ERRORS'].nil? ? nil : ENV['NETUITIVE_RAILS_IGNORED_ERRORS'].dup
      if ignored_exception_string.nil? || (ignored_exception_string == '')
        if !data['ignored_errors'].nil? && data['ignored_errors'].is_a?(Array)
          @ignored_errors = data['ignored_errors']
        end
      else
        @ignored_errors = ignored_exception_string.split(',')
      end
      @ignored_errors.each(&:strip!) unless @ignored_errors.empty?

      NetuitiveLogger.log.debug "read config file. Results:
        debugLevel: #{debug_level_string}
        capture_errors: #{capture_errors},
        ignored_errors: #{ignored_errors},
        queue_time_divisor: #{queue_time_divisor}"
    end
  end
end
