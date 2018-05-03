module NetuitiveRailsAgent
  class GCTest < Test::Unit::TestCase
    def setup
      NetuitiveRailsAgent::ConfigManager.load_config
      GC::Profiler.enable
      @interaction = NetuitiveRailsAgent::ApiInteraction.new
      @gc = NetuitiveRailsAgent::GCStatsCollector.new(@interaction)
    end

    def test_collect
      @interaction.expects(:aggregate_metric).at_least_once
      @interaction.expects(:aggregate_counter_metric).at_least_once
      @gc.collect
    end
  end
end
