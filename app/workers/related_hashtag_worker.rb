class RelatedHashtagWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  sidekiq_options retry: false, unique: :until_executed, unique_expiration: 2.hours, queue: 'related'

  def perform related_tag, user_id, batch_id
    importer = RelatedHashtagImporter.new(related_tag, user_id, batch_id)
    importer.fetch_related_hashtags
  end
end