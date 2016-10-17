class ErrorUtilsTest < Test::Unit::TestCase
  def setup
    self.class.send(:include, ErrorUtils)
    @interaction = mock
  end

  def test_ignored_error
    # ignored error
    RailsConfigManager.ignored_errors = ['StandardError']
    assert(ignored_error?(StandardError.new))

    # not ignored
    RailsConfigManager.ignored_errors = ['RuntimeError']
    assert(!ignored_error?(ArgumentError.new))

    # ignored ancestry
    RailsConfigManager.ignored_errors = ['StandardError^']
    assert(ignored_error?(ArgumentError.new))

    # not ignored ancestry
    RailsConfigManager.ignored_errors = ['RuntimeError^']
    assert(!ignored_error?(ArgumentError.new))

    # subclass doesn't ignore ancestor
    RailsConfigManager.ignored_errors = ['ArgumentError^']
    assert(!ignored_error?(StandardError.new))
  end

  def test_handle_error
    # not ignored
    RailsConfigManager.ignored_errors = []
    RailsConfigManager.capture_errors = true
    metrics = ['test.id.1', 'test.id.2']
    tags = { name: 'value' }
    error = RuntimeError.new
    @interaction.expects(:aggregate_metric).with('test.id.1', 1)
    @interaction.expects(:aggregate_metric).with('test.id.2', 1)
    @interaction.expects(:exception_event).with(error, error.class, tags)
    handle_error(error, metrics, tags)

    # ignored event
    RailsConfigManager.ignored_errors = []
    RailsConfigManager.capture_errors = false
    metrics = ['test.id.1', 'test.id.2']
    tags = { name: 'value' }
    error = RuntimeError.new
    @interaction.expects(:aggregate_metric).with('test.id.1', 1)
    @interaction.expects(:aggregate_metric).with('test.id.2', 1)
    handle_error(error, metrics, tags)

    # ignored error
    RailsConfigManager.ignored_errors = ['RuntimeError']
    RailsConfigManager.capture_errors = false
    metrics = ['test.id.1', 'test.id.2']
    tags = { name: 'value' }
    error = RuntimeError.new
    handle_error(error, metrics, tags)
  end
end
