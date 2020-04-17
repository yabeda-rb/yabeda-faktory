# frozen_string_literal: true

require "faktory"
require "yabeda"

require "yabeda/faktory/version"
require "yabeda/faktory/client_middleware"
require "yabeda/faktory/worker_middleware"

module Yabeda
  module Faktory
    class Error < StandardError; end

    JOB_ENQUEUE_TIME_BUCKETS = [
      0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5, 10 # standard (from Prometheus)
    ].freeze

    LONG_RUNNING_JOB_RUNTIME_BUCKETS = [
      0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5, 10, # standard (from Prometheus)
      30, 60, 120, 300, 1800, 3600, 21_600 # Faktory jobs may be very long-running
    ].freeze

    Yabeda.configure do
      group :faktory

      counter :jobs_enqueued_total, tags: %i[queue worker success], comment: "A counter of the total number of jobs faktory has enqueued."

      histogram :job_enqueue_runtime, comment: "A histogram of the job enqueue time.",
                unit: :seconds, per: :job,
                tags: %i[queue worker success],
                buckets: JOB_ENQUEUE_TIME_BUCKETS


      next unless ::Faktory.worker?

      counter   :jobs_executed_total,  tags: %i[queue worker success], comment: "A counter of the number of jobs faktory worker has executed."

      histogram :job_execution_runtime, comment: "A histogram of the job execution time.",
                unit: :seconds, per: :job,
                tags: %i[queue worker success],
                buckets: LONG_RUNNING_JOB_RUNTIME_BUCKETS
    end

    ::Faktory.configure_client do |config|
      config.client_middleware do |chain|
        chain.add ClientMiddleware
      end
    end

    ::Faktory.configure_worker do |config|
      config.client_middleware do |chain|
        chain.add ClientMiddleware
      end
      config.worker_middleware do |chain|
        chain.add WorkerMiddleware
      end
    end

    class << self
      def labelize(payload)
        { queue: payload["queue"], worker: worker_class(payload) }
      end

      def worker_class(payload)
        worker = payload["jobtype"]

        if defined?(ActiveJob::QueueAdapters::FaktoryAdapter::JobWrapper)
          if worker.is_a?(ActiveJob::QueueAdapters::FaktoryAdapter::JobWrapper) || worker == "ActiveJob::QueueAdapters::FaktoryAdapter::JobWrapper"
            return payload.dig("custom", "wrapped").to_s
          end
        end

        worker.to_s
      end
    end
  end
end
