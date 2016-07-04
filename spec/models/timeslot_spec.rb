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

describe Timeslot do
  describe "defaults" do
    it "has zero number_of_likes" do
      slot = Timeslot.create
      expect(slot.number_of_likes).to eq(0)
    end

    it "has zero number_of_photos" do
      slot = Timeslot.create
      expect(slot.number_of_photos).to eq(0)
    end
  end
end
