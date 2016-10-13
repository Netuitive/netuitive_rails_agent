module NetuitiveActiveRecordSub
  def self.subscribe
    ActiveSupport::Notifications.subscribe(/instantiation.active_record/) do |*_args|
      NetuitiveRubyAPI.aggregate_metric('active_record.instantiation', 1)
    end

    ActiveSupport::Notifications.subscribe(/sql.active_record/) do |*_args|
      NetuitiveRubyAPI.aggregate_metric('active_record.sql.statement', 1)
    end
  end
end
