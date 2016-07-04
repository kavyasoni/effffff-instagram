class QueriesController < ApplicationController
  before_action :fetch_current_user
  before_action :bounce_guests

  def index
  end
end