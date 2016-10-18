module NetuitiveRailsAgent
  class TestWorker
  end

  class SidekiqTest < Test::Unit::TestCase
    def setup
      @interaction = mock
      @chain_tracker = NetuitiveRailsAgent::SidekiqTracker::ChainTracker.new
      @chain_tracker.interaction = @interaction
      @error_tracker = NetuitiveRailsAgent::SidekiqTracker::ErrorTracker.new
      @error_tracker.interaction = @interaction
    end

    def test_chain
      # wrapped
      @interaction.expects(:aggregate_metric).with('sidekiq.WrappedWorker.job.count', 1)
      @interaction.expects(:aggregate_metric).with('sidekiq.test_queue.job.count', 1)
      @interaction.expects(:aggregate_metric).with('sidekiq.test_queue.WrappedWorker.job.count', 1)
      @chain_tracker.call(NetuitiveRailsAgent::TestWorker.new, { 'wrapped' => 'WrappedWorker', 'queue' => 'test_queue' }, nil) {}
      # not wrapped
      @interaction.expects(:aggregate_metric).with('sidekiq.NetuitiveRailsAgent::TestWorker.job.count', 1)
      @interaction.expects(:aggregate_metric).with('sidekiq.test_queue.job.count', 1)
      @interaction.expects(:aggregate_metric).with('sidekiq.test_queue.NetuitiveRailsAgent::TestWorker.job.count', 1)
      @chain_tracker.call(NetuitiveRailsAgent::TestWorker.new, { 'queue' => 'test_queue' }, nil) {}
    end

    def test_error
      NetuitiveRailsAgent::ConfigManager.ignored_errors = []
      NetuitiveRailsAgent::ConfigManager.capture_errors = true
      context = { context: 'Exception during Sidekiq lifecycle event.' }
      tags = {
        sidekiq: 'true',
        context: 'Exception during Sidekiq lifecycle event.'
      }
      error = RuntimeError.new
      @interaction.expects(:aggregate_metric).with('sidekiq.errors', 1)
      @interaction.expects(:exception_event).with(error, error.class, tags)
      @error_tracker.call(error, context)
    end
  end
end
