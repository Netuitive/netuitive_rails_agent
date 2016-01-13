class GCStatsCollector

	def self.collect()
		if GC::Profiler.enabled?
			begin
				GC.stat.each do |key, value|
					NetuitiveLogger.log.debug "GC stat key: #{key}"
					if key.to_s == "total_allocated_object" or key.to_s == "total_freed_object" or key.to_s == "count"
						NetuitiveLogger.log.debug "sending aggregateCounterMetric GC.stat.#{key}"
						NetuitiveRubyAPI::netuitivedServer.aggregateCounterMetric("GC.stat.#{key}", value)
					else
						NetuitiveLogger.log.debug "sending aggregateMetric GC.stat.#{key}"
						NetuitiveRubyAPI::netuitivedServer.aggregateMetric("GC.stat.#{key}", value)
					end
				end
				NetuitiveLogger.log.debug "sending aggregateCounterMetric GC.profiler.total_time"
				NetuitiveRubyAPI::netuitivedServer.aggregateCounterMetric("GC.profiler.total_time", GC::Profiler.total_time)
			rescue
				NetuitiveLogger.log.error "failure to communicate to netuitived"
			end
		end
	end
end