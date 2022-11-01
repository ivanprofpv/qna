class AnswersController < ApplicationController
    before_action :authenticate_user!, except: %i[index show]
    before_action :find_question, only: %i[new create]
    before_action :load_answer, only: %i[show edit update destroy]

  def show
  end

  def new
    @answer = @question.answers.new
  end

  def edit
  end

  def create
    @answer = @question.answers.new(answer_params)

    @answer.user = current_user

    if @answer.save
      redirect_to question_path(@question), notice: 'Answer successfully created!'
    else
      render 'questions/show'
    end
  end

  def update
    if @answer.update(answer_params)
      redirect_to answer_path(@answer)
    else
      render :edit
    end
  end

  def destroy
    if current_user&.author?(@answer)
      @answer.destroy
      redirect_to questions_path(@answer.question), notice: 'Answer successfully deleted!'
    else
      redirect_to questions_path(@answer.question)
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