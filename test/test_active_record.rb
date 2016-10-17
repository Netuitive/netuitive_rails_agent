class ActiveRecordTest < Test::Unit::TestCase
  def setup
    @interaction = mock
    @sub = NetuitiveActiveRecordSub.new(@interaction)
  end

  def test_instantiation
    @interaction.expects(:aggregate_metric).with('active_record.instantiation', 1)
    @sub.instantiation
  end

  def test_sql
    @interaction.expects(:aggregate_metric).with('active_record.sql.statement', 1)
    @sub.sql
  end
end
