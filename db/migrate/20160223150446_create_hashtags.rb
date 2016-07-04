class CreateHashtags < ActiveRecord::Migration
  def change
    create_table :hashtags do |t|
      t.references :image
      t.string :label
      t.text :raw_related_hashtags, array:true, default: []
      t.text :related_hashtags, array:true, default: []
      t.text :related_hashtag_ids, array:true, default: []
      t.integer :total_count_on_ig, default: 0
      t.timestamps null: false
    end
  end
end
