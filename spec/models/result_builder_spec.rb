describe ResultBuilder do
  before :each do
    @batch = create(:request_batch, query_terms: ['one', 'two', 'three'])

    @h1 = create(:hashtag)
    @h2 = create(:hashtag)
    @h3 = create(:hashtag)
    @h4 = create(:hashtag, label: 'one', related_hashtag_ids: [@h1.id])
    @h5 = create(:hashtag, label: 'two', related_hashtag_ids: [@h2.id])
    @h6 = create(:hashtag, label: 'three', related_hashtag_ids: [@h3.id])
  end

  feature "results" do
    it "returns all uniq, relevant hashtags discovered via the related tags " do
      results = ResultBuilder.new(@batch).results
      expect(results).to eq([@h1.id.to_s, @h2.id.to_s, @h3.id.to_s])
    end
  end
end