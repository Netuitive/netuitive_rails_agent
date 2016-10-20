module NetuitiveRailsAgent
  class ObjectSpaceStatsCollector
    attr_reader :interaction
    def initialize(interaction)
      @interaction = interaction
    end

    def collect
      NetuitiveRailsAgent::NetuitiveLogger.log.debug 'collecting object space metrics'
      NetuitiveRailsAgent::ErrorLogger.guard('error during collecting object space metrics') do
        ObjectSpace.count_objects.each do |key, value|
          NetuitiveRailsAgent::NetuitiveLogger.log.debug "ObjectSpace.count_objects.#{key}"
          interaction.aggregate_metric("ObjectSpace.count_objects.#{key}", value)
        end
      end
      NetuitiveRailsAgent::NetuitiveLogger.log.debug 'finished collecting object space metrics'
    end
  end
end
