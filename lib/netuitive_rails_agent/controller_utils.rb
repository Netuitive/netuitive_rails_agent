module NetuitiveRailsAgent
  module ControllerUtils
    def netuitive_action_name
      NetuitiveRailsAgent::ErrorLogger.guard('error during netuitive_action_name') do
        return controller.action_name if defined? controller # rails 3.1.X
        action_name # rails 4.X
      end
    end

    def netuitive_controller_name
      self.class.name
    end

    def netuitive_request_uri
      NetuitiveRailsAgent::ErrorLogger.guard('error during netuitive_request_uri') do
        return request.fullpath if defined? request.fullpath # rails 3
        request.original_fullpath # rails >3.2
      end
    end
  end
end
