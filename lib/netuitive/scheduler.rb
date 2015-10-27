require 'netuitive/rails_config_manager'
class Scheduler

	def initialize
		@configManager=ConfigManager.new
	end

	def startSchedule
		Thread.new do
  			while true do
  				sleep(@configManager.interval)
    			NetuitiveRubyAPI::aggregator.sendMetrics
  			end
		end
	end
end 
