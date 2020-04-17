class SamplePlainJob
  include Faktory::Job

  def perform(*args)
    "My job is simple"
  end
end

class FailingPlainJob
  include Faktory::Job

  def perform(*args)
    raise "Badaboom"
  end
end

class SampleActiveJob < ActiveJob::Base
  self.queue_adapter = :faktory

  def perform(*args)
    "I'm doing my job"
  end
end

class FailingActiveJob < ActiveJob::Base
  self.queue_adapter = :faktory
  def perform(*args)
    raise "Boom"
  end
end