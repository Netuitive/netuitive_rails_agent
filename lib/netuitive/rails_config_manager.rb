require 'netuitive/netuitive_rails_logger'

class ConfigManager
  class << self
    attr_accessor :capture_errors

    attr_accessor :ignored_errors

    attr_accessor :queue_time_divisor

    attr_accessor :sidekiq_enabled

    attr_accessor :action_controller_enabled

    attr_accessor :active_record_enabled

    attr_accessor :action_view_enabled

    attr_accessor :action_mailer_enabled

    attr_accessor :active_support_enabled

    attr_accessor :active_job_enabled

    attr_accessor :request_wrapper_enabled

    attr_accessor :action_errors_enabled

    attr_accessor :gc_enabled

    attr_accessor :object_space_enabled

    attr_accessor :data

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
      @action_controller_enabled = boolean_property('actionControllerEnabled', 'NETUITIVE_RAILS_ACTION_CONTROLLER_ENABLED')
      @active_record_enabled = boolean_property('activeRecordEnabled', 'NETUITIVE_RAILS_ACTIVE_RECORD_ENABLED')
      @action_view_enabled = boolean_property('actionViewEnabled', 'NETUITIVE_RAILS_ACTION_VIEW_ENABLED')
      @action_mailer_enabled = boolean_property('actionMailerEnabled', 'NETUITIVE_RAILS_ACTION_MAILER_ENABLED')
      @active_support_enabled = boolean_property('activeSupportEnabled', 'NETUITIVE_RAILS_ACTIVE_SUPPORT_ENABLED')
      @active_job_enabled = boolean_property('activeJobEnabled', 'NETUITIVE_RAILS_ACTIVE_JOB_ENABLED')
      @request_wrapper_enabled = boolean_property('requestWrapperEnabled', 'NETUITIVE_RAILS_REQUEST_WRAPPER_ENABLED')
      @action_errors_enabled = boolean_property('actionErrorsEnabled', 'NETUITIVE_RAILS_ACTION_ERRORS_ENABLED')
      @gc_enabled = boolean_property('gcEnabled', 'NETUITIVE_RAILS_GC_ENABLED')
      @object_space_enabled = boolean_property('objectSpaceEnabled', 'NETUITIVE_RAILS_OBJECT_SPACE_ENABLED')

      NetuitiveLogger.log.debug "read config file. Results:
        debugLevel: #{debug_level_string},
        capture_errors: #{capture_errors},
        ignored_errors: #{ignored_errors},
        queue_time_divisor: #{queue_time_divisor},
        sidekiq_enabled: #{sidekiq_enabled},
        action_controller_enabled: #{action_controller_enabled},
        active_record_enabled: #{active_record_enabled},
        action_view_enabled: #{action_view_enabled},
        action_mailer_enabled: #{action_mailer_enabled},
        active_support_enabled: #{active_support_enabled},
        active_job_enabled: #{active_job_enabled},
        request_wrapper_enabled: #{request_wrapper_enabled},
        action_errors_enabled: #{action_errors_enabled},
        gc_enabled: #{gc_enabled},
        object_space_enabled: #{object_space_enabled}"
    end
  end
end
