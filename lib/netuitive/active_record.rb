module NetuitiveActiveRecordSub
  def self.subscribe
    ActiveSupport::Notifications.subscribe(/instantiation.active_record/) do |*_args|
      begin
        NetuitiveRubyAPI.netuitivedServer.aggregateMetric('active_record.instantiation', 1)
      rescue
        NetuitiveLogger.log.error 'failure to communicate to netuitived'
      end
    end

    ActiveSupport::Notifications.subscribe(/sql.active_record/) do |*_args|
      begin
        NetuitiveRubyAPI.netuitivedServer.aggregateMetric('active_record.sql.statement', 1)
      rescue
        NetuitiveLogger.log.error 'failure to communicate to netuitived'
      end
    end
  end
end
