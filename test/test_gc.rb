require 'netuitive/gc'

class GCTest < Test::Unit::TestCase
  def setup
    GC::Profiler.enable
    @interaction = ApiInteraction.new
    @gc = GCStatsCollector.new(@interaction)
  end

  def test_collect
    @interaction.expects(:aggregate_metric).at_least_once
    @interaction.expects(:aggregate_counter_metric).at_least_once
    @gc.collect
  end
end
