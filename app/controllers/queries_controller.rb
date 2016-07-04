class QueriesController < ApplicationController
  before_action :fetch_current_user
  before_action :bounce_guests
  before_action :prepare_results
  before_action :prepare_hashtags, only: [:search]
  before_action :ensure_search_is_allowed, only: [:search]

  def new
  end

  def search
    batch_id = record_batch_request
    @query_tags.each do |tag|
      checker = ImportChecker.new(tag, batch_id)
      result  = checker.determine_import_action
      PrimaryHashtagWorker.perform_async(tag, @current_user.id, batch_id) if result == :run_search
    end

    return redirect_to query_waiting_path
  end

  def waiting
  end

  def record_batch_request
    batch = @current_user.request_batches.create(query_terms: @query_tags)
    return batch.id
  end

  private

  def ensure_search_is_allowed
    return true if @current_user.can_search?
    flash[:notice] = 'You are not allowed to do that'
    redirect_to root_path
  end

  def prepare_results
    @results = []
  end

  def prepare_hashtags
    one = params["hashtag_one"].gsub(/#/,'')
    two = params["hashtag_two"].gsub(/#/,'')
    three = params["hashtag_three"].gsub(/#/,'')
    @query_tags = [one, two, three].uniq.compact
  end
end