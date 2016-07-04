class ResultsController < ApplicationController
  before_action :fetch_current_user
  before_action :bounce_guests

  def show
    batch      = @current_user.request_batches.find(params[:id])
    result_ids = ResultBuilder.new(batch).results
    @results   = Hashtag.find(result_ids).sort_by(&:total_count_on_ig).reverse.first(30)
  end
end