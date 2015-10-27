module NetuitiveActiveJobSub
  def self.subscribe
    ActiveSupport::Notifications.subscribe /enqueue.active_job/ do |*args| 
      NetuitiveRubyAPI::aggregator.aggregateMetric("active_job.enqueue", 1)
    end
    ActiveSupport::Notifications.subscribe /perform.active_job/ do |*args| 
      NetuitiveRubyAPI::aggregator.aggregateMetric("active_job.perform", 1)
    end
  end
end  
