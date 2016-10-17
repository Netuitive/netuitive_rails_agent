class GCStatsCollector
  attr_reader :interaction
  def initialize(interaction)
    @interaction = interaction
  end

  def collect
    return unless GC::Profiler.enabled?
    begin
        RailsNetuitiveLogger.log.debug 'collecting gc metrics'
        GC.stat.each do |key, value|
          RailsNetuitiveLogger.log.debug "GC stat key: #{key}"
          if (key.to_s == 'total_allocated_object') || (key.to_s == 'total_freed_object') || (key.to_s == 'count')
            RailsNetuitiveLogger.log.debug "sending aggregateCounterMetric GC.stat.#{key}"
            interaction.aggregate_counter_metric("GC.stat.#{key}", value)
          else
            RailsNetuitiveLogger.log.debug "sending aggregateMetric GC.stat.#{key}"
            interaction.aggregate_metric("GC.stat.#{key}", value)
          end
        end
        RailsNetuitiveLogger.log.debug 'sending aggregateCounterMetric GC.profiler.total_time'
        interaction.aggregate_counter_metric('GC.profiler.total_time', GC::Profiler.total_time)
      rescue => e
        RailsNetuitiveLogger.log.error "exception during gc collection: message:#{e.message} backtrace:#{e.backtrace}"
      end
  end
end
