class GCStatsCollector

	def self.collect()
		if GC::Profiler.enabled?
			begin
				GC.stat.each do |key, value|
					NetuitiveRubyAPI::netuitivedServer.aggregateMetric("GC.stat.#{key}", value)
				end
				NetuitiveRubyAPI::netuitivedServer.aggregateMetric("GC.profiler.total_time", GC::Profiler.total_time)
			rescue
				NetuitiveLogger.log.error "failure to communicate to netuitived"
			end
		end
	end
end