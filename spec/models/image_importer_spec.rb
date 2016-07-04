def weak_image_data_hash
  { tags: ['one', 'two'], likes: { count: 11 }, timestamp: '1456244825', id: 'existing-uid' }
end

def strong_image_data_hash
  { tags: ['one', 'two'], likes: { count: 110 }, timestamp: '1456244825', id: 'existing-uid' }
end

describe ImageImporter do
  describe "import" do
    it "saves the image with the correct data for an image with 100 likes or more" do
      ImageImporter.import(strong_image_data_hash)
      expect(Image.last.ig_publish_time).to eq '1456244825'
      expect(Image.last.number_of_likes).to eq 110
      expect(Image.last.hashtags.count).to eq 2
    end

    it "saves the hashtags for an image with 100 likes or more" do
      ImageImporter.import(strong_image_data_hash)
      expect(Hashtag.count).to eq 2
      expect(Hashtag.first.label).to eq 'one'
      expect(Hashtag.last.label).to eq 'two'
      expect(Hashtag.first.raw_related_hashtags).to eq ['one', 'two']
      expect(Hashtag.last.raw_related_hashtags).to eq ['one', 'two']
    end

    it "does not create hashtags that already exist" do
      Hashtag.create(label: 'one')
      ImageImporter.import(strong_image_data_hash)
      expect(Hashtag.count).to eq 2
    end

    it "does not import images with existing IG uid" do
      Image.create(ig_media_id: 'existing-uid')
      expect(Image.count).to eq 1
      ImageImporter.import(strong_image_data_hash)
      expect(Image.count).to eq 1
    end

    it "updates the correct timeslot" do
      ImageImporter.import(strong_image_data_hash)
      expect(Timeslot.count).to eq 48
      image_hashtags = Image.first.hashtags
      image_hashtags.each do |tag|
        expect(tag.timeslots.where(slot_name: '18').first.number_of_photos).to eq 1
        expect(tag.timeslots.where(slot_name: '18').first.number_of_likes).to eq 110
      end
    end

    it "does not import the image for an image with 99 likes or less" do
      ImageImporter.import(weak_image_data_hash)
      expect(Image.count).to eq 0
    end

    it "does not save any hashtags for an image with 99 likes or less" do
      ImageImporter.import(weak_image_data_hash)
      expect(Hashtag.count).to eq 0
    end
  end

  describe 'create_image' do
    it 'creates a new image record' do
      uid = 'cool-uid'
      likes = 400
      timestamp = '1456244825'
      tags = []
      url = 'http://www.instagram.com/fake'

      ImageImporter.create_image(uid, likes, timestamp, tags, url)
      expect(Image.count).to eq 1
      expect(Image.last.ig_media_id).to eq 'cool-uid'
      expect(Image.last.ig_publish_time).to eq '1456244825'
      expect(Image.last.number_of_likes).to eq 400
      expect(Image.last.ig_media_url).to eq 'http://www.instagram.com/fake'
    end
  end
end