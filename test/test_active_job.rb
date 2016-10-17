class ActiveJobTest < Test::Unit::TestCase
  def setup
    @interaction = mock
    @sub = NetuitiveActiveJobSub.new(@interaction)
  end

  def test_enqueue
    @interaction.expects(:aggregate_metric).with('active_job.enqueue', 1)
    @sub.enqueue
  end

  def test_perform
    @interaction.expects(:aggregate_metric).with('active_job.perform', 1)
    @sub.perform
  end
end
