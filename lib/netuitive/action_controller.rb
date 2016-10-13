require 'netuitive/netuitive_rails_logger'
require 'netuitive/error_tracker'
require 'netuitive/request_data'
require 'action_controller'

module ActionController
  class Base
    include ErrorTrackerHook
    include RequestDataHook
    before_action :netuitive_request_hook
  end
end

module NetuitiveActionControllerSub
  def self.subscribe
    ActiveSupport::Notifications.subscribe(/process_action.action_controller/) do |*args|
      event = ActiveSupport::Notifications::Event.new(*args)
      controller = event.payload[:controller].to_s
      action = event.payload[:action].to_s
      NetuitiveRubyAPI.add_sample("action_controller.#{controller}.#{action}.request.total_duration", event.duration)
      NetuitiveRubyAPI.add_sample("action_controller.#{controller}.#{action}.request.query_time", event.payload[:db_runtime])
      NetuitiveRubyAPI.add_sample("action_controller.#{controller}.#{action}.request.view_time", event.payload[:view_runtime])
      NetuitiveRubyAPI.add_sample("action_controller.#{controller}.request.total_duration", event.duration)
      NetuitiveRubyAPI.add_sample("action_controller.#{controller}.request.query_time", event.payload[:db_runtime])
      NetuitiveRubyAPI.add_sample("action_controller.#{controller}.request.view_time", event.payload[:view_runtime])
      NetuitiveRubyAPI.add_sample('action_controller.request.total_duration', event.duration)
      NetuitiveRubyAPI.add_sample('action_controller.request.query_time', event.payload[:db_runtime])
      NetuitiveRubyAPI.add_sample('action_controller.request.view_time', event.payload[:view_runtime])
      NetuitiveRubyAPI.aggregate_metric("action_controller.#{controller}.#{action}.total_requests", 1)
      NetuitiveRubyAPI.aggregate_metric("action_controller.#{controller}.total_requests", 1)
      NetuitiveRubyAPI.aggregate_metric('action_controller.total_requests', 1)
    end
    ActiveSupport::Notifications.subscribe(/write_fragment.action_controller/) do |*_args|
      NetuitiveRubyAPI.aggregate_metric('action_controller.write_fragment', 1)
    end
    ActiveSupport::Notifications.subscribe(/read_fragment.action_controller/) do |*_args|
      NetuitiveRubyAPI.aggregate_metric('action_controller.read_fragment', 1)
    end
    ActiveSupport::Notifications.subscribe(/expire_fragment.action_controller/) do |*_args|
      NetuitiveRubyAPI.aggregate_metric('action_controller.expire_fragment', 1)
    end
    ActiveSupport::Notifications.subscribe(/write_page.action_controller/) do |*_args|
      NetuitiveRubyAPI.aggregate_metric('action_controller.write_page', 1)
    end
    ActiveSupport::Notifications.subscribe(/expire_page.action_controller/) do |*_args|
      NetuitiveRubyAPI.aggregate_metric('action_controller.expire_page', 1)
    end
    ActiveSupport::Notifications.subscribe(/send_file.action_controller/) do |*_args|
      NetuitiveRubyAPI.aggregate_metric('action_controller.sent_file', 1)
    end
    ActiveSupport::Notifications.subscribe(/redirect_to.action_controller/) do |*_args|
      NetuitiveRubyAPI.aggregate_metric('action_controller.redirect', 1)
    end
    ActiveSupport::Notifications.subscribe(/halted_callback.action_controller/) do |*_args|
      NetuitiveRubyAPI.aggregate_metric('action_controller.halted_callback', 1)
    end
  end
end
