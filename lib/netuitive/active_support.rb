module NetuitiveActiveSupportSub
  def self.subscribe
    ActiveSupport::Notifications.subscribe(/cache_read.active_support/) do |*_args|
      NetuitiveRubyAPI.aggregate_metric('active_support.cache_read', 1)
    end
    ActiveSupport::Notifications.subscribe(/cache_generate.active_support/) do |*_args|
      NetuitiveRubyAPI.aggregate_metric('active_support.cache_generate', 1)
    end
    ActiveSupport::Notifications.subscribe(/cache_fetch_hit.active_support/) do |*_args|
      NetuitiveRubyAPI.aggregate_metric('active_support.cache_fetch_hit', 1)
    end
    ActiveSupport::Notifications.subscribe(/cache_write.active_support/) do |*_args|
      NetuitiveRubyAPI.aggregate_metric('active_support.cache_write', 1)
    end
    ActiveSupport::Notifications.subscribe(/cache_delete.active_support/) do |*_args|
      NetuitiveRubyAPI.aggregate_metric('active_support.cache_delete', 1)
    end
  end
end
