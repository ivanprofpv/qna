# Preview all emails at http://localhost:3000/rails/mailers/question_notifications
class QuestionNotificationsPreview < ActionMailer::Preview
  def notify
    user = FactoryBot.create(:user)
    question = FactoryBot.create(:question)

    QuestionNotificationsMailer.notify(question, user)
  end
end
