class ObjectSpaceStatsCollector
  def self.collect
    NetuitiveLogger.log.debug 'collecting object space metrics'
    ObjectSpace.count_objects.each do |key, value|
      NetuitiveLogger.log.debug "ObjectSpace.count_objects.#{key}"
      NetuitiveRubyAPI.aggregate_metric("ObjectSpace.count_objects.#{key}", value)
    end
  rescue => e
    NetuitiveLogger.log.error "exception during object space collection: message:#{e.message} backtrace:#{e.backtrace}"
  end
end
