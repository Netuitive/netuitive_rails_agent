ActionController::Base.class_eval do
  include NetuitiveRailsAgent::ErrorTrackerHook if NetuitiveRailsAgent::ConfigManager.action_errors_enabled
  if NetuitiveRailsAgent::ConfigManager.request_wrapper_enabled
    include NetuitiveRailsAgent::RequestDataHook
    before_action :netuitive_request_hook
  end
end

module NetuitiveRailsAgent
  class ActionControllerSub
    attr_reader :interaction

    def initialize(interaction)
      @interaction = interaction
    end

    def subscribe
      ActiveSupport::Notifications.subscribe(/process_action.action_controller/) do |*args|
        process_action(*args)
      end
      ActiveSupport::Notifications.subscribe(/write_fragment.action_controller/) do |*_args|
        write_fragment
      end
      ActiveSupport::Notifications.subscribe(/read_fragment.action_controller/) do |*_args|
        read_fragment
      end
      ActiveSupport::Notifications.subscribe(/expire_fragment.action_controller/) do |*_args|
        expire_fragment
      end
      ActiveSupport::Notifications.subscribe(/write_page.action_controller/) do |*_args|
        write_page
      end
      ActiveSupport::Notifications.subscribe(/expire_page.action_controller/) do |*_args|
        expire_page
      end
      ActiveSupport::Notifications.subscribe(/send_file.action_controller/) do |*_args|
        send_file
      end
      ActiveSupport::Notifications.subscribe(/redirect_to.action_controller/) do |*_args|
        redirect_to
      end
      ActiveSupport::Notifications.subscribe(/halted_callback.action_controller/) do |*_args|
        halted_callback
      end
    end

    def process_action(*args)
      event = ActiveSupport::Notifications::Event.new(*args)
      controller = event.payload[:controller].to_s
      action = event.payload[:action].to_s
      interaction.add_sample("action_controller.#{controller}.#{action}.request.total_duration", event.duration)
      interaction.add_sample("action_controller.#{controller}.#{action}.request.query_time", event.payload[:db_runtime])
      interaction.add_sample("action_controller.#{controller}.#{action}.request.view_time", event.payload[:view_runtime])
      interaction.add_sample("action_controller.#{controller}.request.total_duration", event.duration)
      interaction.add_sample("action_controller.#{controller}.request.query_time", event.payload[:db_runtime])
      interaction.add_sample("action_controller.#{controller}.request.view_time", event.payload[:view_runtime])
      interaction.add_sample('action_controller.request.total_duration', event.duration)
      interaction.add_sample('action_controller.request.query_time', event.payload[:db_runtime])
      interaction.add_sample('action_controller.request.view_time', event.payload[:view_runtime])
      interaction.aggregate_metric("action_controller.#{controller}.#{action}.total_requests", 1)
      interaction.aggregate_metric("action_controller.#{controller}.total_requests", 1)
      interaction.aggregate_metric('action_controller.total_requests', 1)
    end

    def write_fragment
      interaction.aggregate_metric('action_controller.write_fragment', 1)
    end

    def read_fragment
      interaction.aggregate_metric('action_controller.read_fragment', 1)
    end

    def expire_fragment
      interaction.aggregate_metric('action_controller.expire_fragment', 1)
    end

    def write_page
      interaction.aggregate_metric('action_controller.write_page', 1)
    end

    def expire_page
      interaction.aggregate_metric('action_controller.expire_page', 1)
    end

    def send_file
      interaction.aggregate_metric('action_controller.sent_file', 1)
    end

    def redirect_to
      interaction.aggregate_metric('action_controller.redirect', 1)
    end

    def halted_callback
      interaction.aggregate_metric('action_controller.halted_callback', 1)
    end
  end
end
