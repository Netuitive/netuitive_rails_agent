require 'netuitive/error_utils'

class SidekiqTracker
  def self.setup
    return unless ConfigManager.sidekiq_enabled

    NetuitiveLogger.log.debug 'turning on sidekiq tracking'
    require 'sidekiq'
    Sidekiq.configure_server do |config|
      config.error_handlers << proc { |ex, ctx_hash| SidekiqTracker::ErrorTracker.new.call(ex, ctx_hash) }
      config.server_middleware do |chain|
        chain.add SidekiqTracker::ChainTracker
      end
    end
    NetuitiveLogger.log.debug 'sidekiq tracking installed'
  end

  class ChainTracker
    def call(worker, item, queue)
      begin
        klass = item['wrapped'.freeze] || worker.class.to_s
        queue = item['queue']
        NetuitiveLogger.log.debug "sidekiq job tracked. queue: #{queue}, class: #{klass}"
        NetuitiveRubyAPI.aggregate_metric("sidekiq.#{klass}.job.count", 1)
        NetuitiveRubyAPI.aggregate_metric("sidekiq.#{queue}.job.count", 1)
        NetuitiveRubyAPI.aggregate_metric("sidekiq.#{queue}.#{klass}.job.count", 1)
      rescue => e
        NetuitiveLogger.log.error "exception during sidekiq chain tracking: message:#{e.message} backtrace:#{e.backtrace}"
      end
      yield
    end
  end

  class ErrorTracker
    include ErrorUtils

    def call(exception, ctx_hash)
      NetuitiveLogger.log.debug "sidekiq error tracked. context: #{ctx_hash[:context]}"
      tags = {
        sidekiq: 'true',
        context: ctx_hash[:context]
      }
      metrics = ['sidekiq.errors']
      job = ctx_hash[:job]
      unless job.nil?
        if defined? job.item
          item = job.item
          klass = item['wrapped'.freeze] || worker.class.to_s
          queue = item['queue']
          metrics << "sidekiq.#{queue}.#{klass}.error.count"
          metrics << "sidekiq.#{queue}.error.count"
        end
      end

      handle_error(exception, metrics, tags)
    rescue => e
      NetuitiveLogger.log.error "exception during sidekiq error tracking: message:#{e.message} backtrace:#{e.backtrace}"
    end
  end
end
