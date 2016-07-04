# == Schema Information
#
# Table name: images
#
#  id              :integer          not null, primary key
#  ig_media_id     :string
#  ig_media_url    :string
#  ig_publish_time :string
#  number_of_likes :integer          default("0")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

describe Image do
  describe "age_in_hours_since_first_fetched" do
    it "has zero number_of_photos" do
      frozen_time = Time.local(2015, 1, 1, 12, 0, 0)

      Timecop.freeze(frozen_time) do
        pub_time = (frozen_time - 6.days).to_i
        @image = Image.create(ig_publish_time: pub_time)
      end

      expect(@image.age_in_hours_since_first_fetched).to eq 144
    end
  end

  describe "create_hashtags" do
    it "creates new hashtags for a given image" do
      image = create(:image)
      tags  = ['one', 'two', 'three']
      image.create_hashtags(tags)
      expect(Hashtag.count).to eq 3
    end

    it "does not create new hashtags for existing hashtags" do
      create(:hashtag, label: 'three')
      image = create(:image)
      tags  = ['one', 'two', 'three']
      image.create_hashtags(tags)
      expect(Hashtag.count).to eq 3
    end
  end

  describe "update_hashtag_info" do
    before :each do
      @image = create(:image)
      @tag = create(:hashtag, image: @image)
    end

    it "updates the correct hashtags with new data" do
      @image.update_hashtag_info('23', 30)
      correct_slot = @tag.timeslots.where(slot_name: '23').first
      expect(correct_slot.number_of_likes).to eq 30
      expect(correct_slot.number_of_photos).to eq 1
    end

    it "does not update incorrect hashtags with new data" do
      @image.update_hashtag_info('23', 30)
      bad_slot = @tag.timeslots.first
      expect(bad_slot.number_of_likes).to eq 0
      expect(bad_slot.number_of_photos).to eq 0
    end
  end
end