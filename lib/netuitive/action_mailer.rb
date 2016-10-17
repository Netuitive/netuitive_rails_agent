class NetuitiveActionMailer
  attr_reader :interaction
  def initialize(interaction)
    @interaction = interaction
  end

  def subscribe
    ActiveSupport::Notifications.subscribe(/receive.action_mailer/) do |*args|
      receive(args)
    end
    ActiveSupport::Notifications.subscribe(/deliver.action_mailer/) do |*args|
      deliver(args)
    end
  end

  def receive(*args)
    event = ActiveSupport::Notifications::Event.new(*args)
    mailer = event.payload[:mailer].to_s
    interaction.aggregate_metric("action_mailer.#{mailer}.receive", 1)
  end

  def deliver(*args)
    event = ActiveSupport::Notifications::Event.new(*args)
    mailer = event.payload[:mailer].to_s
    interaction.aggregate_metric("action_mailer.#{mailer}.deliver", 1)
  end
end
