# == Schema Information
#
# Table name: hashtags
#
#  id                   :integer          not null, primary key
#  image_id             :integer
#  label                :string
#  raw_related_hashtags :text             default("{}"), is an Array
#  related_hashtags     :text             default("{}"), is an Array
#  related_hashtag_ids  :text             default("{}"), is an Array
#  total_count_on_ig    :integer          default("0")
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

def ig_tags
  ["c_and_w", "c_battery", "c_clef", "c_compiler", "c_horizon", "c_major", "c_major_scale", "c_program", "ca", "caaba", "cab"]
end

def ig_object
  { type: "image", tags: ig_tags, likes: { count: 363}, id: "9497045", timestamp: 950082807 }
end

describe Hashtag do
  describe "creation" do
    it "new hashtag comes with 24 timeslots" do
      hashtag = Hashtag.create
      expect(hashtag.timeslots.count).to eq(24)
    end
  end

  describe "update_or_create" do
    it 'updates an existing hashtag if it exists' do
      hashtag = Hashtag.create(label: 'ocean', total_count_on_ig: 15)
      Hashtag.update_or_create('ocean', 28)
      expect(hashtag.reload.total_count_on_ig).to eq 28
      expect(Hashtag.count).to eq 1
    end

    it 'creates a new hashtag if one does not exist yet' do
      expect(Hashtag.count).to eq 0
      Hashtag.update_or_create('river', 43)
      expect(Hashtag.last.total_count_on_ig).to eq 43
      expect(Hashtag.last.label).to eq 'river'
      expect(Hashtag.count).to eq 1
    end
  end

  describe 'establish_hashtag_mix' do
    it 'returns the correct hashtag mix' do
      object = { tags: ['cat', 'mouse', 'rat'] }
      tag_in_question = create(:hashtag, label: 'dog', related_hashtags: ['fish', 'bird'])
      mix = Hashtag.establish_hashtag_mix(object, tag_in_question)
      expect(mix).to eq(['fish', 'bird', 'cat', 'mouse', 'rat'])
    end
  end

  describe "update_siblings" do
    before :each do
      ig_tags.each_with_index do |tag, index|
        Hashtag.create(label: tag, total_count_on_ig: (index + 1))
      end
      Hashtag.create(label: 'candle', total_count_on_ig: 455)
      Hashtag.create(label: 'crockery', total_count_on_ig: 355)
      @tag = Hashtag.create(label: 'cricket', total_count_on_ig: 55, related_hashtags: ['candle', 'crockery'])
    end

    it 'updates the related tag IDs' do
      Hashtag.update_siblings('cricket', ig_object)
      expect(@tag.reload.related_hashtag_ids.count).to eq 13
    end

    it 'updates an existing hashtag if it exists' do
      Hashtag.update_siblings('cricket', ig_object)
      ig_tags.each do |t|
        expect(@tag.reload.related_hashtags).to include t
      end
      expect(@tag.reload.related_hashtags).to include 'candle'
      expect(@tag.reload.related_hashtags).to include 'crockery'
    end
  end
end