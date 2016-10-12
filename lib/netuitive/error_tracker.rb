require 'netuitive/controller_utils'
require 'netuitive/rails_config_manager'
module ErrorTrackerHook
  extend ActiveSupport::Concern

  include ControllerUtils

  def isIgnoredError(exception)
    if !ConfigManager.ignoredErrors.empty?
      ConfigManager.ignoredErrors.each do |name|
        if name.include? "^"
          name.tr!('^','')
          exception.class.ancestors.each do |ancestor|
            if name.casecmp(ancestor.name) == 0
              return true;
            end
          end
        elsif name.casecmp(exception.class.name) == 0
          return true;
        end
      end
    end
    return false
  end

  included do
    rescue_from Exception do |exception|
      begin
        NetuitiveLogger.log.debug "caught error: #{exception}"
        if !isIgnoredError(exception)
          NetuitiveLogger.log.debug "error: #{exception} wasn't ignored"
          if ConfigManager.captureErrors
            NetuitiveLogger.log.debug "sending error: #{exception}"
            NetuitiveRubyAPI::netuitivedServer.exceptionEvent(exception, exception.class, requestUri, controllerName, actionName)
            NetuitiveLogger.log.debug "sent error"
          end
          NetuitiveLogger.log.debug "sending error metrics"
          NetuitiveRubyAPI::netuitivedServer.aggregateMetric("action_controller.errors", 1)
          if controllerName
            NetuitiveLogger.log.debug "sent error metric with controllerName: #{controllerName}"
            NetuitiveRubyAPI::netuitivedServer.aggregateMetric("action_controller.#{controllerName}.errors", 1)
            if actionName
              NetuitiveLogger.log.debug "sent error metric with actionName: #{actionName}"
              NetuitiveRubyAPI::netuitivedServer.aggregateMetric("action_controller.#{controllerName}.#{actionName}.errors", 1)
            end
          end
        end
      rescue => e
        NetuitiveLogger.log.error "failure to communicate to netuitived"
      end
      raise exception
    end
  end
end
