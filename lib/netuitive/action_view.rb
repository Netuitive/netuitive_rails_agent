module NetuitiveActionViewSub
  def self.subscribe
    ActiveSupport::Notifications.subscribe /render_template.action_view/ do |*args| 
      NetuitiveRubyAPI::netuitivedServer.aggregateMetric("action_view.render_template", 1)
    end
    ActiveSupport::Notifications.subscribe /render_partial.action_view/ do |*args| 
      NetuitiveRubyAPI::netuitivedServer.aggregateMetric("action_view.render_partial", 1)
    end
  end
end
