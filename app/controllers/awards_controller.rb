class AwardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @user_awards = current_user.awards
  end
end
