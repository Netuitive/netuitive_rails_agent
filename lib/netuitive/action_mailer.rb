module NetuitiveActionMailer
  def self.subscribe
  	ActiveSupport::Notifications.subscribe /receive.action_mailer/ do |*args| 
      event = ActiveSupport::Notifications::Event.new(*args)
      mailer = "#{event.payload[:mailer]}"
      NetuitiveRubyAPI::aggregator.aggregateMetric("action_mailer.#{mailer}.receive", 1)
    end
    ActiveSupport::Notifications.subscribe /deliver.action_mailer/ do |*args| 
      event = ActiveSupport::Notifications::Event.new(*args)
      mailer = "#{event.payload[:mailer]}"
      NetuitiveRubyAPI::aggregator.aggregateMetric("action_mailer.#{mailer}.deliver", 1)
    end
  end
end
