# == Schema Information
#
# Table name: user_preferences
#
#  id                      :integer          not null, primary key
#  user_id                 :integer
#  emails_active           :boolean          default("true")
#  intro_complete          :boolean          default("false")
#  onboard_series_complete :boolean          default("false")
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class UserPreference < ActiveRecord::Base
  belongs_to :user
end