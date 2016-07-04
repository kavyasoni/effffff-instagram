class SessionsController < ApplicationController
  def create
    user = User.find_or_create_from_uid(auth_hash)
    set_current_user(user)
    redirect_to root_path
  end

  def destroy
    cookies.delete(:session_key)
    flash[:notice] = 'You have been logged out'
    redirect_to root_path
  end

  def failure
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end

  def set_current_user user
    digest = Digest::SHA2.hexdigest("#{user.ig_access_token}#{user.last_login_time}")
    user.update(auth_digest: digest)
    cookies.permanent[:session_key] = digest
  end
end