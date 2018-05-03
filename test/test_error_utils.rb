module NetuitiveRailsAgent
  class ErrorUtilsTest < Test::Unit::TestCase
    def setup
      NetuitiveRailsAgent::ConfigManager.load_config
      self.class.send(:include, NetuitiveRailsAgent::ErrorUtils)
      @interaction = mock
    end

    def test_ignored_error
      # ignored error
      NetuitiveRailsAgent::ConfigManager.ignored_errors = ['StandardError']
      assert(ignored_error?(StandardError.new))

      # not ignored
      NetuitiveRailsAgent::ConfigManager.ignored_errors = ['RuntimeError']
      assert(!ignored_error?(ArgumentError.new))

      # ignored ancestry
      NetuitiveRailsAgent::ConfigManager.ignored_errors = ['StandardError^']
      assert(ignored_error?(ArgumentError.new))

      # not ignored ancestry
      NetuitiveRailsAgent::ConfigManager.ignored_errors = ['RuntimeError^']
      assert(!ignored_error?(ArgumentError.new))

      # subclass doesn't ignore ancestor
      NetuitiveRailsAgent::ConfigManager.ignored_errors = ['ArgumentError^']
      assert(!ignored_error?(StandardError.new))
    end

    def test_handle_error
      # not ignored
      NetuitiveRailsAgent::ConfigManager.ignored_errors = []
      NetuitiveRailsAgent::ConfigManager.capture_errors = true
      metrics = ['test.id.1', 'test.id.2']
      tags = { name: 'value' }
      error = RuntimeError.new
      @interaction.expects(:aggregate_metric).with('test.id.1', 1)
      @interaction.expects(:aggregate_metric).with('test.id.2', 1)
      @interaction.expects(:exception_event).with(error, error.class, tags)
      handle_error(error, metrics, tags)

      # ignored event
      NetuitiveRailsAgent::ConfigManager.ignored_errors = []
      NetuitiveRailsAgent::ConfigManager.capture_errors = false
      metrics = ['test.id.1', 'test.id.2']
      tags = { name: 'value' }
      error = RuntimeError.new
      @interaction.expects(:aggregate_metric).with('test.id.1', 1)
      @interaction.expects(:aggregate_metric).with('test.id.2', 1)
      handle_error(error, metrics, tags)

      # ignored error
      NetuitiveRailsAgent::ConfigManager.ignored_errors = ['RuntimeError']
      NetuitiveRailsAgent::ConfigManager.capture_errors = false
      metrics = ['test.id.1', 'test.id.2']
      tags = { name: 'value' }
      error = RuntimeError.new
      handle_error(error, metrics, tags)
    end
  end
end
