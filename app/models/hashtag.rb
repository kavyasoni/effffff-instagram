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

class Hashtag < ActiveRecord::Base
  belongs_to :image
  has_many :timeslots

  after_create :add_timeslots

  def self.import_data_hash tag, data_hash
    data_hash.each do |obj|
      if obj[0] == 'data'
        media_count = obj[1][:media_count] || obj[1]['media_count']
        Hashtag.update_or_create(tag, media_count)
      end
    end
  end

  def self.update_or_create name, count
    if self.where(label: name).any?
      self.where(label: name).first.update(total_count_on_ig: count)
    else
      create(label: name, total_count_on_ig: count)
    end
  end

  def self.establish_hashtag_mix object, tag_in_question
    current_related_tags  = tag_in_question.related_hashtags
    possibly_related_tags = object[:tags]
    [current_related_tags,possibly_related_tags].flatten.uniq.compact
  end

  def self.update_own_related_tags tag, object
    hashtag = Hashtag.where(label: tag).first
    tags    = establish_hashtag_mix(object, hashtag)
    tag_ids = Hashtag.where(label: tags).map(&:id)
    hashtag.update_attributes(related_hashtags: tags, raw_related_hashtags: tags, related_hashtag_ids: tag_ids)
  end

  def self.update_siblings tag, object
    queried_tag, best_labels, best_ids = self.fetch_best_related_tags(tag, object)
    queried_tag.update(related_hashtags: best_labels, raw_related_hashtags: best_labels, related_hashtag_ids: best_ids)
  end

  private

  def add_timeslots
    timeslots = []
    TIMESLOT_LABELS.each do |slot|
      timeslots.push Timeslot.new(hashtag: self, slot_name: slot)
    end
    Timeslot.ar_import timeslots
  end

  def self.fetch_best_related_tags tag, object
    queried_tag  = Hashtag.where(label: tag).first
    tags         = establish_hashtag_mix(object, queried_tag)
    best_related = Hashtag.where(label: tags).sort_by(&:total_count_on_ig).first(50)
    cleaned      = best_related.select { |x| x.total_count_on_ig != 0 }
    best_labels  = cleaned.map(&:label)
    best_ids     = cleaned.map(&:id)
    [queried_tag, best_labels, best_ids]
  end
end