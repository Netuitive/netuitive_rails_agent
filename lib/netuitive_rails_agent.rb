require 'logger'
require 'active_support'
require 'action_controller'
require 'action_mailer'
require 'active_support/concern'
require 'netuitive_ruby_api'
require 'netuitive_rails_agent/config_manager'
require 'netuitive_rails_agent/netuitive_logger'

# load config and logger
NetuitiveRailsAgent::ConfigManager.load_config
NetuitiveRailsAgent::NetuitiveLogger.setup
NetuitiveRailsAgent::ConfigManager.read_config

require 'netuitive_rails_agent/api_interaction'
require 'netuitive_rails_agent/controller_utils'
require 'netuitive_rails_agent/error_utils'
require 'netuitive_rails_agent/error_tracker'
require 'netuitive_rails_agent/request_data'
require 'netuitive_rails_agent/action_controller'
require 'netuitive_rails_agent/active_record'
require 'netuitive_rails_agent/action_view'
require 'netuitive_rails_agent/action_mailer'
require 'netuitive_rails_agent/active_support'
require 'netuitive_rails_agent/active_job'
require 'netuitive_rails_agent/sidekiq'
require 'netuitive_rails_agent/gc'
require 'netuitive_rails_agent/objectspace'
require 'netuitive_rails_agent/scheduler'

# subscribe to notifications
interaction = NetuitiveRailsAgent::ApiInteraction.new
NetuitiveRailsAgent::ActionControllerSub.new(interaction).subscribe if NetuitiveRailsAgent::ConfigManager.action_controller_enabled
NetuitiveRailsAgent::ActiveRecordSub.new(interaction).subscribe if NetuitiveRailsAgent::ConfigManager.active_record_enabled
NetuitiveRailsAgent::ActionViewSub.new(interaction).subscribe if NetuitiveRailsAgent::ConfigManager.action_view_enabled
NetuitiveRailsAgent::ActionMailerSub.new(interaction).subscribe if NetuitiveRailsAgent::ConfigManager.action_mailer_enabled
NetuitiveRailsAgent::ActiveSupportSub.new(interaction).subscribe if NetuitiveRailsAgent::ConfigManager.active_support_enabled
NetuitiveRailsAgent::ActiveJobSub.new(interaction).subscribe if NetuitiveRailsAgent::ConfigManager.active_job_enabled

# start metrics that are collected on a schedule
NetuitiveRailsAgent::Scheduler.new(interaction).start_schedule if NetuitiveRailsAgent::ConfigManager.gc_enabled || NetuitiveRailsAgent::ConfigManager.object_space_enabled

# sidekiq
NetuitiveRailsAgent::SidekiqTracker.new.setup if NetuitiveRailsAgent::ConfigManager.sidekiq_enabled

NetuitiveRailsAgent::NetuitiveLogger.log.info 'Netuitive rails agent installed'
