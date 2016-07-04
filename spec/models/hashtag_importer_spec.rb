require 'sidekiq/testing'

describe HashtagImporter do
  describe "import" do
    before :each do
      @user  = create(:user)
      @batch = create(:request_batch, user: @user, query_terms: ['vehicle', 'truck', 'transport'])
      Sidekiq::Testing.inline!
    end

    it "saves the hashtags returned in the data hash" do
      importer = HashtagImporter.fetch_hashtag 'car', @user.id, @batch.id
      expect(Hashtag.count).to eq 21
    end

    it "saves the correct hashtag information" do
      importer = HashtagImporter.fetch_hashtag 'car', @user.id, @batch.id
      expect(Hashtag.first.label).to eq 'car'
      expect(Hashtag.last.label).to eq 'cabasset'
    end

    it "updates the value for an existing hashtag" do
      # InstagramInterface stubs API calls, returns 420 for count

      h = Hashtag.create(total_count_on_ig: 5, label: 'car')
      importer = HashtagImporter.fetch_hashtag 'car', @user.id, @batch.id
      expect(h.reload.total_count_on_ig).to eq 420
    end
  end
end