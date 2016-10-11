require 'netuitive/netuitive_rails_logger'
require 'netuitive/error_tracker'
require 'netuitive/request_data'
require 'action_controller'

class ActionController::Base
  include ErrorTrackerHook
  include RequestDataHook
  before_action :netuitiveRequestHook
end

module NetuitiveActionControllerSub
  def self.subscribe
    ActiveSupport::Notifications.subscribe /process_action.action_controller/ do |*args| 
      event = ActiveSupport::Notifications::Event.new(*args)
      controller = "#{event.payload[:controller]}"
      action = "#{event.payload[:action]}"
      begin
        NetuitiveRubyAPI::netuitivedServer.addSample("action_controller.#{controller}.#{action}.request.total_duration", event.duration)
        NetuitiveRubyAPI::netuitivedServer.addSample("action_controller.#{controller}.#{action}.request.query_time", event.payload[:db_runtime])
        NetuitiveRubyAPI::netuitivedServer.addSample("action_controller.#{controller}.#{action}.request.view_time", event.payload[:view_runtime])
        NetuitiveRubyAPI::netuitivedServer.aggregateMetric("action_controller.#{controller}.#{action}.total_requests", 1)
        NetuitiveRubyAPI::netuitivedServer.aggregateMetric("action_controller.#{controller}.total_requests", 1)
        NetuitiveRubyAPI::netuitivedServer.aggregateMetric("action_controller.total_requests", 1)
      rescue
          NetuitiveLogger.log.error "failure to communicate to netuitived"
      end
    end
    ActiveSupport::Notifications.subscribe /write_fragment.action_controller/ do |*args| 
      begin
        NetuitiveRubyAPI::netuitivedServer.aggregateMetric("action_controller.write_fragment", 1)
      rescue
          NetuitiveLogger.log.error "failure to communicate to netuitived"
      end
    end
    ActiveSupport::Notifications.subscribe /read_fragment.action_controller/ do |*args| 
      begin
        NetuitiveRubyAPI::netuitivedServer.aggregateMetric("action_controller.read_fragment", 1)
      rescue
          NetuitiveLogger.log.error "failure to communicate to netuitived"
      end
    end
    ActiveSupport::Notifications.subscribe /expire_fragment.action_controller/ do |*args| 
      begin
        NetuitiveRubyAPI::netuitivedServer.aggregateMetric("action_controller.expire_fragment", 1)
      rescue
          NetuitiveLogger.log.error "failure to communicate to netuitived"
      end
    end
    ActiveSupport::Notifications.subscribe /write_page.action_controller/ do |*args| 
      begin
        NetuitiveRubyAPI::netuitivedServer.aggregateMetric("action_controller.write_page", 1)
      rescue
          NetuitiveLogger.log.error "failure to communicate to netuitived"
      end
    end
    ActiveSupport::Notifications.subscribe /expire_page.action_controller/ do |*args| 
      begin
        NetuitiveRubyAPI::netuitivedServer.aggregateMetric("action_controller.expire_page", 1)
      rescue
        NetuitiveLogger.log.error "failure to communicate to netuitived"
      end
    end
    ActiveSupport::Notifications.subscribe /send_file.action_controller/ do |*args| 
      begin
        NetuitiveRubyAPI::netuitivedServer.aggregateMetric("action_controller.sent_file", 1)
      rescue
        NetuitiveLogger.log.error "failure to communicate to netuitived"
      end
    end
    ActiveSupport::Notifications.subscribe /redirect_to.action_controller/ do |*args| 
      begin
        NetuitiveRubyAPI::netuitivedServer.aggregateMetric("action_controller.redirect", 1)
      rescue
        NetuitiveLogger.log.error "failure to communicate to netuitived"
      end
    end
    ActiveSupport::Notifications.subscribe /halted_callback.action_controller/ do |*args| 
      begin
        NetuitiveRubyAPI::netuitivedServer.aggregateMetric("action_controller.halted_callback", 1)
      rescue
        NetuitiveLogger.log.error "failure to communicate to netuitived"
      end
    end
  end
end
