class StatsController < ApplicationController
  before_action :fetch_current_user
  before_action :redirect_non_admins

  def index
    @searches = RequestBatch.includes(:user).all.reverse
  end

  private

  def redirect_non_admins
    unless @current_user.admin?
      flash[:notice] = 'You cannot view that page'
      redirect_to root_path
    end
  end
end