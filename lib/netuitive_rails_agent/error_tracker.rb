module NetuitiveRailsAgent
  module ErrorTrackerHook
    extend ActiveSupport::Concern

    include NetuitiveRailsAgent::ControllerUtils

    include NetuitiveRailsAgent::ErrorUtils

    included do
      NetuitiveRailsAgent::NetuitiveLogger.log.debug 'ErrorTracker included'
      rescue_from Exception do |exception|
        begin
          tags = {
            URI: netuitive_request_uri,
            Controller: netuitive_controller_name,
            Action: netuitive_action_name
          }
          metrics = ['action_controller.errors']
          if netuitive_controller_name
            metrics << "action_controller.#{netuitive_controller_name}.errors"
            if netuitive_action_name
              metrics << "action_controller.#{netuitive_controller_name}.#{netuitive_action_name}.errors"
            end
          end
          handle_error(exception, metrics, tags)
        rescue => e
          NetuitiveRailsAgent::NetuitiveLogger.log.error "exception during controller error tracking: message:#{e.message} backtrace:#{e.backtrace}"
        end
        raise exception
      end
    end
  end
end
