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

class RequestBatch < ActiveRecord::Base
  belongs_to :user

  def username
    user.ig_username
  end

  def self.increment_completeness_for request_id
    request   = RequestBatch.find(request_id)
    new_count = request.complete_queries + 1
    request.update(complete_queries: new_count)
  end

  def mark_as_complete!
    if complete_queries == 3
      update_attributes(complete: true)
      notify_subscriber
    end
  end

  def notify_subscriber
    TransactionMailer.notify_subscriber(user_id).deliver_now if user.emailable?
  end
end
