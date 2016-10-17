class ObjectSpaceStatsCollector
  attr_reader :interaction
  def initialize(interaction)
    @interaction = interaction
  end

  def collect
    RailsNetuitiveLogger.log.debug 'collecting object space metrics'
    ObjectSpace.count_objects.each do |key, value|
      RailsNetuitiveLogger.log.debug "ObjectSpace.count_objects.#{key}"
      interaction.aggregate_metric("ObjectSpace.count_objects.#{key}", value)
    end
  rescue => e
    RailsNetuitiveLogger.log.error "exception during object space collection: message:#{e.message} backtrace:#{e.backtrace}"
  end
end
