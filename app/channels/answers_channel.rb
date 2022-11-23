class AnswersChannel < ApplicationCable::Channel
  def subscribed
    stream_from "question_answers_channel_#{params[:question]}"
  end

  def unsubscribed
  end
end
