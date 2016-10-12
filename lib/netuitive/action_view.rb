module NetuitiveActionViewSub
  def self.subscribe
    ActiveSupport::Notifications.subscribe /render_template.action_view/ do |*args|
      begin
        NetuitiveRubyAPI::netuitivedServer.aggregateMetric("action_view.render_template", 1)
      rescue
        NetuitiveLogger.log.error "failure to communicate to netuitived"
      end
    end
    ActiveSupport::Notifications.subscribe /render_partial.action_view/ do |*args|
      begin
        NetuitiveRubyAPI::netuitivedServer.aggregateMetric("action_view.render_partial", 1)
      rescue
        NetuitiveLogger.log.error "failure to communicate to netuitived"
      end
    end
  end
end
