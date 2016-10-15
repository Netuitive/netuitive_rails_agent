require 'netuitive/netuitive_rails_logger'
require 'netuitive/gc'
require 'netuitive/objectspace'

class Scheduler
  def self.start_schedule
    NetuitiveLogger.log.debug 'starting schedule'
    Thread.new do
      loop do
        collect_metrics
        sleep(interval)
      end
    end
  end

  def self.interval
    interval = NetuitiveRubyAPI.netuitivedServer.interval
    interval = 60 if interval.nil?
    interval
  end

  def self.collect_metrics
    NetuitiveLogger.log.debug 'collecting schedule metrics'
    begin
      GCStatsCollector.collect if ConfigManager.gc_enabled
      ObjectSpaceStatsCollector.collect if ConfigManager.object_space_enabled
    rescue => e
      NetuitiveLogger.log.error "unable to collect schedule metrics: message:#{e.message} backtrace:#{e.backtrace}"
    end
  end
end
