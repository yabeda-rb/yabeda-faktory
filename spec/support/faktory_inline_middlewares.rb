require 'faktory/testing'

module FaktoryTestingInlineWithMiddlewares
  def push(job)
    return super unless Faktory::Testing.inline?

    job = Faktory.load_json(Faktory.dump_json(job))
    job_class = Faktory::Testing.constantize(job['jobtype'])
    job_instance = job_class.new
    Faktory.worker_middleware.invoke(job_instance, job) do
      job_instance.perform(*job['args'])
    end
    job['jid']
  end
end

Faktory::Client.prepend(FaktoryTestingInlineWithMiddlewares)
