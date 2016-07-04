class ImageImporter
  def self.import ig_data_object
    timestamp = ig_data_object[:timestamp]
    uid       = ig_data_object[:id]
    likes     = ig_data_object[:likes][:count]
    tags      = ig_data_object[:tags]
    url       = ig_data_object[:url]

    return unless likes.to_i > 99
    return false if Image.where(ig_media_id: uid).any?
    self.create_image(uid, likes, timestamp, tags, url)
  end

  def self.create_image uid, likes, timestamp, tags, url
    slot_name   = TimeConverter.new(timestamp).get_slot_name
    saved_image = Image.create(ig_media_id: uid, ig_publish_time: timestamp, number_of_likes: likes, ig_media_url: url)
    saved_image.create_hashtags(tags)
    saved_image.update_hashtag_info(slot_name, likes)
  end
end