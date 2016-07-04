module ApplicationHelper
  def current_user
    @current_user
  end

  def is_admin?
    current_user && current_user.admin?
  end
end