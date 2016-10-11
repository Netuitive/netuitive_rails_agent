require 'netuitive/netuitive_rails_logger'
class ConfigManager

	class << self
		def setup()
			readConfig()
		end

		def captureErrors
			@@captureErrors
		end

		def ignoredErrors
			@@ignoredErrors
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

			exceptionString=ENV["NETUITIVE_RAILS_SEND_ERROR_EVENTS"] == nil ? nil : ENV["NETUITIVE_RAILS_SEND_ERROR_EVENTS"].dup
			if(exceptionString == nil or exceptionString == "")
				@@captureErrors = data["sendErrorEvents"]
			else
				exceptionString.strip!
				@@captureErrors = exceptionString.casecmp("true") == 0
			end

			@@ignoredErrors = Array.new
			ignoredExceptionString=ENV["NETUITIVE_RAILS_IGNORED_ERRORS"] == nil ? nil : ENV["NETUITIVE_RAILS_IGNORED_ERRORS"].dup
			if(ignoredExceptionString == nil or ignoredExceptionString == "")
				if data["ignoredErrors"] != nil && data["ignoredErrors"].kind_of?(Array)
					@@ignoredErrors = data["ignoredErrors"]
				end
			else
				@@ignoredErrors = ignoredExceptionString.split(",")
			end
			if !@@ignoredErrors.empty?
				@@ignoredErrors.each { |x| x.strip! }
			end

			NetuitiveLogger.log.debug "read config file. Results: 
				debugLevel: #{debugLevelString}
				captureErrors: #{@@captureErrors},
				ignoredErrors: #{ignoredErrors}"
		end
	end
end 
