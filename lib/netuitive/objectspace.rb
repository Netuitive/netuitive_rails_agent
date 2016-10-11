class ObjectSpaceStatsCollector

	def self.collect()
		begin
			ObjectSpace.count_objects.each do |key, value|
				NetuitiveLogger.log.debug "ObjectSpace.count_objects.#{key}"
				NetuitiveRubyAPI::netuitivedServer.aggregateMetric("ObjectSpace.count_objects.#{key}", value)
			end
		rescue 
			NetuitiveLogger.log.error "failure to communicate to netuitived"
		end
	end
end