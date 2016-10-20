module NetuitiveRailsAgent
  module RequestDataHook
    include NetuitiveRailsAgent::ControllerUtils

    HEADERS_NAMES = [
      'HTTP_X_REQUEST_START'.freeze,
      'HTTP_X_QUEUE_START'.freeze,
      'HTTP_X_MIDDLEWARE_START'.freeze
    ].freeze

    def self.header_start_time(headers)
      NetuitiveRailsAgent::ErrorLogger.guard('error during header_start_time') do
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
          return nil if start_time.nil?
          return (Time.now.to_f - start_time) * 1000.0
        end
      end
      nil
    end

    def netuitive_request_hook
      return unless request
      NetuitiveRailsAgent::ErrorLogger.guard('error during netuitive_request_hook') do
        queue_time = NetuitiveRailsAgent::RequestDataHook.header_start_time(request.headers)
        if queue_time.nil?
          NetuitiveRailsAgent::NetuitiveLogger.log.info 'no queue time header found for request'
          return
        end
        NetuitiveRailsAgent::NetuitiveLogger.log.debug "queue_time: #{queue_time}"
        NetuitiveRailsAgent::NetuitiveLogger.log.debug 'sending queue_time metrics'
        NetuitiveRubyAPI.add_sample('action_controller.request.queue_time', queue_time)
        return unless netuitive_controller_name
        NetuitiveRailsAgent::NetuitiveLogger.log.debug "sending queue_time metrics with netuitive_controller_name #{netuitive_controller_name}"
        NetuitiveRubyAPI.add_sample("action_controller.#{netuitive_controller_name}.request.queue_time", queue_time)
        return unless netuitive_action_name
        NetuitiveRailsAgent::NetuitiveLogger.log.debug "sending queue_time metrics with netuitive_action_name #{netuitive_action_name}"
        NetuitiveRubyAPI.add_sample("action_controller.#{netuitive_controller_name}.#{netuitive_action_name}.request.queue_time", queue_time)
      end
    end
  end
end
