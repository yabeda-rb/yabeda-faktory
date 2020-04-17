# frozen_string_literal: true

module Yabeda
  module Faktory
    # Faktory worker middleware
    class WorkerMiddleware
      def call(_job_instance, payload)
        success = true
        start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        yield
      rescue Exception # rubocop: disable Lint/RescueException
        success = false
        raise
      ensure
        elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC) - start
        labels = { success: success }.merge(Yabeda::Faktory.labelize(payload))
        Yabeda.faktory.job_execution_runtime.measure(labels, elapsed.round(3))
        Yabeda.faktory.jobs_executed_total.increment(labels)
      end
    end
  end
end
