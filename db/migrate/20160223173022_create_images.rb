class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :ig_media_id
      t.string :ig_media_url
      t.string :ig_publish_time
      t.integer :number_of_likes, default: 0
      t.timestamps null: false
    end
  end
end