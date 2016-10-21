module NetuitiveRailsAgent
  class ApiInteraction
    def send_metrics
      NetuitiveRubyAPI.send_metrics
    end

    def add_sample(metric_id, val)
      NetuitiveRailsAgent::ErrorLogger.guard('error during add_sample') do
        NetuitiveRubyAPI.add_sample(metric_id, val)
      end
    end

    def add_counter_sample(metric_id, val)
      NetuitiveRailsAgent::ErrorLogger.guard('error during add_counter_sample') do
        NetuitiveRubyAPI.add_counter_sample(metric_id, val)
      end
    end

    def aggregate_metric(metric_id, val)
      NetuitiveRailsAgent::ErrorLogger.guard('error during aggregate_metric') do
        NetuitiveRubyAPI.aggregate_metric(metric_id, val)
      end
    end

    def aggregate_counter_metric(metric_id, val)
      NetuitiveRailsAgent::ErrorLogger.guard('error during aggregate_counter_metric') do
        NetuitiveRubyAPI.aggregate_counter_metric(metric_id, val)
      end
    end

    def clear_metrics
      NetuitiveRailsAgent::ErrorLogger.guard('error during clear_metrics') do
        NetuitiveRubyAPI.clear_metrics
      end
    end

    def interval
      NetuitiveRailsAgent::ErrorLogger.guard('error during interval') do
        NetuitiveRubyAPI.interval
      end
    end

    def event(message, timestamp = Time.new, title = 'Ruby Event', level = 'Info', source = 'Ruby Agent', type = 'INFO', tags = nil)
      NetuitiveRailsAgent::ErrorLogger.guard('error during event') do
        NetuitiveRubyAPI.event(message, timestamp, title, level, source, type, tags)
      end
    end

    def exception_event(exception, klass = nil, tags = nil)
      NetuitiveRailsAgent::ErrorLogger.guard('error during exception_event') do
        NetuitiveRubyAPI.exception_event(exception, klass, tags)
      end
    end

    def stop_server
      NetuitiveRailsAgent::ErrorLogger.guard('error during stop_server') do
        NetuitiveRubyAPI.stop_server
      end
    end
  end
end
