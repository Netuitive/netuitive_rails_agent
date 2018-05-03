module NetuitiveRailsAgent
  class NetuitiveLoggerTest < Test::Unit::TestCase
    def self.prepare
      NetuitiveRailsAgent::ConfigManager.load_config
    end

    def test_format_age
      age = NetuitiveRailsAgent::NetuitiveLogger.format_age('weekly')
      assert_equal(age, 'weekly')
      age = NetuitiveRailsAgent::NetuitiveLogger.format_age(nil)
      assert_equal(age, 'daily')
      age = NetuitiveRailsAgent::NetuitiveLogger.format_age(10)
      assert_equal(age, 10)
      age = NetuitiveRailsAgent::NetuitiveLogger.format_age('10')
      assert_equal(age, 10)
    end

    def test_format_size
      size = NetuitiveRailsAgent::NetuitiveLogger.format_size('weekly')
      assert_equal(size, 'weekly')
      size = NetuitiveRailsAgent::NetuitiveLogger.format_size(nil)
      assert_equal(size, 1_000_000)
      size = NetuitiveRailsAgent::NetuitiveLogger.format_size(10)
      assert_equal(size, 10)
      size = NetuitiveRailsAgent::NetuitiveLogger.format_size('10')
      assert_equal(size, 10)
    end
  end
end
