module NetuitiveRailsAgent
  class RequestDataTest < Test::Unit::TestCase
    def setup
      NetuitiveRailsAgent::ConfigManager.load_config
      NetuitiveRailsAgent::ConfigManager.queue_time_divisor = 1.0
    end

    def test_header_start_time
      headers = { 'HTTP_X_REQUEST_START' => Time.now.to_f.to_s }
      time = NetuitiveRailsAgent::RequestDataHook.header_start_time(headers)
      assert(time < 3000 && time > 0)
      headers = { 'HTTP_X_REQUEST_START' => 't=' + Time.now.to_f.to_s }
      time = NetuitiveRailsAgent::RequestDataHook.header_start_time(headers)
      assert(time < 3000 && time > 0)
    end
  end
end
