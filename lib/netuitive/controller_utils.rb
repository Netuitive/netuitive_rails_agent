module ControllerUtils
  def actionName
    if defined? @controller #rails 2
      return @controller.action_name
    elsif defined? controller #rails 3.1.X
      return controller.action_name
    else
      return action_name #rails 4.X
    end
  end

  def controllerName
    return self.class.name
  end

  def requestUri
    if defined? request.request_uri #rails 2
      return request.request_uri
    elsif defined? request.fullpath #rails 3
      return request.fullpath
    else
      return request.original_fullpath #rails >3.2
    end
  end
end