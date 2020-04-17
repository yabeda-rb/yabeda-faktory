RSpec.describe Yabeda::Faktory do
  it "has a version number" do
    expect(Yabeda::Faktory::VERSION).not_to be nil
  end

  it "configures middlewares" do
    expect(Faktory.client_middleware).to include(have_attributes(klass: Yabeda::Faktory::ClientMiddleware))
  end

  describe "plain Faktory jobs" do
    it "measures enqueue" do
      Yabeda.faktory.jobs_enqueued_total.values.clear # This is a hack
      Yabeda.faktory.job_enqueue_runtime.values.clear # This is a hack also

      SamplePlainJob.perform_async
      SamplePlainJob.perform_async
      FailingPlainJob.perform_async

      expect(Yabeda.faktory.jobs_enqueued_total.values).to include(
        { queue: "default", worker: "SamplePlainJob", success: true } => 2,
        { queue: "default", worker: "FailingPlainJob", success: true } => 1,
      )
      expect(Yabeda.faktory.job_enqueue_runtime.values).to include(
        { queue: "default", worker: "SamplePlainJob", success: true } => kind_of(Numeric),
        { queue: "default", worker: "FailingPlainJob", success: true } => kind_of(Numeric),
      )
    end

    it "measures runtime" do
      Yabeda.faktory.jobs_executed_total.values.clear   # This is a hack
      Yabeda.faktory.job_execution_runtime.values.clear # This is a hack also

      Faktory::Testing.inline! do
        SamplePlainJob.perform_async
        SamplePlainJob.perform_async
        FailingPlainJob.perform_async rescue nil
      end

      expect(Yabeda.faktory.jobs_executed_total.values).to include(
        { queue: "default", worker: "SamplePlainJob", success: true } => 2,
        { queue: "default", worker: "FailingPlainJob", success: false } => 1,
      )
      expect(Yabeda.faktory.job_execution_runtime.values).to include(
        { queue: "default", worker: "SamplePlainJob", success: true } => kind_of(Numeric),
        { queue: "default", worker: "FailingPlainJob", success: false } => kind_of(Numeric),
      )
    end
  end

  describe "ActiveJob jobs" do
    it "measures enqueue" do
      Yabeda.faktory.jobs_enqueued_total.values.clear # This is a hack
      Yabeda.faktory.job_enqueue_runtime.values.clear # This is a hack also
      SampleActiveJob.perform_later
      expect(Yabeda.faktory.jobs_enqueued_total.values).to include(
        { queue: "default", worker: "SampleActiveJob", success: true } => 1,
      )
      expect(Yabeda.faktory.job_enqueue_runtime.values).to include(
        { queue: "default", worker: "SampleActiveJob", success: true } => kind_of(Numeric),
      )
    end

    it "measures runtime" do
      Yabeda.faktory.jobs_executed_total.values.clear   # This is a hack
      Yabeda.faktory.job_execution_runtime.values.clear # This is a hack also

      Faktory::Testing.inline! do
        SampleActiveJob.perform_later
        SampleActiveJob.perform_later
        FailingActiveJob.perform_later rescue nil
      end

      expect(Yabeda.faktory.jobs_executed_total.values).to include(
        { queue: "default", worker: "SampleActiveJob", success: true } => 2,
        { queue: "default", worker: "FailingActiveJob", success: false } => 1,
      )
      expect(Yabeda.faktory.job_execution_runtime.values).to include(
        { queue: "default", worker: "SampleActiveJob", success: true } => kind_of(Numeric),
        { queue: "default", worker: "FailingActiveJob", success: false } => kind_of(Numeric),
      )
    end
  end
end
