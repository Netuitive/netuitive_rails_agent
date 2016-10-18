module NetuitiveRailsAgent
  module ErrorUtils
    attr_accessor :interaction

    def ignored_error?(exception)
      unless NetuitiveRailsAgent::ConfigManager.ignored_errors.empty?
        NetuitiveRailsAgent::ConfigManager.ignored_errors.each do |name|
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

    def handle_error(exception, metrics = [], tags = {})
      NetuitiveRailsAgent::NetuitiveLogger.log.debug "received error: #{exception}"
      unless ignored_error?(exception)
        @interaction = NetuitiveRailsAgent::ApiInteraction.new unless @interaction
        NetuitiveRailsAgent::NetuitiveLogger.log.debug "#{exception} wasn't ignored"
        if NetuitiveRailsAgent::ConfigManager.capture_errors
          NetuitiveRailsAgent::NetuitiveLogger.log.debug "sending error: #{exception}"
          @interaction.exception_event(exception, exception.class, tags)
          NetuitiveRailsAgent::NetuitiveLogger.log.debug 'sent error'
        end
        NetuitiveRailsAgent::NetuitiveLogger.log.debug 'sending error metrics'
        metrics.each do |metric|
          @interaction.aggregate_metric(metric.to_s, 1)
          NetuitiveRailsAgent::NetuitiveLogger.log.debug "sent error metric with name: #{metric}"
        end
      end
    rescue => e
      NetuitiveRailsAgent::NetuitiveLogger.log.error "exception during error tracking: message:#{e.message} backtrace:#{e.backtrace}"
    end
  end
end
