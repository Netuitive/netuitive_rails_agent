class ObjectSpaceTest < Test::Unit::TestCase
  def setup
    @interaction = ApiInteraction.new
    @os = ObjectSpaceStatsCollector.new(@interaction)
  end

  def test_collect
    @interaction.expects(:aggregate_metric).at_least_once
    @os.collect
  end
end
