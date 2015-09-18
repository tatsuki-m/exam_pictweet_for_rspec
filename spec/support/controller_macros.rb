module ControllerMacros
  def set_user_session(user)
    sign_in user
  end
end