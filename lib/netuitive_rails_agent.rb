require 'netuitive_ruby_api'
require 'active_support/all'
require 'netuitive/action_controller'
require 'netuitive/active_record'
require 'netuitive/action_view'
require 'netuitive/action_mailer'
require 'netuitive/active_support'
require 'netuitive/active_job'
require 'netuitive/rails_config_manager'

NetuitiveActionControllerSub::subscribe
NetuitiveActiveRecordSub::subscribe
NetuitiveActionViewSub::subscribe
NetuitiveActionMailer::subscribe
NetuitiveActiveSupportSub::subscribe
NetuitiveActiveJobSub::subscribe

ConfigManager::setup