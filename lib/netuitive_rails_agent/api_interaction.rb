module NetuitiveRailsAgent
  class ApiInteraction
    def send_metrics
      NetuitiveRubyAPI.send_metrics
    end

    def add_sample(metric_id, val)
      NetuitiveRubyAPI.add_sample(metric_id, val)
    end

    def add_counter_sample(metric_id, val)
      NetuitiveRubyAPI.add_counter_sample(metric_id, val)
    end

    def aggregate_metric(metric_id, val)
      NetuitiveRubyAPI.aggregate_metric(metric_id, val)
    end

    def aggregate_counter_metric(metric_id, val)
      NetuitiveRubyAPI.aggregate_counter_metric(metric_id, val)
    end

    def clear_metrics
      NetuitiveRubyAPI.clear_metrics
    end

    def interval
      NetuitiveRubyAPI.interval
    end

    def event(message, timestamp = Time.new, title = 'Ruby Event', level = 'Info', source = 'Ruby Agent', type = 'INFO', tags = nil)
      NetuitiveRubyAPI.event(message, timestamp, title, level, source, type, tags)
    end

    def exception_event(exception, klass = nil, tags = nil)
      NetuitiveRubyAPI.exception_event(exception, klass, tags)
    end

    def stop_server
      NetuitiveRubyAPI.stop_server
    end
  end
end
