module NetuitiveRailsAgent
  class Scheduler
    attr_reader :gc_stats_collector
    attr_reader :object_space_collector
    attr_reader :interaction
    def initialize(interaction)
      @gc_stats_collector = NetuitiveRailsAgent::GCStatsCollector.new(interaction)
      @object_space_collector = NetuitiveRailsAgent::ObjectSpaceStatsCollector.new(interaction)
      @interaction = interaction
    end

    def start_schedule
      NetuitiveRailsAgent::NetuitiveLogger.log.debug 'starting schedule'
      Thread.new do
        loop do
          NetuitiveRailsAgent::ErrorLogger.guard('error during schedule') do
            collect_metrics
            sleep_time = interval
            NetuitiveRailsAgent::NetuitiveLogger.log.debug "scheduler sleeping for: #{sleep_time}"
            sleep(sleep_time)
          end
        end
      end
    end

    def interval
      interval = interaction.interval
      interval = 60 if interval.nil?
      interval
    end

    def collect_metrics
      NetuitiveRailsAgent::NetuitiveLogger.log.debug 'start collecting schedule metrics'
      NetuitiveRailsAgent::ErrorLogger.guard('error during collect_metrics') do
        gc_stats_collector.collect if NetuitiveRailsAgent::ConfigManager.gc_enabled
        object_space_collector.collect if NetuitiveRailsAgent::ConfigManager.object_space_enabled
      end
      NetuitiveRailsAgent::NetuitiveLogger.log.debug 'finshed collecting schedule metrics'
    end
  end
end
