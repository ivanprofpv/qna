class SendAnswerJob < ApplicationJob
  queue_as :default

  def perform(answer)
    html = ApplicationController.render(
      partial: 'answers/answer_block',
      locals: { answer: answer }
    )

    ActionCable.server.broadcast "question_answers_channel_#{answer.question.id}",
                                 html: html, user: answer.user.id
  end
end
