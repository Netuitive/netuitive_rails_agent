module NetuitiveRailsAgent
  module RequestDataHook
    include NetuitiveRailsAgent::ControllerUtils

    HEADERS_NAMES = [
      'HTTP_X_REQUEST_START'.freeze,
      'HTTP_X_QUEUE_START'.freeze,
      'HTTP_X_MIDDLEWARE_START'.freeze
    ].freeze

    def self.header_start_time(headers)
      if headers
        start_time = nil
        HEADERS_NAMES.each do |header_name|
          header = headers[header_name]
          next if header.nil?
          match = /\d+(\.\d{1,2})?/.match(header)
          if match.nil?
            NetuitiveRailsAgent::NetuitiveLogger.log.error "queue time header value #{header} is not recognized"
            next
          end
          header_time = match.to_s.to_f / NetuitiveRailsAgent::ConfigManager.queue_time_divisor
          NetuitiveRailsAgent::NetuitiveLogger.log.debug "queue header_time: #{header_time}"
          start_time = start_time.nil? || header_time < start_time ? header_time : start_time
          NetuitiveRailsAgent::NetuitiveLogger.log.debug "queue start_time: #{start_time}"
        end
        return (Time.now.to_f - start_time) * 1000.0
      end
      nil
    end

    def netuitive_request_hook
      return unless request
      begin
        queue_time = NetuitiveRailsAgent::RequestDataHook.header_start_time(request.headers)
        NetuitiveRailsAgent::NetuitiveLogger.log.debug "queue_time: #{queue_time}"
        NetuitiveRailsAgent::NetuitiveLogger.log.debug 'sending queue_time metrics'
        NetuitiveRailsAgent::NetuitiveRubyAPI.add_sample('action_controller.request.queue_time', queue_time)
        return unless netuitive_controller_name
        NetuitiveRailsAgent::NetuitiveLogger.log.debug "sending queue_time metrics with netuitive_controller_name #{netuitive_controller_name}"
        NetuitiveRailsAgent::NetuitiveRubyAPI.add_sample("action_controller.#{netuitive_controller_name}.request.queue_time", queue_time)
        return unless netuitive_action_name
        NetuitiveRailsAgent::NetuitiveLogger.log.debug "sending queue_time metrics with netuitive_action_name #{netuitive_action_name}"
        NetuitiveRailsAgent::NetuitiveRubyAPI.add_sample("action_controller.#{netuitive_controller_name}.#{netuitive_action_name}.request.queue_time", queue_time)
      rescue => e
        NetuitiveRailsAgent::NetuitiveLogger.log.error "exception during request tracking: message:#{e.message} backtrace:#{e.backtrace}"
      end
    end
  end
end
