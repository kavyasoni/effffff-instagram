class CreateTimeslots < ActiveRecord::Migration
  def change
    create_table :timeslots do |t|
      t.references :hashtag
      t.integer :number_of_likes, default: 0
      t.integer :number_of_photos, default: 0
      t.string :slot_name
      t.timestamps null: false
    end
  end
end
