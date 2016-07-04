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

describe User do
  feature "can_search" do
    it "returns true if user has no search requests in the last 24 hours" do
      user = create(:user)
      expect(user.can_search?).to be true
    end

    it "returns false if user has any search requests in the last 24 hours" do
      user = create(:user)
      create(:request_batch, user: user)
      expect(user.can_search?).to be false
    end
  end

  feature "admin" do
    it "returns true if ig_username is suggested_username" do
      user = create(:user, ig_username: 'suggested_username')
      expect(user.admin?).to be true
    end

    it "returns false if ig_username is not suggested_username" do
      user = create(:user, ig_username: 'anything_else')
      expect(user.admin?).to be false
    end
  end

  feature "user_preferences" do
    it "user gets user_preferences created upon creation" do
      user = create(:user)
      expect(user.user_preferences.count).to eq 1
    end
  end

  feature "find_or_create_from_uid" do
    before :each do
      @auth_hash = OmniAuth::AuthHash.new({ uid: 'XYZ', info: { nickname: 'Pawel' }, credentials: { token: 'token' } })
    end

    it "returns updated existing user with matching UID" do
      frozen_time = Time.local(2015, 1, 1, 12, 0, 0)
      Timecop.freeze(frozen_time) do
        @user = create(:user, uid: 'XYZ', ig_username: 'suggested_username')
      end

      User.find_or_create_from_uid(@auth_hash)
      login_time = @user.reload.last_login_time.to_i
      expect(Time.at(login_time).to_date).to eq Time.now.to_date
    end

    it "creates a new user if no existing user is found" do
      User.find_or_create_from_uid(@auth_hash)
      expect(User.last.ig_username).to eq 'Pawel'
    end
  end
end
