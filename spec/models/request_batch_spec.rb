# == Schema Information
#
# Table name: request_batches
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  query_terms      :text             default("{}"), is an Array
#  complete         :boolean          default("false")
#  complete_queries :integer          default("0")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  job_ids          :text             default("{}"), is an Array
#

describe RequestBatch do
  describe "username" do
    it "returns the user's instagram username" do
      user = create(:user, ig_username: 'Bob')
      batch = create(:request_batch, user: user)
      expect(batch.username).to eq('Bob')
    end
  end

  describe "mark_as_complete" do
    it "marks a request batch as complete" do
      batch = create(:request_batch)
      expect(batch.complete).to be false
      batch.mark_as_complete!
      expect(batch.reload.complete).to be true
    end
  end

  describe "increment_completeness_for" do
    it "increments the number of complete queries" do
      batch = create(:request_batch, complete_queries: 1)
      RequestBatch.increment_completeness_for(batch.id)
      expect(batch.reload.complete_queries).to be 2
    end

    it "marks the batch as complete when 3 queries have been completed" do
      batch = create(:request_batch, complete_queries: 2)
      RequestBatch.increment_completeness_for(batch.id)
      expect(batch.reload.complete_queries).to be 3
      expect(batch.reload.complete).to be true
    end
  end
end
