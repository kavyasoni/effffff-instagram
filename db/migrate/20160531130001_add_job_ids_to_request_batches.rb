class AddJobIdsToRequestBatches < ActiveRecord::Migration
  def self.up
    add_column :request_batches, :job_ids, :text, array: true, default: []
  end

  def self.down
    remove_column :request_batches, :job_ids
  end
end