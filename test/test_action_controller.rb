require 'test/unit'
require 'mocha/test_unit'
require 'active_support'
require 'action_controller'
require 'netuitive_ruby_api'
require 'netuitive/api_interaction'
require 'netuitive/controller_utils'
require 'netuitive/error_utils'
require 'netuitive/netuitive_rails_logger'
require 'netuitive/rails_config_manager'
require 'netuitive/error_tracker'
require 'netuitive/action_controller'
require 'netuitive/action_mailer'
require 'netuitive/action_view'
require 'netuitive/active_job'
require 'netuitive/active_record'
require 'netuitive/active_support'
require 'netuitive/gc'
require 'netuitive/objectspace'
require 'netuitive/request_data'
require 'netuitive/sidekiq'

class ActionControllerTest < Test::Unit::TestCase
  def setup
    @interaction = mock
    @sub = NetuitiveActionControllerSub.new(@interaction)
    RailsNetuitiveLogger.setup
  end

  def test_process_action
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
