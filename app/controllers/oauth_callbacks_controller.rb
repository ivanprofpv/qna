class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    oauth('Github')
  end

  def vkontakte
    oauth('vkontakte')
  end

  private

  def oauth(provider)
 current_request = request.env['omniauth.auth']
    @user = User.find_for_oauth(current_request)

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    elsif current_request && current_request[:provider] && current_request[:uid]
      session[:auth_provider] = current_request[:provider]
      session[:auth_uid] = current_request[:uid]&.to_s
      render 'users/confirmation_email'
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
