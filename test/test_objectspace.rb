module NetuitiveRailsAgent
  class ObjectSpaceTest < Test::Unit::TestCase
    def setup
      @interaction = NetuitiveRailsAgent::ApiInteraction.new
      @os = NetuitiveRailsAgent::ObjectSpaceStatsCollector.new(@interaction)
    end

    def test_collect
      @interaction.expects(:aggregate_metric).at_least_once
      @os.collect
    end
  end
end
