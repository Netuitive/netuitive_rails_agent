module NetuitiveRailsAgent
  class GCStatsCollector
    attr_reader :interaction
    def initialize(interaction)
      @interaction = interaction
    end

    def collect
      unless GC::Profiler.enabled?
        NetuitiveRailsAgent::NetuitiveLogger.log.warn 'gc profiler not enabled'
        return
      end
      NetuitiveRailsAgent::NetuitiveLogger.log.debug 'collecting gc metrics'
      NetuitiveRailsAgent::ErrorLogger.guard('error during collecting gc metrics') do
        GC.stat.each do |key, value|
          NetuitiveRailsAgent::NetuitiveLogger.log.debug "GC stat key: #{key}"
          if (key.to_s == 'total_allocated_object') || (key.to_s == 'total_freed_object') || (key.to_s == 'count')
            NetuitiveRailsAgent::NetuitiveLogger.log.debug "sending aggregateCounterMetric GC.stat.#{key}"
            interaction.aggregate_counter_metric("GC.stat.#{key}", value)
          else
            NetuitiveRailsAgent::NetuitiveLogger.log.debug "sending aggregateMetric GC.stat.#{key}"
            interaction.aggregate_metric("GC.stat.#{key}", value)
          end
        end
        NetuitiveRailsAgent::NetuitiveLogger.log.debug 'sending aggregateCounterMetric GC.profiler.total_time'
        interaction.aggregate_counter_metric('GC.profiler.total_time', GC::Profiler.total_time)
      end
      NetuitiveRailsAgent::NetuitiveLogger.log.debug 'finished collecting gc metrics'
    end
  end
end
