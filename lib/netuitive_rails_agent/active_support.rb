module NetuitiveRailsAgent
  class ActiveSupportSub
    attr_reader :interaction
    def initialize(interaction)
      @interaction = interaction
    end

    def subscribe
      ActiveSupport::Notifications.subscribe(/cache_read.active_support/) do |*_args|
        cache_read
      end
      ActiveSupport::Notifications.subscribe(/cache_generate.active_support/) do |*_args|
        cache_generate
      end
      ActiveSupport::Notifications.subscribe(/cache_fetch_hit.active_support/) do |*_args|
        cache_fetch_hit
      end
      ActiveSupport::Notifications.subscribe(/cache_write.active_support/) do |*_args|
        cache_write
      end
      ActiveSupport::Notifications.subscribe(/cache_delete.active_support/) do |*_args|
        cache_delete
      end
    end

    def cache_read
      interaction.aggregate_metric('active_support.cache_read', 1)
    end

    def cache_generate
      interaction.aggregate_metric('active_support.cache_generate', 1)
    end

    def cache_fetch_hit
      interaction.aggregate_metric('active_support.cache_fetch_hit', 1)
    end

    def cache_write
      interaction.aggregate_metric('active_support.cache_write', 1)
    end

    def cache_delete
      interaction.aggregate_metric('active_support.cache_delete', 1)
    end
  end
end
