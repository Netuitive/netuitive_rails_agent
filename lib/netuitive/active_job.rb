class NetuitiveActiveJobSub
  attr_reader :interaction
  def initialize(interaction)
    @interaction = interaction
  end

  def subscribe
    ActiveSupport::Notifications.subscribe(/enqueue.active_job/) do |*_args|
      enqueue
    end
    ActiveSupport::Notifications.subscribe(/perform.active_job/) do |*_args|
      perform
    end
  end

  def enqueue
    interaction.aggregate_metric('active_job.enqueue', 1)
  end

  def perform
    interaction.aggregate_metric('active_job.perform', 1)
  end
end
