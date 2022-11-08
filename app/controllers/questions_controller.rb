class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show update destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answers = @question.answers
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)

    @question.user = current_user

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    end
  end

  def update
    if current_user&.author?(@question)
      @question.update(question_params)
    else
      redirect_to question_path(@question), notice: 'You are not permitted.'
    end
  end

  def destroy
    if current_user&.author?(@question)
      @question.destroy
      redirect_to root_path, notice: 'Question successfully deleted!'
    else
      redirect_to root_path
    end
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [])
  end
end
