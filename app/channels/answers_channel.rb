class AnswersChannel < ApplicationCable::Channel
  def subscribed
    reject if params[:question].blank?
  end

  def follow
    stream_from "question_answers_channel_#{params[:question]}"
  end
end
