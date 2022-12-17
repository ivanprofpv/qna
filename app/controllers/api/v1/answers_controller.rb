class Api::V1::AnswersController < Api::V1::BaseController
  def index
    @answers = question.answers
    render json: @answers
  end

  def show
    render json: answer
  end

  def create
    answer = question.answers.build(answer_params.merge(user: current_resource_owner))

    if answer.save
      render json: answer, status: :created
    else
      render json: { errors: answer.errors, status: :unprocessable_entity }
    end
  end

  def update
    authorize answer

    if answer.update(answer_params)
      render json: answer, status: :created
    else
      render json: { errors: answer.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize answer
    
    if answer.destroy
      render json: answer, status: :ok
    else
      render json: { errors: 'Answer not delete.' }, status: :unprocessable_entity
    end
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end
  
  def answer
    @answer ||= question.answers.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end