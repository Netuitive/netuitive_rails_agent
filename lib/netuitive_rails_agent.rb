require 'netuitive/rails_config_manager'
require 'netuitive/netuitive_rails_logger'

# load config and logger
RailsConfigManager.load_config
RailsNetuitiveLogger.setup
RailsConfigManager.read_config

require 'active_support'
require 'action_controller'
require 'action_mailer'
require 'active_support/concern'
require 'netuitive_ruby_api'
require 'netuitive/api_interaction'
require 'netuitive/controller_utils'
require 'netuitive/error_utils'
require 'netuitive/error_tracker'
require 'netuitive/request_data'
require 'netuitive/action_controller'
require 'netuitive/active_record'
require 'netuitive/action_view'
require 'netuitive/action_mailer'
require 'netuitive/active_support'
require 'netuitive/active_job'
require 'netuitive/sidekiq'
require 'netuitive/gc'
require 'netuitive/objectspace'
require 'netuitive/scheduler'

# subscribe to notifications
interaction = ApiInteraction.new
NetuitiveActionControllerSub.new(interaction).subscribe if RailsConfigManager.action_controller_enabled
NetuitiveActiveRecordSub.new(interaction).subscribe if RailsConfigManager.active_record_enabled
NetuitiveActionViewSub.new(interaction).subscribe if RailsConfigManager.action_view_enabled
NetuitiveActionMailer.new(interaction).subscribe if RailsConfigManager.action_mailer_enabled
NetuitiveActiveSupportSub.new(interaction).subscribe if RailsConfigManager.active_support_enabled
NetuitiveActiveJobSub.new(interaction).subscribe if RailsConfigManager.active_job_enabled

# start metrics that are collected on a schedule
Scheduler.new(interaction).start_schedule if RailsConfigManager.gc_enabled || RailsConfigManager.object_space_enabled

# sidekiq
SidekiqTracker.new.setup if RailsConfigManager.sidekiq_enabled

RailsNetuitiveLogger.log.info 'Netuitive rails agent installed'
