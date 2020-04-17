require "bundler/setup"

require 'faktory/cli' # Fake that we're a worker to test worker-specific things
require "yabeda/faktory"

require 'faktory/testing'
require 'active_job'
require 'active_job/queue_adapters/faktory_adapter'
require "pry"

require_relative "support/jobs"
require_relative "support/faktory_inline_middlewares"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.mock_with :rspec

  Kernel.srand config.seed
  config.order = :random

  config.before(:all) do
    Yabeda.configure!
    Faktory::Testing.fake!
    ActiveJob::QueueAdapters::FaktoryAdapter::JobWrapper.jobs.clear
  end

  config.after(:all) do
    Faktory::Queues.clear_all
    Faktory::Testing.disable!
  end
end

ActiveJob::Base.logger = Logger.new(nil)
