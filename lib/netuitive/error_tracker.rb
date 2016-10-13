require 'netuitive/controller_utils'
require 'netuitive/rails_config_manager'
module ErrorTrackerHook
  extend ActiveSupport::Concern

  include ControllerUtils

  def ignored_error?(exception)
    unless ConfigManager.ignored_errors.empty?
      ConfigManager.ignored_errors.each do |name|
        if name.include? '^'
          name.tr!('^', '')
          exception.class.ancestors.each do |ancestor|
            return true if name.casecmp(ancestor.name).zero?
          end
        elsif name.casecmp(exception.class.name).zero?
          return true
        end
      end
    end
    false
  end

  included do
    rescue_from Exception do |exception|
      begin
        NetuitiveLogger.log.debug "caught error: #{exception}"
        unless ignored_error?(exception)
          NetuitiveLogger.log.debug "#{exception} wasn't ignored"
          if ConfigManager.capture_errors
            NetuitiveLogger.log.debug "sending error: #{exception}"
            NetuitiveRubyAPI.exception_event(exception, exception.class, netuitive_request_uri, netuitive_controller_name, netuitive_action_name)
            NetuitiveLogger.log.debug 'sent error'
          end
          NetuitiveLogger.log.debug 'sending error metrics'
          NetuitiveRubyAPI.aggregate_metric('action_controller.errors', 1)
          if netuitive_controller_name
            NetuitiveLogger.log.debug "sent error metric with netuitive_controller_name: #{netuitive_controller_name}"
            NetuitiveRubyAPI.aggregate_metric("action_controller.#{netuitive_controller_name}.errors", 1)
            if netuitive_action_name
              NetuitiveLogger.log.debug "sent error metric with netuitive_action_name: #{netuitive_action_name}"
              NetuitiveRubyAPI.aggregate_metric("action_controller.#{netuitive_controller_name}.#{netuitive_action_name}.errors", 1)
            end
          end
        end
      rescue => e
        NetuitiveLogger.log.error "exception during error tracking: message:#{e.message} backtrace:#{e.backtrace}"
      end
      raise exception
    end
  end
end
