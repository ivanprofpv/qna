class Api::V1::AnswersController < Api::V1::BaseController
  def index
    render json: question.answers
  end

  def show
    render json: answer
  end

  private

  def question
    Question.find(params[:question_id])
  end
  
  def answer
    question.answers.find(params[:id])
  end
end