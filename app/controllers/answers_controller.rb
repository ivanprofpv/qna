class AnswersController < ApplicationController

  include Voted

  before_action :authenticate_user!, only: %i[create update destroy best]
  before_action :find_question, only: %i[create]
  before_action :load_answer, only: %i[update destroy best]

  def edit; end

  def create
    authorize Answer
    @answer = @question.answers.create(answer_params)
    @answer.user = current_user
    publish_answer if @answer.save
    @answer_comment = @answer.comments.new
  end

  def update
    authorize @answer
    @question = @answer.question
    @answer.update(answer_params)
  end

  def destroy
    authorize @answer
    @answer.destroy
  end

  def best
    authorize @answer
    @question = @answer.question

    return unless current_user.author?(@question)

    @answer.set_best
  end

  private

  def publish_answer
    html = ApplicationController.render(
      partial: 'answers/answer_block',
      locals: { answer: @answer }
    )

    ActionCable.server.broadcast("question_answers_channel_#{@question.id}",
                                 { html: html, author_id: @answer.user.id })
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [],
                                    links_attributes: [:name, :url, :_destroy],
                                    award_attributes: [:title, :image])
  end
end
