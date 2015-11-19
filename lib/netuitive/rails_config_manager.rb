require 'netuitive/netuitive_rails_logger'
class ConfigManager

	class << self
		def setup()
			readConfig()
		end

		def readConfig()
			gem_root= File.expand_path("../../..", __FILE__)
			data=YAML.load_file "#{gem_root}/config/agent.yml"
			debugLevelString=ENV["NETUITIVE_RAILS_DEBUG_LEVEL"]
			if(debugLevelString == nil or debugLevelString == "")
				debugLevelString=data["debugLevel"]
			end
			if debugLevelString == "error"
				NetuitiveLogger.log.level = Logger::ERROR
			elsif debugLevelString == "info"
				NetuitiveLogger.log.level = Logger::INFO
			elsif debugLevelString == "debug"
				NetuitiveLogger.log.level = Logger::DEBUG
			else
				NetuitiveLogger.log.level = Logger::ERROR
			end
			NetuitiveLogger.log.debug "read config file. Results: 
				debugLevel: #{debugLevelString}"
		end
	end
end 
