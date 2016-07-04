class PrimaryHashtagWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  sidekiq_options retry: false, unique: :until_executed, unique_expiration: 2.hours, queue: 'primary'

  def perform tag, user_id, batch_id
    importer = PrimaryHashtagImporter.new(tag, user_id, batch_id)
    result   = importer.make_api_request
    importer.fetch_details_for_related_tags
    importer.increment_completeness_of_search_request_batch if result == :internal_media_200
  end
end