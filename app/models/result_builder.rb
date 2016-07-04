class ResultBuilder
  def initialize batch
    @batch = batch
  end

  def results
    hashtag_array = []
    primary_tags = Hashtag.where(label: @batch.query_terms)
    primary_tags.each do |tag|
      hashtag_array.push tag.related_hashtag_ids
    end

    hashtag_array.flatten.uniq
  end
end