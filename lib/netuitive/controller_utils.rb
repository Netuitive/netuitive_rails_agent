module ControllerUtils
  def netuitive_action_name
    return controller.action_name if defined? controller # rails 3.1.X
    action_name # rails 4.X
  end

  def netuitive_controller_name
    self.class.name
  end

  def netuitive_request_uri
    return request.fullpath if defined? request.fullpath # rails 3
    request.original_fullpath # rails >3.2
  end
end
