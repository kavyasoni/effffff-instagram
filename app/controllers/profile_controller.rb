class ProfileController < ApplicationController
  before_action :fetch_current_user
  before_action :bounce_guests

  def edit
  end

  def update
    if @current_user.update_attributes(permitted_params.user)
      flash[:notice] = 'Your profile has been updated'
    else
      flash[:warning] = 'Your details could not be updated'
    end
    redirect_to profile_path
  end

  def searches
    @searches = @current_user.request_batches.reverse
  end

  def update_email_prefs
    @current_user.set_email_address(permitted_params.user)
    redirect_to thanks_for_email_path
  end
end