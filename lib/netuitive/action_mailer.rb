module NetuitiveActionMailer
  def self.subscribe
    ActiveSupport::Notifications.subscribe /receive.action_mailer/ do |*args|
      event = ActiveSupport::Notifications::Event.new(*args)
      mailer = "#{event.payload[:mailer]}"
      begin
        NetuitiveRubyAPI::netuitivedServer.aggregateMetric("action_mailer.#{mailer}.receive", 1)
      rescue
        NetuitiveLogger.log.error "failure to communicate to netuitived"
      end
    end
    ActiveSupport::Notifications.subscribe /deliver.action_mailer/ do |*args|
      event = ActiveSupport::Notifications::Event.new(*args)
      mailer = "#{event.payload[:mailer]}"
      begin
        NetuitiveRubyAPI::netuitivedServer.aggregateMetric("action_mailer.#{mailer}.deliver", 1)
      rescue
        NetuitiveLogger.log.error "failure to communicate to netuitived"
      end
    end
  end
end
