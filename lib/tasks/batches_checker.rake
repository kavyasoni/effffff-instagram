namespace :batches do
  desc "check to see if any batches need to be marked as complete"

  task complete: :environment do
    batches = RequestBatch.where(complete: false)
    batches.each do |batch|
      statuses = []

      job_ids = batch.job_ids
      job_ids.each do |job_id|
        data = Sidekiq::Status::get_all job_id
        status = data['status'] || data[:status]
        statuses.push status
      end

      if (statuses.uniq.compact == ['complete'] || statuses.uniq.compact == [])
        batch.mark_as_complete!
      end
    end
  end
end