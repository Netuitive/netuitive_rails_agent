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
          begin
            collect_metrics
            sleep_time = interval
            NetuitiveRailsAgent::NetuitiveLogger.log.debug "scheduler sleeping for: #{sleep_time}"
            sleep(sleep_time)
          rescue => e
            NetuitiveRailsAgent::NetuitiveLogger.log.error "error during schedule: #{e.message}, backtrace: #{e.backtrace}"
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
      NetuitiveRailsAgent::NetuitiveLogger.log.debug 'collecting schedule metrics'
      begin
        gc_stats_collector.collect if NetuitiveRailsAgent::ConfigManager.gc_enabled
        object_space_collector.collect if NetuitiveRailsAgent::ConfigManager.object_space_enabled
      rescue => e
        NetuitiveRailsAgent::NetuitiveLogger.log.error "unable to collect schedule metrics: message:#{e.message} backtrace:#{e.backtrace}"
      end
    end
  end
end
