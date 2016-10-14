class GCStatsCollector
  def self.collect
    return unless GC::Profiler.enabled?
    begin
        NetuitiveLogger.log.debug 'collecting gc metrics'
        GC.stat.each do |key, value|
          NetuitiveLogger.log.debug "GC stat key: #{key}"
          if (key.to_s == 'total_allocated_object') || (key.to_s == 'total_freed_object') || (key.to_s == 'count')
            NetuitiveLogger.log.debug "sending aggregateCounterMetric GC.stat.#{key}"
            NetuitiveRubyAPI.aggregate_counter_metric("GC.stat.#{key}", value)
          else
            NetuitiveLogger.log.debug "sending aggregateMetric GC.stat.#{key}"
            NetuitiveRubyAPI.aggregate_metric("GC.stat.#{key}", value)
          end
        end
        NetuitiveLogger.log.debug 'sending aggregateCounterMetric GC.profiler.total_time'
        NetuitiveRubyAPI.aggregate_counter_metric('GC.profiler.total_time', GC::Profiler.total_time)
      rescue => e
        NetuitiveLogger.log.error "exception during gc collection: message:#{e.message} backtrace:#{e.backtrace}"
      end
  end
end
