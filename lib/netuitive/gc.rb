class GCStatsCollector

	def self.collect()
		if GC::Profiler.enabled?
			begin
				GC.stat.each do |key, value|
					if key == "total_allocated_object" or key == "total_freed_object" or key == "count"
						NetuitiveRubyAPI::netuitivedServer.addCounterSample("GC.stat.#{key}", value)
					else
						NetuitiveRubyAPI::netuitivedServer.aggregateMetric("GC.stat.#{key}", value)
					end
				end
				NetuitiveRubyAPI::netuitivedServer.addCounterSample("GC.profiler.total_time", GC::Profiler.total_time)
			rescue
				NetuitiveLogger.log.error "failure to communicate to netuitived"
			end
		end
	end
end