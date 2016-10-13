module NetuitiveActiveSupportSub
  def self.subscribe
    ActiveSupport::Notifications.subscribe(/cache_read.active_support/) do |*_args|
      begin
        NetuitiveRubyAPI.netuitivedServer.aggregateMetric('active_support.cache_read', 1)
      rescue
        NetuitiveLogger.log.error 'failure to communicate to netuitived'
      end
    end
    ActiveSupport::Notifications.subscribe(/cache_generate.active_support/) do |*_args|
      begin
        NetuitiveRubyAPI.netuitivedServer.aggregateMetric('active_support.cache_generate', 1)
      rescue
        NetuitiveLogger.log.error 'failure to communicate to netuitived'
      end
    end
    ActiveSupport::Notifications.subscribe(/cache_fetch_hit.active_support/) do |*_args|
      begin
        NetuitiveRubyAPI.netuitivedServer.aggregateMetric('active_support.cache_fetch_hit', 1)
      rescue
        NetuitiveLogger.log.error 'failure to communicate to netuitived'
      end
    end
    ActiveSupport::Notifications.subscribe(/cache_write.active_support/) do |*_args|
      begin
        NetuitiveRubyAPI.netuitivedServer.aggregateMetric('active_support.cache_write', 1)
      rescue
        NetuitiveLogger.log.error 'failure to communicate to netuitived'
      end
    end
    ActiveSupport::Notifications.subscribe(/cache_delete.active_support/) do |*_args|
      begin
        NetuitiveRubyAPI.netuitivedServer.aggregateMetric('active_support.cache_delete', 1)
      rescue
        NetuitiveLogger.log.error 'failure to communicate to netuitived'
      end
    end
  end
end
