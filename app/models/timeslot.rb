# == Schema Information
#
# Table name: timeslots
#
#  id               :integer          not null, primary key
#  hashtag_id       :integer
#  number_of_likes  :integer          default("0")
#  number_of_photos :integer          default("0")
#  slot_name        :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Timeslot < ActiveRecord::Base
  belongs_to :hashtag
end