module ControllerHelpers
  def login(user)
    @request.env['devise.mapping'] = Devise.mappings[:user] # to login the user with devise
    sign_in(user)
  end
end
