class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def create
    question = Question.find(params[:question_id])
    byebug
    @subscription = question.subscriptions.create(user: current_user)

    @subscription.save
  end

  def destroy
    subscription = Subscription.find(params[:id])

    subscription.destroy
  end
end
