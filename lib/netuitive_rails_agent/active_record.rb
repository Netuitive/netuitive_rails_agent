module NetuitiveRailsAgent
  class ActiveRecordSub
    attr_reader :interaction
    def initialize(interaction)
      @interaction = interaction
    end

    def subscribe
      ActiveSupport::Notifications.subscribe(/instantiation.active_record/) do |*_args|
        instantiation
      end

      ActiveSupport::Notifications.subscribe(/sql.active_record/) do |*_args|
        sql
      end
    end

    def instantiation
      interaction.aggregate_metric('active_record.instantiation', 1)
    end

    def sql
      interaction.aggregate_metric('active_record.sql.statement', 1)
    end
  end
end
