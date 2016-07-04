# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  auth_digest     :text
#  last_login_time :string
#  uid             :string
#  ig_username     :string
#  ig_access_token :string
#  email           :string
#  full_name       :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryGirl.define do
  factory :user do
    uid { Faker::Number.number(10) }
    auth_digest { Faker::Lorem.characters(20) }
    ig_access_token { Faker::Lorem.characters(20) }
    ig_username { Faker::Lorem.word }
  end
end
