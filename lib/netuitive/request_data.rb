require 'netuitive/rails_config_manager'

module RequestDataHook

  include ControllerUtils

  HEADERS_NAMES = [
    'HTTP_X_REQUEST_START'.freeze,
    'HTTP_X_QUEUE_START'.freeze,
    'HTTP_X_MIDDLEWARE_START'.freeze
  ].freeze

  def self.headerStartTime(headers)
    if headers
      startTime = nil
      HEADERS_NAMES.each do |headerName|
        header = headers[headerName]
        if header != nil
          headerTime = header.to_f/ConfigManager.queueTimeDivisor
          NetuitiveLogger.log.debug "queue headerTime: #{headerTime}"
          startTime = (startTime == nil || headerTime < startTime) ? headerTime : startTime
          NetuitiveLogger.log.debug "queue startTime: #{startTime}"
        end
      end
      return (Time.now.to_i - startTime) * 1000.0
    end
    return nil
  end

  def netuitiveRequestHook
    if request
      queueTime = RequestDataHook::headerStartTime(request.headers)
      NetuitiveLogger.log.debug "queue_time: #{queueTime}"
      NetuitiveLogger.log.debug "sending queue_time metrics"
      NetuitiveRubyAPI::netuitivedServer.addSample("action_controller.request.queue_time", queueTime)
      if controllerName
        NetuitiveLogger.log.debug "sending queue_time metrics with controllerName #{controllerName}"
        NetuitiveRubyAPI::netuitivedServer.addSample("action_controller.#{controllerName}.request.queue_time", queueTime)
        if actionName
          NetuitiveLogger.log.debug "sending queue_time metrics with actionName #{actionName}"
          NetuitiveRubyAPI::netuitivedServer.addSample("action_controller.#{controllerName}.#{actionName}.request.queue_time", queueTime)
        end
      end
    end
  end
end
