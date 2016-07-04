class ImportChecker
  def initialize tag, request_batch_id
    @tag              = tag
    @request_batch_id = request_batch_id
  end

  def determine_import_action
    request = SearchRequest.where(query: @tag)

    if searched_for_within_last_hour?(request)
      request.first.increment!(:search_count)
      return :no_action
    elsif request.any?
      increment_search_details(request)
      return :run_search
    else
      record_query
      return :run_search
    end
  end

  def increment_search_details request
    new_count = request.first.search_count + 1
    request.first.update_attributes(search_count: new_count, last_api_search: Time.now)
  end

  def record_query
    SearchRequest.create(query: @tag, last_api_search: Time.now, search_count: 1)
  end

  def searched_for_within_last_hour? request
    return false if request.none?
    request.last.last_api_search > (Time.now - 1.hour)
  end
end