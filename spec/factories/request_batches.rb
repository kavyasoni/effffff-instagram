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

FactoryGirl.define do
  factory :request_batch do
  end
end
