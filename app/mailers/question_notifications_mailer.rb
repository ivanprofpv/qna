class QuestionNotificationsMailer < ApplicationMailer
  def notify(question, user)
    @question = question

    mail to: user.email, subject: 'The question has been updated!'
  end
end
