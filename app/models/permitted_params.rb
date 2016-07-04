class PermittedParams < Struct.new(:params)
  def user
    params.require(:user).permit(*user_attributes)
  end

  def user_attributes
    [:email, :full_name]
  end
end