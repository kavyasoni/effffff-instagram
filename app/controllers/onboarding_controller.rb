class OnboardingController < ApplicationController
  before_action :fetch_current_user
  before_action :bounce_guests

  def intro
  end

  def complete_intro
    @current_user.complete_intro!
    redirect_to root_path
  end
end