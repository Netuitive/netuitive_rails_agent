class ConfigManager

	def initialize()
		@error=0
		@info=1
		@debug=2
		readConfig()
	end

	def isDebug?
		if @debugLevel >= @debug
			return true
		end
		return false
	end

	def isInfo?
		if @debugLevel >= @info
			return true
		end
		return false
	end

	def isError?
		if @debugLevel >= @error
			return true
		end
		return false
	end

	def readConfig()
		gem_root= File.expand_path("../../..", __FILE__)
		data=YAML.load_file "#{gem_root}/config/agent.yml"
		debugLevelString=data["debugLevel"]
		if debugLevelString == "error"
			@debugLevel=@error
		elsif debugLevelString == "info"
			@debugLevel=@info
		elsif debugLevelString == "debug"
			@debugLevel=@debug
		else
			@debugLevel=@error
		end

		if isDebug?
			puts "read config file. Results: 
			debugLevel: #{debugLevelString}"
		end
	end

end  
