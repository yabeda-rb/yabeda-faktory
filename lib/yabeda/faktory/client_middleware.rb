# frozen_string_literal: true

module Yabeda
  module Faktory
    # Client middleware to count number of enqueued jobs
    class ClientMiddleware
      def call(payload, _connection_pool)
        success = true
        start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        yield
      rescue Exception # rubocop: disable Lint/RescueException
        success = false
        raise
      ensure
        elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC) - start
        labels = { success: success }.merge(Yabeda::Faktory.labelize(payload))
        Yabeda.faktory.jobs_enqueued_total.increment(labels)
        Yabeda.faktory.job_enqueue_runtime.measure(labels, elapsed.round(3))
      end
    end
  end
end
