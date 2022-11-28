module ApplicationHelper
  def is_the_user_logged_in?
    user_signed_in?
  end
end
