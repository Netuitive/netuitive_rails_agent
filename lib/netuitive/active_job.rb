module NetuitiveActiveJobSub
  def self.subscribe
    ActiveSupport::Notifications.subscribe /enqueue.active_job/ do |*args|
      begin
        NetuitiveRubyAPI::netuitivedServer.aggregateMetric("active_job.enqueue", 1)
      rescue
        NetuitiveLogger.log.error "failure to communicate to netuitived"
      end
    end
    ActiveSupport::Notifications.subscribe /perform.active_job/ do |*args|
      begin
        NetuitiveRubyAPI::netuitivedServer.aggregateMetric("active_job.perform", 1)
      rescue
        NetuitiveLogger.log.error "failure to communicate to netuitived"
      end
    end
  end
end
