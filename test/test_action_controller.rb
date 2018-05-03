require 'test/unit'
require 'mocha/test_unit'
require 'active_support'
require 'action_controller'
require 'netuitive_ruby_api'
require 'netuitive_rails_agent/api_interaction'
require 'netuitive_rails_agent/controller_utils'
require 'netuitive_rails_agent/error_utils'
require 'netuitive_rails_agent/netuitive_logger'
require 'netuitive_rails_agent/config_manager'
require 'netuitive_rails_agent/error_logger'
require 'netuitive_rails_agent/error_tracker'
require 'netuitive_rails_agent/action_controller'
require 'netuitive_rails_agent/action_mailer'
require 'netuitive_rails_agent/action_view'
require 'netuitive_rails_agent/active_job'
require 'netuitive_rails_agent/active_record'
require 'netuitive_rails_agent/active_support'
require 'netuitive_rails_agent/gc'
require 'netuitive_rails_agent/objectspace'
require 'netuitive_rails_agent/request_data'
require 'netuitive_rails_agent/sidekiq'

module NetuitiveRailsAgent
  class ActionControllerTest < Test::Unit::TestCase
    def setup
      NetuitiveRailsAgent::ConfigManager.load_config
      @interaction = mock
      @sub = NetuitiveRailsAgent::ActionControllerSub.new(@interaction)
      NetuitiveRailsAgent::NetuitiveLogger.setup
    end

    def test_process_action
      NetuitiveRailsAgent::ConfigManager.action_controller_whitelist = 'test_controller'
      @interaction.expects(:add_sample).with('action_controller.test_controller.test_action.request.total_duration', 1000.0)
      @interaction.expects(:add_sample).with('action_controller.test_controller.test_action.request.query_time', 3)
      @interaction.expects(:add_sample).with('action_controller.test_controller.test_action.request.view_time', 4)
      @interaction.expects(:add_sample).with('action_controller.test_controller.request.total_duration', 1000.0)
      @interaction.expects(:add_sample).with('action_controller.test_controller.request.query_time', 3)
      @interaction.expects(:add_sample).with('action_controller.test_controller.request.view_time', 4)
      @interaction.expects(:add_sample).with('action_controller.request.total_duration', 1000.0)
      @interaction.expects(:add_sample).with('action_controller.request.query_time', 3)
      @interaction.expects(:add_sample).with('action_controller.request.view_time', 4)
      @interaction.expects(:aggregate_metric).with('action_controller.test_controller.test_action.total_requests', 1)
      @interaction.expects(:aggregate_metric).with('action_controller.test_controller.total_requests', 1)
      @interaction.expects(:aggregate_metric).with('action_controller.total_requests', 1)
      @sub.process_action(nil, 1, 2, nil, controller: 'test_controller', action: 'test_action', db_runtime: 3, view_runtime: 4)
      @interaction.expects(:add_sample).with('action_controller.request.total_duration', 1000.0)
      @interaction.expects(:add_sample).with('action_controller.request.query_time', 3)
      @interaction.expects(:add_sample).with('action_controller.request.view_time', 4)
      @interaction.expects(:aggregate_metric).with('action_controller.total_requests', 1)
      @sub.process_action(nil, 1, 2, nil, controller: 'fail_controller', action: 'fail_action', db_runtime: 3, view_runtime: 4)
    end

    def test_write_fragment
      @interaction.expects(:aggregate_metric).with('action_controller.write_fragment', 1)
      @sub.write_fragment
    end

    def test_read_fragment
      @interaction.expects(:aggregate_metric).with('action_controller.read_fragment', 1)
      @sub.read_fragment
    end

    def test_expire_fragment
      @interaction.expects(:aggregate_metric).with('action_controller.expire_fragment', 1)
      @sub.expire_fragment
    end

    def test_write_page
      @interaction.expects(:aggregate_metric).with('action_controller.write_page', 1)
      @sub.write_page
    end

    def test_expire_page
      @interaction.expects(:aggregate_metric).with('action_controller.expire_page', 1)
      @sub.expire_page
    end

    def test_send_file
      @interaction.expects(:aggregate_metric).with('action_controller.sent_file', 1)
      @sub.send_file
    end

    def test_redirect_to
      @interaction.expects(:aggregate_metric).with('action_controller.redirect', 1)
      @sub.redirect_to
    end

    def test_halted_callback
      @interaction.expects(:aggregate_metric).with('action_controller.halted_callback', 1)
      @sub.halted_callback
    end
  end
end
