module ErrorUtils
  attr_accessor :interaction

  def ignored_error?(exception)
    unless RailsConfigManager.ignored_errors.empty?
      RailsConfigManager.ignored_errors.each do |name|
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
    RailsNetuitiveLogger.log.debug "received error: #{exception}"
    unless ignored_error?(exception)
      RailsNetuitiveLogger.log.debug "#{exception} wasn't ignored"
      if RailsConfigManager.capture_errors
        RailsNetuitiveLogger.log.debug "sending error: #{exception}"
        @interaction = ApiInteraction.new unless @interaction
        @interaction.exception_event(exception, exception.class, tags)
        RailsNetuitiveLogger.log.debug 'sent error'
      end
      RailsNetuitiveLogger.log.debug 'sending error metrics'
      metrics.each do |metric|
        @interaction.aggregate_metric(metric.to_s, 1)
        RailsNetuitiveLogger.log.debug "sent error metric with name: #{metric}"
      end
    end
  rescue => e
    RailsNetuitiveLogger.log.error "exception during error tracking: message:#{e.message} backtrace:#{e.backtrace}"
  end
end
