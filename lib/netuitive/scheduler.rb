require 'netuitive/netuitive_rails_logger'
require 'netuitive/gc'
require 'netuitive/rubyvm'
require 'netuitive/objectspace'
class Scheduler
	def self.startSchedule
		Thread.new do
     while true do
      interval = 60
      begin
        interval = NetuitiveRubyAPI::netuitivedServer.interval
      rescue
        NetuitiveLogger.log.info "unable to retrieve netuitived interval defaulting to 60"
      end
      collectMetrics
      sleep(interval)
    end
  end
end
def self.collectMetrics
  GCStatsCollector::collect
  ObjectSpaceStatsCollector::collect
end
end 