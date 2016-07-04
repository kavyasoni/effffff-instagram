class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.text   :auth_digest
      t.string :last_login_time
      t.string :uid
      t.string :ig_username
      t.string :ig_access_token
      t.string :email
      t.string :full_name
      t.timestamps null: false
    end
  end
end
