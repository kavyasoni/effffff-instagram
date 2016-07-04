class CreateSearchRequests < ActiveRecord::Migration
  def change
    create_table :search_requests do |t|
      t.string :query
      t.integer :search_count, default: 0
      t.datetime :last_api_search
      t.timestamps null: false
    end
  end
end