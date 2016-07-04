class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def permitted_params
    PermittedParams.new(params)
  end

  def bounce_guests
    unless @current_user
      flash[:notice] = 'You cannot go there!'
      redirect_to root_path
    end
  end

  def fetch_current_user
    cookie_key = cookies.permanent[:session_key]
    return false unless cookie_key
    @current_user = User.where(auth_digest: cookie_key).first
  end
end