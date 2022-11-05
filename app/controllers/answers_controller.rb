class AnswersController < ApplicationController
    before_action :authenticate_user!, only: %i[create update destroy best]
    before_action :find_question, only: %i[create]
    before_action :load_answer, only: %i[update destroy best]

  def edit
  end

  def create
    @answer = @question.answers.create(answer_params)

    @answer.user = current_user

    @answer.save
  end

  def update
    @question = @answer.question
    if current_user&.author?(@answer)
      @answer.update(answer_params)
    else
      redirect_to question_path(@answer.question), notice: 'You are not permitted.'
    end
  end

  def destroy
    if current_user&.author?(@answer)
      @answer.destroy
      redirect_to question_path(@answer.question), notice: 'Answer successfully deleted.'
    else
      redirect_to question_path, notice: 'You cannot delete the wrong answer.'
    end
  end

  def best
    @question = @answer.question

    if current_user.author?(@question)
      @answer.set_best
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
