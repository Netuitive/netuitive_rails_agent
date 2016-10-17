class ActionViewTest < Test::Unit::TestCase
  def setup
    @interaction = mock
    @sub = NetuitiveActionViewSub.new(@interaction)
  end

  def test_render_template
    @interaction.expects(:aggregate_metric).with('action_view.render_template', 1)
    @sub.render_template
  end

  def test_render_partial
    @interaction.expects(:aggregate_metric).with('action_view.render_partial', 1)
    @sub.render_partial
  end
end
