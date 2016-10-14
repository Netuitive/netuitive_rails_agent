module ErrorUtils
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

  def handle_error(exception, metrics = [], tags = {})
    NetuitiveLogger.log.debug "received error: #{exception}"
    unless ignored_error?(exception)
      NetuitiveLogger.log.debug "#{exception} wasn't ignored"
      if ConfigManager.capture_errors
        NetuitiveLogger.log.debug "sending error: #{exception}"
        NetuitiveRubyAPI.exception_event(exception, exception.class, tags)
        NetuitiveLogger.log.debug 'sent error'
      end
      NetuitiveLogger.log.debug 'sending error metrics'
      metrics.each do |metric|
        NetuitiveRubyAPI.aggregate_metric(metric.to_s, 1)
        NetuitiveLogger.log.debug "sent error metric with name: #{metric}"
      end
    end
  rescue => e
    NetuitiveLogger.log.error "exception during error tracking: message:#{e.message} backtrace:#{e.backtrace}"
  end
end
