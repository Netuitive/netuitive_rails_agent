class Scheduler
  attr_reader :gc_stats_collector
  attr_reader :object_space_collector
  attr_reader :interaction
  def initialize(interaction)
    @gc_stats_collector = GCStatsCollector.new(interaction)
    @object_space_collector = ObjectSpaceStatsCollector.new(interaction)
    @interaction = interaction
  end

  def start_schedule
    NetuitiveLogger.log.debug 'starting schedule'
    Thread.new do
      loop do
        collect_metrics
        sleep(interval)
      end
    end
  end

  def interval
    interval = interaction.netuitivedServer.interval
    interval = 60 if interval.nil?
    interval
  end

  def collect_metrics
    NetuitiveLogger.log.debug 'collecting schedule metrics'
    begin
      gc_stats_collector.collect if ConfigManager.gc_enabled
      object_space_collector.collect if ConfigManager.object_space_enabled
    rescue => e
      NetuitiveLogger.log.error "unable to collect schedule metrics: message:#{e.message} backtrace:#{e.backtrace}"
    end
  end
end
