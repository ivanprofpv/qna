class QuestionNotificationsService
  def initialize(question)
    @question = question
    @subscribers = question.subscriptions.map(&:user)
  end

  def call
    @subscribers.each { |user| QuestionNotificationsMailer.notify(@question, user).deliver_later }
  end
end
