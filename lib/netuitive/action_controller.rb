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
      begin
        NetuitiveRubyAPI::netuitivedServer.addSample("#{controller}.#{action}.request.total_duration", event.duration)
        NetuitiveRubyAPI::netuitivedServer.addSample("#{controller}.#{action}.request.query_time", event.payload[:db_runtime])
        NetuitiveRubyAPI::netuitivedServer.addSample("#{controller}.#{action}.request.view_time", event.payload[:view_runtime])
      rescue
        if ConfigManager.isError?
          puts "failure to communicate to netuitived"
        end
      end
    end
    ActiveSupport::Notifications.subscribe /write_fragment.action_controller/ do |*args| 
      begin
        NetuitiveRubyAPI::netuitivedServer.aggregateMetric("action_controller.write_fragment", 1)
      rescue
        if ConfigManager.isError?
          puts "failure to communicate to netuitived"
        end
      end
    end
    ActiveSupport::Notifications.subscribe /read_fragment.action_controller/ do |*args| 
      begin
        NetuitiveRubyAPI::netuitivedServer.aggregateMetric("action_controller.read_fragment", 1)
      rescue
        if ConfigManager.isError?
          puts "failure to communicate to netuitived"
        end
      end
    end
    ActiveSupport::Notifications.subscribe /expire_fragment.action_controller/ do |*args| 
      begin
        NetuitiveRubyAPI::netuitivedServer.aggregateMetric("action_controller.expire_fragment", 1)
      rescue
        if ConfigManager.isError?
          puts "failure to communicate to netuitived"
        end
      end
    end
    ActiveSupport::Notifications.subscribe /write_page.action_controller/ do |*args| 
      begin
        NetuitiveRubyAPI::netuitivedServer.aggregateMetric("action_controller.write_page", 1)
      rescue
        if ConfigManager.isError?
          puts "failure to communicate to netuitived"
        end
      end
    end
    ActiveSupport::Notifications.subscribe /expire_page.action_controller/ do |*args| 
      begin
        NetuitiveRubyAPI::netuitivedServer.aggregateMetric("action_controller.expire_page", 1)
      rescue
        if ConfigManager.isError?
          puts "failure to communicate to netuitived"
        end
      end
    end
    ActiveSupport::Notifications.subscribe /send_file.action_controller/ do |*args| 
      begin
        NetuitiveRubyAPI::netuitivedServer.aggregateMetric("action_controller.sent_file", 1)
      rescue
        if ConfigManager.isError?
          puts "failure to communicate to netuitived"
        end
      end
    end
    ActiveSupport::Notifications.subscribe /redirect_to.action_controller/ do |*args| 
      begin
        NetuitiveRubyAPI::netuitivedServer.aggregateMetric("action_controller.redirect", 1)
      rescue
        if ConfigManager.isError?
          puts "failure to communicate to netuitived"
        end
      end
    end
    ActiveSupport::Notifications.subscribe /halted_callback.action_controller/ do |*args| 
      begin
        NetuitiveRubyAPI::netuitivedServer.aggregateMetric("action_controller.halted_callback", 1)
      rescue
        if ConfigManager.isError?
          puts "failure to communicate to netuitived"
        end
      end
    end
  end
end
