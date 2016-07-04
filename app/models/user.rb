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

class User < ActiveRecord::Base
  has_many :request_batches, dependent: :destroy
  has_one :user_preference, dependent: :destroy

  after_create :create_email_preferences
  validates :email, length: { in: 1..255, allow_nil: true }
  validates :full_name, length: { in: 1..255, allow_nil: true }

  def self.find_or_create_from_uid auth_hash
    time_of_request = DateTime.current.to_i
    uid, username, access_token = self.attrs_from(auth_hash)

    if user = User.where(uid: uid).first
      user.update(last_login_time: time_of_request)
      user
    else
      User.create(uid: uid, ig_username: username, ig_access_token: access_token, last_login_time: time_of_request)
    end
  end

  def complete_intro!
    user_preference.update_attributes(intro_complete: true)
  end

  def intro_still_outstanding?
    user_preference.intro_complete == false
  end

  def can_search?
    request_batches.where("created_at >= ?", Time.zone.now.beginning_of_day).none?
  end

  def admin?
    ig_username == 'suggested_username'
  end

  def set_email_address user_params
    self.update_attributes(email: user_params[:email])
  end

  def emailable?
    self.email.present? && (user_preference.emails_active == true)
  end

  private

  def create_email_preferences
    UserPreference.create(user: self)
  end

  def self.attrs_from hash
    [hash.uid, hash.info.nickname, hash.credentials.token]
  end
end