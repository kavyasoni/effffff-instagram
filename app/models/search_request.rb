# == Schema Information
#
# Table name: search_requests
#
#  id              :integer          not null, primary key
#  query           :string
#  search_count    :integer          default("0")
#  last_api_search :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class SearchRequest < ActiveRecord::Base
end
