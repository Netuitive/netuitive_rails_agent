require 'active_support/all'
require 'active_support'
require 'action_controller'
require 'netuitive_ruby_api'
require 'netuitive/rails_config_manager'
require 'netuitive/netuitive_rails_logger'
require 'netuitive/api_interaction'
require 'netuitive/controller_utils'
require 'netuitive/error_utils'
require 'netuitive/action_controller'
require 'netuitive/active_record'
require 'netuitive/action_view'
require 'netuitive/action_mailer'
require 'netuitive/active_support'
require 'netuitive/active_job'
require 'netuitive/sidekiq'
require 'netuitive/error_tracker'
require 'netuitive/request_data'
require 'netuitive/gc'
require 'netuitive/objectspace'
require 'netuitive/scheduler'

# load config and logger
ConfigManager.load_config
NetuitiveLogger.setup
ConfigManager.read_config

# subscribe to notifications
interaction = ApiInteraction.new
NetuitiveActionControllerSub.new(interaction).subscribe if ConfigManager.action_controller_enabled
NetuitiveActiveRecordSub.new(interaction).subscribe if ConfigManager.active_record_enabled
NetuitiveActionViewSub.new(interaction).subscribe if ConfigManager.action_view_enabled
NetuitiveActionMailer.new(interaction).subscribe if ConfigManager.action_mailer_enabled
NetuitiveActiveSupportSub.new(interaction).subscribe if ConfigManager.active_support_enabled
NetuitiveActiveJobSub.new(interaction).subscribe if ConfigManager.active_job_enabled

# start metrics that are collected on a schedule
Scheduler.new(interaction).start_schedule if ConfigManager.gc_enabled || ConfigManager.object_space_enabled

# sidekiq
SidekiqTracker.new.setup if ConfigManager.sidekiq_enabled
