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

class Image < ActiveRecord::Base
  has_many :hashtags

  def age_in_hours_since_first_fetched
    (self.created_at.to_i - self.ig_publish_time.to_i) / 3600
  end

  def create_hashtags tags
    tags_to_update = []

    tags.each do |tag|
      next if Hashtag.where(label: tag).any?
      t = hashtags.create(related_hashtags: tags, raw_related_hashtags: tags, label: tag)
      tags_to_update.push(t)
    end

    tag_ids = tags_to_update.map(&:id)
    tags_to_update.each do |x|
      x.update_attributes(related_hashtag_ids: tag_ids)
    end
  end

  def update_hashtag_info slot_name, likes
    self.hashtags.each do |tag|
      correct_slot = tag.timeslots.where(slot_name: slot_name).first
      correct_slot.number_of_likes += likes
      correct_slot.number_of_photos += 1
      correct_slot.save
    end
  end
end
