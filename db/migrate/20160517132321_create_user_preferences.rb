class CreateUserPreferences < ActiveRecord::Migration
  def change
    create_table :user_preferences do |t|
      t.references :user
      t.boolean :emails_active, default: true
      t.boolean :intro_complete, default: false
      t.boolean :onboard_series_complete, default: false
      t.timestamps null: false
    end
  end
end
