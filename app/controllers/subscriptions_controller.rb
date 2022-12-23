class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def create
    authorize Subscription
    @question = Question.find(params[:question_id])
    @subscription = @question.subscriptions.create(user: current_user)
    if @subscription.save
      redirect_to @question, notice: 'Question subscribe created.'
    else
      redirect_to @question, notice: 'Subscription failed'
    end
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    authorize @subscription
    if @subscription.destroy
      redirect_to root_path, notice: 'Question subscribe deleted.'
    end
  end
end
