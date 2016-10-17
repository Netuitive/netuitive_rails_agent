class ActionMailerTest < Test::Unit::TestCase
  def setup
    @interaction = mock
    @sub = NetuitiveActionMailer.new(@interaction)
  end

  def test_receive
    @interaction.expects(:aggregate_metric).with('action_mailer.test_mailer.receive', 1)
    @sub.receive(nil, nil, nil, nil, mailer: 'test_mailer')
  end

  def test_deliver
    @interaction.expects(:aggregate_metric).with('action_mailer.test_mailer.deliver', 1)
    @sub.deliver(nil, nil, nil, nil, mailer: 'test_mailer')
  end
end
