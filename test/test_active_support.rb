module NetuitiveRailsAgent
  class ActiveSupportTest < Test::Unit::TestCase
    def setup
      @interaction = mock
      @sub = NetuitiveRailsAgent::ActiveSupportSub.new(@interaction)
    end

    def test_cache_read
      @interaction.expects(:aggregate_metric).with('active_support.cache_read', 1)
      @sub.cache_read
    end

    def test_cache_generate
      @interaction.expects(:aggregate_metric).with('active_support.cache_generate', 1)
      @sub.cache_generate
    end

    def test_cache_fetch_hit
      @interaction.expects(:aggregate_metric).with('active_support.cache_fetch_hit', 1)
      @sub.cache_fetch_hit
    end

    def test_cache_write
      @interaction.expects(:aggregate_metric).with('active_support.cache_write', 1)
      @sub.cache_write
    end

    def test_cache_delete
      @interaction.expects(:aggregate_metric).with('active_support.cache_delete', 1)
      @sub.cache_delete
    end
  end
end
