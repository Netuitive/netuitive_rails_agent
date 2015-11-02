module NetuitiveActiveRecordSub
	def self.subscribe
		ActiveSupport::Notifications.subscribe /instantiation.active_record/ do |*args| 
			begin
				NetuitiveRubyAPI::netuitivedServer.aggregateMetric("active_record.instantiation", 1)
			rescue
				if ConfigManager.isError?
					puts "failure to communicate to netuitived"
				end
			end
		end
		
		ActiveSupport::Notifications.subscribe /sql.active_record/ do |*args| 
			begin
				NetuitiveRubyAPI::netuitivedServer.aggregateMetric("active_record.sql.statement", 1)
			rescue
				if ConfigManager.isError?
					puts "failure to communicate to netuitived"
				end
			end
		end
	end
end
