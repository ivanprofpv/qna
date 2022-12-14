class QuestionsController < ApplicationController

  include Voted

  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show update destroy]

  def index
    @questions = Question.all
  end

  def show
    gon.question_id = @question.id
    gon.user_id = current_user&.id
    @subscription = @question.subscriptions.find_by(user: current_user)
    @answer = Answer.new
    @answers = @question.answers
    @answer.links.new
  end

  def new
    @question = Question.new
    @question.links.new
    @award = Award.new(question: @question)
  end

  def create
    @question = Question.new(question_params)

    @question.user = current_user

    if @question.save
      ActionCable.server.broadcast 'questions_channel', @question
      redirect_to @question, notice: 'Your question successfully created.'
    end
  end

  def update
    authorize @question
    @question.update(question_params)
    @subscription = @question.subscriptions.find_by(user: current_user)
  end

  def destroy
    authorize @question
    @question.destroy

    redirect_to root_path, notice: 'Question successfully deleted!'
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                      links_attributes: [:name, :url, :_destroy],
                                      award_attributes: [:title, :image])
  end
end
