module NetuitiveActionControllerSub
  def self.subscribe
    ActiveSupport::Notifications.subscribe /process_action.action_controller/ do |*args| 
      event = ActiveSupport::Notifications::Event.new(*args)
      controller = "#{event.payload[:controller]}"
      action = "#{event.payload[:action]}"
      format = "format:#{event.payload[:format] || 'all'}"
      format = "format:all" if format == "format:*/*" 
      host = "host:#{ENV['INSTRUMENTATION_HOSTNAME']}"
      status = event.payload[:status]
      tags = [controller, action, format, host] 
      NetuitiveRubyAPI::aggregator.addSample("#{controller}.#{action}.request.total_duration", event.duration)
      NetuitiveRubyAPI::aggregator.addSample("#{controller}.#{action}.request.query_time", event.payload[:db_runtime])
      NetuitiveRubyAPI::aggregator.addSample("#{controller}.#{action}.request.view_time", event.payload[:view_runtime])
    end
    ActiveSupport::Notifications.subscribe /write_fragment.action_controller/ do |*args| 
      NetuitiveRubyAPI::aggregator.aggregateMetric("action_controller.write_fragment", 1)
    end
    ActiveSupport::Notifications.subscribe /read_fragment.action_controller/ do |*args| 
      NetuitiveRubyAPI::aggregator.aggregateMetric("action_controller.read_fragment", 1)
    end
    ActiveSupport::Notifications.subscribe /expire_fragment.action_controller/ do |*args| 
      NetuitiveRubyAPI::aggregator.aggregateMetric("action_controller.expire_fragment", 1)
    end
    ActiveSupport::Notifications.subscribe /write_page.action_controller/ do |*args| 
      NetuitiveRubyAPI::aggregator.aggregateMetric("action_controller.write_page", 1)
    end
    ActiveSupport::Notifications.subscribe /expire_page.action_controller/ do |*args| 
      NetuitiveRubyAPI::aggregator.aggregateMetric("action_controller.expire_page", 1)
    end
    ActiveSupport::Notifications.subscribe /send_file.action_controller/ do |*args| 
      NetuitiveRubyAPI::aggregator.aggregateMetric("action_controller.sent_file", 1)
    end
    ActiveSupport::Notifications.subscribe /redirect_to.action_controller/ do |*args| 
      NetuitiveRubyAPI::aggregator.aggregateMetric("action_controller.redirect", 1)
    end
    ActiveSupport::Notifications.subscribe /halted_callback.action_controller/ do |*args| 
      NetuitiveRubyAPI::aggregator.aggregateMetric("action_controller.halted_callback", 1)
    end
  end
end
