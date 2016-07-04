class PrimaryHashtagImporter
  def initialize tag, user_id, batch_id
    @tag      = tag
    @user_id  = user_id
    @batch_id = batch_id
    @fetcher  = InstagramInterface.new(@user_id, @tag)
  end

  def fetch_details_for_related_tags
    parent_tag = Hashtag.where(label: @tag).first

    if parent_tag
      parent_tag.related_hashtags.each do |related_tag|
        # checker = ImportChecker.new(related_tag, @user_id, @batch_id)
        # result  = checker.determine_import_action
        job_id  = RelatedHashtagWorker.perform_async(related_tag, @user_id, @batch_id) #if result == :run_search
        push_job_id_to_batch(job_id)
      end
    else
    end
  end

  def fetch_single_hashtag
    @fetcher.single_tag_data(@tag)
  end

  def increment_completeness_of_search_request_batch
    RequestBatch.increment_completeness_for @batch_id
  end

  def make_api_request
    result = fetch_single_hashtag

    if result == :ig_status_429
      job_id = PrimaryHashtagWorker.perform_in(61.minutes, @tag, @user_id, @batch_id)
      push_job_id_to_batch(job_id)
      return :internal_429
    else
      Hashtag.import_data_hash(@tag, result)
      make_media_api_request
    end
  end

  def make_media_api_request
    all_media = @fetcher.hashtag_media

    if all_media == :ig_status_429
      job_id = PrimaryHashtagMediaWorker.perform_in(61.minutes, @tag, @user_id, @batch_id)
      push_job_id_to_batch(job_id)
      return :internal_429_for_media
    else
      puts 'I am in the else'
      all_media.each do |ig_data_object|
        puts "saving media for tag"
        save_media_for_tag(ig_data_object)
      end
      return :internal_media_200
    end
  end

  def save_media_for_tag ig_data_object
    ImageImporter.import(ig_data_object)
    Hashtag.update_siblings(@tag, ig_data_object)
    Hashtag.update_own_related_tags(@tag, ig_data_object)
  end

  private

  def push_job_id_to_batch job_id
    @batch = RequestBatch.find(@batch_id)
    old_job_ids = @batch.job_ids
    old_job_ids.push job_id if job_id
    @batch.update_attributes(job_ids: old_job_ids)
  end
end