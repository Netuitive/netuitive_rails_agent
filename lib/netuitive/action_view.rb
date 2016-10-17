class NetuitiveActionViewSub
  attr_reader :interaction
  def initialize(interaction)
    @interaction = interaction
  end

  def subscribe
    ActiveSupport::Notifications.subscribe(/render_template.action_view/) do |*_args|
      render_template
    end
    ActiveSupport::Notifications.subscribe(/render_partial.action_view/) do |*_args|
      render_partial
    end
  end

  def render_template
    interaction.aggregate_metric('action_view.render_template', 1)
  end

  def render_partial
    interaction.aggregate_metric('action_view.render_partial', 1)
  end
end
