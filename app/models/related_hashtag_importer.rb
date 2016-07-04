class RelatedHashtagImporter
  def initialize tag, user_id, batch_id
    @tag      = tag
    @user_id  = user_id
    @batch_id = batch_id
  end

  def fetch_related_hashtags
    api_fetcher  = InstagramInterface.new(@user_id, @tag)
    data_for_tag = api_fetcher.single_tag_data(@tag)

    if data_for_tag == :ig_status_429
      job_id = RelatedHashtagWorker.perform_in(61.minutes, @tag, @user_id, @batch_id)
      push_job_id_to_batch(job_id)
      return :internal_429
    else
      Hashtag.import_data_hash(@tag, data_for_tag)
      return :internal_200
    end
  end

  private

  def push_job_id_to_batch job_id
    @batch = RequestBatch.find(@batch_id)
    old_job_ids = @batch.job_ids
    old_job_ids.push job_id if job_id
    @batch.update_attributes(job_ids: old_job_ids)
  end
end