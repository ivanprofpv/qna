class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def create
    question = Question.find(params[:question_id])
    @subscription = question.subscription.create(user: current_user)

    render partial: 'questions/subscribe' if @subscribe.save
  end

  def destroy
    subscription = Subscription.find(params[:id])

    subscription.destroy
  end
end
