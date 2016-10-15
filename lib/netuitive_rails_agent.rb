require 'netuitive_ruby_api'
require 'active_support/all'
require 'netuitive/action_controller'
require 'netuitive/active_record'
require 'netuitive/action_view'
require 'netuitive/action_mailer'
require 'netuitive/active_support'
require 'netuitive/active_job'
require 'netuitive/rails_config_manager'
require 'netuitive/scheduler'
require 'netuitive/sidekiq'

# load config and logger
ConfigManager.load_config
NetuitiveLogger.setup
ConfigManager.read_config

# subscribe to notifications
NetuitiveActionControllerSub.subscribe if ConfigManager.action_controller_enabled
NetuitiveActiveRecordSub.subscribe if ConfigManager.active_record_enabled
NetuitiveActionViewSub.subscribe if ConfigManager.action_view_enabled
NetuitiveActionMailer.subscribe if ConfigManager.action_mailer_enabled
NetuitiveActiveSupportSub.subscribe if ConfigManager.active_support_enabled
NetuitiveActiveJobSub.subscribe if ConfigManager.active_job_enabled

# start metrics that are collected on a schedule
Scheduler.start_schedule if ConfigManager.gc_enabled || ConfigManager.object_space_enabled

# sidekiq
SidekiqTracker.setup if ConfigManager.sidekiq_enabled
