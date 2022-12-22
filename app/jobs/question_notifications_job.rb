class QuestionNotificationsJob < ApplicationJob
  queue_as :default

  def perform(question)
    QuestionNotificationsService.new(question).call
  end
end
