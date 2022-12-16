class Api::V1::QuestionsController < Api::V1::BaseController
  def index
    render json: question_all
  end

  def show
    render json: question
  end

  private

  def question
    Question.find(params[:id])
  end

  def question_all
    @questions = Question.all
  end
end